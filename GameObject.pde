class GameObject {
  Vector2 pos = new Vector2(width / 2,height / 2);
  float w = 8;
  float h = 8;
  float speed = 1;
  String Tag = "";
  color skin = color(1);
  boolean HasMoved = false;
  Map map;  //The map the gameobject exists within.
  
  GameObject (Map map) {
    this(map, width / 2,height / 2);
  }
  GameObject (Map map, float x, float y) {
    pos = new Vector2(x,y);
    this.map = map;
  }
  
  public void Update () {
    HasMoved = false;
  }
  
  void Move (Vector2 heading) {
    heading = heading.normalize().multiply(speed);
    if (HasMoved == false) {
      print("x:" + heading.x + ", y: " + heading.y + "\n");
      if (CheckCollision(pos.x, pos.y + heading.y)) {
        pos.y += heading.y;
      }
      
      if (CheckCollision(pos.x + heading.x, pos.y)) {
        pos.x += heading.x;
      }
      HasMoved = true;
    }
  }
  
  void MoveUp () {
    Move(new Vector2(0, -1));
  }
  void MoveDown() {
    Move(new Vector2(0, 1));
  }
  void MoveRight() {
    Move(new Vector2(1, 0));
  }
  void MoveLeft() {
    Move(new Vector2(-1, 0));
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
