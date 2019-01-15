import oscP5.*;
import netP5.*;
import processing.serial.*;
import java.util.*; 
import spout.*;

// DECLARE A SPOUT OBJECT
Spout spout;

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
LightBang bkgBang;

//general canon
ArrayList<ParticleCircle> circles;

//single form of view
ParticleCircle  particleController;

boolean showFps =false;

void setup() {
  size(1024, 768, P3D);
  frameRate(60);

  //5 x 6

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

  //lightbang
<<<<<<< HEAD
  bkgBang = new LightBang(200);
=======
  bkgBang = new LightBang(60);
>>>>>>> 017ea7fba39604e6762d378d06387107c5866e96


  //cirlce
  circles = new ArrayList<ParticleCircle>();

  //center
  particleController = new ParticleCircle(10000, width, height, 0, 0);
  particleController.id = 0;
  particleController.duration  =10*1000;
  particleController.reset();
<<<<<<< HEAD
=======

  spout = new Spout(this);

  // CREATE A NAMED SENDER
  // A sender can be created now with any name.
  // Otherwise a sender is created the first time
  // "sendTexture" is called and the sketch
  // folder name is used.  
  spout.createSender("Spout Processing");
>>>>>>> 017ea7fba39604e6762d378d06387107c5866e96
}


void draw() {
  pg.beginDraw();
<<<<<<< HEAD
  pg.fill(bkgBang.getColor(), 20);
=======
  pg.fill(bkgBang.getColor(), 50);
>>>>>>> 017ea7fba39604e6762d378d06387107c5866e96
  pg.rect(0, 0, width, height);
  pg.endDraw();

  //input data
  //displayData();

  //canon
  //visualizeCanon();

  //voices
<<<<<<< HEAD
  displayVoices();

  if (grabController) {
    particleController.updateCenter(pitch*width, yaw*height);
=======
  displayVoices(pg);

  if (grabController) {
    particleController.updateCenter(pitch*width, yaw*height);
    particleController.incCircles = map(roll, 0, 1, 0.01, 0.09);
>>>>>>> 017ea7fba39604e6762d378d06387107c5866e96
    particleController.draw(pg);
    particleController.updateGrow();
  } else {
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
  }




  image(pg, 0, 0);

  //send IMU information
  if (abs(roll - pRoll)  > 0.05 ||  abs(pitch - pPitch)  > 0.05  ||  abs(yaw - pYaw)  > 0.05 ) {
    sendIMU("/dirxyz", yaw, pitch, roll);
    //println(imuStr);
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
<<<<<<< HEAD

  bkgBang.udpate();
  updateIMU();
=======
  
    //input data
  displayData();

  bkgBang.udpate();
  updateIMU();

  spout.sendTexture();
>>>>>>> 017ea7fba39604e6762d378d06387107c5866e96
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

  if (key == 'b') {
    bkgBang.bang();
  }

  if (key == 'c') {
    grabController= !grabController;
    bkgBang.bang();

    particleController.id = 0;
    particleController.duration  = 25*1000;
    particleController.reset();
<<<<<<< HEAD
=======

    imuDisplayTime = millis();
    imuDisplayLock = false;

    voicesDisplayTime = millis();
    voicesDisplayLock = false;
>>>>>>> 017ea7fba39604e6762d378d06387107c5866e96
    print("controller: "+grabController);
  }
}
