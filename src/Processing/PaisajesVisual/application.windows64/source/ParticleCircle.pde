class ParticleCircle {
  int n = 125;

  float[] m = new float[n];
  float[] x = new float[n];
  float[] y = new float[n];
  float[] vx = new float[n];
  float[] vy = new float[n];

  float particleWidth  = 300;
  float particleHeight = 300;

  float posX = 50;
  float posY = 50;

  int id = 0;
  boolean lock = false;

  //duration in seconds
  float duration;
  float cTime = 0;

  float maxCircles =0.05;
  float incCircles = 0.05;
  float incTime = 0.0;

  float attractX;
  float attractY;


  ParticleCircle(float particleWidth, float particleHeight, float posX, float posY) {
    this.particleWidth  = particleWidth;
    this.particleHeight = particleHeight;

    this.posX = posX;
    this.posY = posY;

    this.attractX = posX + particleWidth/2.0;
    this.attractY = posY + particleHeight/2.0;
  }


  void updateGrow() {


    if (!lock) {
      float currentTime = millis();
      if (currentTime - cTime > duration) {
        println("time done");
        println(currentTime - cTime+" "+duration);
        lock = true;
        incCircles = maxCircles;
      } else {
        incCircles += incTime;
      }
      //println(incCircles);
    }
  }


  void draw(PGraphics pg) {
    for (int i = 0; i < n; i++) {
      float dx = width/2.0 - x[i];
      float dy = height/2.0 - y[i];

      float d = sqrtSemi(dx*dx + dy*dy);
      if (d < 1) d = 1;

      float f = cos(d * incCircles) * m[i] / d;

      vx[i] = vx[i] * 0.5 + f * dx;
      vy[i] = vy[i] * 0.5 + f * dy;
    }

    pg.beginDraw();
    pg.beginShape(POINTS);
    for (int i = 0; i < n; i++) {
      x[i] += vx[i];
      y[i] += vy[i];

      if (x[i] <= posX) x[i] = particleWidth + posX;
      else if (x[i] >= particleWidth+ posX) x[i] = posX;

      if (y[i] <= posY) y[i] = particleHeight + posY;
      else if (y[i] >= particleHeight+ posY) y[i] = posY;

      if (m[i] < 0) {
        pg.stroke(155, 150);
      } else { 
        pg.stroke(255, 150);
      }

      pg.vertex(x[i], y[i]);
    }
    pg.endShape();
    pg.endDraw();
  }

  void reset() {
    cTime = millis();

    //free the lock to update the timer
    lock = false;

    float fps_ms = 1000.0/frameRate;
    
    float dur_fsp = duration/fps_ms;

    incTime = maxCircles/dur_fsp;
    incCircles= 0;
    
    println("fps:"+fps_ms+" "+frameRate);
    println("id: "+id+" inc: "+incTime);
    println(dur_fsp*duration+" "+duration);

    for (int i = 0; i < n; i++) {
      m[i] = randomGaussian() * 16;
      x[i] = random(particleWidth);
      y[i] = random(particleHeight);
    }
  }
  /**
   * Semi-Accurate approximation for a floating-point square root.
   * Roughly 1.4x as fast as java.lang.Math.sqrt(x);
   
   */
  float sqrtSemi(float f) {
    float y = Float.intBitsToFloat(0x5f375a86 - (Float.floatToIntBits(f) >> 1)); // evil floating point bit level hacking -- Use 0x5f375a86 instead of 0x5f3759df, due to slight accuracy increase. (Credit to Chris Lomont)
    y = y * (1.5F - (0.5F * f * y * y));   // Newton step, repeating increases accuracy
    return f * y;
  }
}
