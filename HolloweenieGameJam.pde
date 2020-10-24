import static java.awt.event.KeyEvent.*;

Player player;
Map map;

HashMap<String, PImage> sprites = new HashMap();

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
      ang = radians(random(360));
      speed = 150;
      size = 45;
      viewDist = 200;

      attackDist = 100;
      attackDamageMin = 0;
      attackDamageMax = 2.25;
      attackTime = 0.15;
      attackTicks = attackCooldown = 3.75;
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

  sprites.put("player", scale(loadImage("data/player.png"), 50, 50));
  sprites.put("heart", scale(loadImage("data/heart.png"), 30, 30));
  sprites.put("ghost", scale(loadImage("data/ghost.png"), 45, 45));
  sprites.put("wall", loadImage("data/wall.png"));
  sprites.put("death_overlay", scale(loadImage("data/death_overlay.png"), width, height));
  sprites.put("background", scale(loadImage("data/background.png"), width, height));

  map = new Map() {
    {
      create("data/test.spooky");
    }
  };

  player = new Player() {
    {
      pos = new PVector(350, 300);
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

  for (int i = 0; i < 12; i++)
    createGhost();

  for (int i = 0; i < 8; i++)
    createHealthBooster();
}

void draw() {
  deltaTime = (float)(millis() - time) / 1000;
  time = millis();

  if (sprites.get("background") == null)
    background(64);
  else
    background(sprites.get("background"));

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

PImage scale(PImage img, float pnwidth, float pnheight) {
  int nwidth = (int)pnwidth, nheight = (int)pnheight;
  PImage out = createImage(nwidth, nheight, img.format);

  float scaleX = (float)img.width / (float)nwidth, scaleY = (float)img.height / (float)nheight;

  for (int y = 0; y < nheight; y++)
    for (int x = 0; x < nwidth; x++) {
      out.pixels[x + y * nwidth] = img.pixels[int(x * scaleX) + int(y * scaleY) * img.pixelWidth];
    }

  return out;
}

PImage tile(PImage img, float pnwidth, float pnheight) {
  int nwidth = (int)pnwidth, nheight = (int)pnheight;
  PImage out = createImage(nwidth, nheight, img.format);
  
  for (int y = 0; y < nheight; y++)
    for (int x = 0; x < nwidth; x++) {
      out.pixels[x + y * nwidth] = img.pixels[(x % img.pixelWidth) + (y % img.pixelHeight) * img.pixelWidth];
    }
  
  return out;
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
