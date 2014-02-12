class Boss
{
  ArrayList<Enemy> enemies = new ArrayList<Enemy>();
  Boss(int size)
  {
    for (int i = 0; i < size+1; i++)
    {
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
      enemies.get(i).vel.y = .1;
      enemies.get(i).w = 50;
    }
  }
  void display()
  {
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
}

