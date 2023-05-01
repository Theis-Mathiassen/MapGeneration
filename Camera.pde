class Camera {
  Vector2 pos;
  Vector2 Size;
  Vector2 ScreenPos;
  Vector2 ScreenSize;
  Vector2 Scale;
  PShape FloorTile;
  
  int Transparency;
  
  int ChunkSize = 128;
  PGraphics[][] TileChunks;
  boolean renderingChunks;
  Map map;
  boolean voronoiRepresentation;
  
  
  Camera (float x, float y, float w, float h, float screenX, float screenY, float screenW, float screenH, int transparency, boolean voronoiRepresentation) {
    pos = new Vector2(x,y);
    Size = new Vector2(w,h);
    ScreenPos = new Vector2(screenX, screenY);
    ScreenSize = new Vector2(screenW, screenH);
    Scale = new Vector2(screenW / w, screenH / h);
    Transparency = transparency;
    //TileChunks = new PGraphics[chunksX][chunksY];
    this.voronoiRepresentation = voronoiRepresentation;
  }
  
  void DrawMap (Map map) {
    fill(0);
    rect(ScreenPos.x, ScreenPos.y, ScreenSize.x, ScreenSize.y);
    if (TileChunks == null && renderingChunks == false && map.generated == true) {
      renderingChunks = true;
      this.map = map;
      thread("RenderMap");
    }
    if (TileChunks == null || renderingChunks == true) {
      String displayText;
      if (map.generated == true) {
        displayText = "Drawing";
      } else {
        displayText = "Generating";
      }
      if (second() % 3 < 1) {
        text(displayText + ".", width/2, height/2);
      } else if(second() % 3 < 2) {
        text(displayText + "..", width/2, height/2);
      } else {
        text(displayText + "...", width/2, height/2);
      }
        
      
    } else {
      //PImage imageToRender = createImage((int)ScreenSize.x, (int)ScreenSize.y, RGB);
      int iStart = max((int)(pos.x/ChunkSize), 0);
      int iFinish = min(1+(int)(pos.x+Size.x)/ChunkSize, TileChunks.length);
      int jStart = max((int)(pos.y/ChunkSize), 0);
      int jFinish = min(1+(int)(pos.y+Size.y)/ChunkSize, TileChunks[0].length);
      pushMatrix();
      translate(ScreenPos.x, ScreenPos.y);
      scale(Scale.x, Scale.y);
      for (int i = iStart; i < iFinish; i++) {
        int iX = i * ChunkSize;
        for (int j = jStart; j < jFinish; j++) {
          //imageToRender.set((int)(iX - pos.x),(int)(j * ChunkSize - pos.y),(PImage)TileChunks[i][j]);
          image(TileChunks[i][j], iX - pos.x, j * ChunkSize - pos.y, ChunkSize, ChunkSize);
        }
      }
      popMatrix();
      //image(imageToRender, 0,0);
    }
    
  }
  
  public void RenderChunks () {
    print("Rendering");
    int chunksX = (map.tilesX * map.tileSizeX) / ChunkSize;
    int chunksY = (map.tilesY * map.tileSizeY) / ChunkSize;
    TileChunks = new PGraphics[chunksX][chunksY];
    for (int i = 0; i < chunksX; i++) {
      for (int j = 0; j < chunksY; j++) {
        TileChunks[i][j] = createGraphics(ChunkSize, ChunkSize);
        int TilesPerChunkX = ChunkSize / map.tileSizeX;
        int TilesPerChunkY = ChunkSize / map.tileSizeY;
        TileChunks[i][j].beginDraw();
        TileChunks[i][j].noStroke();
        
        for (int k = 0; k < TilesPerChunkX; k++) {
          int x = i * TilesPerChunkX + k;
          for (int l = 0; l < TilesPerChunkY; l++) {
            int y = j * TilesPerChunkY + l;
            if (voronoiRepresentation && map.VoronoiCell[x][y] != null) {
              //Draw the cell starting point
              if (x == (int)map.VoronoiCell[x][y].pos.x && y ==(int)map.VoronoiCell[x][y].pos.y) {
                TileChunks[i][j].fill(0, Transparency);
              } else {
                TileChunks[i][j].fill(map.VoronoiCell[x][y].CellColor, Transparency);
              }
            } else {
              if (map.grid[x][y] == 0) {
                TileChunks[i][j].fill(0,Transparency);
              } else {
                TileChunks[i][j].fill(128, Transparency);
              }
            }
            
            TileChunks[i][j].rect(k * map.tileSizeX, l * map.tileSizeY, map.tileSizeX, map.tileSizeY);
            
          }
        }
        //if (voronoiRepresentation && ((int)VoronoiCell[i][j].pos.x) / chunksX == i) {
        //  TileChunks[i][j].fill(0);
        //  TileChunks[i][j].rect(VoronoiCell[i][j].pos.x, VoronoiCell[i][j].pos.y, tileSizeX, tileSizeY);
        //}
        TileChunks[i][j].endDraw();
      }
    }
    renderingChunks = false;
  }
  
  
  
  void DrawGrid (int[][] grid, int tileSize) {
    int iStart = max((int)pos.x/tileSize, 0);
    int iFinish = min(1+(int)(pos.x+Size.x)/tileSize, grid.length);
    int jStart = max((int)pos.y/tileSize, 0);
    int jFinish = min(1+(int)(pos.y+Size.y)/tileSize, grid[0].length);
    //byte[][] grid = map.GetGrid();
    color c1 = color(255, 0, 0);
    color c2 = color(0, 0, 255);
    for (int i = iStart; i < iFinish; i++) {
      int iX = i * tileSize;
      for (int j = jStart; j < jFinish; j++) {
        //if (grid[i][j] == 2) {
        //  fill(0,128, 255);
        //} else if (grid[i][j] == 3) {
        //  fill(128, 128, 255);
        //}
        //print((int)(log((grid[i][j]+1))*5) + "\n");
        float amt = (float)grid[i][j] / MaxDistanceToPath;
        //amt = log(amt+0.17)/2+0.92;
        if (grid[i][j] == Integer.MAX_VALUE) {
          fill(0);
        } else if (grid[i][j] == 0) {
          fill(255);
        } else {
          //print(MaxDistanceToPath + "\n");
          fill(lerpColor(c1, c2, amt));
        }
        rect((iX - pos.x) * Scale.x, (j*tileSize - pos.y) * Scale.y, tileSize * Scale.x, tileSize * Scale.y);
      }
    }
  }
  void DrawGrid (boolean[][] grid, int tileSize) {
    int iStart = max((int)pos.x/tileSize, 0);
    int iFinish = min(1+(int)(pos.x+Size.x)/tileSize, grid.length);
    int jStart = max((int)pos.y/tileSize, 0);
    int jFinish = min(1+(int)(pos.y+Size.y)/tileSize, grid[0].length);
    //byte[][] grid = map.GetGrid();
    for (int i = iStart; i < iFinish; i++) {
      int iX = i * tileSize;
      for (int j = jStart; j < jFinish; j++) {
        if (grid[i][j] == true) {
          fill(0,0, 255);
          rect((iX - pos.x) * Scale.x, (j*tileSize - pos.y) * Scale.y, tileSize * Scale.x, tileSize * Scale.y);
        } else {
          fill(255, 0, 0);
        }
        //rect(iX - pos.x, j*tileSize - pos.y, tileSize, tileSize);
      }
    }
  }
  
  void DrawDijkstraMapPath (DijkstraMap dMap, int tileSize) {
    int iStart = max((int)pos.x/tileSize, 0);
    int iFinish = min(1+(int)(pos.x+Size.x)/tileSize, dMap.VertexMap.length);
    int jStart = max((int)pos.y/tileSize, 0);
    int jFinish = min(1+(int)(pos.y+Size.y)/tileSize, dMap.VertexMap[0].length);
    //byte[][] grid = map.GetGrid();
    for (int i = iStart; i < iFinish; i++) {
      int iX = i * tileSize;
      for (int j = jStart; j < jFinish; j++) {
        int jY = j * tileSize;
        if (dMap.VertexMap[i][j] != null && dMap.VertexMap[i][j].prev != null) {
          stroke(1);
          int halfSize = tileSize >> 1;
          //line(iX + halfSize - pos.x, jY + halfSize - pos.y, dMap.VertexMap[i][j].prev.x * tileSize + halfSize - pos.x, dMap.VertexMap[i][j].prev.y * tileSize + halfSize - pos.y);
          drawArrow((int)((iX + halfSize - pos.x) * Scale.x), (int)((jY + halfSize - pos.y) * Scale.y), (int)((dMap.VertexMap[i][j].prev.x * tileSize + halfSize - pos.x)  * Scale.x), (int)((dMap.VertexMap[i][j].prev.y * tileSize + halfSize - pos.y) * Scale.y));
          noStroke();
        }
      }
    }
  }
  
  void DrawObject (GameObject obj) {
    if (obj.pos.x + obj.w > pos.x && obj.pos.x < pos.x + Size.x && obj.pos.y + obj.h > pos.y && obj.pos.y < pos.y + Size.y) {
      if (obj.Texture == null) { 
        fill(obj.skin);
        rect((obj.pos.x - pos.x) * Scale.x, (obj.pos.y - pos.y) * Scale.y, obj.w * Scale.x, obj.h * Scale.y);
      } else {
        image(obj.Texture, (obj.pos.x - pos.x) * Scale.x, (obj.pos.y - pos.y) * Scale.y, obj.w * Scale.x, obj.h * Scale.y);
      }
    }
  }
  
  void MoveTo (GameObject obj) {
    pos.x = obj.pos.x - (Size.x/2);
    pos.y = obj.pos.y - (Size.y/2);
  }
  
}
