class Enemy
{
  PVector loc;
  PVector vel;
  int w;
  float d;
  boolean hit;
  int life = 100;
  Explosion e;
  boolean dead;
  int deadLife = 20;
  Enemy()
  {
    vel = new PVector(0, .5);
    w = 50;
    d = sqrt(2)*w;
    loc = new PVector(random(d, width-d), 0);
  }
  void display()
  {
    if (!dead)
    {
      colorMode(RGB, 255, 255, 255);
      fill(150);
      rectMode(CENTER);
      rect(loc.x, loc.y, w, w);
      if (!hit)
      {
        fill(0, 0, 255, 100);
      }
      else
      {
        fill(255, 0, 0, 100);
      }
      ellipse(loc.x, loc.y, d, d);
    }
    else
    {
      e.display();
    }
  }
  void move()
  {
    if (!dead)
    {
      loc.add(vel);
    }
    if (dead)
    {
      loc.set(-100, -100);
    }
  }
  boolean checkShooter(Shooter s)
  {
    if (dist(s.loc.x, s.loc.y, loc.x, loc.y) < (d/2)+(s.d/2))
    {
      return true;
    }
    return false;
  }
  boolean checkParticle(Particle p)
  {
    if (dist(p.loc.x, p.loc.y, loc.x, loc.y) < (d/2)+(p.d/2))
    {
      return true;
    }
    return false;
  }
}
class blasterEnemy extends Enemy
{

  Timer bulletTimer;
  float bulletnum = 5;
  ArrayList<enemyBullet> bullets = new ArrayList<enemyBullet>();

  blasterEnemy()
  {
    bulletnum =10;
    bulletTimer = new Timer(2000);
  }
  void aim()
  {
  }
  void shoot()
  {
    if (!dead)
    {
      if (bulletTimer.go())
      {
        for (float i = 0; i < bulletnum; i++)
        {
          bullets.add(new enemyBullet(loc.x, loc.y, cos((2*PI)*(i/bulletnum)), sin((2*PI)*(i/bulletnum))));
        }
      }
      for (int i = bullets.size()-1; i > 0; i --) {
        enemyBullet b = bullets.get(i);
        b.move();
        b.display();
      }
    }
  }
}

