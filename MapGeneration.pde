//final int sizeX = 2500;
//final int sizeY = 1300;
Camera MainCamera;
Camera MiniMap;
//Camera cameraVoronoi;
boolean GameMode = true;

Map MainMap = new Map();



//Generators
//Drunk drunk = new Drunk(MainMap,MainMap.tilesX * 2 / 4, MainMap.tilesY * 2 / 4, 30, true);
Drunk drunk2;
Drunk drunk21;
//Drunk drunk3 = new Drunk(MainMap,MainMap.tilesX * 3 / 4, MainMap.tilesY * 1 / 4, 20, false);
//Drunk drunk4 = new Drunk(MainMap,10, 10, 10, false);
DrunkPath CastleToCave;



Voronoi voronoiGenerator;

CellularAutomata Cell1;
WhiteNoise HighNoise;

CellularAutomata Cell2;
WhiteNoise LowNoise;

CellularAutomata Cell3;
WhiteNoise LowNoise2;

Prefab Castle;
Prefab Cave;

//Player
ArrayList<GameObject> GameObjects = new ArrayList<GameObject>();
Player player;



DijkstraMap dijkstra = new DijkstraMap(MainMap.tilesX, MainMap.tilesY);
int MaxDistanceToPath;


long seed;
void setup () {
  size(2048, 1024, P2D);
  MainCamera = new Camera(0,0,width,height, 0, 0, width, height, 255, false);
  MiniMap = new Camera(0,0,4000,4000,width-400, 0, 400, 400, 255, false);
  //cameraVoronoi = new Camera(0,0,width,height, 255, true);
  frameRate(60);
  noStroke();
  background(0);
  seed = (long)random(10000);
  randomSeed(seed);
  
  //player = new Player(MainMap,134*MainMap.tileSizeX, 100*MainMap.tileSizeY);
  player = new Player(MainMap,50*MainMap.tileSizeX, 50*MainMap.tileSizeY);
  
  
  drunk2 = new Drunk(MainMap,130, 120, 90000, true, true);
  Drunk drunk21 = new Drunk(MainMap,130, 120, 40000, true, true);
  CastleToCave = new DrunkPath(MainMap, new Vector2[]{new Vector2(130,120),new Vector2(230,50), new Vector2(399, 160)}, 50,50,true, 5);
  
  Cell1  = new CellularAutomata(MainMap,6,5,9,0,5);
  HighNoise = new WhiteNoise(MainMap, 0.6, 4, false);
  
  Cell2  = new CellularAutomata(MainMap,3,3,9,0,3);
  LowNoise = new WhiteNoise(MainMap, 0.3, 1, false);
  
  Cell3  = new CellularAutomata(MainMap,4,3,9,0,3);
  WhiteNoise LowNoise2 = new WhiteNoise(MainMap,0.6, 1, false);
  
  voronoiGenerator = new Voronoi(MainMap, 5, true, 10, true);
  
  PImage CastleIMG = loadImage("Assets/Castle.png");
  byte[][] CastleSCH = new byte[0][0];
  if (CastleIMG != null) {
    CastleSCH = Img2Schematic(CastleIMG);
  }
  Castle = new Prefab(MainMap, 30, 30,CastleSCH,true);
  
  PImage CaveImage = loadImage("Assets/Outpost.png");
  byte[][] CaveSCH = new byte[0][0];
  if (CaveImage != null) {
    CaveSCH = Img2Schematic(CaveImage);
  }
  Cave = new Prefab(MainMap, 400, 150,CaveSCH,true);
  
  Castle.ChildGenerators.add(Cave);
  
  Cave.ChildGenerators.add(CastleToCave);
  CastleToCave.ChildGenerators.add(voronoiGenerator);
  
  HighNoise.ChildGenerators.add(Cell1);
  voronoiGenerator.addGeneratorToCell(0, HighNoise);
  
  LowNoise.ChildGenerators.add(Cell2);
  voronoiGenerator.addGeneratorToCell(1, LowNoise);
  
  LowNoise2.ChildGenerators.add(Cell3);
  voronoiGenerator.addGeneratorToCell(2, LowNoise2);
  
  drunk21.pos.x = voronoiGenerator.cells[3].pos.x;
  drunk21.pos.y = voronoiGenerator.cells[3].pos.y;
  voronoiGenerator.addGeneratorToCell(3, drunk21);
  drunk2.pos.x = voronoiGenerator.cells[4].pos.x;
  drunk2.pos.y = voronoiGenerator.cells[4].pos.y;
  voronoiGenerator.addGeneratorToCell(4, drunk2);
  //voronoiGenerator.addGeneratorToBorder(HighNoise);
  Generator borderGen = new WhiteNoise(MainMap, 0.3, 1, true);
  borderGen.ChildGenerators.add(new CellularAutomata(MainMap,3,2,9,0,1));
  voronoiGenerator.addGeneratorToBorder(borderGen);
  //voronoiGenerator.addGeneratorToBorder(new CellularAutomata(MainMap,4,2,9, 0.3,16));
  
  
  GameObjects.add(player);
  
  thread("GenerateMap");
  //GenerateMap();
  
  
  print("\n");
  print("Seed: " + seed + "\n");
  
}
/*int igen = 0;
void GenerateNext () {
  voronoiGenerator.ChildGenerators.get(igen).Generate();
  igen++;
  
  MainCamera.DrawGrid(MainMap.Locked, MainMap.tileSizeX);
}*/

