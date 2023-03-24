class Enemy extends GameObject {
  Raycast LineOfSight;
  Enemy (Map map) {
    this(new Vector2(10, 10), map);
  }
  Enemy (Vector2 pos, Map map) {
    super(map);
    Pos = pos;
    skin = color(0, 255, 0);
  }
  
  public void Update () {
    ScanPlayer(player, MainMap, 0);
  }
  
  void ScanPlayer (Player player, Map map, int ObstructionValue) {
    LineOfSight = new Raycast(new Vector2(Pos.x, Pos.y),new Vector2(player.Pos.x, player.Pos.y));
    LineOfSight.Calculate(map.grid, map.tileSizeX, ObstructionValue);
    //LineOfSight.Draw();
  }
}
