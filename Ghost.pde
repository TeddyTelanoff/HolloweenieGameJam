class Ghost implements IGhost {
  PVector pos, vel, dir;
  float speed, ang, viewDist, size, 
    attackDist, attackDamageMin, attackDamageMax, attackTime, attackCooldown, attackTicks;

  void update() {
    if (attackTicks < attackCooldown) {
      attackTicks += deltaTime;
    }

    if (sqrt(pow(player.pos.x - pos.x, 2) + pow(player.pos.y - pos.y, 2)) <= viewDist) {
      dir = new PVector(player.pos.x - pos.x, player.pos.y - pos.y).normalize();

      if (random(100 * deltaTime) < 1)
        attack();
    } else
      dir = PVector.fromAngle(ang);
    dir.add(new PVector(random(-1, 1), random(-1, 1)));

    vel.add(PVector.mult(dir, speed).mult(deltaTime));

    PVector ppos = pos.copy();

    pos.add(vel);
    vel.lerp(new PVector(), 0.75);

    if (pos.x < 0)
      pos.x = width;
    if (pos.y < 0)
      pos.y = height;
    if (pos.x > width)
      pos.x = 0;
    if (pos.y > height)
      pos.y = 0;
  }

  void attack() {
    if (sqrt(pow(player.pos.x - pos.x, 2) + pow(player.pos.y - pos.y, 2)) <= viewDist) {
      player.health -= map(attackTicks, 0, attackCooldown, attackDamageMin, attackDamageMax);
    }

    attackTicks = 0;
  }

  void draw() {
    if (sprites.get("ghost") == null) {
      fill(#FF0000);
      square(pos.x - size / 2, pos.y - size / 2, size);
    } else {
      image(sprites.get("ghost"), pos.x - size / 2, pos.y - size / 2, size, size);
    }
  }
}
