Shooter s;
PVector shakeScreen;
ArrayList<Particle> particles = new ArrayList<Particle>();
boolean[] keys = new boolean[4];
void setup()
{
  size(800, 700);
  shakeScreen = new PVector(0, 0);
  s = new Shooter();

  particles.add(new Particle());
}
void draw()
{
  colorMode(RGB, 255, 255, 255);
  //background(255);
  if (mousePressed && mouseButton == LEFT)
  {
    fill(0, 10);
    rect(0, 0, width, height);
  }
  else
  {
    fill(255, 10);
    rect(0, 0, width, height);
  }
  s.display();
  s.friction();
  s.move();
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

