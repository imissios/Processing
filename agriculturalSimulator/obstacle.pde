class Obstacle {
  
  PVector location;
  int r;
  int type;
  int associatedPop; //each building is associated with a population humans
  float healthReqRate = 5; //rate to multiply pop by
  float reqHealth; //calculation value for health needed to maintain population
  
  Obstacle(int t) {
    type = t;
    location = new PVector(mouseX, mouseY);
    if (type == 1) {
      //building
      r = 80;
      associatedPop = int(random(8,16));
      reqHealth = associatedPop * healthReqRate;
    }
    else {
      //fence
      r = 25;
      associatedPop = 0;
      reqHealth = associatedPop * healthReqRate;
    }
    
    //performance optimization
    int row = (int) (location.y / cellSize);
    int col = (int) (location.x / cellSize);
    grid[row][col].add(this);
  }
  
  void display() {
  //fill(255, 0, 0);
  //ellipse(location.x, location.y, r * 2, r * 2);
    if (type == 1) {
      tint(255);
      image(frm,location.x,location.y,r,r);
    }
    else {
      tint(245,255,180);
      image(fnc,location.x,location.y,r,r);
    }
  }
  
  boolean checkCollision(PVector position, float radius) {
  float distance = dist(location.x, location.y, position.x, position.y);
  if (distance <= radius + this.r) {
    return true;
  }
  return false;
}
  
}
