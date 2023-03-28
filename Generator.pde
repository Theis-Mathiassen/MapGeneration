public interface IGenerator {
  ///Summary:
  //Step 1 Do what you must.
  //Step 2 Lock cells that can't be modified.
  //Step 3 Call childgenerator
  //Step 4 return the lock state to the state before step 2.
  //Step 5 return.
  void GeneratorFunction ();
  void LockFunction ();
  void CallChildGenerators();
  void UnlockFunction ();
}

public abstract class Generator implements IGenerator {
  
  ArrayList<Generator> ChildGenerators = new ArrayList<Generator>();
  protected boolean Lock;
  protected boolean[][] CellsToLock;
  Map map;
  Generator (Map map, boolean lock) {
    this.map = map;
    Lock = lock;
    CellsToLock = new boolean[map.tilesX][map.tilesY];
  }
  void Generate () {
    if (Lock) {
      CellsToLock = new boolean[map.tilesX][map.tilesY];
    }
    GeneratorFunction ();
    LockFunction ();
    CallChildGenerators();
    UnlockFunction ();
  }
  void CallChildGenerators() {
    for (int i = 0; i < ChildGenerators.size(); i++) {
      Generator gen = ChildGenerators.get(i);
      gen.Generate();
    }
  }
  void LockFunction (){
    if (Lock)
      map.PushLock(CellsToLock);
  }
  void UnlockFunction (){
    if (Lock)
      map.PopLock();
  }
}

class EmptyGen extends Generator {
  EmptyGen (Map map) {
    super(map, false);
  }
  void GeneratorFunction () {
    
  }
}

class Voronoi extends Generator {
  int NumSeeds;
  boolean ManhattanInterpretation;
  color[] colorArray = new color[]{color(33,26,82),color(89, 79, 191),color(84, 97, 110),color(187, 91, 23),color(223, 142, 48),
                              color(151, 112, 31),color(177, 147, 53),color(0, 127, 163),color(49, 169, 193),color(161, 101, 71),
                              color(204, 139, 102),color(14, 133, 99),color(92, 175, 141),color(204, 68, 91),color(231, 130, 147)};
  VoronoiCell[] cells;
  Voronoi (Map map, int numSeeds, boolean ManhattanInterpretation, boolean lock) {
    super(map, lock);
    //Create all cells and add them to childgenerators
    NumSeeds = numSeeds;
    cells = new VoronoiCell[NumSeeds];
    this.ManhattanInterpretation = ManhattanInterpretation;
    for (int i = 0; i < numSeeds; i++) {
      color col = i < colorArray.length ? colorArray[i] : color(random(255), random(255), random(255));
      VoronoiCell cell = new VoronoiCell(map, i, new Vector2(random(map.tilesX), random(map.tilesY)), col, lock);
      ChildGenerators.add(cell);
      cells[i] = cell;
    }
    
  }
  void GeneratorFunction () {
    for (int i = 0; i < map.tilesX; i++) {
      for (int j = 0; j < map.tilesY; j++) {
        VoronoiCell LowestDistanceCell = null;
        double LowestDistance = Double.MAX_VALUE;
        for (int k = 0; k < NumSeeds; k++) {
          VoronoiCell cell = (VoronoiCell)ChildGenerators.get(k);
          double distance;
          if (ManhattanInterpretation) {
            distance = ManhattanDistance(i, j, (int)cell.pos.x, (int)cell.pos.y);
          } else {
            distance = EuclideanDistance(i, j, (int)cell.pos.x, (int)cell.pos.y);
          }
          if (distance <= LowestDistance) {
            LowestDistanceCell = cell;
            LowestDistance = distance;
          }
        }
        map.VoronoiCell[i][j] = LowestDistanceCell;// == null ? color(0) : LowestDistanceCell.CellColor;
      }  
    }
  }
  void addGeneratorToCell (int index, Generator gen) {
    ChildGenerators.get(index).ChildGenerators.add(gen);
  }
  void LockFunction (){
  }
  void UnlockFunction (){
  }
  
  double EuclideanDistance(int ax, int ay, int bx, int by){
    return sqrt((ax-bx)*(ax-bx)+(ay-by)*(ay-by));
  }

