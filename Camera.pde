class Camera {
  Vector2 Pos;
  Vector2 Size;
  PShape FloorTile;
  
  int Transparency;
  
  int ChunkSize = 128;
  PGraphics[][] TileChunks;
  
  
  Camera (float x, float y, float w, float h) {
    Pos = new Vector2(x,y);
    Size = new Vector2(w,h);
    Transparency = 255;
    
  }
  
  void DrawMap (Map map, boolean Voronoi) {
    
    if (TileChunks == null) {
      
      RenderChunks(map, Voronoi);
    }
    
    int iStart = max((int)(Pos.x/ChunkSize), 0);
    int iFinish = min(1+(int)(Pos.x+Size.x)/ChunkSize, TileChunks.length);
    int jStart = max((int)(Pos.y/ChunkSize), 0);
    int jFinish = min(1+(int)(Pos.y+Size.y)/ChunkSize, TileChunks[0].length);
    for (int i = iStart; i < iFinish; i++) {
      int iX = i * ChunkSize;
      for (int j = jStart; j < jFinish; j++) {
        image(TileChunks[i][j], iX - Pos.x, j * ChunkSize - Pos.y);
      }
    }
  }
  
  void RenderChunks (Map map, boolean VoronoiRepresentation) {
    int ChunksX = (map.tilesX * map.tileSizeX) / ChunkSize;
    int ChunksY = (map.tilesY * map.tileSizeY) / ChunkSize;
    TileChunks = new PGraphics[ChunksX][ChunksY];
    for (int i = 0; i < ChunksX; i++) {
      for (int j = 0; j < ChunksY; j++) {
        TileChunks[i][j] = createGraphics(ChunkSize, ChunkSize);
        int TilesPerChunkX = ChunkSize / map.tileSizeX;
        int TilesPerChunkY = ChunkSize / map.tileSizeY;
        TileChunks[i][j].beginDraw();
        TileChunks[i][j].noStroke();
        
        for (int k = 0; k < TilesPerChunkX; k++) {
          int x = i * TilesPerChunkX + k;
          for (int l = 0; l < TilesPerChunkY; l++) {
            int y = j * TilesPerChunkY + l;
            if (VoronoiRepresentation) {
              TileChunks[i][j].fill(map.VoronoiCell[x][y].CellColor);
            } else {
              if (map.grid[x][y] == 0) {
                TileChunks[i][j].fill(0);
              } else {
                TileChunks[i][j].fill(128);
              }
            }
            if (VoronoiRepresentation) {
              if (x == (int)map.VoronoiCell[x][y].Pos.x && y ==(int)map.VoronoiCell[x][y].Pos.y) {
                TileChunks[i][j].fill(0);
              }
            }
            TileChunks[i][j].rect(k * map.tileSizeX, l * map.tileSizeY, map.tileSizeX, map.tileSizeY);
            
          }
        }
        //if (VoronoiRepresentation && ((int)VoronoiCell[i][j].Pos.x) / ChunksX == i) {
        //  TileChunks[i][j].fill(0);
        //  TileChunks[i][j].rect(VoronoiCell[i][j].Pos.x, VoronoiCell[i][j].Pos.y, tileSizeX, tileSizeY);
        //}
        TileChunks[i][j].endDraw();
      }
    }
  }
  
  
  
  void DrawGrid (int[][] grid, int tileSize) {
    int iStart = max((int)Pos.x/tileSize, 0);
    int iFinish = min(1+(int)(Pos.x+Size.x)/tileSize, grid.length);
    int jStart = max((int)Pos.y/tileSize, 0);
    int jFinish = min(1+(int)(Pos.y+Size.y)/tileSize, grid[0].length);
    //byte[][] grid = map.GetGrid();
    for (int i = iStart; i < iFinish; i++) {
      int iX = i * tileSize;
      for (int j = jStart; j < jFinish; j++) {
        if (grid[i][j] == 2) {
          fill(0,128, 255);
        } else if (grid[i][j] == 3) {
          fill(128, 128, 255);
        }
        rect(iX - Pos.x, j*tileSize - Pos.y, tileSize, tileSize);
      }
    }
  }
  
  void DrawObject (GameObject obj) {
    fill(obj.skin);
    rect(obj.Pos.x - Pos.x, obj.Pos.y - Pos.y, obj.w, obj.h);
  }
  
  void MoveTo (GameObject obj) {
    Pos.x = obj.Pos.x - (Size.x/2);
    Pos.y = obj.Pos.y - (Size.y/2);
  }
  
}
