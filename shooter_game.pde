Shooter s;
ArrayList<Enemy> enemies;
ArrayList<blasterEnemy> blaster;
ArrayList<shooterEnemy> shooter;
ArrayList<Explosion> explosions = new ArrayList<Explosion>();
ArrayList<Particle> particles;
boolean[] keys = new boolean[4];
int timer;
Timer enemyTimer;
Timer shakeTimer;
boolean dark = true;
int location = 0;
PFont font;
Button Play;
Button Intructions;
Button Credits;
Button Back;
ArrayList<Star> stars = new ArrayList<Star>();
boolean play;
int score;
boolean paused;
boolean gameOver;
int multiplier = 1;
int enemiesKilled;
boolean shakeScreen;
void setup()
{
  size(800, 700);
  font = loadFont("VirtualDJ-48.vlw");
  textFont(font);
  Play = new Button(width/2, "PLAY", 1, true);
  Intructions = new Button(width/2+75, "DEBRIEF", 2, false);
  Credits = new Button(width/2+150, "CREDITS", 3, false);
  Back = new Button(width/2+200, "BACK", 0, false);
  shakeTimer = new Timer(500);
  stars.add(new Star());
}
void draw()
{    
  if (shakeScreen && !paused)
  {
    translate(random(-10, 10), random(-10, 10));
    if (shakeTimer.go())
    {
      shakeScreen = false;
    }
  }
  if (!paused)
  {
    stars.add(new Star());
  }
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
  if (!play)
  {
    menu();
  }
  else
  {
    if (!gameOver)
    {
      game();
    }
    else
    {
      gameOver();
    }
  }
}
void gameOver()
{
  fill(0);
  textAlign(CENTER);
  textSize(20);
  text("YOU LOSE. FINAL SCORE: \n\n" + score + "\n\nPRESS ENTER TO RETURN TO MENU", width/2, height/2);
  noLoop();
}
void keyPressed()
{
  if (key == 'w' || key == 'W')
  {
    keys[0] = true;
  }
  if (key == 's'  || key == 'S')
  {
    keys[1] = true;
  }
  if (key == 'a'  || key == 'A')
  {
    keys[2] = true;
  }
  if (key == 'd'  || key == 'D')
  {
    keys[3] = true;
  }
  if (key == 'p' || key == 'P')
  {
    if (play && !gameOver)
    {
      paused = !paused;
      //      if(paused)
      //      {
      //        noLoop();
      //      }
      //      else
      //      {
      //        loop();
      //      }
    }
  }
  if (keyCode == ENTER)
  {
    if (gameOver)
    {
      play = false;
      score = 0;
      gameOver = false;
      loop();
    }
  }
  //  if(key == ' ')
  //  {
  //    shakeScreen = PVector.random2D();
  //    shakeScreen.set(-shakeScreen.x,-shakeScreen.y);
  //  }
}
void keyReleased()
{
  if (key == 'w'  || key == 'W')
  {
    keys[0] = false;
  }
  if (key == 's'  || key == 'S')
  {
    keys[1] = false;
  }
  if (key == 'a'  || key == 'A')
  {
    keys[2] = false;
  }
  if (key == 'd'  || key == 'D')
  {
    keys[3] = false;
  }
}
void game()
{
  checkMultiplier();
  colorMode(RGB, 255, 255, 255);
  if (dark)
  {
    fill(255);
  }
  else
  {
    fill(0);
  }
  textSize(15);
  textAlign(LEFT);
  text("SCORE: " + score, 10, height-10);
  text("x" + multiplier, 10, height-25);
  textAlign(RIGHT);
  text("HEALTH: " + s.life, width-10, height-10);
  rectMode(CORNER);
  //background(255);
  if (mousePressed && mouseButton == LEFT && !paused)
  {
    fill(0, 10);
    dark = true;
  }
  else if (!mousePressed && !paused)
  {
    fill(255, 10);
    dark = false;
  }
  if (!paused)
  {
    rect(0, 0, width, height);
  }

  s.display();
  s.friction();
  s.move();
  println(enemies.size());
  if (enemyTimer.go())
  {
    enemyTimer.duration-=5;
    int random = int(random(3));
    if (random == 0)
    {
      enemies.add(new blasterEnemy());
    }
    else if (random == 1)
    {
      enemies.add(new Enemy());
    }
    else
    {
      enemies.add(new shooterEnemy());
    }
  }
  for (int i = enemies.size()-1; i > 0; i --) {
    Enemy e = enemies.get(i);
    e.display();
    e.move();
    if (e instanceof  blasterEnemy)
    {
      ((blasterEnemy)e).shoot();
    }
    if (e instanceof  shooterEnemy)
    {
      ((shooterEnemy)e).aim(s);
      ((shooterEnemy)e).shoot();
    }
    if (e.checkShooter(s))
    {
      background(255, 0, 0);
      s.life--;
      shakeTimer.maxTime = millis() + shakeTimer.duration;
      shakeScreen = true;
      enemiesKilled = 0;
      if (s.life <= 0)
      {
        location = 0;
        gameOver = true;
        dark = true;
      }
    }
    if (e.loc.y-e.d > height)
    {
      enemies.remove(i);
    }
    if (e instanceof  shooterEnemy)
    {
      for (int j = ((shooterEnemy)e).bullets.size()-1; j > 0; j--)
      {
        for (int w = particles.size()-1; w > 0; w--)
        {
          if (((shooterEnemy)e).bullets.get(j).checkParticle(particles.get(w)))
          {
            ((shooterEnemy)e).bullets.remove(j);
            particles.remove(w);
            return;
          }
        }
        if (s.checkParticle(((shooterEnemy)e).bullets.get(j)))
        {
          background(255, 0, 0);
          s.life--;
          shakeTimer.maxTime = millis() + shakeTimer.duration;

          shakeScreen = true;

          enemiesKilled = 0;
          if (s.life <= 0)
          {
            location = 0;
            gameOver = true;
            dark = true;
          }
          ((shooterEnemy)e).bullets.remove(j);
          return;
        }
        if (((shooterEnemy)e).bullets.get(j).loc.x > width || ((shooterEnemy)e).bullets.get(j).loc.x < 0 || ((shooterEnemy)e).bullets.get(j).loc.y > height || ((shooterEnemy)e).bullets.get(j).loc.y < 0)
        {
          ((shooterEnemy)e).bullets.remove(j);
          return;
        }
      }
    }
    if (e instanceof  blasterEnemy)
    {
      for (int j = ((blasterEnemy)e).bullets.size()-1; j > 0; j--)
      {
        for (int w = particles.size()-1; w > 0; w--)
        {
          if (((blasterEnemy)e).bullets.get(j).checkParticle(particles.get(w)))
          {
            ((blasterEnemy)e).bullets.remove(j);
            particles.remove(w);
            return;
          }
        }
        if (s.checkParticle(((blasterEnemy)e).bullets.get(j)))
        {
          background(255, 0, 0);
          s.life--;
          shakeTimer.maxTime = millis() + shakeTimer.duration;

          shakeScreen = true;
          enemiesKilled = 0;
          if (s.life <= 0)
          {
            location = 0;
            gameOver = true;
            dark = true;
          }
          ((blasterEnemy)e).bullets.remove(j);
          return;
        }
        if (((blasterEnemy)e).bullets.get(j).loc.x > width || ((blasterEnemy)e).bullets.get(j).loc.x < 0 || ((blasterEnemy)e).bullets.get(j).loc.y > height || ((blasterEnemy)e).bullets.get(j).loc.y < 0)
        {
          ((blasterEnemy)e).bullets.remove(j);
          return;
        }
      }
    }
  }
  if (!paused)
  {
    particles.add(new Particle());
  }

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
  for (int i = explosions.size()-1; i > 0; i --)
  {
    Explosion e = explosions.get(i);
    e.display();
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
          explosions.add(new Explosion(enemies.get(j).loc.x, enemies.get(j).loc.y));
          enemiesKilled++;
          score+=enemies.get(j).scoreUp*multiplier;
          enemies.remove(j);
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
    text("ANYTHING AND EVERYTHING BY CLAYTON MCLEAN", 10, 50);
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
void checkMultiplier()
{
  if (enemiesKilled < 10)
  {
    multiplier = 1;
  }
  if (enemiesKilled >= 10)
  {
    multiplier = 2;
  }
  if (enemiesKilled >= 25)
  {
    multiplier = 4;
  }
  if (enemiesKilled >= 40)
  {
    multiplier = 8;
  }
}

