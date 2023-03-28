class Enemy extends GameObject {
  Raycast LineOfSight;
  Vector2 LastSeenPlayer;
  Enemy (Map map) {
    this(new Vector2(10, 10), map);
  }
  Enemy (Vector2 pos, Map map) {
    super(map);
    this.pos = pos;
    skin = color(0, 255, 0);
    speed = 0.85;
    LastSeenPlayer = new Vector2(pos.x, pos.y);
  }
  
  public void Update () {
    super.Update();
    ScanPlayer(player, MainMap, 0);
  }
  
  void ScanPlayer (Player player, Map map, int ObstructionValue) {
    LineOfSight = new Raycast(new Vector2(pos.x + w/2, pos.y + h/2),new Vector2(player.pos.x + player.w/2, player.pos.y + player.h/2));
    boolean hit = LineOfSight.Calculate(map.grid, map.tileSizeX, ObstructionValue);
    if (hit) {
      LastSeenPlayer = LineOfSight.Hit;
    }
    Move(LastSeenPlayer.subtract(new Vector2(pos.x + w/2, pos.y + h/2)));
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
