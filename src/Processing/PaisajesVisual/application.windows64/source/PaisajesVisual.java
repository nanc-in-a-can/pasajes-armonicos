import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 
import processing.serial.*; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class PaisajesVisual extends PApplet {




 


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

public void setup() {
  
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


public void draw() {
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
  if (abs(roll - pRoll)  > 0.05f ||  abs(pitch - pPitch)  > 0.05f  ||  abs(yaw - pYaw)  > 0.05f ) {
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

public void keyPressed() {
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
/*
Canon compilation
*/
class Canon{
  ArrayList<Float> durs;
  ArrayList<Float> notes;
  
  float onset;
  float bcp;
  float remainder;
  
  Canon(){
    durs = new ArrayList<Float>();
    notes = new ArrayList<Float>();
    
    onset = 0;
    bcp = 0;
    remainder = 0;
  }
  
  
  
  
  
  
  
  
}
// Serial port state.
Serial       port;
final String serialConfigFile = "serialconfig.txt";
boolean      printSerial = false;

//min, max
float maxX = -10000.0f;
float minX = 100000.0f;

float maxY = -10000.0f;
float minY = 100000.0f;

float maxZ = -10000.0f;
float minZ =  100000.0f;

/*
setup Serial
 */
public void setupPort() {
  // Serial port setup.
  // Grab list of serial ports and choose one that was persisted earlier or default to the first port.
  int selectedPort = 0;
  String[] availablePorts = Serial.list();
  printArray(Serial.list());
  if (availablePorts == null) {
    println("ERROR: No serial ports available!");
    exit();
  }
  String[] serialConfig = loadStrings(serialConfigFile);
  if (serialConfig != null && serialConfig.length > 0) {
    String savedPort = serialConfig[0];
    println("read: "+savedPort);
    try {
      port = new Serial(this, savedPort, 115200);
      port.bufferUntil('\n');
      // Check if saved port is in available ports.
      for (int i = 0; i < availablePorts.length; ++i) {
        if (availablePorts[i].equals(savedPort)) {
          selectedPort = i;
        }
      }
    }
    catch(Exception e) {
    }
  }

  println();
}

public void setupIMU() {
  imuData = new ArrayDeque<String>();
}


public void printIMUValues() {
}

public void serialEvent(Serial p) {
  String incoming = p.readString();
  if (printSerial) {
    println(incoming);
  }

  if ((incoming.length() > 8)) {
    String[] list = split(incoming, " ");
    if ( (list.length > 0) && (list[0].equals("Orientation:")) ) {
      
      //save the last value
      pRoll  = roll;
      pPitch = pitch;
      pYaw   = yaw;
      
      
      roll  = PApplet.parseFloat(list[3]); // Roll = Z
      pitch = PApplet.parseFloat(list[2]); // Pitch = Y 
      yaw   = PApplet.parseFloat(list[1]); // Yaw/Heading = X


      if (yaw > maxX) {
        maxX = yaw;
      }
      if (yaw < minX) {
        minX = yaw;
      }

      if (pitch > maxY) {
        maxY = pitch;
      }
      if (pitch < minY) {
        minY = pitch;
      }

      if (roll > maxZ) {
        maxZ = roll;
      }
      if (roll < minZ) {
        minZ = roll;
      }
      yaw   = map(yaw, minX, maxX, 0.0f, 1.0f);
      pitch = abs(map(pitch, minY, maxY, 0.0f, 1.0f));
      roll  = map(roll, minZ, maxZ, 0.0f, 1.0f);
   
      
      imuStr = String.format("%.2f", roll)+" "+String.format("%.2f", pitch) +" "+String.format("%.2f", yaw);
      //
      imuData.addLast(imuStr);
      if (imuData.size() > maxDequeValues) {
        imuData.removeFirst();
      }
    }
  }
}

//display 
public void displayData() {
  textFont(font);

  int x = 10;
  int y = 20;
  stroke(255);
  try {
    for (String imudata : imuData) {
      text(imudata, x, y);
      y+=15;
    }
  } 
  catch (java.util.ConcurrentModificationException exception) {
  } 
  catch (Throwable throwable) {
  }
}
JSONArray  json;

//defulta json path

String jsonPath = "C:/Users/thomas/Documents/pasajes-armonicos/src/Supercollider/../JSONs/1010-canon.json";
boolean doneReadingJson = false;

public void loadJson(String path) {
  jsonPath = path;

  println("got json path "+jsonPath);

  json = loadJSONArray (jsonPath);

  //print values

  for (int i = 0; i < json.size(); i++) {

    JSONObject canon = json.getJSONObject(i); 

    Canon can = new Canon();

    int id = canon.getInt("cp");

    //onset, bcp, remainder
    float onset = canon.getFloat("onset");
    float bcp = canon.getFloat("bcp");
    float remainder = canon.getFloat("remainder");

    //duration
    JSONArray durs = canon.getJSONArray("durs");
    for (float times : durs.getFloatArray()) {
      //println(times);
      can.durs.add(times);
    }

    //Notes
    JSONArray notes = canon.getJSONArray("notes");
    for (float note : notes.getFloatArray()) {
      //println(note);
      can.notes.add(note);
    }
    can.onset = onset;
    can.bcp = bcp;
    can.remainder = remainder;

    //add the canon
    canons.add(can);

    println(id + ", " + durs.size() + ", " + notes.size());
  }
}

/*
Visual
 */

public void visualizeCanon() {
  textFont(font);

  int x = 260;
  int y = 20;

  stroke(255);
  try {
    for (Canon can : canons) {
      for (int i  = 0; i < can.notes.size(); i++) {
        float note = can.notes.get(i);
        float dur  = can.durs.get(i);

        String names = String.format("%.2f", note) + " "+String.format("%.2f", dur);
        text(names, x, y);
        y+=15;
      }
      x+= 80;
      y = 20;
    }
  }
  catch (java.util.ConcurrentModificationException exception) {
  } 
  catch (Throwable throwable) {
  }
}
class BkgBang{
  
  float bkgColor =0;
  
  BkgBang(){
    
  }
  
  public float getBack(){
    return bkgColor;
  }
  
  public void updateBkg(){
    
  }
  
  public void drawBkg(){
    
  }
  
  public void enable(){
    
  }
  
  public void diable(){
    
  }
  
}
/*

 */

boolean msgVoice = true;


public void oscSetup() {
  oscP5 = new OscP5(this, 32001);
  myRemoteLocation = new NetAddress("127.0.0.1", 32000);
}

public void sendRead() {
  OscMessage myMessage = new OscMessage("/play");
  myMessage.add(1);
  /* send the message */
  oscP5.send(myMessage, myRemoteLocation);
  println("send /play 1");
}


//send x,y,z values
public void sendIMU(String msg, float x, float y, float z) {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage(msg);

  myMessage.add(x);
  myMessage.add(y);
  myMessage.add(z);

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation);
}

/* incoming osc message are forwarded to the oscEvent method. */
public void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */

  if (msgVoice) {
    print("### received an osc message.");
    print(" addrpattern: "+theOscMessage.addrPattern());
    println(" typetag: "+theOscMessage.typetag());
  }

  if (theOscMessage.checkAddrPattern("/json")==true) {
    String jsonPath = theOscMessage.get(0).stringValue();
    loadJson(jsonPath);
    doneReadingJson = true;
    //load json
  }

  if (theOscMessage.checkAddrPattern("/voice_event")==true) {

    int   index = theOscMessage.get(0).intValue();
    float cvp   = theOscMessage.get(1).floatValue();
    float dur  = theOscMessage.get(2).floatValue();
    float note  = theOscMessage.get(3).floatValue();

    String inMsg = index+" "+ String.format("%.2f", cvp)+" "+String.format("%.2f", dur)+" "+   String.format("%.2f", note);

    strVoice = inMsg;
    voiceData.addLast(strVoice);
    if (voiceData.size() > maxVoices) {
      voiceData.removeFirst();
    }  
    
    float cirW = 1280 /5.0f;
    float cirH = 720 / 7.0f;
   
    
    //map
    // 0 -> 17  // 8 -> 21   //16 -> 24  //24 -> 10  //32-> 32
    // 1 -> 12  // 9 -> 5    //17 -> 29  //25 -> 0   //33 -> 33
    // 2 -> 28  // 10 -> 6   //18 -> 28  //26 -> 1   //34 => 34
    // 3 -> 22  // 11 -> 7   //19 -> 27  //27 -> 2 
    // 4 -> 16  // 12 -> 8   //20 -> 26  //28 -> 3
    // 5 -> 11  // 13 -> 9   //21 -> 25  //29 -> 4
    // 6 -> 13  // 14 -> 14  //22 -> 20  //30 -> 30
    // 7 -> 23  // 15 -> 19  //23 -> 15  //31 -> 31
    
    int mapValues[]= {17, 12, 28, 22, 16, 11, 13, 23,
                      21,  5,  6,  7,  8,  9, 14, 19,
                      24, 29, 29, 27, 26, 25, 20, 15,
                      10,  0,  1,  2,  3,  4, 30, 31, 
                      32, 33, 34};
                      
    int mapIndex = mapValues[index];
    int indexX = mapIndex%5;
    int indexY = mapIndex/5%7;

    if (circles.isEmpty()) {
      ParticleCircle circle  = new ParticleCircle(cirW, cirH, 0 + indexX*cirW, 0 + indexY*cirH);
      circle.id = mapIndex;
      circle.duration  = dur*1000;
      circle.reset();
      circles.add(circle);
      println("create first");
    } else {

      //add a new Particle Cricle and grow depdending on the duration;
      boolean foundId = false;
      for (ParticleCircle circle : circles) {
        if (mapIndex == circle.id) {
          mapIndex = circle.id;
          foundId = true;
          break;
        }
      }

      if (foundId) {
        circles.get(index).duration  = dur*1000;
        circles.get(index).reset();
      } else {
        ParticleCircle circle  = new ParticleCircle(cirW, cirH, 0 + indexX*cirW, 0 + indexY*cirH);
        circle.id = mapIndex;
        circle.duration  = dur*1000;
        circle.reset();
        circles.add(circle);
      }
    }


    //index, dur, note
    // println(
  }
}

//voices event
class Partcile{
  float x;
  float y;
  
  float vx;
  float yy;

  
  public void update(){
    
  }
}
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

  float maxCircles =0.05f;
  float incCircles = 0.05f;
  float incTime = 0.0f;

  float attractX;
  float attractY;


  ParticleCircle(float particleWidth, float particleHeight, float posX, float posY) {
    this.particleWidth  = particleWidth;
    this.particleHeight = particleHeight;

    this.posX = posX;
    this.posY = posY;

    this.attractX = posX + particleWidth/2.0f;
    this.attractY = posY + particleHeight/2.0f;
  }


  public void updateGrow() {


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


  public void draw(PGraphics pg) {
    for (int i = 0; i < n; i++) {
      float dx = width/2.0f - x[i];
      float dy = height/2.0f - y[i];

      float d = sqrtSemi(dx*dx + dy*dy);
      if (d < 1) d = 1;

      float f = cos(d * incCircles) * m[i] / d;

      vx[i] = vx[i] * 0.5f + f * dx;
      vy[i] = vy[i] * 0.5f + f * dy;
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

  public void reset() {
    cTime = millis();

    //free the lock to update the timer
    lock = false;

    float fps_ms = 1000.0f/frameRate;
    
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
  public float sqrtSemi(float f) {
    float y = Float.intBitsToFloat(0x5f375a86 - (Float.floatToIntBits(f) >> 1)); // evil floating point bit level hacking -- Use 0x5f375a86 instead of 0x5f3759df, due to slight accuracy increase. (Credit to Chris Lomont)
    y = y * (1.5F - (0.5F * f * y * y));   // Newton step, repeating increases accuracy
    return f * y;
  }
}
String strVoice = "";
Deque<String> voiceData;
int maxVoices  = 50;


public void setupVoiceData() {
  voiceData = new ArrayDeque<String>();
}

/*
Display information about the voices
*/
public void displayVoices() {
  textFont(font);

  int x = 130;
  int y = 20;
  
  stroke(255);
  try {
    for (String voice : voiceData) {
      text(voice, x, y);
      y+=15;
    }
  } 
  catch (java.util.ConcurrentModificationException exception) {
  } 
  catch (Throwable throwable) {
  }
}
  public void settings() {  size(1280, 720, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "PaisajesVisual" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}