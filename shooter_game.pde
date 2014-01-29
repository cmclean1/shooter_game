Shooter s;
blasterEnemy e = new blasterEnemy();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
PVector shakeScreen;
ArrayList<Particle> particles = new ArrayList<Particle>();
boolean[] keys = new boolean[4];
int timer;
Timer enemyTimer;
boolean dark;
void setup()
{
  size(800, 700);
  shakeScreen = new PVector(0, 0);
  s = new Shooter();
  enemyTimer = new Timer(5000);
  particles.add(new Particle());
  enemies.add(new blasterEnemy());
}
void draw()
{
  colorMode(RGB, 255, 255, 255);
  rectMode(CORNER);
  //background(255);
  if (mousePressed && mouseButton == LEFT)
  {
    fill(0, 10);
    rect(0, 0, width, height);
    dark = true;
  }
  else
  {
    fill(255, 10);
    rect(0, 0, width, height);
    dark = false;
  }
  e.move();
  e.display();
  e.shoot();
  s.display();
  s.friction();
  s.move();
  if (enemyTimer.go())
  {
    int i = int(random(2));
    if (i == 0)
    {
      enemies.add(new blasterEnemy());
    }
    else
    {
      enemies.add(new blasterEnemy());
    }
    timer+=5000;
  }
  for (int i = enemies.size()-1; i > 0; i --) {
    Enemy e = enemies.get(i);
    e.display();
    e.move();

    if (e == new blasterEnemy())
    {
                print("S");

    }
  }
  particles.add(new Particle());
  for (int i = particles.size()-1; i > 0; i --)
  {
    Particle p = particles.get(i);
    p.display();
    p.move();

    if (p.loc.x > width || p.loc.x < 0 || p.loc.y > height || p.loc.y < 0)
    {
      particles.remove(i);
    }
  }
  for (int i = particles.size()-1; i > 0; i --)
  {
    for (int j = enemies.size()-1; j > 0; j --)
    {
      if (enemies.get(j).checkParticle(particles.get(i)) && !enemies.get(j).dead)
      {
        enemies.get(j).hit = true;
        particles.remove(i);

        enemies.get(j).life--;
        if (enemies.get(j).life <= 0)
        {
          enemies.get(j).e = new Explosion(enemies.get(j).loc.x, enemies.get(j).loc.y);
          enemies.get(j).dead = true;
        }
        return;
      }
      else
      {
        enemies.get(j).hit = false;
      }
    }
  }
  for (int i = particles.size()-1; i > 0; i --)
  {
    for (int j = enemies.size()-1; j > 0; j --)
    {
      if (enemies.get(j).checkParticle(particles.get(i)) && !enemies.get(j).dead)
      {
        enemies.get(j).hit = true;
        particles.remove(i);

        enemies.get(j).life--;
        if (enemies.get(j).life <= 0)
        {
          enemies.get(j).e = new Explosion(enemies.get(j).loc.x, enemies.get(j).loc.y);
          enemies.get(j).dead = true;
        }
        return;
      }
      else
      {
        enemies.get(j).hit = false;
      }
    }
  }
}
void keyPressed()
{
  if (key == 'w')
  {
    keys[0] = true;
  }
  if (key == 's')
  {
    keys[1] = true;
  }
  if (key == 'a')
  {
    keys[2] = true;
  }
  if (key == 'd')
  {
    keys[3] = true;
  }
  //  if(key == ' ')
  //  {
  //    shakeScreen = PVector.random2D();
  //    shakeScreen.set(-shakeScreen.x,-shakeScreen.y);
  //  }
}
void keyReleased()
{
  if (key == 'w')
  {
    keys[0] = false;
  }
  if (key == 's')
  {
    keys[1] = false;
  }
  if (key == 'a')
  {
    keys[2] = false;
  }
  if (key == 'd')
  {
    keys[3] = false;
  }
}

