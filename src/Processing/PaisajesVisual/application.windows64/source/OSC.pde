/*

 */

boolean msgVoice = true;


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
    
    float cirW = 1280 /5.0;
    float cirH = 720 / 7.0;
   
    
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
