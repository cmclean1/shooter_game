import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class shooter_game extends PApplet {

Shooter s;
int[] gunTime = {
  20, 50, 125, 1
};
int[] gunDamage = {
  1, 5, 15, 1
};
ArrayList<Enemy> enemies;
ArrayList<blasterEnemy> blaster;
ArrayList<shooterEnemy> shooter;
ArrayList<Explosion> explosions = new ArrayList<Explosion>();
ArrayList<Particle> particles;
ArrayList<enemyBullet> bullets = new ArrayList<enemyBullet>();
ArrayList<Boss> bosses;
boolean[] keys = new boolean[4];
int timer;
int money = 1000;
int gunType = 0;
int gunTimer = 0;
Timer enemyTimer;
Timer shakeTimer;
Timer bossTimer;
boolean dark = true;
int location = 0;
PFont font;
ArrayList<Gold> g = new ArrayList<Gold>();
Button Play;
Button Intructions;
Button Credits;
Button Back, Back2;
Button Campaign, Survival;
Button Planets;
Button Guns, Upgrades;
Gun Auto, Missle, Bomb, Laser;
Upgrades Health, Damage, Navigation, Magnetism, Speed;
ArrayList<Star> stars = new ArrayList<Star>();
boolean play;
int score;
boolean paused;
boolean gameOver;
int multiplier = 1;
int enemiesKilled;
boolean shakeScreen;
float distance = random(0, 500);
PVector[] yish = { 
  new PVector(50+distance, -50), new PVector(90+distance, -75), new PVector(130+distance, -100), new PVector(170+distance, -75), new PVector(210+distance, -50),
};
public void setup()
{
  size(800, 700);
  font = loadFont("VirtualDJ-48.vlw");
  textFont(font);
  Play = new Button(width/2, "PLAY", 1, false);
  Intructions = new Button(width/2+75, "DEBRIEF", 2, false);
  Credits = new Button(width/2+150, "CREDITS", 3, false);
  Back = new Button(width/2+225, "BACK", 0, false);
  Back2 = new Button(width/2+225, "BACK", 4, false);
  Campaign = new Button(width/2, "CAMPAIGN", 4, false);
  Survival = new Button(width/2+75, "SURVIVAL", 5, true);
  Guns = new Button(width/2+75, "GUNS", 6, false);
  Planets = new Button(width/2, "PLANETS", 7, false);
  Upgrades = new Button(width/2+150, "UPGRADES", 8, false);
  shakeTimer = new Timer(500);
  Auto = new Gun(100, 200, 0, "A", "Fast shooting gun with small weak bullets");
  Missle = new Gun(200, 200, 1, "M", "Slow missle with large strong bullets");
  Bomb = new Gun(300, 200, 2, "B", "Very slow, strong bombs");
  Laser = new Gun(400, 200, 3, "L", "Very fast very weak bullets");
  Health = new Upgrades(100, 200, 5, 10, "Health");
  Damage = new Upgrades(100, 275, 5, 10, "Damage");
  Navigation = new Upgrades(100, 350, 5, 10, "Navigation");
  Magnetism = new Upgrades(100, 425, 5, 10, "Magnetism");
  Speed = new Upgrades(100, 500, 5, 10, "Speed");

  stars.add(new Star());
}
public void draw()
{    
  println(mouseX);
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
  for (int i = stars.size ()-1; i > 0; i--)
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
  } else
  {
    if (!gameOver)
    {
      game();
    } else
    {
      gameOver();
    }
  }
}
public void gameOver()
{
  fill(0);
  textAlign(CENTER);
  textSize(20);
  text("YOU LOSE. FINAL SCORE: \n\n" + score + "\n\nPRESS ENTER TO RETURN TO MENU", width/2, height/2);
  noLoop();
}
public void keyPressed()
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
}
public void keyReleased()
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
public void game()
{
  checkMultiplier();
  colorMode(RGB, 255, 255, 255);
  if (dark)
  {
    fill(255);
  } else
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
  } else if (!mousePressed && !paused)
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
  if (enemyTimer.go())
  {
    enemyTimer.duration-=5;
    int random = PApplet.parseInt(random(4));
    if (random == 0)
    {
      enemies.add(new blasterEnemy());
    } else if (random == 1)
    {
      enemies.add(new Enemy());
    } else if (random == 2)
    {
      enemies.add(new shooterEnemy());
    } else
    {
      enemies.add(new rotaterEnemy());
    }
  }
  //  if (bossTimer.go())
  //  {
  //    bosses.add(new Boss(5));
  //    distance = random(0, 500);
  //    yish[0] = new PVector(50+distance, -50);
  //    yish[1] = new PVector(90+distance, -75);
  //    yish[2] = new PVector(130+distance, -100);
  //    yish[3] = new PVector(170+distance, -75);
  //    yish[4] = new PVector(210+distance, -50);
  //  }
  for (int i = bosses.size ()-1; i >= 0; i--)
  {
    Boss b = bosses.get(i);
    b.display();
  }
  for (int i = enemies.size ()-1; i >= 0; i --) {
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
    if (e instanceof rotaterEnemy)
    {
      ((rotaterEnemy)e).shoot();
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
  }
  for (int j = bullets.size ()-1; j >= 0; j--)
  { 
    for (int w = particles.size ()-1; w >= 0; w--)
    {
      if (bullets.get(j).checkParticle(particles.get(w)))
      {
        bullets.remove(j);
        particles.remove(w);
        return;
      }
    }
    if (s.checkParticle(bullets.get(j)))
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
      bullets.remove(j);
      //return;
    } else if (bullets.get(j).loc.x > width || bullets.get(j).loc.x < 0 || bullets.get(j).loc.y > height || bullets.get(j).loc.y < 0)
    {
      bullets.remove(j);
      //return;
    }
  }
  if (!paused)
  {
    if (millis() > gunTimer + gunTime[gunType])
    {
      particles.add(new Particle(false));
      while (gunTimer < millis ())
      {
        gunTimer+=gunTime[gunType];
      }
    }
  }
  for (int i = explosions.size ()-1; i >= 0; i --)
  {
    Explosion e = explosions.get(i);
    e.display();
    if (s.checkParticle(e))
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
      explosions.remove(i);
    }
  }
  for (int i = g.size ()-1; i >= 0; i --)
  {
    Gold gold = g.get(i);
    gold.display();
    gold.attract(s);
    if (gold.checkShooter(s))
    {
      g.remove(i);
      score+=500;
      money+=(5*multiplier);
    }
    if (gold.offScreen())
    {
      g.remove(i);
    }
  }
  for (int i = particles.size ()-1; i >= 0; i --)
  { 
    Particle p = particles.get(i);
    p.display();
    p.move();
    for (int j = enemies.size ()-1; j >= 0; j--)
    {
      if (enemies.get(j).checkParticle(particles.get(i)) && !enemies.get(j).dead)
      {
        enemies.get(j).hit = true;
        p.dead = true;
        p.r = new Residue(p.loc.x, p.loc.y, -p.vel.x+(random(-3, 3)), -p.vel.y+(random(-3, 3)));
        enemies.get(j).life-=gunDamage[gunType];
        if (enemies.get(j).life <= 0)
        {
          explosions.add(new Explosion(enemies.get(j).loc.x, enemies.get(j).loc.y));
          enemiesKilled++;
          for (int k = 0; k < 3; k++)
          {
            g.add(new Gold(enemies.get(j).loc.x, enemies.get(j).loc.y, enemies.get(j).d));
          }
          score+=enemies.get(j).scoreUp*multiplier;
          enemies.remove(j);
        }
      } else
      {
        enemies.get(j).hit = false;
      }
    }
    if (p.loc.x > width || p.loc.x < 0 || p.loc.y > height || p.loc.y < 0)
    {
      particles.remove(i);
      //return;
    } else if (p.dead && p.r.life <= 0)
    {
      particles.remove(i);
      //return;
    }
  }
}
public void menu()
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
  if (location == 1)
  {
    text("GAME MODES", width/2, height/2-200);
    Campaign.display();
    Survival.display();
    Back.display();
  }
  if (location == 2)
  {
    Back.display();
    fill(0, 0, 255);
    textAlign(LEFT);
    textSize(20);
    text("MOVE WITH WSAD \nCONTROL SHOOTER WITH MOUSE \nKILL BLUE ENEMIES \nAVOID ENEMIES and DEBRIS \nHOLD MOUSE TO CHANGE SHOOTER mode \nPRESS P TO PAUSE", 10, 50);
  }
  if (location == 3)
  {
    Back.display();
    fill(0, 0, 255);
    textAlign(LEFT);
    textSize(20);
    text("ANYTHING AND EVERYTHING BY CLAYTON MCLEAN", 10, 50);
  }
  if (location == 4)
  {
    campaign();
  }
  if (location == 6)
  {
    guns();
  }
  if (location == 8)
  {
    upgrades();
  }
}
public void mouseClicked()
{
  if (mouseButton == LEFT)
  {
    if (location == 1)
    {
      Back.ifClicked();
      Survival.ifClicked();
      Campaign.ifClicked();
    } else if (location == 0)
    {
      Play.ifClicked();
      Intructions.ifClicked();
      Credits.ifClicked();
      Back.ifClicked();
    } else if (location == 2)
    {
      Back.ifClicked();
    } else if (location == 3)
    {
      Back.ifClicked();
    } else if (location == 4)
    {
      Guns.ifClicked();
      Upgrades.ifClicked();
      Back.ifClicked();
    }
    if (location == 6)
    {
      Missle.clicked();
      Auto.clicked();
      Bomb.clicked();
      Laser.clicked();
      Back2.ifClicked();
    }
    if (location == 8)
    {
      Back2.ifClicked();
      Health.ifClicked();
    }
  }
}
public void checkMultiplier()
{
  if (enemiesKilled < 5)
  {
    multiplier = 1;
  }
  if (enemiesKilled >= 5)
  {
    multiplier = 2;
  }
  if (enemiesKilled >= 10)
  {
    multiplier = 4;
  }
  if (enemiesKilled >= 15)
  {
    multiplier = 8;
  }
}

