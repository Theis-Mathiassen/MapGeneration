
class Map {
  //Tile size and Chunksize, can not be relatively prime.
  int tileSizeX = 4;
  int tileSizeY = 4;  
  int tilesX = 512;//sizeX / tileSizeX;
  int tilesY = 256;//sizeY / tileSizeY;
  private byte[][] grid = new byte[tilesX][tilesY];    //0 = Wall & 1 = Walkable(Floor)
  
  VoronoiCell[][] VoronoiCell = new VoronoiCell[tilesX][tilesY];
  
  boolean[][] Locked = new boolean[tilesX][tilesY];  //1 = Locked & 0 = Unlocked
  byte[][] Region = new byte[tilesX][tilesY];  //0 = Region0 & 1 = Region1 osv.
  Stack<boolean[][]> LockedStates = new Stack<boolean[][]>();
  
  
  Vector2 PosToTile (Vector2 pos) {
    return new Vector2(floor(pos.x / tileSizeX), floor(pos.y / tileSizeY));
    
  }
  
  boolean SetGrid (int x, int y, byte val) {
    if (x < 0 || x >= grid.length || y < 0 || y >= grid[x].length) { //<>//
      return false;
    }
    if (Locked[x][y] == true) {
      return false;
    }
    
    grid[x][y] = val;
    return true;
  }
  byte[][] GetGrid() {
    byte[][] result = new byte[tilesX][tilesY];
    for (int i = 0; i < tilesX; i++) {
      for (int j = 0; j < tilesY; j++) {
        result[i][j] = grid[i][j];
      }
    }
    return result;
  }
  byte GetGrid (int x, int y) {
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
