class HealthBooster implements IHealthBooster {
  PVector pos;
  float diam, hp;
  
  void draw() {
    if (sprites.get("heart") == null) {
      noStroke();
      fill(#BFFA5B);
      circle(pos.x, pos.y, diam);
    } else {
      image(sprites.get("heart"), pos.x - diam / 2, pos.y - diam / 2, diam, diam);
    }
  }
}
