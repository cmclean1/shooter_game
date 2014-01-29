class enemyBullet
{
  PVector loc;
  PVector vel;
  int d;
  enemyBullet(float x, float y)
  {
    vel = PVector.random2D();
    loc = new PVector(x, y);
  }
  void display()
  {
    fill(128);
    ellipse(loc.x, loc.y, 4, 4);
  }
  void move()
  {
    loc.add(vel);
  }
}

