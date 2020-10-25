import static java.awt.event.KeyEvent.*;

import processing.awt.PSurfaceAWT;

import javax.swing.JFileChooser;
import javax.swing.JFrame;

Player player;
Map map;

HashMap<String, PImage> sprites = new HashMap();

ArrayList<Ghost> ghosts = new ArrayList();
ArrayList<Spider> spiders = new ArrayList();
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

  return ghost;
}

Spider createSpider() {
  Spider spider;
  spiders.add(spider = new Spider() {
    {
      pos = new PVector(random(width), random(height));
      vel = new PVector();
      ang = radians(random(360));
      speed = 200;
      size = 60;
      viewDist = 175;

      attackDist = 75;
      attackDamageMin = 0;
      attackDamageMax = 3.25;
      attackTime = 0.05;
      attackTicks = attackCooldown = 9.75;
    }
  }
  );

  for (Wall wall : walls)
    if (wall.isColliding(spider)) {
      ghosts.remove(spider);

      return createSpider();
    }

  return spider;
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
  sprites.put("spider", scale(loadImage("data/spider.png"), 60, 60));
  sprites.put("wall", loadImage("data/wall.png"));
  sprites.put("death_overlay", scale(loadImage("data/death_overlay.png"), width, height));
  sprites.put("background", scale(loadImage("data/background.png"), width, height));


  map = new Map() {
    {
      create("data/main.spooky");
    }
  };

  for (int i = 0; i < 8; i++)
    createGhost();
  for (int i = 0; i < 3; i++)
    createSpider();

  for (int i = 0; i < 5; i++)
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
    
  for (int i = 0; i < spiders.size(); i++)
    spiders.get(i).update();

  for (int i = 0; i < walls.size(); i++)
    walls.get(i).draw();

  for (int i = 0; i < spiders.size(); i++)
    spiders.get(i).draw();

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

  if (keyCode == VK_O &&keys.contains(VK_CONTROL))
    open();
}

void keyReleased() {
  if (keys.contains(keyCode))
    keys.remove(keys.indexOf(keyCode));
}

void open() {
  JFileChooser fileChooser = new JFileChooser();
  fileChooser.setDialogTitle("Open Map...");
  try {
    fileChooser.setCurrentDirectory(new File(PApplet.class.getProtectionDomain().getCodeSource().getLocation().toURI()));
  } 
  catch (Exception e) {
  }
  if (fileChooser.showOpenDialog(((PSurfaceAWT.SmoothCanvas) ((PSurfaceAWT) surface).getNative()).getFrame()) == JFileChooser.APPROVE_OPTION) {
    File selectedFile = fileChooser.getSelectedFile();
    map.create(selectedFile.getAbsolutePath());
  }
}
