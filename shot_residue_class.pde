class Residue
{
  PVector loc;
  PVector vel;
  int life = 100;
  int d = 2;
  Residue(float x, float y, float velx, float vely)
  {
    loc = new PVector(x, y);
    vel = new PVector(velx, vely);
  }
  void display()
  {
    loc.add(vel);
    colorMode(RGB, 255, 255, 255);
    fill(190, life);
    life--;
    ellipse(loc.x, loc.y, d, d);
  }
}

