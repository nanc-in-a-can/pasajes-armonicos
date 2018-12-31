/**
 * oscP5message by andreas schlegel
 * example shows how to create osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

String msg = "";
String raw = "";

void setup() {
  size(400, 400);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 32000);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("172.34.87.5", 12999);
}


void draw() {
  background(0);
  
  text(msg, 20, 20);
}

void mousePressed() {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/unitypos");

  myMessage.add(map(mouseX, 0, 1, 0, 20));
  myMessage.add(map(mouseY, 0, 1, 0, 10));

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation);
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  
  if (theOscMessage.checkAddrPattern("/dirxyz")==true) {

    float firstValue = theOscMessage.get(0).floatValue();  
    float secondValue = theOscMessage.get(1).floatValue();
    float thirdValue = theOscMessage.get(2).floatValue();
    
    msg = theOscMessage.addrPattern()+" -  "+firstValue+", "+secondValue+", "+thirdValue;
    
  }
  
  raw = theOscMessage.toString();
 
}
