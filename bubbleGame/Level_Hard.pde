void hard() {  
  
  stroke(255);
  strokeWeight(2);
  textSize(100);
  
  image(back, 0, 0);
  
  mouse = new PVector(mouseX, mouseY);
  
  //defines new values whenever a point is received
  if (change == true) {
    target = random(targetMin, targetMax);
    x_val = int(random(120,x_max));
    y_val = int(random(height/2+60,(height-target)));
    m = new Mover(x_val, y_val);  
    tweight = int(random(3,4));
    change = false;
    score = score + 1;
  }
  
  //text in top left to track info
  fill(255);
  counter = "" + score;
  text(counter,30,110);
  fill(0);
  
  //draws the target somewhere on the grid, determined by the randomized x_val
   strokeWeight(tweight);
   stroke(225,225,255);
   noFill();
   m.applyForce(floater);
   m.update();
   loc_y = m.getY();
   ellipse(x_val, loc_y, target, target);
    
  strokeWeight(2);
  
  //determines if two circles are (roughly) matched up
  if ((mouse.x <= x_val + tweight) && (mouse.x >= x_val - tweight) && (mouse.y <= loc_y + tweight) && (mouse.y >= loc_y - tweight) && (size.x <= target + tweight) && (size.x >= target - tweight)) {
    success = true;
    change = true;
    bubblepop.play();
  }
  
  //change circle colour if the player gets a point
  if (success == true) {
    stroke(0,255,0);
    sCount++;
  }
  else {
    stroke(255,20,100);
    sCount = 0;
  }
  
  //slows down the transition from green to red to make it apparent that the player got a point
  if (sCount == 11) {
    success = false;
  }
  
  ellipse(mouse.x, mouse.y, size.x, size.x);
  point(mouse.x, mouse.y);
  
  //shrink movable circle when mouse button is held down
  if (mousePressed) {
    size.sub(acc);
  }
  else {
    //grow movable circle when no input
    size.add(acc);
  }
  
  //end game with a losing message when bubble hits top of frame
  if (m.checkEdges() == 1) {
    image(go, 0, 0);
    splash.play();
    noLoop();
  }
  
  
  //end game with a winning message when score is 10
  if (score >= 10) {
    image(yw, 0, 0);
    jingle.play();
    noLoop();
  }
  
}
