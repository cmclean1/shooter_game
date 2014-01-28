class Shooter
{
  PVector loc;
  int d;
  PVector vel;
  PVector acc;
  Shooter()
  {
    loc = new PVector(width/2, height/2);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    d = 30;
  }
  void display()
  {
    if (mousePressed && mouseButton == LEFT)
    {
      fill(255);
    }
    else
    {
      fill(0);
    }
    ellipse(loc.x, loc.y, d, d);
  }
  void friction()
  {
    if (vel.x > 0 && keys[3] == false)
    {
      vel.x-=.02;
    }
    else if (vel.x < 0 && keys[2] == false)
    {
      vel.x+=.02;
    }
    if (vel.y > 0 && keys[1] == false)
    {
      vel.y-=.02;
    }
    else if (vel.y < 0 && keys[0] == false)
    {
      vel.y+=.02;
    }
  }
  void move()
  {
    vel.add(acc);
    loc.add(vel);
    if (keys[0])
    {
      acc.y = -.05;
    }
    else if (keys[1])
    {
      acc.y = .05;
    }
    else if (keys[2])
    {
      acc.x = -.05;
    }
    else if (keys[3])
    {
      acc.x = .05;
    }
    else
    {
      acc.set(0, 0);
    }
  }
}

