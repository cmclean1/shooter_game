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
  void display()
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
  void ifClicked()
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
  boolean clicked()
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

