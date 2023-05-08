import processing.sound.*;

PImage back;
PImage go;
PImage yw;
PImage ocean;

SoundFile bubblepop;
SoundFile jingle;
SoundFile splash;

Mover m;

int x_max;
int x_val;
int y_val;
float loc_y;

PVector mouse;
PVector size;
PVector acc;
PVector floater;

float targetMax = 80.0;
float targetMin = 6.0;
float target;
int tweight;

boolean change = true;
boolean success = false;
int sCount = 0;

int levelSel = 0;
int score = -1;
float damp = 1;
String counter;

boolean win = false;

/**
  *
  * INSTRUCTIONS *
  *
  * your cursor location controls a circle's location
  * your mouse button helps you control the size of the circle
  * use both to line your circle up with the bubbles to gain points
  * you win after 10 points, or you lose if you miss a bubble before it reaches the top
  *
  *
**/

void setup() {
  size(900, 675);
  
  noFill();
  strokeWeight(2);
  background(255);
  stroke(255);
  textSize(100);
  
  go = loadImage("game_over.png");
  ocean = loadImage("ocean.png");
  back = loadImage("ocean_score.png");
  yw = loadImage("you_won.png");
  
  bubblepop = new SoundFile(this,"pop.wav");
  bubblepop.amp(0.5);
  
  splash = new SoundFile(this,"lose_splash.wav");
  splash.amp(0.75);
  jingle = new SoundFile(this,"win_jingle.wav");
  jingle.amp(0.75);
  
  image(ocean, 0, 0);
  
  size = new PVector(10,10);
  acc = new PVector(1,1);
  
  x_max = width - 120;
  
}

void draw() {  
  
  if (levelSel == 0){
    levelSel = select();
  }
  else if (levelSel == 1){
    floater = new PVector(0, -0.0075);
    easy();
  }
  else {
    floater = new PVector(0, -0.013);
    hard();
  }
  
}
