Shooter s;
ArrayList<Enemy> enemies;
ArrayList<blasterEnemy> blaster;
PVector shakeScreen;
ArrayList<Particle> particles;
boolean[] keys = new boolean[4];
int timer;
Timer enemyTimer;
boolean dark = true;
int location = 0;
PFont font;
Button Play;
Button Intructions;
Button Credits;
Button Back;
ArrayList<Star> stars = new ArrayList<Star>();
boolean play;
void setup()
{
  size(800, 700);
  shakeScreen = new PVector(0, 0);

  font = loadFont("VirtualDJ-48.vlw");
  textFont(font);
  Play = new Button(width/2, "PLAY", 1, true);
  Intructions = new Button(width/2+75, "DEBRIEF", 2, false);
  Credits = new Button(width/2+150, "CREDITS", 3, false);
  Back = new Button(width/2+200, "BACK", 0, false);

  stars.add(new Star());
}
void draw()
{
  if (!play)
  {
    menu();
  }
  else
  {
    game();
  }
  stars.add(new Star());
  for (int i = stars.size()-1; i > 0; i--)
  {
    Star s = stars.get(i);
    s.display();
    s.move();
    if (s.loc.y < 0)
    {
      stars.remove(i);
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
void game()
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
  s.display();
  s.friction();
  s.move();
  if (enemyTimer.go())
  {
    blaster.add(new blasterEnemy());
    enemies.add(new Enemy());
  }
  for (int i = enemies.size()-1; i > 0; i --) {
    Enemy e = enemies.get(i);
    e.display();
    e.move();
    if (e.checkShooter(s))
    {
      background(255, 0, 0);
      s.life--;
      if (s.life <= 0)
      {
        location = 0;
        play = false;
        dark = true;
      }
    }
    if (e.loc.y-e.d > height)
    {
      enemies.remove(i);
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
  for (int i = blaster.size()-1; i > 0; i --) {
    blasterEnemy e = blaster.get(i);
    e.display();
    e.move();
    e.shoot();
    if (e.checkShooter(s))
    {
      background(255, 0, 0);
      s.life--;
      if (s.life <= 0)
      {
        location = 0;
        dark = true;
        play = false;
      }
    }
    if (e.loc.y-e.d > height)
    {
      blaster.remove(i);
    }

    for (int j = e.bullets.size()-1; j > 0; j--)
    {
      for (int w = particles.size()-1; w > 0; w--)
      {
        if (e.bullets.get(j).checkParticle(particles.get(w)))
        {
          e.bullets.remove(j);
          particles.remove(w);
          return;
        }
      }
      if (s.checkParticle(e.bullets.get(j)))
      {
        background(255, 0, 0);
        s.life--;
        if (s.life <= 0)
        {
          location = 0;
          play = false;
          dark = true;
        }
        e.bullets.remove(j);
        return;
      }
      if (e.bullets.get(j).loc.x > width || e.bullets.get(j).loc.x < 0 || e.bullets.get(j).loc.y > height || e.bullets.get(j).loc.y < 0)
      {
        e.bullets.remove(j);
        return;
      }
    }
  }

  for (int i = particles.size()-1; i > 0; i --)
  {
    if (particles.get(i).dead && particles.get(i).r.life <= 0)
    {
      particles.remove(i);
      return;
    }
    for (int j = enemies.size()-1; j > 0; j --)
    {
      if (enemies.get(j).checkParticle(particles.get(i)) && !enemies.get(j).dead)
      {
        enemies.get(j).hit = true;
        particles.get(i).dead = true;
        particles.get(i).r = new Residue(particles.get(i).loc.x, particles.get(i).loc.y, -particles.get(i).vel.x+(random(-3, 3)), -particles.get(i).vel.y+(random(-3, 3)));
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
    if (particles.get(i).dead && particles.get(i).r.life <= 0)
    {
      particles.remove(i);
      return;
    }
    for (int j = blaster.size()-1; j > 0; j --)
    {
      if (blaster.get(j).checkParticle(particles.get(i)) && !blaster.get(j).dead)
      {
        blaster.get(j).hit = true;
        particles.get(i).dead = true;
        particles.get(i).r = new Residue(particles.get(i).loc.x, particles.get(i).loc.y, -particles.get(i).vel.x, -particles.get(i).vel.y);
        if (particles.get(i).r.life <= 0)
        {
          particles.remove(i);
        }
        blaster.get(j).life--;
        if (blaster.get(j).life <= 0)
        {
          blaster.get(j).e = new Explosion(blaster.get(j).loc.x, blaster.get(j).loc.y);
          blaster.get(j).dead = true;
        }
        return;
      }
      else
      {
        blaster.get(j).hit = false;
      }
    }
  }
}
void menu()
{
  fill(0, 10);
  rectMode(CORNER);
  rect(0, 0, width, height);
  textAlign(CENTER);
  textSize(50);
  fill(255);
  if (location == 0)
  {
    text("NAMELESS \nSHOOTER GAME", width/2, height/2-200);
    Play.display();
    Intructions.display();
    Credits.display();
  }
  if (location == 2)
  {
    Back.display();
    fill(0, 0, 255);
    textAlign(LEFT);
    textSize(20);
    text("MOVE WITH WSAD \nCONTROL SHOOTER WITH MOUSE \nKILL BLUE ENEMIES \nAVOID BULLETS \nPRESS MOUSE TO CHANGE SHOOTER", 10, 50);
  }
  if (location == 3)
  {
    Back.display();
    fill(0, 0, 255);
    textAlign(LEFT);
    textSize(20);
    text("EVERYTHING AND EVERYTHING BY CLAYTON MCLEAN", 10, 50);
  }
}
void mousePressed()
{
  if (location == 0)
  {
    Play.ifClicked();
    Intructions.ifClicked();
    Credits.ifClicked();
  }
  if (location == 2 || location == 3)
  {
    Back.ifClicked();
  }
}

