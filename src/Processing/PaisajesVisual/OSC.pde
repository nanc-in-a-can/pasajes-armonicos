/*

 */

void oscSetup() {
  oscP5 = new OscP5(this, 32001);
  myRemoteLocation = new NetAddress("127.0.0.1", 32000);
}

void sendRead() {
  OscMessage myMessage = new OscMessage("/play");
  myMessage.add(1);
  /* send the message */
  oscP5.send(myMessage, myRemoteLocation);
  println("send /play 1");
}


//send x,y,z values
void sendIMU(String msg, float x, float y, float z) {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage(msg);

  myMessage.add(x);
  myMessage.add(y);
  myMessage.add(z);

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation);
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());

  if (theOscMessage.checkAddrPattern("/json")==true) {
    String jsonPath = theOscMessage.get(0).stringValue();

    loadJson(jsonPath);
    //load json
  }
  
  if (theOscMessage.checkAddrPattern("/voice_event")==true) {
    //index, dur, note
   // println(theOscMessage.get(0).intValue()+" "+theOscMessage.get(0).floatValue()+" "+theOscMessage.get(0).floatValue());
  }
}

//voices event
