
class Crop {
  ArrayList<PVector> crop;
  
  Crop(int num) {
    crop = new ArrayList();
    for(int i = 0; i < num; i++) {
      crop.add(new PVector(random(width), random(height))); 
    }
  }
  
  void add(PVector loc) {
    crop.add(loc.copy()); 
  }
  
  void run() {
    display();
  }
  
  void display() {
    for(PVector f: crop) {
      //tint(220,255,180);
      tint(255);
      image(crp,f.x,f.y,16,16);
      //rectMode(CENTER);
      //stroke(0);
      //fill(255,0,255);
      //rect(f.x, f.y, 8, 8);
    }
  }
  
  ArrayList getCrop() {
    return crop; 
  }
  
  int getCropSize() {
    return crop.size();
  }
}
