import oscP5.*;
import netP5.*;
import controlP5.*;

//gui
ControlP5 cp5;
Slider2D  sliderXY;
Slider    sliderZ;

//osc
OscP5 oscP5;
NetAddress myRemoteLocation;

//ip values
String strIP = "127.0.0.1";
String strPort = "32000";

String msg = "/dirxyz";


//slider vaues
float sliderPrevX = 0.0;
float sliderPrevY = 0.0;
float sliderPrevZ = 0.0;

float sliderCurrX = 0.0;
float sliderCurrY = 0.0;
float sliderCurrZ = 0.0;

void setup() {
  size(500, 300);

  PFont font = createFont("arial", 12);

  //osc
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress(strIP, Integer.parseInt(strPort));

  cp5 = new ControlP5(this);

  sliderXY = cp5.addSlider2D("xy")
    .setPosition(30, 40)
    .setSize(150, 150)
    .setMinMax(0.0, 0.0, 1.0, 1.0)
    .setValue(0.5, 0.5)
    //.disableCrosshair()
    ;

  sliderZ = cp5.addSlider("z")
    .setPosition(30, 250)
    .setRange(0, 1)
    .setSize(150, 20)
    ;

  ///////////////////////////////////////////////////////

  cp5.addTextlabel("OSC Message")
    .setText("OSC Message "+msg)
    .setPosition(250, 50)
    .setColorValue(0xffffffff);

  cp5.addTextfield("ip")
    .setPosition(250, 80)
    .setSize(150, 20)
    .setFocus(true)
    .setValue(strIP)
    .setColor(color(255, 0, 0));

  cp5.addTextfield("port")
    .setPosition(250, 130)
    .setSize(150, 20)
    .setValue(strPort)
    .setAutoClear(false);
}


void ip(String strValue) {
  strIP = strValue;
  myRemoteLocation = new NetAddress(strIP, Integer.parseInt(strPort));
  println(strIP+ " "+strPort);
}

void port(String strValue) {
  strPort = strValue;
  myRemoteLocation = new NetAddress(strIP, Integer.parseInt(strPort));
  println(strIP+ " "+strPort);
}


void draw() {
  background(0);

  sliderPrevX = sliderCurrX;
  sliderPrevY = sliderCurrY;
  sliderPrevZ = sliderCurrZ;

  sliderCurrX = sliderXY.getArrayValue()[0];
  sliderCurrY = sliderXY.getArrayValue()[1];
  sliderCurrZ = sliderZ.getValue();


  if (sliderPrevX != sliderCurrX || sliderPrevY != sliderCurrY || sliderPrevZ != sliderCurrZ) {
    sendValues(msg, sliderCurrX, sliderCurrY, sliderCurrZ);
    println("sent values "+msg+"  "+ sliderCurrX+" "+sliderCurrY+" "+sliderCurrZ);
  }
}

void keyPressed() {
  if (key == 'a') {
    OscMessage myMessage = new OscMessage("/play");
    myMessage.add(1);
    /* send the message */
    oscP5.send(myMessage, myRemoteLocation);
    println("send /play 1");
  }
}

void sendValues(String msg, float x, float y, float z) {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage(msg);

  myMessage.add(x);
  myMessage.add(y);
  myMessage.add(z);

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation);
}
