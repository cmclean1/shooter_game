ArrayList<Particle> testParticles = new ArrayList<Particle>();

void campaign()
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
void guns()
{
  text("WEAPONS MARKET", width/2, height/2-250);
  Back2.display();
  Auto.display();
  Missle.display();
  Bomb.display();
  Laser.display();
}
void upgrades()
{
  text("UPGRADES", width/2, height/2-250);
  Back2.display();
  Health.display();
  Damage.display();
  Navigation.display();
  Magnetism.display();
  Speed.display();
}

void testShooter()
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

