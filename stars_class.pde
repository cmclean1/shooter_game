class Star
{
  PVector loc;
  PVector vel;
  PVector acc;
  color c;
  Star()
  {
    loc = new PVector(random(width), height);
    acc = new PVector(0, random(-2, -.01));
    vel = new PVector(0, 0);
  }
  void display()
  {
    colorMode(RGB, 255, 255, 255);
    if (!dark)
    {
      c = color(0);
    }
    else
    {
      c = color(255);
    }
    fill(c);
    noStroke();
    ellipse(loc.x, loc.y, 2, 2);
  }
  void move()
  {
    if (!paused)
    {
      vel.add(acc);
      loc.add(vel);
    }
  }
}

