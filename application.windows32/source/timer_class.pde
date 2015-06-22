class Timer
{
  int duration;
  int maxTime;
  int pauseTime;
  int newTime;
  boolean changeTime = false;
  Timer(int _duration)
  {
    duration = _duration;
    maxTime = millis() + duration;
  }
  boolean go()
  {
    checkifPaused();
    if (!paused)
    {
      if (millis() > maxTime)
      {
        maxTime+=duration;
        return true;
      }
    }
    return false;
  }
  void checkifPaused()
  {
    if (paused && !changeTime)
    {
      pauseTime = millis();
      changeTime = true;
    } else if (!paused && changeTime)
    {
      newTime = millis()-pauseTime;
      maxTime+=newTime;
      changeTime = false;
    }
  }
}

