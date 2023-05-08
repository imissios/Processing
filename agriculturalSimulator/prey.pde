
class Prey {
  PVector location;
  DNA dna;
  
  float health;
  float maxspeed;
  float r;
  float xoff, yoff;
  int marked;
  
  Prey(PVector loc, DNA dna) {
    this.dna = dna;
    location = loc.copy();
    health = 50;
    marked = 0;
    xoff = random(1000);
    yoff = random(1000);
    
    // genes[0] determines maxspeed and r
    //maxspeed = map(dna.genes[0], 0, 1, 15, 0);
    maxspeed = 10;
    r = map(dna.genes[0], 0, 1, 30, 65);
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
    health -= 0.2;
    
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
        health += 25;
      }
    }
  }
  
  void eat(Crop f) {
    ArrayList<PVector> food = f.getCrop();
    
    if (health < 25) {
    
    for(int i = food.size() - 1; i >= 0; i--) {
      PVector p = food.get(i);
      int eatRange = 30;
      
      PVector d = new PVector(p.x, p.y);
      PVector distVect = PVector.sub(this.location, d);
      float dist = distVect.mag();
        if (dist < eatRange){
          if (marked == 0) {
            food.remove(i);
            health += 25;
            marked = 1;
        }
        else {
          health = 0; //killed
        }
      }
    }
    }
  }
  
  Prey reproduce(int popSize) {
    Prey child = null;
    float repRate = 0.0025; //default rate
    if (popSize <= 20) {
      repRate *= 3.0;
    }
    if(random(1) < repRate) { 
       DNA dnaNew = this.dna.copy();
       dnaNew.mutate(0.01); 
       child = new Prey(location,dnaNew);
       return child;
    }
    else {
      return null;
    }
  }
  
  boolean dead() {
    if(health < 0.0) {
      return true;
    } 
    else {
      return false;
    }
  }
  
  // wraparound
  void borders() {
    int heightBox = 120;
    if (location.x < -r) location.x = width + r;
    if (location.y < -r) location.y = height + r - 120;
    if (location.x > width + r) location.x = -r;
    if (location.y > height - heightBox + r) location.y = -r;
  }
  
  float checkObstacleCollision(Obstacle obstacle) {
  float distance = dist(location.x, location.y, obstacle.location.x, obstacle.location.y);
  float chanceToBreak = 0.0;
  if (distance <= r + obstacle.r) {
    if (obstacle.type == 2) {
      //chance to break fence
      chanceToBreak = random(1);
      if (chanceToBreak >= 0.95) {
        //no change to pathing, because fence will break
      }
      else {
        //if fence doesn't break
        PVector avoidance = PVector.sub(location, obstacle.location);
        avoidance.normalize();
        avoidance.mult(maxspeed);
        collisionUpdate(avoidance);
      }
    }
    else {
      PVector avoidance = PVector.sub(location, obstacle.location);
      avoidance.normalize();
      avoidance.mult(maxspeed);
      collisionUpdate(avoidance);
    }
    }
    return chanceToBreak;
  }
  
  void display() {
    //ellipseMode(CENTER);
    //stroke(0, health);  // health determines opacity
    //fill(0,255,0,health);    // health determines opacity
    //ellipse(location.x, location.y, r, r);
    pushMatrix();
    if (marked == 1) {
      tint(255,120,120);
    }
    else {
      //tint(255,220,180);
      tint(255);
    }
    image(pry,location.x,location.y,r,r);
    popMatrix();
  }
}
