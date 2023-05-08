int selection = 0;
int easyX, easyY;
int hardX, hardY;
int buttonH = 40;
int buttonW = 120;

String easyTxt = "EASY";
String hardTxt = "HARD";

boolean easyOver = false;
boolean hardOver = false;

int select() {
  
  textSize(20);
  
  easyX = width/2-140;
  easyY = width/2-145;
  hardX = width/2;
  hardY = width/2-145;
  
  update(mouseX, mouseY);
  noFill();
  stroke(255);
  
  if (hardOver) {
    stroke(165,195,255);
  } else {
    stroke(255);
  }
 
  rect(hardX, hardY, buttonW, buttonH);
  text(hardTxt, hardX+40, hardY+27);
  
  if (easyOver) {
    stroke(165,195,255);
  } else {
    stroke(255);
  }
  
  rect(easyX, easyY, buttonW, buttonH);
  text(easyTxt, easyX+40, easyY+27);
 
  return selection;
}

void update(int x, int y) {
  if ( overEasy(easyX, easyY, buttonW, buttonH) ) {
    easyOver = true;
    hardOver = false;
  } else if ( overHard(hardX, hardY, buttonW, buttonH) ) {
    hardOver = true;
    easyOver = false;
  } else {
    easyOver = hardOver = false;
  }
}

void mousePressed() {
  if (easyOver) {
    selection = 1;
  }
  if (hardOver) {
    selection = 2;
  }
}

  boolean overEasy(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

  boolean overHard(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}
