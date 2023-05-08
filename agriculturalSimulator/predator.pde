class Predator {
  PVector location;
  PVector velocity = new PVector(0, 0);
  DNA dna;

  float health;
  float maxspeed;
  float maxforce = 5;
  float r;
  float xoff, yoff;
  int marked;

  Predator(PVector loc, DNA dna) {
    this.dna = dna;
    location = loc.copy();
    health = 150;
    xoff = random(1000);
    yoff = random(1000);
    marked = 0;

    // genes[0] determines maxspeed and r
    //maxspeed = map(dna.genes[0], 0, 1, 15, 0);
    r = map(dna.genes[0], 0, 1, 20, 50);
    maxspeed = 1;
  }

  void run(ArrayList<Predator> predators) {
    update();
    herd(predators);
    borders();
    display();
  }

  void update() {
    float vx = map(noise(xoff), 0, 1, -maxspeed, maxspeed);
    float vy = map(noise(yoff), 0, 1, -maxspeed, maxspeed);
    velocity = new PVector(vx, vy);

    //location.add(velocity);
    health -= 0.2;

    xoff += 0.01;
    yoff += 0.01;
  }

  void herd(ArrayList<Predator> predators) {
    
    float desiredSeparation = r * 2;
    PVector sum = new PVector();
    int count = 0;
    for (Predator other : predators) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < desiredSeparation)) {
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);
        sum.add(diff);
        count++;
      }
    }
    if (count > 0) {
      if (count > 5) {
        PVector separation = separate(predators);
        separation.mult(2);
        collisionUpdate(separation);
      } else {
        sum.div(count);
        sum.normalize();
        sum.mult(maxspeed);
        PVector steer = PVector.sub(sum, velocity);
        steer.limit(maxforce);
        collisionUpdate(steer);
      }
    } else {
      location.add(velocity);
    }
  }

  PVector separate(ArrayList<Predator> predators) {
    float desiredSeparation = r;
    PVector sum = new PVector();
    int count = 0;
    for (Predator other : predators) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < desiredSeparation)) {
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);
        sum.add(diff);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } else {
      return new PVector();
    }
  }

  void collisionUpdate(PVector force) {
    velocity.add(force);
    location.add(velocity);
  }

  void eat(ArrayList<Prey> prey) {

    int eatRange = 20;

    if (health < 75) {

      for (int i = prey.size() - 1; i >= 0; i--) {
        Prey py = prey.get(i);

        PVector d = new PVector(py.location.x, py.location.y);
        PVector distVect = PVector.sub(this.location, d);
        float dist = distVect.mag();
        if (dist < eatRange) {
          prey.remove(i);
          health += 25;
        }
      }
    } else {
      //do nothing if not hungry
    }
  }

  void eatFarm(ArrayList<Livestock> livestock) {

    int eatRange = 20;

    if (health < 75) {

      for (int i = livestock.size() - 1; i >= 0; i--) {
        Livestock lv = livestock.get(i);

        PVector d = new PVector(lv.location.x, lv.location.y);
        PVector distVect = PVector.sub(this.location, d);
        float dist = distVect.mag();
        if (dist < eatRange) {
          if (marked == 0) {
            marked = 1;
            livestock.remove(i);
            health += 25;
          } else {
            health = 0;
            //killed by humans
          }
        }
      }
    } else {
      //do nothing if not hungry
    }
  }

  // at any moment, there is a tiny chance a bloop will reproduce
  Predator reproduce() {
    Predator child = null;
    if (random(1) < 0.00075) {
      DNA dnaNew = this.dna.copy();
      dnaNew.mutate(0.01);
      child = new Predator(location, dnaNew);
      return child;
    } else {
      return null;
    }
  }

  boolean dead() {
    if (health < 0.0) {
      return true;
    } else {
      return false;
    }
  }

  // wraparound
  void borders() {
    int heightBox = 120;
    if (location.x < -r) location.x = width + r;
    if (location.y < -r) location.y = height + r - 120;
    if (location.x > width + r) location.x = -r;
    if (location.y > height-heightBox + r) location.y = -r;
  }

  float checkObstacleCollision(Obstacle obstacle) {
    float distance = dist(location.x, location.y, obstacle.location.x, obstacle.location.y);
    float chanceToBreak = 0.0;
    if (distance <= r + obstacle.r) {
      if (obstacle.type == 2) {
        //chance to break fence
        chanceToBreak = random(1);
        if (chanceToBreak >= 0.9) {
          //no change to pathing, because fence will break
        } else {
          //if fence doesn't break
          PVector avoidance = PVector.sub(location, obstacle.location);
          avoidance.normalize();
          avoidance.mult(maxspeed);
          collisionUpdate(avoidance);
        }
      } else {
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
    //if (marked == 1) {
    //  stroke(255,0,0);
    //}
    //else {
    //  stroke(0);
    //}
    //fill(255,0,0, health);    // health determines opacity
    //ellipse(location.x, location.y, r, r);
    if (marked == 1) {
      tint(250, 150, 150);
    } else {
      tint(255);
    }
    image(prd, location.x, location.y, r, r);
  }
}
