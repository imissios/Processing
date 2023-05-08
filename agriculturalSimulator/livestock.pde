
class Livestock {
  PVector location;
  DNA dna;
  
  float health;
  float maxspeed;
  float r;
  float xoff, yoff;
  
  Livestock(PVector loc) {
    location = loc.copy();
    health = 20;
    xoff = random(1000);
    yoff = random(1000);
    
    // genes[0] determines maxspeed and r
    //maxspeed = map(dna.genes[0], 0, 1, 15, 0);
    maxspeed = 2;
    r = 30;
  }
  
  void run() {
    update();
    borders();
    display();
  }
  
  void update() {
    float vx = map(noise(xoff), 0, 1, -maxspeed, maxspeed);
    float vy = map(noise(yoff), 0, 1, -maxspeed, maxspeed);
    PVector velocity = new PVector(vx, vy);
    
    location.add(velocity);
    
    xoff += 0.01;
    yoff += 0.01;
  }
  
  void collisionUpdate(PVector force) {
    location.add(force);
  }
  
  void eat(Food f) {
    ArrayList<PVector> food = f.getFood();
    
    for(int i = food.size() - 1; i >= 0; i--) {
      PVector p = food.get(i);
      int eatRange = 30;
      
      PVector d = new PVector(p.x, p.y);
      PVector distVect = PVector.sub(this.location, d);
      float dist = distVect.mag();
      if (dist < eatRange){
        food.remove(i);
      }
    }
  }
  
  // wraparound
  void borders() {
    if (location.x < -r) location.x = width + r;
    if (location.y < -r) location.y = height + r;
    if (location.x > width + r) location.x = -r;
    if (location.y > height + r) location.y = -r;
  }
  
  void checkObstacleCollision(Obstacle obstacle) {
  float distance = dist(location.x, location.y, obstacle.location.x, obstacle.location.y);
  if (distance <= r + obstacle.r) {
        PVector avoidance = PVector.sub(location, obstacle.location);
        avoidance.normalize();
        avoidance.mult(maxspeed);
        collisionUpdate(avoidance);
    }
  }
  
  void display() {
    //ellipseMode(CENTER);
    //stroke(0, health);  // health determines opacity
    //fill(0,255,0,health);    // health determines opacity
    //ellipse(location.x, location.y, r, r);
    tint(255);
    image(lvs,location.x,location.y,r,r);
  }
}
