class ParticleCircle {
  int numParticles;

  float[] m;
  float[] x;
  float[] y;
  float[] vx;
  float[] vy;

  float particleWidth;
  float particleHeight;

  float posX;
  float posY;

  int id = 0;
  boolean lock = false;

  //duration in seconds
  float duration;
  float cTime = 0;

  float maxCircles  = 0.08;
  float incCircles  = 0.08;
  float incTime     = 0.0;

  float attractX;
  float attractY;
  
  float centerX = width/2.0;
  float centerY = height/2.0;

  LightBang lightBang;

  ParticleCircle(int numParticles, float particleWidth, float particleHeight, float posX, float posY) {
    this.numParticles = numParticles;
    this.particleWidth  = particleWidth;
    this.particleHeight = particleHeight;

    this.posX = posX;
    this.posY = posY;

    this.attractX = posX + particleWidth/2.0;
    this.attractY = posY + particleHeight/2.0;

    lightBang = new LightBang(80);

    m  = new float[numParticles];
    x  = new float[numParticles];
    y  = new float[numParticles];
    vx = new float[numParticles];
    vy = new float[numParticles];
  }
  
  void updateCenter(float posx, float posy){
    centerX = posx;
    centerY = posy;
  }

  void updateGrow() {
    if (!lock) {
      float currentTime = millis();
      if (currentTime - cTime > duration) {
        println("time done");
        println(currentTime - cTime+" "+duration);
        lock = true;
        incCircles = maxCircles;
        println(incCircles);
      } else {
        incCircles += incTime;
      }
      //println(incCircles);
    }
  }


  void draw(PGraphics pg) {

    if (lightBang.isEnable()) {
      pg.beginDraw();
      pg.fill(lightBang.getColor());
      pg.rect(posX, posY, particleWidth, particleHeight);
      pg.endDraw();
    }
    for (int i = 0; i < numParticles; i++) {
      float dx = centerX - x[i];
      float dy = centerY - y[i];

      float d = sqrtSemi(dx*dx + dy*dy);
      if (d < 1) d = 1;

      float f = cos(d * incCircles) * m[i] / d;

      vx[i] = vx[i] * 0.5 + f * dx;
      vy[i] = vy[i] * 0.5 + f * dy;
    }

    pg.beginDraw();
    pg.beginShape(POINTS);
    for (int i = 0; i < numParticles; i++) {
      x[i] += vx[i];
      y[i] += vy[i];

      if (x[i] < posX) x[i] = particleWidth + posX;
      else if (x[i] > particleWidth+ posX) x[i] = posX;

      if (y[i] < posY) y[i] = particleHeight + posY;
      else if (y[i] > particleHeight+ posY) y[i] = posY;

      if (m[i] < 0.0) {
        pg.stroke(155);
      } else { 
        pg.stroke(255, 150);
      }

      pg.vertex(x[i], y[i]);
    }
    pg.endShape();
    pg.endDraw();

    lightBang.udpate();
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

    for (int i = 0; i < numParticles; i++) {
      m[i] = randomGaussian() * 16;
      x[i] = random(particleWidth);
      y[i] = random(particleHeight);
    }
    lightBang.bang();
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
