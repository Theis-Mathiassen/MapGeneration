class Raycast {
  Vector2 Source;
  Vector2 Target;
  Vector2 Hit;
  Vector2 heading;
  
  float tmpX;
  float tmpY;
  int currentTileX;
  int currentTileY;
  
  Raycast (Vector2 Source, Vector2 Target) {
    this.Source = Source;
    this.Target = Target;
    heading = Target.subtract(Source).normalize();
  }
  
  boolean Calculate (short[][] map, int tileSize, int obstructionValue) {
    
    
    //print(heading + "\n");
    
    tmpX = Source.x;
    tmpY = Source.y;
    
    currentTileX = floor(tmpX) / tileSize;
    currentTileY = floor(tmpY) / tileSize;
    
    boolean targetReached = false;
    
    while (targetReached == false) {
      targetReached = CalculateStep(tileSize);
      try {
        if (heading.x > 0) {
          if (heading.y > 0) {
            if (map[currentTileX][currentTileY] == obstructionValue) {
              Hit = new Vector2(tmpX, tmpY);
              return false;
            }
          } else {
            if (tmpY / tileSize == currentTileY) {
              if (map[currentTileX][currentTileY-1] == obstructionValue) {
                Hit = new Vector2(tmpX, tmpY);
                return false;
              }
            } else {
              if (map[currentTileX][currentTileY] == obstructionValue) {
                Hit = new Vector2(tmpX, tmpY);
                return false;
              }
            }
          }
        }
        else {
          if (heading.y > 0) {
            if (tmpX / tileSize == currentTileX) {
              if (map[currentTileX-1][currentTileY] == obstructionValue) {
                Hit = new Vector2(tmpX, tmpY);
                return false;
              }
            } else {
              if (map[currentTileX][currentTileY] == obstructionValue) {
                Hit = new Vector2(tmpX, tmpY);
                return false;
              }
            }
          } else {
            if (tmpX / tileSize == currentTileX) {
              if (map[currentTileX-1][currentTileY] == obstructionValue) {
                Hit = new Vector2(tmpX, tmpY);
                return false;
              }
            } else if (tmpY / tileSize == currentTileY) {
              if (map[currentTileX][currentTileY-1] == obstructionValue) {
                Hit = new Vector2(tmpX, tmpY);
                return false;
              }
            } else {
              if (map[currentTileX][currentTileY] == obstructionValue) {
                Hit = new Vector2(tmpX, tmpY);
                return false;
              }
            }  
          }
        }
        
      } catch(ArrayIndexOutOfBoundsException e) {
        Hit = new Vector2(tmpX, tmpY);
        return false;
      }
      
    } //<>// //<>// //<>// //<>//
    Hit = new Vector2(Target.x, Target.y);
    return true;
  }
  
  boolean CalculateStep (int tileSize) {
    float nearestXBorder;
      if (heading.x == 0) {
        nearestXBorder = Float.MAX_VALUE;
      } else {
        if (heading.x > 0) {
          nearestXBorder = (currentTileX + 1) * tileSize;
        } else {
          if (floor(tmpX) == (currentTileX) * tileSize) {
            nearestXBorder = (currentTileX - 1) * tileSize;
          } else {
            nearestXBorder = (currentTileX) * tileSize;
          }
        }
      }
      //= heading.x == 0 ? Float.MAX_VALUE: (heading.x > 0 ? (currentTileX + 1) * tileSize : (floor(tmpX) == (currentTileX) * tileSize ? (currentTileX - 1) * tileSize : (currentTileX) * tileSize));
      
      float distToNearestXBorder = (heading.x > 0 ? nearestXBorder - tmpX : tmpX - nearestXBorder );
      //float nearestYBorder = heading.y == 0 ? Float.MAX_VALUE : (heading.y > 0 ? (currentTileY + 1) * tileSize : (floor(tmpY) == (currentTileY) * tileSize ? (currentTileY - 1) * tileSize : (currentTileY) * tileSize));
      float nearestYBorder;
      if (heading.y == 0) {
        nearestYBorder = Float.MAX_VALUE;
      } else {
        if (heading.y > 0) {
          nearestYBorder = (currentTileY + 1) * tileSize;
        } else {
          if (floor(tmpY) == (currentTileY) * tileSize) {
            nearestYBorder = (currentTileY - 1) * tileSize;
          } else {
            nearestYBorder = (currentTileY) * tileSize;
          }
        }
      }
      float distToNearestYBorder = (heading.y > 0 ? nearestYBorder - tmpY : tmpY - nearestYBorder );
      
      if (nearestXBorder == Float.NaN && nearestYBorder == Float.NaN) {
        return true;
      } else if (nearestXBorder == Float.NaN) {
        //Check if overshoot
        if ((tmpY <= Target.y && Target.y <= nearestYBorder) || (tmpY >= Target.y && Target.y >= nearestYBorder)) {
          return true;
        }
        tmpY = nearestYBorder;
        
      } else if (nearestYBorder == Float.NaN) {
        //Check if overshoot
        if ((tmpX <= Target.x && Target.x <= nearestXBorder) || (tmpX >= Target.x && Target.x >= nearestXBorder)) {
          return true;
        }
        tmpX = nearestXBorder;
      } else {
        //Check if overshoot
        /*if (heading.x == 0) {
          heading.x += 0.001;
        }
        if (heading.y == 0) {
          heading.y += 0.001;
        }*/
        float stepsToXBorder = abs(distToNearestXBorder / heading.x);
        float stepsToYBorder = abs(distToNearestYBorder / heading.y);
        if (stepsToXBorder < stepsToYBorder) {
          //Check if overshoot
          if ((tmpX <= Target.x && Target.x <= nearestXBorder) || (tmpX >= Target.x && Target.x >= nearestXBorder)) {
            return true;
          }
          tmpX += heading.x * stepsToXBorder;
          tmpY += heading.y * stepsToXBorder;
        } else {
          //Check if overshoot
          if ((tmpY <= Target.y && Target.y <= nearestYBorder) || (tmpY >= Target.y && Target.y >= nearestYBorder)) {
            return true;
          }
          tmpY += heading.y * stepsToYBorder;
          tmpX += heading.x * stepsToYBorder;
        }
      }
      currentTileX = floor(tmpX) / tileSize;
      currentTileY = floor(tmpY) / tileSize;
      //stroke(0);
      //fill(255, 0, 0);
      //circle(tmpX - MainCamera.pos.x, tmpY - MainCamera.pos.y, 4);
      //noStroke();
      
      //rect(currentTileX * tileSize - MainCamera.pos.x, currentTileY * tileSize - MainCamera.pos.y, tileSize, tileSize);
       return false;
      //print(heading.x + "\n");
  }
  
  void Draw () {
    //stroke(0);
    //line(Source.x - MainCamera.pos.x, Source.y - MainCamera.pos.y, Hit.x - MainCamera.pos.x, Hit.y - MainCamera.pos.y);
    //noStroke();
  }
}