class Particle
{
  int[] d = {
    5, 10, 15, 2
  };
  PVector loc;
  PVector vel;
  PVector acc;
  Residue r;
  boolean dead;
  Particle(boolean test)
  {
    if (test)
    {
      loc = new PVector (100, 200);
    } else
    {
      loc = new PVector(s.loc.x, s.loc.y);
    }
    vel = PVector.random2D();
    acc = new PVector(0, 0);
  }
  public void display()
  {
    if (!dead)
    {
      colorMode(HSB, 25, 100, 100);
      fill(abs(sqrt(sq(vel.x)+sq(vel.y))), 100, 100);
      noStroke();
      ellipse(loc.x, loc.y, d[gunType], d[gunType]);
    } else
    {
      r.display();
      loc.set(-100, -100);
    }
  }
  public void move()
  {
    if (!paused)
    {
      acc.set(dist(mouseX, 0, loc.x, 0)/1000, dist(0, mouseY, 0, loc.y)/1000);

      if (mousePressed && mouseButton == LEFT)
      {
        acc.set(-dist(mouseX, 0, loc.x, 0)/1000, -dist(0, mouseY, 0, loc.y)/1000);
      }
      if (mouseX > loc.x)
      {
        acc.x*=-1;
      }
      if (mouseY > loc.y)
      {
        acc.y*=-1;
      }
      vel.add(acc);
      loc.add(vel);
    }
  }
  public void testMove()
  {
    acc.set(0, -1);
    vel.add(acc);
    loc.add(vel);
  }
}

