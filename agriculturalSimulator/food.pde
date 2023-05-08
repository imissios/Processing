
class Food {
  ArrayList<PVector> food;
  
  Food(int num) {
    food = new ArrayList();
    for(int i = 0; i < num; i++) {
      food.add(new PVector(random(width), random(height))); 
    }
  }
  
  void add(PVector loc) {
    food.add(loc.copy()); 
  }
  
  void run() {
    display();
    
    // there is 10% chance food will appear randomly
    if(random(1) < 0.1) {
      food.add(new PVector(random(width), random(height)));
    }
  }
  
  void display() {
    for(PVector f: food) {
      //rectMode(CENTER);
      //stroke(0);
      //fill(255,255,0);
      //rect(f.x, f.y, 8, 8);
      tint(255);
      image(fd,f.x,f.y,16,16);
    }
  }
  
  ArrayList getFood() {
    return food; 
  }
}
