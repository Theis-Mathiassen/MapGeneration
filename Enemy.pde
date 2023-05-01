class Enemy extends GameObject {
  Raycast LineOfSight;
  Vector2 LastSeenPlayer;
  Enemy (Map map) {
    this(map, new Vector2(10, 10), "");
  }
  Enemy (Map map, Vector2 pos, String asset) {
    super(map, pos.x, pos.y, asset);
    this.pos = pos;
    skin = color(0, 255, 0);
    speed = 3;
    LastSeenPlayer = new Vector2(pos.x, pos.y);
  }
  
  public void Update () {
    super.Update();
    ScanPlayer(player, MainMap, 0);
    if (CheckCollision(player)) {
      player.dead = true;
    }
  }
  
  void ScanPlayer (Player player, Map map, int ObstructionValue) {
    LineOfSight = new Raycast(new Vector2(pos.x + w/2, pos.y + h/2),new Vector2(player.pos.x + player.w/2, player.pos.y + player.h/2));
    boolean hit = LineOfSight.Calculate(map.grid, map.tileSizeX, ObstructionValue);
    if (hit) {
      LastSeenPlayer = LineOfSight.Hit;
    }
    Vector2 moveAction = LastSeenPlayer.subtract(new Vector2(pos.x + w/2, pos.y + h/2));
    if (moveAction.length() > speed) {
      Move(moveAction);
    }
    /*if (LastSeenPlayer.x - pos.x < 0) {
      MoveLeft();
    } else {
      MoveRight();
    }
    if (LastSeenPlayer.y - pos.y < 0) {
      MoveUp();
    } else {
      MoveDown();
    }*/
    LineOfSight.Draw();
  }
}