class Boss
{
  ArrayList<Enemy> bossenemies = new ArrayList<Enemy>();
  int middle;
  int max;
  Boss(int size)
  {
    middle = ((size-1)/2);
    max = middle;
    for (int i = 0; i < size; i++)
    {
      int random = PApplet.parseInt(random(4));
      if (random == 0)
      {
        bossenemies.add(new blasterEnemy());
      }
      else if (random == 1)
      {
        bossenemies.add(new Enemy());
      }
      else if (random == 2)
      {
        bossenemies.add(new shooterEnemy());
      }
      else
      {
        bossenemies.add(new rotaterEnemy());
      }
      bossenemies.get(i).bossSet(i, yish);
    }
    for (int i = 1; i < max; i++)
    {
      bossenemies.get(middle-i).life = bossenemies.get(middle-i).life + bossenemies.get(middle-i-1).life;
      bossenemies.get(middle+i).life = bossenemies.get(middle+i).life + bossenemies.get(middle+i+1).life;
    }
    //    bossenemies.get(2).life = bossenemies.get(2).life + bossenemies.get(1).life;
    //    bossenemies.get(4).life = bossenemies.get(4).life + bossenemies.get(5).life;
    bossenemies.get(middle).life = bossenemies.get(middle-1).life + bossenemies.get(middle+1).life + bossenemies.get(middle).life;
  }
  public void display()
  {
    // println(middle);

    if (bossenemies.get(middle).dead == true)
    {
      for (int j = 1; j < middle+1; j++)
      {
        if (bossenemies.get(middle-j).dead == false)
        {
          explosions.add(new Explosion(bossenemies.get(middle-j).loc.x, bossenemies.get(middle-j).loc.y));
          enemiesKilled++;
          bossenemies.get(middle-j).dead = true;
          score+=bossenemies.get(middle-j).scoreUp*multiplier;
        }
        if (bossenemies.get(middle+j).dead == false)
        {
          explosions.add(new Explosion(bossenemies.get(middle+j).loc.x, bossenemies.get(middle+j).loc.y));
          enemiesKilled++;
          bossenemies.get(middle+j).dead = true;
          score+=bossenemies.get(middle+j).scoreUp*multiplier;
        }
      }
    }
    for (int k = 0; k < max; k++)
    {
      if (bossenemies.get(middle-k).dead == true)
      {
        for (int j = middle-k; j >= 0; j--)
        {
          if (bossenemies.get(j).dead == false)
          {
            explosions.add(new Explosion(bossenemies.get(j).loc.x, bossenemies.get(j).loc.y));
            enemiesKilled++;
            bossenemies.get(j).dead = true;
            score+=bossenemies.get(j).scoreUp*multiplier;
          }
        }
      }
      if (bossenemies.get(middle+k).dead == true)
      {
        for (int j = middle+k; j < bossenemies.size(); j++)
        {
          if (bossenemies.get(j).dead == false)
          {
            explosions.add(new Explosion(bossenemies.get(j).loc.x, bossenemies.get(j).loc.y));
            enemiesKilled++;
            bossenemies.get(j).dead = true;
            score+=bossenemies.get(j).scoreUp*multiplier;
          }
        }
      }
    }
    for (int i = bossenemies.size()-1; i >= 0; i--) {
      Enemy e = bossenemies.get(i);
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
        bossenemies.get(i).dead = true;
      }
    }
    for (int i = particles.size()-1; i > 0; i --)
    {
      for (int j = bossenemies.size()-1; j >= 0; j --)
      {
        if (bossenemies.get(j).checkParticle(particles.get(i)) && !bossenemies.get(j).dead)
        {
          bossenemies.get(j).hit = true;
          particles.get(i).dead = true;
          particles.get(i).r = new Residue(particles.get(i).loc.x, particles.get(i).loc.y, -particles.get(i).vel.x+(random(-3, 3)), -particles.get(i).vel.y+(random(-3, 3)));
          bossenemies.get(j).life--;
          if (j != middle)
          {
            if (j < middle)
            {
              for (int k = j; k <= middle; k++)
              {
                bossenemies.get(k).life--;
              }
            }
            if (j > middle)
            {
              for (int k = j; k >= middle; k--)
              {
                bossenemies.get(k).life--;
              }
            }
          }
          if (bossenemies.get(j).life <= 0)
          {
            explosions.add(new Explosion(bossenemies.get(j).loc.x, bossenemies.get(j).loc.y));
            enemiesKilled++;
            score+=bossenemies.get(j).scoreUp*multiplier;
            bossenemies.get(j).dead = true;
          }
          //return;
        }
        else
        {
          bossenemies.get(j).hit = false;
        }
      }
    }
  }
}

