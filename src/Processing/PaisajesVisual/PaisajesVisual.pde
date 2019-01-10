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

String imuStr = "";
Deque<String> imuData;
int maxDequeValues = 50;


//
PGraphics pg;

//
PFont font;

//
void setup() {
  size(1024, 768);
  frameRate(60);
  
  font = createFont("Inconsolata.otf", 12, true);
  
  //PGraphics
  pg = createGraphics(1024, 768); 
  
  //setupIMU
  setupIMU();
  
  //Port
  setupPort();
  
  //setup OSC
  oscSetup();
  
}


void draw() {
  background(0);
  
  
  displayData();
  image(pg, 0, 0);
}
