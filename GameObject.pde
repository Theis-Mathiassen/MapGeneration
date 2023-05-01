class GameObject {
  Vector2 pos = new Vector2(width / 2,height / 2);
  float w = MainMap.tileSizeX;
  float h = MainMap.tileSizeY;
  float speed = 1;
  String Tag = "";
  color skin = color(1);
  boolean HasMoved = false;
  Map map;  //The map the gameobject exists within.
  
  boolean dead;
  
  PImage Texture;
  
  GameObject (Map map) {
    this(map, width / 2,height / 2, "");
  }
  GameObject (Map map, float x, float y, String AssetsPath) {
    pos = new Vector2(x,y);
    this.map = map;
    
    Texture = loadImage(AssetsPath);
  }
  
  public void Update () {
    HasMoved = false;
  }
  
  void Move (Vector2 heading) {
    heading = heading.normalize();
    if (HasMoved == false) {
      //print("x:" + heading.x + ", y: " + heading.y + "\n");
      //for (int i = GameObjects
      
      for (int i = 0; i < speed; i++) {
        if (CheckCollision(pos.x, pos.y + heading.y)) {
          pos.y += heading.y;
        }
        if (CheckCollision(pos.x + heading.x, pos.y)) {
          pos.x += heading.x;
        }
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
  
  boolean CheckCollision (GameObject obj) {
    return pos.x < obj.pos.x + obj.w && pos.x + w > obj.pos.x && pos.y < obj.pos.y + obj.h && pos.y + h > obj.pos.y;
  }
  
  boolean CheckCollision (GameObject obj, float x, float y) {
    return x < obj.pos.x + obj.w && x + w > obj.pos.x && y < obj.pos.y + obj.h && y + h > obj.pos.y;
  }
  
}
