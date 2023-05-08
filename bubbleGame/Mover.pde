class Mover {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;

  Mover(int x, int y) {
    location = new PVector(x,y);
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    mass = 1;
  }
  
  void applyForce(PVector force) {
    PVector f = PVector.div(force,mass);
    acceleration.add(f);
  }
  
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  float getY() {
    return location.y;
  }

  int checkEdges() {

    if (location.y <= 0) {
      return 1;
    }
    else {
      return 0;
    }

  }

}
