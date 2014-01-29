class Timer
{
  int duration;
  int maxTime;
  Timer(int _duration)
  {
    duration = _duration;
    maxTime = millis() + duration;
  }
  boolean go()
  {
    if(millis() > maxTime)
    {
      maxTime+=duration;
      return true;
    }
    return false;
  }
}
