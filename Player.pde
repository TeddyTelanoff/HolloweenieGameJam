class Player implements IPlayer {
  PVector pos, vel, 
    attackIndicatorSize, healthBarSize;
  float speed, viewDist, size, 
    attackDist, attackTime, attackCooldown, attackTicks, 
    health, maxHealth, hpReach;

  void update() {
    if (health <= 0)
      noLoop();

    if (keys.contains(VK_LEFT))
      move(new PVector(-1, 0));
    if (keys.contains(VK_RIGHT))
      move(new PVector( 1, 0));
    if (keys.contains(VK_UP))
      move(new PVector( 0, -1));
    if (keys.contains(VK_DOWN))
      move(new PVector( 0, 1));

    if (attackTicks < attackCooldown) {
      attackTicks += deltaTime;
    }

    if (keys.contains(VK_SPACE))
      attack();

    pos.add(vel);
    vel.lerp(new PVector(), 0.75);
    
    health = maxHealth;
    
    if (pos.x < 0)
      pos.x = 0;
    if (pos.y < 0)
      pos.y = 0;
    if (pos.x > width)
      pos.x = width;
    if (pos.y > height)
      pos.y = height;

    for (Wall wall : walls)
      if (wall.isColliding(this)) {
        if (wall.pos.x + wall.size.x >= pos.x - size / 2) {
          pos.x -= (pos.x - size / 2) - (wall.pos.x + wall.size.x);
        }
        else if (wall.pos.x <= pos.x + size / 2) {
          pos.x += (pos.x + size / 2) - (wall.pos.x);
        }
      }
      
    for (int i = healthBoosters.size() - 1; i >= 0; i--)
      if (sqrt(pow(healthBoosters.get(i).pos.x - pos.x, 2) + pow(healthBoosters.get(i).pos.y - pos.y, 2)) <= hpReach) {
        health = constrain(health += healthBoosters.get(i).hp, 0, maxHealth);
        
        healthBoosters.remove(i);
        createHealthBooster();

        break;
      }

    if (attackTicks < attackTime)
      for (int i = ghosts.size() - 1; i >= 0; i--) {
        if (sqrt(pow(ghosts.get(i).pos.x - pos.x, 2) + pow(ghosts.get(i).pos.y - pos.y, 2)) <= attackDist) {
          ghosts.remove(i);

          createGhost();
        }
      }
  }

  void draw() {
    noStroke();
    if (attackTicks < attackTime) {
      fill(0x3950ABC1);
      circle(pos.x, pos.y, attackDist * 2);
    }
    if (sprites.get("player") == null) {
      fill(#FFFF00);
      square(pos.x - size / 2, pos.y - size / 2, size);
    } else {
      image(sprites.get("player"), pos.x - size / 2, pos.y - size / 2, size, size);
    }
  }

  void drawUI() {
    attackIndicator();
    drawHealth();
  }

  void drawHealth() {
    fill(#5F502D);
    strokeWeight(4);
    stroke(#746137);
    rect(25 + 25 + attackIndicatorSize.x + 4 - 4, 15 - 4, healthBarSize.x + 8, healthBarSize.y + 8);

    if (health > 0) {
      fill(#F50A51);
      noStroke();
      rect(25 + 25 + attackIndicatorSize.x + 4, 15, (health / maxHealth) * healthBarSize.x, healthBarSize.y);
    }
  }

  void attack() {
    if (attackTicks >= attackCooldown) {
      attackTicks = 0;
    }
  }

  void attackIndicator() {
    fill(#5F502D);
    strokeWeight(4);
    stroke(#746137);
    rect(25 - 4, 15 - 4, attackIndicatorSize.x + 8, attackIndicatorSize.y + 8);

    if (attackTicks != 0) {
      fill(#50ABC1);
      noStroke();
      rect(25, 15, (attackTicks / attackCooldown) * attackIndicatorSize.x, attackIndicatorSize.y);
    }
  }

  void mask() {
    loadPixels();
    for (int y = 0; y < height; y++)
      for (int x = 0; x < width; x++) {
        if (sqrt(pow(x - pos.x, 2) + pow(y - pos.y, 2)) > viewDist) {
          pixels[x + y * width] = color(24);
        }
      }
    updatePixels();
    
    if (health < 5 && sprites.get("death_overlay") != null)
      image(sprites.get("death_overlay"), 0, 0);
  }

  void move(PVector dir) {
    vel.add(dir.mult(speed).mult(deltaTime));
  }
}
