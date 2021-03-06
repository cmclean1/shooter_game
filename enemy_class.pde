class Enemy
{
  PVector loc;
  PVector vel;
  float w;
  float d;
  boolean hit;
  int life = int(random(50, 151));
  int maxLife = life;
  Explosion e;
  boolean dead;
  int deadLife = 20;
  int scoreUp;
  Enemy()
  {
    vel = new PVector(0, random(.2, .8));
    w = random(25, 50);
    d = sqrt(2)*w;
    d*=1.1;
    loc = new PVector(random(d, width-d), -50);
    scoreUp = maxLife*10+(int(w)*10);
  }
  void bossSet(int wut, PVector[] locs)
  {
    vel.y = .1;
    loc = new PVector(locs[wut].x, locs[wut].y);
    w = 50;
    life = 100;
  }
  void display()
  {
    d = sqrt(2)*w;
    d*=1.1;
    scoreUp = maxLife*10+(int(w)*10);
    colorMode(RGB, 255, 255, 255, 100);
    if (!dead)
    {
      fill(150, 255);
      rectMode(CENTER);
      rect(loc.x, loc.y, w, w);
      if (!hit)
      {
        fill(0, 0, 255, 25);
      }
      else
      {
        fill(255, 0, 0, 25);
      }
      ellipse(loc.x, loc.y, d, d);
    }
  }
  void move()
  {
    if (!paused)
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
  int bulletnum = 5;
  float bulletSpeed = random(2);
  float bulletD = random(3, 6);
  blasterEnemy()
  {
    bulletnum = int(random(5, 13));
    bulletTimer = new Timer(int(random(1000, 2000)));
    scoreUp = maxLife*10+(int(w)*10)+(bulletnum*100)+(int(bulletSpeed*100))+int(bulletD*10);
    vel = new PVector(0, random(.2, .8));
    w = random(25, 50);
    d = sqrt(2)*w;
    d*=1.1;
    loc = new PVector(random(d, width-d), -50);
  }
  void shoot()
  {
    if (!dead)
    {
      if (bulletTimer.go())
      {
        for (float i = 0; i < bulletnum; i++)
        {
          bullets.add(new enemyBullet(loc.x, loc.y, cos((2*PI)*(i/bulletnum))*bulletSpeed, sin((2*PI)*(i/bulletnum))*bulletSpeed, bulletD));
        }
      }
    }
    for (int i = bullets.size()-1; i > 0; i --) {
      enemyBullet b = bullets.get(i);
      b.move();
      b.display();
    }
  }
}

class shooterEnemy extends Enemy
{
  Timer bulletTimer;
  float bulletX;
  float bulletY;
  float bulletD = random(3, 6);
  shooterEnemy()
  {
    bulletTimer = new Timer(int(random(500, 2000)));
    scoreUp = maxLife*10+(int(w)*10)+int(bulletD*10)+int((3000-bulletTimer.duration));
    vel = new PVector(0, random(.2, .8));
    w = random(25, 50);
    d = sqrt(2)*w;
    d*=1.1;
    loc = new PVector(random(d, width-d), -50);
  }
  void aim(Shooter s)
  {
    float x = dist(s.loc.x, 0, loc.x, 0);
    float y = dist(0, s.loc.y, 0, loc.y);
    bulletX = dist(s.loc.x, 0, loc.x, 0)/100;
    bulletY = dist(0, s.loc.y, 0, loc.y)/100;
    if (s.loc.x < loc.x)
    {
      bulletX*=-1;
    }
    if (s.loc.y < loc.y)
    {
      bulletY*=-1;
    }
    while (bulletX > 10)
    {
      bulletX/=1.1;
      bulletY/=1.1;
    }
  }
  void shoot()
  {
    if (!dead)
    {
      if (bulletTimer.go())
      {
        bullets.add(new enemyBullet(loc.x, loc.y, bulletX, bulletY, bulletD));
      }
    }
    for (int i = bullets.size()-1; i > 0; i--) {
      enemyBullet b = bullets.get(i);
      b.move();
      b.display();
    }
  }
}
class rotaterEnemy extends Enemy
{
  Timer bulletTimer;
  float bulletX;
  float bulletY;
  float bulletD = random(3, 6);
  int degree;
  float bulletSpeed = random(1,5);
  rotaterEnemy()
  {
    bulletTimer = new Timer(int(random(200, 500)));
    scoreUp = maxLife*10+(int(w)*10)+int(bulletD*10)+int((3000-bulletTimer.duration));
    vel = new PVector(0, random(.2, .8));
    w = random(25, 50);
    d = sqrt(2)*w;
    d*=1.1;
    loc = new PVector(random(d, width-d), -50);
  }
  void shoot()
  {
    bulletX = bulletSpeed*sin(degrees(degree));
    bulletY = bulletSpeed*cos(degrees(degree));
    if (!dead)
    {
      if (bulletTimer.go())
      {
        degree++;
        bullets.add(new enemyBullet(loc.x, loc.y, bulletX, bulletY, bulletD));
      }
    }
    for (int i = bullets.size()-1; i > 0; i--) {
      enemyBullet b = bullets.get(i);
      b.move();
      b.display();
    }
  }
}

