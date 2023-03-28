class Vector2 {
  float x;
  float y;
  Vector2 (float x, float y) {
    this.x = x;
    this.y = y;
  }
  Vector2() {
    this(0,0);
  }
  
  Vector2 subtract (Vector2 vec) {
    return new Vector2(x-vec.x, y-vec.y);
  }
  Vector2 multiply (float num) {
    return new Vector2(x*num, y*num);
  }
  Vector2 divide (float num) {
    if (num == 0)
      print("Vector division by zero");
    return new Vector2(x/num, y/num);
  }
  float length () {
    return sqrt(x*x+y*y);
  }
  Vector2 normalize () {
    if (this.length() == 0) {
      return new Vector2();
    } else {
      return this.divide(this.length());
    }
    
  }
  String toString () {
    return "(x: " + x + ", y: " + y + ")";
  }
  
}
