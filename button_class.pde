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
    recWidth = 85*2;
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
    textSize(29);
    text(message, width/2, y);
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
        blaster = new ArrayList<blasterEnemy>();
        shooter = new ArrayList<shooterEnemy>();

        enemies = new ArrayList<Enemy>();
        particles = new ArrayList<Particle>();
        enemyTimer = new Timer(5000);
        particles.add(new Particle());
        enemies.add(new Enemy());
        blaster.add(new blasterEnemy());
      }
    }
  }
  boolean clicked()
  {
    if (mouseX > width/2-(recWidth/2) && mouseX < width/2+(recWidth/2) && mouseY > (y-5)-(25/2) && mouseY < (y-5)+(25/2))
    { 
      return true;
    }
    else
    {
      return false;
    }
  }
}

