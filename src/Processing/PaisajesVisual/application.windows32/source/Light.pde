class LightBang {

  float bkgColor =0;

  float pTime  = 0;
  float maxDuration; //100ms
  boolean enable = false;

  LightBang(float maxDuration) {
    this.maxDuration = maxDuration;
  }

  void udpate() {
    if (enable) {
      if (millis() - pTime >= maxDuration) {
        bkgColor = 0;
        enable = false;
      }
    }
  }
  
  boolean isEnable(){
    return enable;
  }

  float getColor() {
    return bkgColor;
  }

  void bang() {
    bkgColor = 255;
    pTime = millis();
    enable = true;
  }
}
