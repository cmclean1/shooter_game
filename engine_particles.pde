class Engine
{
  PVector loc;
  PVector vel;
  int life;
  Engine()
  {
    loc = new PVector(s.loc.x, s.loc.y);
    vel = new PVector((-s.vel.x*5)+random(-3, 3), (-s.vel.y*5)+(random(-3, 3)));
    life =100;
  }
  void display()
  {
    colorMode(HSB, 50, 100, 100, 100);
    fill(abs(sqrt(sq(vel.x/5)+sq(vel.y/5))), 100, 100, life);
    if (!paused)
    {
      loc.add(vel);
      life-=5;
    }
    ellipse(loc.x, loc.y, 2, 2);
  }
}

