class Residue
{
  PVector[] loc = new PVector[10];
  PVector[] vel = new PVector[10];
  int life = 100;
  int d = 5;
  Residue(float x, float y, float velx, float vely)
  {
    for (int i = 0; i < loc.length; i++)
    {
      loc[i] = new PVector(x, y);
      vel[i] = new PVector(velx, vely);
    }
  }
  void display()
  {
    for (int i = 0; i < loc.length; i++)
    {
      if (!paused)
      {
        loc[i].add(vel[i]);
        life--;
      }
      colorMode(RGB, 255, 255, 255);
      fill(255, 0, 0, life);
      ellipse(loc[i].x, loc[i].y, d, d);
    }
  }
}

