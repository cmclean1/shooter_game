class Particle
{
  PVector loc;
  PVector vel;
  PVector acc;
  int d = 5;
  Residue r;
  boolean dead;
  Particle()
  {
    loc = new PVector(s.loc.x, s.loc.y);
    vel = PVector.random2D();
    acc = new PVector(0, 0);
  }
  void display()
  {
    if (!dead)
    {
      loc.add(shakeScreen);
      colorMode(HSB, 25, 100, 100);
      fill(abs(sqrt(sq(vel.x)+sq(vel.y))), 100, 100);
      noStroke();
      ellipse(loc.x, loc.y, d, d);
    }
    else
    {
      r.display();
      loc.set(-100, -100);
    }
  }
  void move()
  {
    acc.set(dist(mouseX, 0, loc.x, 0)/1000, dist(0, mouseY, 0, loc.y)/1000);

    if (mousePressed && mouseButton == LEFT)
    {
      acc.set(-dist(mouseX, 0, loc.x, 0)/1000, -dist(0, mouseY, 0, loc.y)/1000);
    }
    if (mouseX > loc.x)
    {
      acc.x*=-1;
    }
    if (mouseY > loc.y)
    {
      acc.y*=-1;
    }
    vel.add(acc);
    loc.add(vel);
  }
}

