int location = 0;
PFont font;
Button Play;
Button Intructions;
Button Credits;
Button Back;
ArrayList<Star> stars = new ArrayList<Star>();
void setup()
{
  size(800, 700);
  font = loadFont("VirtualDJ-48.vlw");
  textFont(font);
  Play = new Button(width/2, "PLAY", 1, true);
  Intructions = new Button(width/2+75, "DEBRIEF", 2, true);
  Credits = new Button(width/2+150, "CREDITS", 3, true);
  Back = new Button(width/2+200, "BACK", 0, true);

  stars.add(new Star());
}
void draw()
{
  background(0);
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
  if (location == 2)
  {
    Back.display();
  }
  if(location == 3)
  {
    Back.display();
  }
  stars.add(new Star());

  for (int i = stars.size()-1; i > 0; i--)
  {
    Star s = stars.get(i);
    s.display();
    s.move();
  }
}
void mousePressed()
{
  if(location == 0)
  {
    Play.ifClicked();
    Intructions.ifClicked();
    Credits.ifClicked();
  }
  if(location == 2 || location == 3)
  {
    Back.ifClicked();
  }
}