class Button {
  int y;
  String message;
  int changeLoc;
  int recWidth;
  boolean mode;//mode will decide whether or not the button will lead to a game or not
  Button(int _y, String _message, int _changeLoc, boolean _mode)
  {
    y = _y;
    message = _message;
    changeLoc = _changeLoc;
    recWidth = 100*2;
    mode = _mode;
  }
  public void display()
  {
    textAlign(CENTER);
    noFill();
    rectMode(CENTER);
    stroke(0, 0, 255);
    rect(width/2, y-5, recWidth, 50);
    fill(0, 0, 255);
    if (clicked())//text will highlight in white if mouse is over the button
    {
      fill(255);
    }
    textSize(25);
    text(message, width/2, y+5);
  }
  public void ifClicked()
  {
    if (clicked())
    {
      location = changeLoc;
      if (mode)//creates starting settings for a game
      {
        play = true;
        s = new Shooter();
        g = new ArrayList<Gold>();
        blaster = new ArrayList<blasterEnemy>();
        bullets = new ArrayList<enemyBullet>();
        shooter = new ArrayList<shooterEnemy>();
        enemies = new ArrayList<Enemy>();
        bosses = new ArrayList<Boss>();
        particles = new ArrayList<Particle>();
        explosions = new ArrayList<Explosion>();
        bossTimer = new Timer(30000);
        enemyTimer = new Timer(5000);
      }
    }
  }
  public boolean clicked()
  {
    if (mouseX > width/2-(recWidth/2) && mouseX < width/2+(recWidth/2) && mouseY > (y-5)-(25/2) && mouseY < (y-5)+(25/2))
    { 
      return true;
    } else
    {
      return false;
    }
  }
}

