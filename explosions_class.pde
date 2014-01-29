class Explosion
{
  PVector[] loc = new PVector[20];
  PVector[] vel= new PVector[20];
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
    if(dark)
    {
      fill(255);
    }
    for (int i = 0; i < loc.length; i++)
    {
      ellipse(loc[i].x, loc[i].y, 5, 5);
      loc[i].add(vel[i]);
    }
  }
}

