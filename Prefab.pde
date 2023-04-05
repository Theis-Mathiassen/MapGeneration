class Prefab extends Generator {
  int x, y;
  byte[][] Schematic;
  Prefab(Map map, int x, int y, byte[][] schematic, boolean lock) {
    super(map, lock);
    Schematic = schematic;
    this.x = x;
    this.y = y;
    Lock = lock;
  }
  void GeneratorFunction (){
    if (Lock) {
      CellsToLock = new boolean[map.tilesX][map.tilesY];
    }
    for (int i = 0; i < Schematic.length; i++) {
      for (int j = 0; j < Schematic[i].length; j++) {
        if (x+i < 0 || x+i >= map.tilesX || y+j < 0 || y+j >= map.tilesY) {
          continue;
        }
        map.SetGrid(x+i,y+j,Schematic[i][j]);
        CellsToLock[x+i][y+j] = true;
      }
    }
  }
}