ArrayList<Particle> testParticles = new ArrayList<Particle>();

public void campaign()
{
  fill(255);
  textSize(50);
  text("HANGAR", width/2, height/2-250);
  ellipse(100, 200, 30, 30);
  textSize(20);
  text("YOUR SHIP", 100, 250);
  textSize(20);
  text("PROGRESS", 650, 150);
  textSize(15);
  textAlign(LEFT);
  text("Day: ", 500, 200);
  text("Money: " + money, 500, 225);
  textAlign(CENTER);
  Planets.display();
  Guns.display();
  Back.display();
  Upgrades.display();
  testShooter();
}
public void guns()
{
  text("WEAPONS MARKET", width/2, height/2-250);
  Back2.display();
  Auto.display();
  Missle.display();
  Bomb.display();
  Laser.display();
}
public void upgrades()
{
  text("UPGRADES", width/2, height/2-250);
  Back2.display();
  Health.display();
  Damage.display();
  Navigation.display();
  Magnetism.display();
  Speed.display();
}

public void testShooter()
{
  if (millis() > gunTimer + gunTime[gunType])
  {
    testParticles.add(new Particle(true));
    while (gunTimer < millis ())
    {
      gunTimer+=gunTime[gunType];
    }
  }
  for (int i = testParticles.size ()-1; i >= 0; i --)
  { 
    Particle p = testParticles.get(i);
    p.display();
    p.testMove();
  }
}

class enemyBullet
{
  PVector loc;
  PVector vel;
  float d;
  enemyBullet(float x, float y, float velx, float vely, float _d)
  {
    vel = new PVector(velx, vely);
    loc = new PVector(x, y);
    d = _d;
  }
  public void display()
  {
    fill(128);
    ellipse(loc.x, loc.y, d, d);
  }
  public void move()
  {
    if (!paused)
    {
      loc.add(vel);
    }
  }
  public boolean checkParticle(Particle p)
  {
    if (dist(p.loc.x, p.loc.y, loc.x, loc.y) < (d/2)+(p.d[gunType]/2))
    {
      return true;
    }
    return false;
  }
}

class Enemy
{
  PVector loc;
  PVector vel;
  float w;
  float d;
  boolean hit;
  int life = PApplet.parseInt(random(50, 100));
  int maxLife = life;
  Explosion e;
  boolean dead;
  int deadLife = 20;
  int scoreUp;
  Enemy()
  {
    vel = new PVector(0, random(.2f, .8f));
    w = random(25, 50);
    d = sqrt(2)*w;
    d*=1.1f;
    loc = new PVector(random(d, width-d), -50);
    scoreUp = maxLife*10+(PApplet.parseInt(w)*10);
  }
  public void bossSet(int wut, PVector[] locs)
  {
    vel.y = .1f;
    loc = new PVector(locs[wut].x, locs[wut].y);
    w = 50;
    life = 100;
  }
  public void display()
  {
    d = sqrt(2)*w;
    d*=1.1f;
    scoreUp = maxLife*10+(PApplet.parseInt(w)*10);
    colorMode(RGB, 255, 255, 255, 100);
    if (!dead)
    {
      fill(150, 255);
      rectMode(CENTER);
      // rect(loc.x, loc.y, w, w);
      if (!hit)
      {
        fill(0, 0, 255, 25);
      } else
      {
        fill(255, 0, 0, 25);
      }
      ellipse(loc.x, loc.y, d, d);
    }
  }

