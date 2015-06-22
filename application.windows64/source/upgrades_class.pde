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
  void display()
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
  boolean enoughMoney()
  {
    if (cost < money && num != maxNum)
    {
      return true;
    }
    return false;
  }
  boolean clicked()
  {
    if (mouseX > 100 && mouseX < 600 && mouseY > loc.y-50 && mouseY < loc.y+50)
    {
      return true;
    }
    return false;
  }
  void ifClicked()
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

