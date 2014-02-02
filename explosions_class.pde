class Explosion
{
  PVector[] loc = new PVector[20];
  PVector[] vel= new PVector[20];
  float d = 5;
  boolean dead = false;
  Explosion(float x, float y)
  {
    for (int i = 0; i < loc.length; i++)
    {
      loc[i] = new PVector(x, y);
      vel[i] = PVector.random2D();
      vel[i].set(vel[i].x*5, vel[i].y*5);
    }
  }
  void display()
  {
    colorMode(RGB, 255, 255, 255);
    fill(0);
    if (dark)
    {
      fill(255);
    }
    for (int i = 0; i < loc.length; i++)
    {
      ellipse(loc[i].x, loc[i].y, d, d);
      loc[i].add(vel[i]);
    }
    if (checkitDone())
    {
      dead = true;
    }
  }
  boolean checkitDone()
  {
    int check = 0;
    for (int i = 0; i < loc.length; i++) {
      if (loc[i].y > height || loc[i].y < 0 || loc[i].x > width || loc[i].x < 0)
      {
        check++;
      }
    }
    if (check == loc.length-1)
    {
      return true;
    }
    return false;
  }
  boolean checkParticle(Particle p)
  {
    for (int i = 0; i < loc.length; i++)
    {
      if (dist(p.loc.x, p.loc.y, loc[i].x, loc[i].y) < (d/2)+(p.d/2))
      {
        return true;
      }
    }
    return false;
  }
}

