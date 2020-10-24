class HealthBooster implements IHealthBooster {
  PVector pos;
  float diam, hp;
  
  void draw() {
    noStroke();
    fill(#BFFA5B);
    circle(pos.x, pos.y, diam);
  }
}
