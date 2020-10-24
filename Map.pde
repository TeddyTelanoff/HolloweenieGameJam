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
      }
    }
  }
}