  public void move()
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
  public boolean checkShooter(Shooter s)
  {
    if (dist(s.loc.x, s.loc.y, loc.x, loc.y) < (d/2)+(s.d/2))
    {
      return true;
    }
    return false;
  }
  public boolean checkParticle(Particle p)
  {
    if (dist(p.loc.x, p.loc.y, loc.x, loc.y) < (d/2)+(p.d[gunType]/2))
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
  float bulletSpeed = random(.5f,2);
  float bulletD = random(3, 6);
  blasterEnemy()
  {
    bulletnum = PApplet.parseInt(random(5, 13));
    bulletTimer = new Timer(PApplet.parseInt(random(1000, 2000)));
    scoreUp = maxLife*10+(PApplet.parseInt(w)*10)+(bulletnum*100)+(PApplet.parseInt(bulletSpeed*100))+PApplet.parseInt(bulletD*10);
    vel = new PVector(0, random(.2f, .8f));
    w = random(25, 50);
    d = sqrt(2)*w;
    d*=1.1f;
    loc = new PVector(random(d, width-d), -50);
  }
  public void shoot()
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
    for (int i = bullets.size ()-1; i > 0; i --) {
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
    bulletTimer = new Timer(PApplet.parseInt(random(500, 2000)));
    scoreUp = maxLife*10+(PApplet.parseInt(w)*10)+PApplet.parseInt(bulletD*10)+PApplet.parseInt((3000-bulletTimer.duration));
    vel = new PVector(0, random(.2f, .8f));
    w = random(25, 50);
    d = sqrt(2)*w;
    d*=1.1f;
    loc = new PVector(random(d, width-d), -50);
  }
  public void aim(Shooter s)
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
      bulletX/=1.1f;
      bulletY/=1.1f;
    }
  }
  public void shoot()
  {
    if (!dead)
    {
      if (bulletTimer.go())
      {
        bullets.add(new enemyBullet(loc.x, loc.y, bulletX, bulletY, bulletD));
      }
    }
    for (int i = bullets.size ()-1; i > 0; i--) {
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
  float bulletSpeed = random(1, 2);
  rotaterEnemy()
  {
    bulletTimer = new Timer(PApplet.parseInt(random(200, 500)));
    scoreUp = maxLife*10+(PApplet.parseInt(w)*10)+PApplet.parseInt(bulletD*10)+PApplet.parseInt((3000-bulletTimer.duration));
    vel = new PVector(0, random(.2f, .8f));
    w = random(25, 50);
    d = sqrt(2)*w;
    d*=1.1f;
    loc = new PVector(random(d, width-d), -50);
  }
  public void shoot()
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
    for (int i = bullets.size ()-1; i > 0; i--) {
      enemyBullet b = bullets.get(i);
      b.move();
      b.display();
    }
  }
}

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
  public void display()
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

class Explosion
{
  PVector[] loc = new PVector[20];
  PVector[] vel= new PVector[20];
  float d = 5;

  Explosion(float x, float y)
  {
    for (int i = 0; i < loc.length; i++)
    {
      loc[i] = new PVector(x, y);
      vel[i] = PVector.random2D();
      vel[i].set(vel[i].x*5, vel[i].y*5);
    }
  }
  public void display()
  {
    colorMode(RGB, 255, 255, 255);
    fill(0);
    if (dark)
    {
      fill(255);
    }
    for (int i = 0; i < loc.length; i++)
    {
      ellipse(loc[i].x, loc[i].y, d, d);
      if(!paused)
      {
      loc[i].add(vel[i]);
      }
    }
  }
  public boolean checkParticle(Particle p)
  {
    for (int i = 0; i < loc.length; i++)
    {
      if (dist(p.loc.x, p.loc.y, loc[i].x, loc[i].y) < (d/2)+(p.d[gunType]/2))
      {
        return true;
      }
    }
    return false;
  }
}

