//Izzy Missios

/**
 
 SOURCES
 --------
 CODE
 based on week 9 ecosystem code example by Sihwa Park
 
 IMAGES from unsplash
 copyright free, edited by me
 
 SOUNDS from freesound:
 cow - invertedturtle
 crop - Walrups
 build - InspectorJ
 build fence - InspectorJ
 game over - deleted_user_877451
 ambience - felix.blume
 
 REQUIREMENTS
 -------------
 Processing Sound library
 Gif Animation library
 
 **/

import gifAnimation.*;
import processing.sound.*;

World world;
int placeType = 1;

PImage fnc;
PImage frm;
Gif pry;
Gif prd;
Gif lvs;
PImage crp;
PImage fd;

PImage go;
PImage bg;

SoundFile gOver;
SoundFile build;
SoundFile buildFence;
SoundFile buyLive;
SoundFile plant;
SoundFile gen;

int over = 0;

int clickTimer = 0;

float noiseScale = 0.02;
float noiseStrength = 85;

int simWidth = 1000;
int simHeight = 1000;
int cellSize = 100;
int numCols = simWidth / cellSize;
int numRows = simHeight / cellSize;
ArrayList<Obstacle>[][] grid = new ArrayList[numRows][numCols];

void setup() {
  size(1280, 720);
  smooth();
  background(15, 0, 8); 
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        float noiseValue = noise(x * noiseScale, y * noiseScale);
        int green = (int) map(noiseValue, 0, 1, 15, 72);
        stroke(0, green, 0);
        point(x, y);
      }
    }
    save("data/background.png");

  fnc = loadImage("fence.png");
  frm = loadImage("building.png");
  pry = new Gif(this, "prey.gif");
  pry.play();
  prd = new Gif(this, "pred.gif");
  prd.play();
  lvs = new Gif(this, "livestock.gif");
  lvs.play();
  crp = loadImage("crop.png");
  fd = loadImage("food.png");
  go = loadImage("go.png");
  
  bg = loadImage("background.png");

  gOver = new SoundFile(this, "GAMEOVER.wav");
  build = new SoundFile(this, "BUILDING.wav");
  buildFence = new SoundFile(this, "BUILDFENCE.wav");
  buyLive = new SoundFile(this, "COW.wav");
  plant = new SoundFile(this, "PLANT.wav");
  gen = new SoundFile(this, "AMBIENCE.wav");

  gen.loop();
  gen.play();

  int numPred = 25;
  int numPrey = 75;

  world = new World(numPred, numPrey);
  world.initializeGrid();
}

void draw() {
  if (over != 1) {
    if (clickTimer > 0) {
      clickTimer = clickTimer - 1;
    }
    //fill(255,255);
    //rectMode(CORNER);
    //rect(0,0,width,height);
  //background(190,225,200);
  background(bg);
  world.run();

  //instructions
  pushMatrix();
  //fill(0,255);
  //rect(0,0,200,155);
  rectMode(CORNER);
  strokeWeight(3);
  stroke(0);
  fill(255);
  rect(width/2, height-120, width/2, 120);

  stroke(0, 255);
  strokeWeight(0);
  fill(0, 255);
  textSize(20);

  text("CLICK TO PLACE OBJECT AT MOUSE LOCATION", width/2+20, (height-120) + 25);
  text("USE KEYS TO CHANGE SELECTION", width/2+20, (height-120) + 50);

  if (placeType == 1) {
    fill(0, 205, 0);
  } else {
    fill(0);
  }
  text("BUILDING: 'B'", width/2+20, (height-120) + 85);

  if (placeType == 2) {
    fill(0, 205, 0);
  } else {
    fill(0);
  }
  text("FENCE: 'F'", width/2+20, (height-120) + 110);

  if (placeType == 3) {
    fill(0, 205, 0);
  } else {
    fill(0);
  }
  text("LIVESTOCK: 'L'", width/2+width/4-80, (height-120) + 85);

  if (placeType == 4) {
    fill(0, 205, 0);
  } else {
    fill(0);
  }
  text("CROP: 'C'", width/2+width/4-80, (height-120) + 110);

  popMatrix();
} else {
  tint(255);
  image(go, 0, 0, width, height);
}
}

void mousePressed() {
  if (clickTimer == 0) {
    //add object
    if (placeType == 1) {
      world.buildingAdd();
    } else if (placeType == 2) {
      world.fenceAdd();
    } else if (placeType == 3) {
      world.livestockAdd();
    } else if (placeType == 4) {
      world.cropAdd();
    }
    clickTimer = 10;
  } else {
    println("please don't spam objects!");
  }
}

void keyPressed() {
  if (key == 'f' || key == 'F') {
    //fence
    placeType = 2;
  } else if (key == 'b' || key == 'B') {
    //building
    placeType = 1;
  } else if (key == 'l' || key == 'L') {
    //livestock
    placeType = 3;
  } else if (key == 'c' || key == 'C') {
    //crop
    placeType = 4;
  } else {
    //ignore
  }
}

void gameOver() {
  gen.stop();
  over = 1;
  noLoop();
  gOver.play();
  //rectMode(CORNER);
  //fill(255);
  //rect(0,0,width,height);
  //fill(0);
  //textSize(120);
  //text("GAME OVER",width/4,height/2);
  tint(255);
  image(go, 0, 0, width, height);
}
