class enemyBullet
{
  PVector loc;
  PVector vel;
  float d;
  enemyBullet(float x, float y, float velx, float vely, float _d)
  {
    vel = new PVector(velx, vely);
    loc = new PVector(x, y);
    d = _d;
  }
  void display()
  {
    fill(128);
    ellipse(loc.x, loc.y, d, d);
  }
  void move()
  {
    loc.add(vel);
  }
  boolean checkParticle(Particle p)
  {
     if (dist(p.loc.x, p.loc.y, loc.x, loc.y) < (d/2)+(p.d/2))
    {
      return true;
    }
    return false;
  }
}

