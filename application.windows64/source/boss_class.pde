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
      int random = int(random(4));
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
  void display()
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

