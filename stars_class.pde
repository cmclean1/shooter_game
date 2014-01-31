class Star
{
  PVector loc;
  PVector vel;
  PVector acc;
  Star()
  {
    loc = new PVector(random(width), height);
    acc = new PVector(0, random(-2, -.01));
    vel = new PVector(0,0);
  }
  void display()
  {
    fill(255);
    if(!dark)
    {
      fill(0);
    }
    noStroke();
    ellipse(loc.x, loc.y, 2, 2);
  }
  void move()
  {
    vel.add(acc);
    loc.add(vel);
  }
}

