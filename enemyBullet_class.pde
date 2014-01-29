class enemyBullet
{
  PVector loc;
  PVector vel;
  int d;
  enemyBullet(float x, float y, float velx, float vely)
  {
    vel = new PVector(velx,vely);
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

