/*

 */

void oscSetup() {
  oscP5 = new OscP5(this, 12000);
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
