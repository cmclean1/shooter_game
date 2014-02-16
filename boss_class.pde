class Boss
{
  ArrayList<Enemy> bossenemies = new ArrayList<Enemy>();
  int middle;
  int max;
  Boss(int size)
  {
    middle = ((size-1)/2)+1;
    max = middle-1;
    for (int i = 0; i < size+1; i++)
    {
      int random = int(random(3));
      if (random == 0)
      {
        bossenemies.add(new blasterEnemy());
      }
      else if (random == 1)
      {
        bossenemies.add(new Enemy());
      }
      else
      {
        bossenemies.add(new shooterEnemy());
      }
      bossenemies.get(i).bossSet((i/float(size))*width-50, -50);
    }
    bossenemies.get(2).life = bossenemies.get(2).life + bossenemies.get(1).life;
    bossenemies.get(4).life = bossenemies.get(4).life + bossenemies.get(5).life;
    bossenemies.get(3).life = bossenemies.get(2).life + bossenemies.get(5).life + bossenemies.get(3).life;
    print(middle);
  }
  void display()
  {
    if (bossenemies.get(middle).dead == true)
    {
      for (int j = 0; j < middle; j++)
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
        for (int j = middle-k; j > 0; j--)
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
    for (int i = 0; i < middle; i++)
    {
    }
    //    if (bossenemies.get(middle).life <= 0)
    //    {
    //    }
    //    if (bossenemies.get(4).life <= 0)
    //    {
    //      if (bossenemies.get(5).dead == false)
    //      {
    //        explosions.add(new Explosion(bossenemies.get(5).loc.x, bossenemies.get(5).loc.y));
    //        enemiesKilled++;
    //        bossenemies.get(5).dead = true;
    //        score+=bossenemies.get(5).scoreUp*multiplier;
    //      }
    //    }
    for (int i = bossenemies.size()-1; i > 0; i--) {
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
      if (e instanceof  shooterEnemy)
      {
        for (int j = bullets.size()-1; j > 0; j--)
        {
          for (int w = particles.size()-1; w > 0; w--)
          {
            if (bullets.get(j).checkParticle(particles.get(w)))
            {
              bullets.remove(j);
              particles.remove(w);
              return;
            }
          }
          if (s.checkParticle((bullets.get(j))))
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
            return;
          }
          if (bullets.get(j).loc.x > width || bullets.get(j).loc.x < 0 || bullets.get(j).loc.y > height || bullets.get(j).loc.y < 0)
          {
            bullets.remove(j);
            return;
          }
        }
      }
      if (e instanceof  blasterEnemy)
      {
        for (int j = bullets.size()-1; j > 0; j--)
        {
          for (int w = particles.size()-1; w > 0; w--)
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
            return;
          }
          if (bullets.get(j).loc.x > width || bullets.get(j).loc.x < 0 || bullets.get(j).loc.y > height || bullets.get(j).loc.y < 0)
          {
            bullets.remove(j);
            return;
          }
        }
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
      for (int j = bossenemies.size()-1; j > 0; j --)
      {
        if (bossenemies.get(j).checkParticle(particles.get(i)) && !bossenemies.get(j).dead)
        {
          bossenemies.get(j).hit = true;
          particles.get(i).dead = true;
          particles.get(i).r = new Residue(particles.get(i).loc.x, particles.get(i).loc.y, -particles.get(i).vel.x+(random(-3, 3)), -particles.get(i).vel.y+(random(-3, 3)));
          bossenemies.get(j).life--;
          if (bossenemies.get(j).life <= 0)
          {
            explosions.add(new Explosion(bossenemies.get(j).loc.x, bossenemies.get(j).loc.y));
            enemiesKilled++;
            score+=bossenemies.get(j).scoreUp*multiplier;
            bossenemies.get(j).dead = true;
          }
          return;
        }
        else
        {
          bossenemies.get(j).hit = false;
        }
      }
    }
  }
}

