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

void setup() {
  size(1024, 768);
  frameRate(60);

  //setup canons
  canons = new ArrayList<Canon>();
  loadJson(jsonPath);

  font = createFont("Inconsolata.otf", 12, true);

  //PGraphics
  pg = createGraphics(1024, 768); 

  //setupIMU
  setupIMU();

  //setup Voices
  setupVoiceData();

  //Port
  setupPort();

  //setup OSC
  oscSetup();

  bkgBang = new BkgBang();
}


void draw() {
  background(bkgBang.getBack());

  //input data
  displayData();

  //canon
  visualizeCanon();

  //voices
  displayVoices();

  visualizeCanon();

  image(pg, 0, 0);

  //send IMU information
  if (abs(roll - pRoll)  > 0.01 ||  abs(pitch - pPitch)  > 0.01  ||  abs(yaw - pYaw)  > 0.01 ) {
    sendIMU("/dirxyz", yaw, pitch, roll);
    println(imuStr);
  }
  
  if (doneReadingJson) {
    sendRead();
    println("send ready");
    doneReadingJson = false;
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
}
