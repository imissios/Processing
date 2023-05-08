class World {
  ArrayList<Predator> pred;
  ArrayList<Prey> prey;
  ArrayList<Livestock> livestock;
  ArrayList<Obstacle> obstacles;
  Food food;
  Crop crop;

  int buildingPlaced = 0;

  float popSupplies;
  float desiredPopHealth;

  int lowSupplyCount = 0;
  int lowSupplyThreshold = 5;
  float lastLowSupplyTime = 0;

  World(int numPred, int numPrey) {
    food = new Food(numPrey*2);
    crop = new Crop(0);
    pred = new ArrayList<Predator>();
    prey = new  ArrayList<Prey>();
    livestock = new ArrayList<Livestock>();
    obstacles = new ArrayList<Obstacle>();

    for (int i = 0; i < numPred; i++) {
      PVector loc = new PVector(random(width), random(height));
      DNA dna = new DNA(1);
      pred.add(new Predator(loc, dna));
    }

    for (int i = 0; i < numPrey; i++) {
      PVector loc = new PVector(random(width), random(height));
      DNA dna = new DNA(1);
      prey.add(new Prey(loc, dna));
    }
  }

  void predBorn(float x, float y) {
    PVector loc = new PVector(x, y);
    DNA dna = new DNA(1);
    pred.add(new Predator(loc, dna));
  }

  void preyBorn(float x, float y) {
    PVector loc = new PVector(x, y);
    DNA dna = new DNA(1);
    prey.add(new Prey(loc, dna));
  }

  void livestockAdd() {
    PVector loc = new PVector(mouseX, mouseY);
    livestock.add(new Livestock(loc));
    buyLive.play();
  }

  void fenceAdd() {
    obstacles.add(new Obstacle(2));
    buildFence.play();
  }

  void buildingAdd() {
    buildingPlaced = 1;
    obstacles.add(new Obstacle(1));
    build.play();
  }

  void cropAdd() {
    PVector loc = new PVector(mouseX, mouseY);
    crop.add(loc);
    plant.play();
  }

  void run() {
    // display and update food
    food.run();
    crop.run();

    for (Obstacle o : obstacles) {
      o.display();
    }

    popSupplies = 0;
    
    for (Livestock ls : livestock) {
      ls.run();
      ls.eat(food);
      popSupplies = popSupplies + ls.health;
    }

    popSupplies = popSupplies + (crop.getCropSize() * 5);

    desiredPopHealth = 0;
    for (Obstacle o : obstacles) {
      if (o.type == 1) {
        desiredPopHealth = desiredPopHealth + o.reqHealth;
      }
    }

    // iterate over the ArrayList backwards since we delete a bloop if it's dead
    for (int i = pred.size() - 1; i >= 0; i--) {
      Predator b = pred.get(i);

      //for(int j = obstacles.size() - 1; j >= 0; j--) {
      //  Obstacle obstacle = obstacles.get(j);
      //  b.checkObstacleCollision(obstacle);
      //  if (b.checkObstacleCollision(obstacle) >= 0.9) {
      //    obstacles.remove(obstacle);
      //  }
      //}

      b.run(pred);
      b.eat(prey);
      b.eatFarm(livestock);

      if (b.dead()) {
        pred.remove(i);
        // make food at where the bloop is dead
        food.add(b.location);
      }

      Predator pdChild = b.reproduce();
      if (pdChild != null) pred.add(pdChild);
    }

    for (int i = prey.size() - 1; i >= 0; i--) {
      Prey p = prey.get(i);

      //for(int j = obstacles.size() - 1; j >= 0; j--) {
      //  Obstacle obstacle = obstacles.get(j);
      //  p.checkObstacleCollision(obstacle);
      //  if (p.checkObstacleCollision(obstacle) >= 0.9) {
      //    obstacles.remove(obstacle);
      //  }
      //  obstacle.display();
      //}

      p.run();
      p.eat(food);
      p.eat(crop);

      if (p.dead()) {
        prey.remove(i);
        // make food at where the bloop is dead
        food.add(p.location);
      }

      Prey pyChild = p.reproduce(prey.size());
      if (pyChild != null) prey.add(pyChild);
    }

    checkCollisions();
    counters();

    if (popSupplies < (0.5 * desiredPopHealth) && buildingPlaced == 1) {
      if (popSupplies == 0) {
        if (lastLowSupplyTime == 0) {
          lastLowSupplyTime = millis();
        } else {
          if (millis() - lastLowSupplyTime >= 5000) { //call gameOver() after 5 seconds of supplies being 0
            gameOver();
          }
        }
      } else if (popSupplies < (0.5 * desiredPopHealth)) {
        if (lastLowSupplyTime == 0) {
          lastLowSupplyTime = millis();
        } else {
          if (millis() - lastLowSupplyTime >= 5000) { //call gameOver() after 5 seconds of supplies being below 50% of requirements
            gameOver();
          }
        }
      }      
      else {
        lastLowSupplyTime = 0; //reset the timer if popSupplies becomes non-zero
      }
    }
  }


  void counters() {
    pushMatrix();

    rectMode(CORNER);
    strokeWeight(3);
    stroke(0);
    fill(255);
    rect(0, height-120, width/2, 120);

    stroke(0, 255);
    strokeWeight(0);
    fill(0, 255);
    textSize(20);

    if (buildingPlaced != 0) {

      text("ADD LIVESTOCK/CROPS TO SUSTAIN THE POPULATION!", 20, (height-120) + 30);
      text("HUMAN POPULATION HEALTH:", 20, (height-120) + 55);
      rect(20, ((height-120) + 70), width/4, 40);
      float supplies = popSupplies; //copy of variable
      if (supplies > desiredPopHealth) {
        supplies = desiredPopHealth;
      }
      else {
        //
      }
      float popHealthBar = map(supplies, 0, desiredPopHealth, 0, (width/4-6));
      if (supplies/desiredPopHealth <= 0.25) {
        fill(150, 0, 20);
      } else if (supplies/desiredPopHealth <= 0.50) {
        fill(150, 85, 20);
      } else if (supplies/desiredPopHealth <= 0.75) {
        fill(120, 140, 20);
      } else {
        fill(20, 150, 30);
      }
      rect(23, ((height-120) + 73), popHealthBar, 34);
    }
    
    fill(0);

    text("PREY: "+prey.size(), width/4+120, (height-120) + 60);
    text("PREDATORS: "+pred.size(), width/4+120, (height-120) + 85);
    text("LIVESTOCK: "+livestock.size(), width/4+120, (height-120) + 110);

    popMatrix();
  }

  void initializeGrid() {
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numCols; j++) {
        grid[i][j] = new ArrayList<Obstacle>();
      }
    }
  }

  void checkCollisions() {
    // Check for collisions using the grid
    for (Predator animal : pred) {
      int row = (int) (animal.location.y / cellSize);
      int col = (int) (animal.location.x / cellSize);
      for (int i = row - 1; i <= row + 1; i++) {
        for (int j = col - 1; j <= col + 1; j++) {
          if (i >= 0 && i < numRows && j >= 0 && j < numCols) {
            ArrayList<Obstacle> cell = grid[i][j];
            for (Obstacle obstacle : cell) {
              if (obstacle.checkCollision(animal.location, animal.r)) {
                animal.checkObstacleCollision(obstacle);
                if (animal.checkObstacleCollision(obstacle) >= 0.9) {
                  obstacles.remove(obstacle);
                }
              }
            }
          }
        }
      }
    }
    for (Livestock animal : livestock) {
      int row = (int) (animal.location.y / cellSize);
      int col = (int) (animal.location.x / cellSize);
      for (int i = row - 1; i <= row + 1; i++) {
        for (int j = col - 1; j <= col + 1; j++) {
          if (i >= 0 && i < numRows && j >= 0 && j < numCols) {
            ArrayList<Obstacle> cell = grid[i][j];
            for (Obstacle obstacle : cell) {
              if (obstacle.checkCollision(animal.location, animal.r)) {
                animal.checkObstacleCollision(obstacle);
              }
            }
          }
        }
      }
    }
    for (Prey animal : prey) {
      int row = (int) (animal.location.y / cellSize);
      int col = (int) (animal.location.x / cellSize);
      for (int i = row - 1; i <= row + 1; i++) {
        for (int j = col - 1; j <= col + 1; j++) {
          if (i >= 0 && i < numRows && j >= 0 && j < numCols) {
            ArrayList<Obstacle> cell = grid[i][j];
            for (Obstacle obstacle : cell) {
              if (obstacle.checkCollision(animal.location, animal.r)) {
                animal.checkObstacleCollision(obstacle);
                if (animal.checkObstacleCollision(obstacle) >= 0.9) {
                  obstacles.remove(obstacle);
                }
              }
            }
          }
        }
      }
    }
  }
}