void draw () {
  background(0);
  //cameraVoronoi.DrawMap(MainMap);
  MainCamera.DrawMap(MainMap);
  //MiniMap.DrawMap(MainMap);
  //MainCamera.DrawGrid(voronoiGenerator.cellBorder, 8);
  //MainCamera.DrawGrid(MainMap.Locked, MainMap.tileSizeX);
  //MainCamera.DrawGrid(dijkstra.distanceMap, MainMap.tileSizeX);
  //MainCamera.DrawDijkstraMapPath(dijkstra, MainMap.tileSizeX);
  if (GameMode) {
    for (int i = GameObjects.size() - 1; i >= 0; i--) {
      GameObject object = GameObjects.get(i);
      if (object.dead == true) {
        GameObjects.remove(object);
        continue;
      }
      object.Update();
      MainCamera.DrawObject(object);
    }
    MainCamera.MoveTo(player);
    //MiniMap.MoveTo(player);
  }
  
  //cameraVoronoi.MoveTo(player);
  
  //print(player.pos.x + "," + player.pos.y + "\n");
  
  //text(frameRate,5,10);
}

void GenerateMap () {
  print(millis());
  Castle.Generate();
  print("Finished map gen, started shortest path...");
  short[][] walkable = MainMap.GetGrid();
  /*for (int i = 0; i < MainMap.tilesX; i++) {
    for (int j = 0; j < MainMap.tilesY; j++) {
      if (walkable[i][j] == 0) {
        walkable[i][j] = 1000;
      }
    }
  }*/
  dijkstra.calcMap(walkable, 59, 50);
  
  int shortestPath = dijkstra.distanceMap[431][188];
  int hotPathWidth = 16;
  int outsideHotPathValue = 500;
  dijkstra.calcDistanceToHotPath(walkable, 431, 188);
  for (int i = 0; i < MainMap.tilesX; i++) {
    for (int j = 0; j < MainMap.tilesY; j++) {
      if (dijkstra.distanceMap[i][j] > hotPathWidth && dijkstra.distanceMap[i][j] != Integer.MAX_VALUE) {
        dijkstra.distanceMap[i][j] = outsideHotPathValue;
      }
    }
  }
  
  //cameraVoronoi.DrawMap(MainMap, true);
  //MainCamera.DrawMap(MainMap, false);
  
  
  //MZ = new MazeSolver(MainMap.GetGrid());
  //MZ.traverse(30, 30);
  
  //background(0);
  //MainCamera.DrawMap(MainMap);
  //MiniMap.DrawMap(MainMap);
  //cameraVoronoi.DrawMap(MainMap);
  
  
  
  
  long totalTiles = MainMap.tilesX * MainMap.tilesY;
  long reachableTiles = 0;
  float averageDistaceFromPath = 0;
  for (int i = 0; i < MainMap.tilesX; i++) {
    for (int j = 0; j < MainMap.tilesY; j++) {
      boolean reachable = (dijkstra.distanceMap[i][j] != Integer.MAX_VALUE);
      
      if(reachable) {
        reachableTiles += 1;
        averageDistaceFromPath += dijkstra.distanceMap[i][j];
        MaxDistanceToPath = MaxDistanceToPath < dijkstra.distanceMap[i][j] ? dijkstra.distanceMap[i][j] : MaxDistanceToPath;
      }
      if (random(1) < 0.004 && dijkstra.distanceMap[i][j] == outsideHotPathValue && reachable && GameMode) {
        GameObjects.add(new Enemy(MainMap, new Vector2(i*MainMap.tileSizeX, j*MainMap.tileSizeY), ""));
      }
    }
  }
  averageDistaceFromPath = averageDistaceFromPath / reachableTiles;
  
  print("Percent reachableTiles: " + (float)reachableTiles/totalTiles * 100 + "%\n");
  print("Shortest path: " + shortestPath + "\n");
  print("Average distance from path: " + averageDistaceFromPath + "\n");
  
  MainMap.generated = true;
  print(millis());
  MainCamera.TileChunks = null;
  //MiniMap.TileChunks = null;
}
void RenderMap () {
  MainCamera.RenderChunks();
  //MiniMap.RenderChunks();
}


byte[][] Img2Schematic (PImage img) {
  byte[][] result = new byte[img.width][img.height];
  img.loadPixels();
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      //print(img.pixels[x*img.height + y]);
      int loc = x + y * img.width;
      if (img.pixels[loc] == -1) {
        result[x][y] = 1;
      }
      else {
        result[x][y] = 0;
      }
    }
  }
  return result;
}


void drawArrow(int cx, int cy, int len, float angle){
  pushMatrix();
  translate(cx, cy);
  rotate(angle);
  line(0,0,len, 0);
  
  line(len, 0, len - (len>>2), -(len>>2));
  line(len, 0, len - (len>>2), (len>>2));
  popMatrix();
}
void drawArrow(int cx, int cy, int x2, int y2){
  drawArrow(cx, cy, (int)sqrt((cx-x2)*(cx-x2)+(cy-y2)*(cy-y2)), atan2(y2-cy, x2-cx));
}
// Calculates the base-10 logarithm of a number
float logn (float x, float n) {
  return (log(x) / log(n));
}


void mousePressed () {
  save("MapImages/test.png");
  //print("Cordinates: " + (int)(mouseX - MainCamera.pos.x) / MainMap.tileSizeX + ", " + (int)(mouseY - MainCamera.pos.y) / MainMap.tileSizeY);
  //GenerateNext();
}
void keyPressed() {
    if (key >= 0 && key < 128) {
      InputSystem.keys[key] = 1;
    }
  }
  void keyReleased () {
    if (key >= 0 && key < 128) {
      InputSystem.keys[key] = 0;
    }
  }
