class Player extends GameObject {
  Player (Map map, float x, float y) {
    super(map, x, y);
    Tag = "Player";
    skin = color(255, 0, 0);
    speed = 2;
  }
  void move () {
    Vector2 dir = new Vector2();
    if (InputSystem.keys['a'] == 1) {
      dir.x -= 1;
    }
    if (InputSystem.keys['d'] == 1) {
      dir.x += 1;
    }
    if (InputSystem.keys['w'] == 1) {
      dir.y -= 1;
    }
    if (InputSystem.keys['s'] == 1) {
      dir.y += 1;
    }
    Move(dir);
  }
  public void Update () {
    super.Update();
    move();
  }
  //public void Draw () {
    //fill(255, 0,0);
    //rect(x, y, tileSizeX, tileSizeY); 
  //}
}