class Gold
{
  float d;
  PVector loc;
  PVector vel;
  PVector acc;
  Gold(float x, float y, float _d)
  {
    d = _d;
    PVector randomVec = new PVector(random(-d/2, d/2), random(-d/2, d/2));
    loc = new PVector(x+randomVec.x, y+randomVec.y);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
  }
  public void display()
  {
    stroke(0xffDAA520);
    strokeWeight(1);
    fill(0xffFFD700);
    ellipse(loc.x, loc.y, 10, 10);
  }
  public void attract(Shooter s)
  {
    acc.set(pow(dist(s.loc.x, 0, loc.x, 0), 1)/10000000, pow(dist(0, s.loc.y, 0, loc.y), 1)/10000000);
    if (s.loc.x < loc.x)
    {
      acc.x*=-1;
    }
    if (s.loc.y < loc.y)
    {
      acc.y*=-1;
    }
    vel.add(acc);
    loc.add(vel);
  }
  public boolean checkShooter(Shooter s)
  {
    if (dist(s.loc.x, s.loc.y, loc.x, loc.y) < (5)+(s.d/2))
    {
      return true;
    } else
    {
      return false;
    }
  }
  public boolean offScreen()
  {
    if (loc.x > width || loc.x < 0 || loc.y > height || loc.y < 0)
    {
      return true;
    }
    else
    return false;
  }
}

class Gun
{
  PVector loc;
  int type;
  String desc;
  int d = 50;
  boolean selected;
  String name;
  Gun(int x, int y, int _type, String _name, String _desc)
  {
    loc = new PVector(x, y);
    type = _type;
    desc = _desc;
    name = _name;
  }
  public void display()
  {
    if (type == gunType)
      selected = true;
    else
      selected = false;
    stroke(0, 0, 255);
    if (ifClicked())
    {
      stroke(255);
      textSize(19);
      text(desc, width/2, height/2+200);
    }
    if (selected)
    {
      stroke(255);
    }
    noFill();
    ellipse(loc.x, loc.y, d, d);
    textSize(25);
    fill(0, 0, 255);
    text(name, loc.x+5, loc.y+10);
  }
  public void clicked()
  {
    if (dist(loc.x, loc.y, mouseX, mouseY) <= d/2)
    {
      gunType = type;
    }
  }
  public boolean ifClicked()
  {
    if (dist(loc.x, loc.y, mouseX, mouseY) <= d/2)
    {
      return true;
    } else
      return false;
  }
}

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
  public boolean checkParticle(enemyBullet b)
  {
    if (dist(b.loc.x, b.loc.y, loc.x, loc.y) < (d/2)+(b.d/2))
    {
      return true;
    }
    return false;
  } 
  public boolean checkParticle(Explosion e)
  {
    for (int i = 0; i < e.loc.length; i++)
    {
      if (dist(e.loc[i].x, e.loc[i].y, loc.x, loc.y) < (d/2)+(e.d/2))
      {
        return true;
      }
    }
    return false;
  }
  public void display()
  {
    for (int i = engineP.size ()-1; i > 0; i --)
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
    } else
    {
      fill(0);
    }
    ellipse(loc.x, loc.y, d, d);
  }
  public void friction()
  {
    if (!paused)
    {
      if (vel.x > 0 && keys[3] == false)
      {
        vel.x-=.02f;
      } else if (vel.x < 0 && keys[2] == false)
      {
        vel.x+=.02f;
      }
      if (vel.y > 0 && keys[1] == false)
      {
        vel.y-=.02f;
      } else if (vel.y < 0 && keys[0] == false)
      {
        vel.y+=.02f;
      }
      if (loc.x > width || loc.x < 0)
      {
        vel.x*=-.5f;
        if (loc.x > width)
          loc.x = width;
        else
          loc.x = 0;
      }
      if (loc.y > height || loc.y < 0)
      {
        vel.y*=-.5f;
        if (loc.y > height)
          loc.y = height;
        else
          loc.y = 0;
      }
    }
  }
  public void move()
  {
    if (!paused)
    {
      vel.add(acc);
      loc.add(vel);
      if (keys[0] || keys[1] || keys[2] || keys[3])
      {
        engineP.add(new Engine());

        if (keys[0])
        {
          acc.y = -.05f;
        } else if (keys[1])
        {
          acc.y = .05f;
        } else if (keys[2])
        {
          acc.x = -.05f;
        } else if (keys[3])
        {
          acc.x = .05f;
        }
      } else
      {
        acc.set(0, 0);
      }
    }
  }
}