  double ManhattanDistance(int ax, int ay, int bx, int by){
    return abs(ax-bx)+abs(ay-by);
  }
}

class VoronoiCell extends Generator {
  color CellColor;
  int id;
  Vector2 pos;
  VoronoiCell (Map map, int id, Vector2 pos, color col, boolean lock) {
    super(map, lock);
    this.id = id;
    this.pos = pos;
    CellColor = col;
  }
  void GeneratorFunction () {
    for (int i = 0; i < map.tilesX; i++) {
      for (int j = 0; j < map.tilesY; j++) {
        if (map.VoronoiCell[i][j] != this) {
          CellsToLock[i][j] = true;
        }
      }
    }
  }
}



class Drunk extends Generator {
  Vector2 pos;
  private int Iterations;
  boolean constrainedByLock;
  Drunk (Map map, int x, int y, int iterations, boolean LockSteppedTiles, boolean constrainedByLock) {
    super(map, LockSteppedTiles);
    pos = new Vector2(x,y);
    Iterations = iterations;
    this.constrainedByLock = constrainedByLock;
  }
  
  void GeneratorFunction (){
    //print("Drunk"); //<>// //<>//
    int dir = 0;
    pos.x = constrain(pos.x, 1, map.tilesX-2);
    pos.y = constrain(pos.y, 1, map.tilesY-2);
    boolean succeds = map.SetGrid((int)pos.x,(int)pos.y,(byte)1);
    //rect(pos.x * map.tileSizeX, pos.y*map.tileSizeY, 10, 10);
    if (constrainedByLock && succeds == false) {
      //Locked start location
      return;
    };
    if (Lock) {
      CellsToLock[(int)pos.x][(int)pos.y] = true;
    }
    for (int i = 0; i < Iterations; i++) {
      int prevX = (int)pos.x, prevY = (int)pos.y;
      int changeDir = floor(random(0, 1));
      if (changeDir == 0) {
        dir = (dir + floor(random(1, 4))) % 4;
      }
      if (dir < 1) {
        pos.x+=1;
      } else if (dir < 2) {
        pos.y+=1;
      } else if (dir < 3) {
        pos.x-=1;
      } else if (dir < 4) {
        pos.y-=1;
      }
      pos.x = constrain(pos.x, 1, map.tilesX-2);
      pos.y = constrain(pos.y, 1, map.tilesY-2);
      succeds = map.SetGrid((int)pos.x,(int)pos.y,(byte)1);
      //rect(pos.x * map.tileSizeX, pos.y*map.tileSizeY, 10, 10);
      if (constrainedByLock && succeds == false) {
        pos.x = prevX; //<>//
        pos.y = prevY;
      };
      if (Lock) {
        CellsToLock[(int)pos.x][(int)pos.y] = true;
      }
    }
  }
}

class CellularAutomata extends Generator {
  int Birth = 5;
  int Survival = 3;
  int OverPopulation = 9; //<>//
  int Iterations = 1;

  CellularAutomata (Map map, int birth, int survival, int overPopulation, int iterations) {
    super(map, false);
    Birth = birth; //<>//
    Survival = survival;
    OverPopulation = overPopulation;
    Iterations = iterations;
  }
 //<>// //<>//
  void GeneratorFunction (){
    for (int i = 0; i < Iterations; i++) {
      Iterate();
    } //<>// //<>//
  }
  byte GetNeighbors (int x, int y, byte[][] oldGrid) {
    byte AliveNeighbors = 0;
    for (int k = -1; k < 2; k++) {
      for (int l = -1; l < 2; l++) {
        int xT = x + k;
        int yT = y + l;
        if (xT == x && yT == y) {
        } else if (xT < 0 || xT >= map.tilesX || yT < 0 || yT >= map.tilesY) {
        } else {
          /*if (xT < x || (xT == x && yT < y)) {
            if (map.GetGrid(xT,yT) != 0) {
              AliveNeighbors += 1;
            }
          } else {
            if (oldGrid[xT][yT] != 0) {
              AliveNeighbors += 1;
            }
          }*/
          if (oldGrid[xT][yT] != 0/* && map.Locked[xT][yT] == false*/) {
            AliveNeighbors += 1;
          }
        }
      }
    }
    return AliveNeighbors;
  }
  void Iterate () {
    byte[][] oldGrid = map.GetGrid();
    for (int i = 0; i < map.tilesX; i++) {
       for (int j = 0; j < map.tilesY; j++) {
         byte AliveNeighbors = GetNeighbors(i,j,oldGrid);
         boolean alive = map.GetGrid(i,j) == 0 ? false : true;
         if (alive) {
           if (AliveNeighbors < Survival) {
             map.SetGrid(i,j,(byte)0);
             //oldGrid[i][j] = 0;
           } else if (AliveNeighbors > OverPopulation) {
             map.SetGrid(i,j,(byte)0);
             //oldGrid[i][j] = 0;
           } else {
             map.SetGrid(i,j,(byte)1);
             //oldGrid[i][j] = 1;
           }
         } else {
           if (AliveNeighbors > Birth) {
             map.SetGrid(i,j,(byte)1);
             //oldGrid[i][j] = 1;
           } else {
             map.SetGrid(i,j,(byte)0);
             //oldGrid[i][j] = 0;
           }
         }
       }
    }
  }
}

