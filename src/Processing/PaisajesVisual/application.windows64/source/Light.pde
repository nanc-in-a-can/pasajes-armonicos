class LightBang {

  float bkgColor =0;

  float pTime  = 0;
  float maxDuration; //100ms
  boolean enable = false;

  LightBang(float maxDuration) {
    this.maxDuration = maxDuration;
<<<<<<< HEAD
=======
  }
  
  void updateDuration(float dur){
    maxDuration = dur;
>>>>>>> 017ea7fba39604e6762d378d06387107c5866e96
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