class Residue
{
  PVector[] loc = new PVector[10];
  PVector[] vel = new PVector[10];
  int life = 100;
  int d = 5;
  Residue(float x, float y, float velx, float vely)
  {
    for (int i = 0; i < loc.length; i++)
    {
      loc[i] = new PVector(x, y);
      vel[i] = new PVector(velx, vely);
    }
  }
  public void display()
  {
    for (int i = 0; i < loc.length; i++)
    {
      if (!paused)
      {
        loc[i].add(vel[i]);
        life-=.5f;
      }
      colorMode(RGB, 255, 255, 255);
      fill(255, 0, 0, life);
      ellipse(loc[i].x, loc[i].y, d, d);
    }
  }
}

class Star
{
  PVector loc;
  PVector vel;
  PVector acc;
  int c;
  Star()
  {
    loc = new PVector(random(width), height);
    acc = new PVector(0, random(-2, -.01f));
    vel = new PVector(0, 0);
  }
  public void display()
  {
    colorMode(RGB, 255, 255, 255);
    if (!dark)
    {
      c = color(0);
    } else
    {
      c = color(255);
    }
    fill(c);
    noStroke();
    ellipse(loc.x, loc.y, 2, 2);
  }
  public void move()
  {
    if (!paused)
    {
      vel.add(acc);
      loc.add(vel);
    }
  }
}

class Timer
{
  int duration;
  int maxTime;
  int pauseTime;
  int newTime;
  boolean changeTime = false;
  Timer(int _duration)
  {
    duration = _duration;
    maxTime = millis() + duration;
  }
  public boolean go()
  {
    checkifPaused();
    if (!paused)
    {
      if (millis() > maxTime)
      {
        maxTime+=duration;
        return true;
      }
    }
    return false;
  }
  public void checkifPaused()
  {
    if (paused && !changeTime)
    {
      pauseTime = millis();
      changeTime = true;
    } else if (!paused && changeTime)
    {
      newTime = millis()-pauseTime;
      maxTime+=newTime;
      changeTime = false;
    }
  }
}

class Upgrades
{
  PVector loc;
  float maxNum;
  float num = 0;
  String name;
  int cost;
  Upgrades(int x, int y, int _maxNum, int _cost, String _name)
  {
    loc = new PVector(x, y);
    maxNum = _maxNum;
    name = _name;
    cost = _cost;
  }
  public void display()
  {


    rectMode(CORNER);

    textAlign(LEFT);
    textSize(20);

    if (num > 0)
    {
      noStroke();
      fill(255);
      rect(loc.x, loc.y, 500*(num/maxNum), 50);
    }
    noFill();
    stroke(0, 0, 255);
    rect(loc.x, loc.y, 500, 50);
    fill(0, 0, 255);
    text(name, loc.x+10, loc.y+35);
    if (maxNum != num)
    {
      text("Cost: " + cost, loc.x+510, loc.y+35);
    } else
    {
      text("MAXED", loc.x+10, loc.y+35);
    }
  }
  public boolean enoughMoney()
  {
    if (cost < money && num != maxNum)
    {
      return true;
    }
    return false;
  }
  public boolean clicked()
  {
    if (mouseX > 100 && mouseX < 600 && mouseY > loc.y-50 && mouseY < loc.y+50)
    {
      return true;
    }
    return false;
  }
  public void ifClicked()
  {
    if (clicked() && enoughMoney())
    {
      cost+=cost;
      num++;
    } else
    {
      fill(255, 0, 0);
      textAlign(CENTER);
      textSize(30);
      text("NOT ENOUGH MONEY", width/2, 150);
    }
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "shooter_game" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
