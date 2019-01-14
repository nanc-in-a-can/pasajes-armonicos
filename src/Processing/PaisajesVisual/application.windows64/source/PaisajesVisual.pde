import oscP5.*;
import netP5.*;
import processing.serial.*;
import java.util.*; 


OscP5 oscP5;
NetAddress myRemoteLocation;

//IMU
float roll  = 0.0F;
float pitch = 0.0F;
float yaw   = 0.0F;

float pRoll  = 0;
float pPitch = 0;
float pYaw   = 0;

String imuStr = "";
Deque<String> imuData;
int maxDequeValues = 50;


//
PGraphics pg;

//
PFont font;

//
ArrayList<Canon> canons;

// background bang
BkgBang bkgBang;

ArrayList<ParticleCircle> circles;

boolean showFps =false;

void setup() {
  size(1280, 720, P3D);
  frameRate(60);

  //5 x 6

  //setup canons
  canons = new ArrayList<Canon>();
  loadJson(jsonPath);

  font = createFont("Inconsolata.otf", 12, true);

  //PGraphics
  pg = createGraphics(1280, 720); 

  //setupIMU
  setupIMU();

  //setup Voices
  setupVoiceData();

  //Port
  setupPort();

  //setup OSC
  oscSetup();

  bkgBang = new BkgBang();

  circles = new ArrayList<ParticleCircle>();
}


void draw() {
  //background(bkgBang.getBack());

  pg.beginDraw();
  pg.fill(0, 20);
  pg.rect(0, 0, width, height);
  pg.endDraw();

  //input data
  displayData();

  //canon
  //visualizeCanon();

  //voices
  displayVoices();

  try {
    for (ParticleCircle circle : circles) {
      circle.draw(pg);
      circle.updateGrow();
    }
  }  
  catch (java.util.ConcurrentModificationException exception) {
  } 
  catch (Throwable throwable) {
  }


  image(pg, 0, 0);

  //send IMU information
  if (abs(roll - pRoll)  > 0.05 ||  abs(pitch - pPitch)  > 0.05  ||  abs(yaw - pYaw)  > 0.05 ) {
    //sendIMU("/dirxyz", yaw, pitch, roll);
    println(imuStr);
  }

  //check if we read the json file
  if (doneReadingJson) {
    sendRead();
    println("send ready");
    doneReadingJson = false;
  }

  if (showFps) {
    stroke(255, 0, 0);
    text(frameRate, 50, 50);
  }
}

void keyPressed() {
  if (key == 'a') {
    loadJson(jsonPath);
  }

  if (key == 'r') {
    sendRead();
    println("send ready");
  }

  if (key == 'f') {
    showFps = !showFps;
  }
}