class WhiteNoise extends Generator {
  float Chance;
  int size;
  WhiteNoise(Map map, float chance, int size) {
    super(map, false);
    Chance = chance;
    this.size = size;
  }
  void GeneratorFunction (){
    for (int i = 0; i < map.tilesX / size; i++) {
      for (int j = 0; j < map.tilesY / size; j++) {
        float randomVal= random(1);
        for (int k = 0; k < size; k++) {
          int xk = i*size+k;
          for (int l = 0; l < size; l++) {
            int ly = j*size+l;
            if (xk >= 0 & xk < map.tilesX && ly >= 0 && ly < map.tilesY) {
              if (randomVal < Chance) {
                map.SetGrid(xk,ly,(byte)1);
              } else {
                map.SetGrid(xk,ly,(byte)0);
              }
            }
          }
        }
      }
    }
  }
}


class DrunkPath extends Generator {
  private Vector2 Pos;
  Vector2[] Targets;
  int pathRadius;
  
  DrunkPath(Map map, Vector2[] Targets, int StartX, int StartY, boolean LockSteppedTiles, int pathRadius) {
    super(map, LockSteppedTiles);
    this.Targets = Targets;
    this.Pos = new Vector2(StartX,StartY);
    this.pathRadius = pathRadius;
  }
  void GeneratorFunction () {
    for (int i = 0; i < Targets.length; i++) {
      Path((int)Targets[i].x, (int)Targets[i].y);
    }
  }
  void Path (int xTarget, int yTarget) {
    int w = 0;
    int m = w * 2;
    while (Pos.x != xTarget || Pos.y != yTarget ) {
      int dir = floor(random(0, 6 + m));

      if (dir < 1 + w) {
        if (Pos.x < xTarget) {
          Pos.x+=1;
        } else if (Pos.x > xTarget) {
          Pos.x-=1;
        }
      } else if (dir < 2 + m) {
        if (Pos.y < yTarget) {
          Pos.y+=1;
        } else if (Pos.y > yTarget) {
          Pos.y-=1;
        }
      } else if (dir < 3 + m) {
        Pos.x+=1;
      } else if (dir < 4 + m) {
        Pos.y+=1;
      } else if (dir < 5 + m) {
        Pos.x-=1;
      } else if (dir < 6 + m) {
        Pos.y-=1;
      }
      Pos.x = constrain(Pos.x, 0, map.tilesX-1);
      Pos.y = constrain(Pos.y, 0, map.tilesY-1);
      for (int i = -(pathRadius-1); i <= (pathRadius-1); i++) {
        int ix = (int)Pos.x + i;
        for (int j = -(pathRadius-1); j <= (pathRadius-1); j++) {
          int jy = (int)Pos.y + j;
          if (ix >= 0 && ix < map.tilesX && jy >= 0 && jy < map.tilesY) {
            map.SetGrid(ix,jy,(byte)1);
            if (Lock) {
              CellsToLock[ix][jy] = true;
            }
          }
          
        }
      }
    }
  }
}
