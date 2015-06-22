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
  void display()
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
  void clicked()
  {
    if (dist(loc.x, loc.y, mouseX, mouseY) <= d/2)
    {
      gunType = type;
    }
  }
  boolean ifClicked()
  {
    if (dist(loc.x, loc.y, mouseX, mouseY) <= d/2)
    {
      return true;
    } else
      return false;
  }
}

