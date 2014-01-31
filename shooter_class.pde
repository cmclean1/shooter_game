class Shooter
{
  PVector loc;
  int d;
  PVector vel;
  PVector acc;
  ArrayList<Engine> engineP = new ArrayList<Engine>();
  int life = 10;
  Shooter()
  {
    loc = new PVector(width/2, height/2);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    d = 30;
  }
  boolean checkParticle(enemyBullet b)
  {
    if (dist(b.loc.x, b.loc.y, loc.x, loc.y) < (d/2)+(b.d/2))
    {
      return true;
    }
    return false;
  }
  void display()
  {
    loc.add(shakeScreen);

    for (int i = engineP.size()-1; i > 0; i --)
    {
      Engine p = engineP.get(i);
      p.display();
      if (p.life <= 0)
      {
        engineP.remove(i);
      }
    }
    colorMode(RGB, 255, 255, 255);
    if (dark)
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
    if (loc.x > width || loc.x < 0)
    {
      vel.x*=-.5;
      if (loc.x > width)
        loc.x = width;
      else
        loc.x = 0;
    }
    if (loc.y > height || loc.y < 0)
    {
      vel.y*=-.5;
      if (loc.y > height)
        loc.y = height;
      else
        loc.y = 0;
    }
  }
  void move()
  {
    vel.add(acc);
    loc.add(vel);
    if (keys[0] || keys[1] || keys[2] || keys[3])
    {
      engineP.add(new Engine());

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
    }
    else
    {
      acc.set(0, 0);
    }
  }
}

