class Raycast {
  Vector2 Source;
  Vector2 Target;
  Vector2 Hit;
  Raycast (Vector2 Source, Vector2 Target) {
    this.Source = Source;
    this.Target = Target;
  }
  
  void Calculate (byte[][] map, int tileSize, int ObstructionValue) {
    Hit = new Vector2(Target.x, Target.y);
    //Use Bresenham's algorithm
    
  }
  void Draw () {
    stroke(0);
    line(Source.x - MainCamera.Pos.x, Source.y - MainCamera.Pos.y, Hit.x - MainCamera.Pos.x, Hit.y - MainCamera.Pos.y);
    noStroke();
  }
}
