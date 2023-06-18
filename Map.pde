
class Map {
  //Tile size and Chunksize, can not be relatively prime.
  int tileSizeX;
  int tileSizeY;  
  int tilesX = 1*512;//sizeX / tileSizeX;
  int tilesY = 1*256;//sizeY / tileSizeY;
  boolean generated = false;
  private short[][] grid = new short[tilesX][tilesY];    //0 = Wall & 1 = Walkable(Floor)
  
  VoronoiCell[][] VoronoiCell = new VoronoiCell[tilesX][tilesY];
  
  boolean[][] Locked = new boolean[tilesX][tilesY];  //1 = Locked & 0 = Unlocked
  byte[][] Region = new byte[tilesX][tilesY];  //0 = Region0 & 1 = Region1 osv.
  Stack<boolean[][]> LockedStates = new Stack<boolean[][]>();
  
  public Map() {
    if (GameMode) {
      tileSizeX = 4;
      tileSizeY = 4;
      print("Hello2");
    }
    print("Hello");
  }
  
  Vector2 PosToTile (Vector2 pos) {
    return new Vector2(floor(pos.x / tileSizeX), floor(pos.y / tileSizeY));
    
  }
  
  boolean SetGrid (int x, int y, byte val) {
    if (x < 0 || x >= grid.length || y < 0 || y >= grid[x].length) {
      return false;
    }
    if (Locked[x][y] == true) {
      return false;
    }
    
    grid[x][y] = val;
    return true;
  }
  short[][] GetGrid() {
    short[][] result = new short[tilesX][tilesY];
    for (int i = 0; i < tilesX; i++) {
      for (int j = 0; j < tilesY; j++) {
        result[i][j] = grid[i][j];
      }
    }
    return result;
  }
  short GetGrid (int x, int y) {
    return grid[x][y];
  }
  //Push old locked state and assign new.
  void PushLock (boolean[][] Lock) {
    if (Locked.length != Lock.length) {
      System.out.println("Wrong size input");
      return;
    }
    print("Push");
    LockedStates.push(Locked);
    boolean[][] newLock = new boolean[Locked.length][Locked[0].length];
    for (int i = 0; i < Locked.length; i++) {
      if (Locked[i].length != Lock[i].length) {
        System.out.println("Wrong size input");
        return;
      }
      for(int j = 0; j < Locked[i].length; j++) {
        newLock[i][j] = Locked[i][j] || Lock[i][j];
      }
    }
    Locked = newLock;
    
    /*print("Printing:\n");
    for (int i = 0; i < grid.length; i++) {
       for (int j = 0; j < grid[i].length; j++) {
         print(Locked[i][j]);
       }
       print("\n");
    }
    print("\n");*/
  }
  void PopLock () {
    print("Pop");
    Locked = LockedStates.pop();
  }
}
