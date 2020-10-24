class Wall implements IWall {
  PVector pos, size;
  PImage img;
  
  void create() {
    size.x = abs(size.x);
    size.y = abs(size.y);
    
    if (sprites.get("wall") != null)
      img = tile(sprites.get("wall"), size.x, size.y);
  }

  void draw() {
    if (sprites.get("wall") == null) {
      noStroke();
      fill(#51235F);
      rect(pos.x, pos.y, size.x, size.y);
    } else {
      image(img, pos.x, pos.y, size.x, size.y);
    }
  }

  boolean isColliding(Player player) {
    PVector size = new PVector(player.size, player.size);
    return isColliding(PVector.sub(player.pos, PVector.div(size, 2)), size);
  }
  boolean isColliding(Ghost ghost) {
    PVector size = new PVector(ghost.size, ghost.size);
    return isColliding(PVector.sub(ghost.pos, PVector.div(size, 2)), size);
  }
  boolean isColliding(HealthBooster healthBooster) {
    PVector size = new PVector(healthBooster.diam, healthBooster.diam);
    return isColliding(PVector.sub(healthBooster.pos, PVector.div(size, 2)), size);
  }

  boolean isColliding(PVector checkPos, PVector checkSize) {
    return (pos.x + size.x >= checkPos.x && pos.x <= checkPos.x + checkSize.x) &&
      (pos.y + size.y >= checkPos.y && pos.y <= checkPos.y + checkSize.y);
  }
}
