interface IWall {
  boolean isColliding(Player player);
  boolean isColliding(Ghost ghost);
  boolean isColliding(Spider spider);
  boolean isColliding(HealthBooster healthBooster);
  boolean isColliding(PVector pos, PVector size);
  void draw();
}
