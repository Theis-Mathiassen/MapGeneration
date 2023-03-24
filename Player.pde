class Player extends GameObject {
  Player (Map map, float x, float y) {
    super(map, x, y);
    Tag = "Player";
    skin = color(255, 0, 0);
    speed = 1;
  }
  void move () {
    if (InputSystem.keys['a'] == 1) {
      MoveLeft();
    }
    if (InputSystem.keys['d'] == 1) {
      MoveRight();
    }
    if (InputSystem.keys['w'] == 1) {
      MoveUp();
    }
    if (InputSystem.keys['s'] == 1) {
      MoveDown();
    }
  }
  public void Update () {
    move();
  }
  //public void Draw () {
    //fill(255, 0,0);
    //rect(x, y, tileSizeX, tileSizeY); 
  //}
}
