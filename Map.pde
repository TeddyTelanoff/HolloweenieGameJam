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
        
        maskShader.set("playerView", player.viewDist);
        break;
      }
    }
  }
}
