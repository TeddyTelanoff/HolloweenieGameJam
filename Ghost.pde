class Ghost implements IGhost {
  PVector pos, vel, dir;
  float speed, viewDist, size, 
    attackDist, attackDamageMin, attackDamageMax, attackTime, attackCooldown, attackTicks;

  void update() {
    if (attackTicks < attackCooldown) {
      attackTicks += deltaTime;
    }

    if (sqrt(pow(player.pos.x - pos.x, 2) + pow(player.pos.y - pos.y, 2)) <= viewDist) {
      dir = new PVector(player.pos.x - random(-viewDist, viewDist) - pos.x, player.pos.y - random(-viewDist, viewDist) - pos.y).normalize();
      vel.add(PVector.mult(dir, speed).mult(deltaTime));

      PVector ppos = pos.copy();

      pos.add(vel);
      vel.lerp(new PVector(), 0.75);

      for (Wall wall : walls)
        if (wall.isColliding(this)) {
          pos = ppos.copy();

          break;
        }

      if (random(100 * deltaTime) < 1)
        attack();
    }
  }

  void attack() {
    if (sqrt(pow(player.pos.x - pos.x, 2) + pow(player.pos.y - pos.y, 2)) <= viewDist) {
      player.health -= map(attackTicks, 0, attackCooldown, attackDamageMin, attackDamageMax);
    }

    attackTicks = 0;
  }

  void draw() {
    fill(#FF0000);
    square(pos.x - size / 2, pos.y - size / 2, size);
  }
}
