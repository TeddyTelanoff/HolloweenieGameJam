class Map implements IMap {
  PVector pos, size;

  void create(String filepath) {
    walls.clear();

    String[] source = loadStrings(filepath);
    for (String line : source) {
      String[] args = line.split(" ");

      switch(args[0]) {
      case "wall":
        pos = new PVector(float(args[1]), float(args[2]));
        size = new PVector(float(args[3]), float(args[4]));

        walls.add(new Wall() {
          {
            pos = Map.this.pos;
            size = Map.this.size;

            create();
          }
        }
        );
        break;
      case "spawn":
        pos = new PVector(float(args[1]), float(args[2]));

        player = new Player() {
          {
            pos = Map.this.pos;
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

        //mask = createImage((int) player.viewDist, (int) player.viewDist, ARGB);
        //for (int y = 0; y < player.viewDist; y++)
        //  for (int x = 0; x < player.viewDist; x++)
        //    if (dist((int) player.viewDist / 2, (int) player.viewDist / 2, x, y) <= player.viewDist)
        //      mask.pixels[x + y * (int) player.viewDist] = color(0);

        //maskShader.set("playerView", player.viewDist * 2 / (float) width - 1, player.viewDist * 2 / (float) height - 1);
        maskShader.set("playerView", player.viewDist);
        //maskShader.set("playerView", 1, 1);
        break;
      }
    }
  }
}
