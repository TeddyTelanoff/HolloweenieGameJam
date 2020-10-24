interface IPlayer {
  void update();
  void attack();
  void move(PVector dir);

  void draw();
  void mask();

  void drawUI();
  void drawHealth();
  void attackIndicator();
}
