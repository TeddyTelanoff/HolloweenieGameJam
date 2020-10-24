import static java.awt.event.KeyEvent.*;

Player player;
Map map;

ArrayList<Ghost> ghosts = new ArrayList();
ArrayList<Wall> walls = new ArrayList();
ArrayList<HealthBooster> healthBoosters = new ArrayList();

int time;
float deltaTime;

Ghost createGhost() {
  Ghost ghost;
  ghosts.add(ghost = new Ghost() {
    {
      pos = new PVector(random(width), random(height));
      vel = new PVector();
      speed = 150;
      size = 45;
      viewDist = 200;

      attackDist = 100;
      attackDamageMin = 0;
      attackDamageMax = 1.25;
      attackTime = 0.15;
      attackTicks = attackCooldown = 2;
    }
  }
  );

  for (Wall wall : walls)
    if (wall.isColliding(ghost)) {
      ghosts.remove(ghost);

      return createGhost();
    }

  return ghost;
}

HealthBooster createHealthBooster() {
  HealthBooster healthBooster;
  healthBoosters.add(healthBooster = new HealthBooster() {
    {
      pos = new PVector(random(width), random(height));
      diam = 30;
      hp = random(1.25, 5.75);
    }
  }
  );

  for (Wall wall : walls)
    if (wall.isColliding(healthBooster)) {
      healthBoosters.remove(healthBooster);

      return createHealthBooster();
    }

  return healthBooster;
}

void setup() {
  size(1280, 720);

  map = new Map() {
    {
      create("data/map.spooky");
    }
  };

  player = new Player() {
    {
      pos = new PVector(300, 300);
      vel = new PVector();
      speed = 300;
      size = 50;
      viewDist = 250;

      attackDist = 175;
      attackTime = 0.25;
      attackTicks = attackCooldown = 1.75;
      attackIndicatorSize = new PVector(300, 50);

      health = maxHealth = 100;
      healthBarSize = new PVector(300, 50);
      hpReach = 75;
    }
  };

  for (int i = 0; i < 20; i++)
    createGhost();

  for (int i = 0; i < 5; i++)
    createHealthBooster();
}

void draw() {
  deltaTime = (float)(millis() - time) / 1000;
  time = millis();

  background(64);

  player.update();
  for (int i = 0; i < ghosts.size(); i++)
    ghosts.get(i).update();

  for (int i = 0; i < walls.size(); i++)
    walls.get(i).draw();

  for (int i = 0; i < ghosts.size(); i++)
    ghosts.get(i).draw();
    
  for (int i = 0; i < healthBoosters.size(); i++)
    healthBoosters.get(i).draw();

  player.draw();
  player.mask();
  player.drawUI();
}

//

ArrayList<Integer> keys = new ArrayList();

void keyPressed() {
  if (!keys.contains(keyCode))
    keys.add(keyCode);
}

void keyReleased() {
  if (keys.contains(keyCode))
    keys.remove(keys.indexOf(keyCode));
}
