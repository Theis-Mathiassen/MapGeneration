class GameObject {
  Vector2 Pos = new Vector2(width / 2,height / 2);
  float w = 8;
  float h = 8;
  float speed = 1;
  String Tag = "";
  color skin = color(1);
  Map map;  //The map the gameobject exists within.
  
  GameObject (Map map) {
    this(map, width / 2,height / 2);
  }
  GameObject (Map map, float x, float y) {
    Pos = new Vector2(x,y);
    this.map = map;
  }
  
  public void Update () {
    
  }
  
  
  void MoveUp () {
    if (CheckCollision(Pos.x, Pos.y - speed)) {
      Pos.y -= speed;
    }
  }
  void MoveDown() {
    if (CheckCollision(Pos.x, Pos.y + speed)) {
        Pos.y += speed;
      }
  }
  void MoveRight() {
    if (CheckCollision(Pos.x + speed, Pos.y)) {
        Pos.x += speed;
      }
  }
  void MoveLeft() {
    if (CheckCollision(Pos.x - speed, Pos.y)) {
        Pos.x -= speed;
      }
  }
  
  boolean CheckCollision (float x, float y) {
    if ((int)x/map.tileSizeX < 0 || (int)x/map.tileSizeX >= map.tilesX || (int)(y)/map.tileSizeX < 0 ||(int)(y)/map.tileSizeY >= map.tilesY ||
        (int)(x+w-1)/map.tileSizeX < 0 || (int)(x+w-1)/map.tileSizeX >= map.tilesX || (int)(y+h-1)/map.tileSizeX < 0 ||(int)(y+h-1)/map.tileSizeX >= map.tilesY) {
      return false;
    }
    if (map.grid[(int)x/map.tileSizeX][(int)(y)/map.tileSizeX] != 0 && map.grid[(int)(x+w-1)/map.tileSizeX][(int)(y)/map.tileSizeX] != 0) {
      if (map.grid[(int)x/map.tileSizeX][(int)(y+h-1)/map.tileSizeX] != 0 && map.grid[(int)(x+w-1)/map.tileSizeX][(int)(y+h-1)/map.tileSizeX] != 0) {
        return true;
      }
    }
    return false;
  }
  
}
