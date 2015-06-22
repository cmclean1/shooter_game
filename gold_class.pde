class Gold
{
  float d;
  PVector loc;
  PVector vel;
  PVector acc;
  Gold(float x, float y, float _d)
  {
    d = _d;
    PVector randomVec = new PVector(random(-d/2, d/2), random(-d/2, d/2));
    loc = new PVector(x+randomVec.x, y+randomVec.y);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
  }
  void display()
  {
    stroke(#DAA520);
    strokeWeight(1);
    fill(#FFD700);
    ellipse(loc.x, loc.y, 10, 10);
  }
  void attract(Shooter s)
  {
    acc.set(pow(dist(s.loc.x, 0, loc.x, 0), 1)/10000000, pow(dist(0, s.loc.y, 0, loc.y), 1)/10000000);
    if (s.loc.x < loc.x)
    {
      acc.x*=-1;
    }
    if (s.loc.y < loc.y)
    {
      acc.y*=-1;
    }
    vel.add(acc);
    loc.add(vel);
  }
  boolean checkShooter(Shooter s)
  {
    if (dist(s.loc.x, s.loc.y, loc.x, loc.y) < (5)+(s.d/2))
    {
      return true;
    } else
    {
      return false;
    }
  }
  boolean offScreen()
  {
    if (loc.x > width || loc.x < 0 || loc.y > height || loc.y < 0)
    {
      return true;
    }
    else
    return false;
  }
}

