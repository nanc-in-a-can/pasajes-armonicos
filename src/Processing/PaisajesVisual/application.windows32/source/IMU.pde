// Serial port state.
Serial       port;
final String serialConfigFile = "serialconfig.txt";
boolean      printSerial = false;

//min, max
float maxX = -10000.0;
float minX = 100000.0;

float maxY = -10000.0;
float minY = 100000.0;

float maxZ = -10000.0;
float minZ =  100000.0;

boolean grabController = false;
boolean lockController = false;
boolean onceController = false;

float pTimeIMU =0;

<<<<<<< HEAD
=======
//display counter
float imuDisplayTime = 0;
boolean imuDisplayLock = true;

>>>>>>> 017ea7fba39604e6762d378d06387107c5866e96
/*
setup Serial
 */
void setupPort() {
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

void setupIMU() {
  imuData = new ArrayDeque<String>();
}


void printIMUValues() {
}

void serialEvent(Serial p) {
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


      roll  = float(list[3]); // Roll = Z
      pitch = float(list[2]); // Pitch = Y 
      yaw   = float(list[1]); // Yaw/Heading = X


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
      yaw   = map(yaw, minX, maxX, 0.0, 1.0);
      pitch = abs(map(pitch, minY, maxY, 0.0, 1.0));
      roll  = map(roll, minZ, maxZ, 0.0, 1.0);


      //if grab the controller change the mode of interaction
      if (abs(roll - pRoll)  > 0.02 ||  abs(pitch - pPitch)  > 0.02  ||  abs(yaw - pYaw)  > 0.02 ) {

        if (!lockController) {
          grabController = true;
          onceController = true;
        }
        pTimeIMU = millis();

        print("controller: "+grabController);
      } else {

        if (!lockController) {
          grabController = false;
        }
<<<<<<< HEAD
        
=======
>>>>>>> 017ea7fba39604e6762d378d06387107c5866e96
      }


      imuStr = String.format("%.2f", roll)+" "+String.format("%.2f", pitch) +" "+String.format("%.2f", yaw);
      //
      imuData.addLast(imuStr);
      if (imuData.size() > maxDequeValues) {
        imuData.removeFirst();
      }
    }
  }
}

void updateIMU() {

  if (onceController && grabController) {

    bkgBang.bang();

    particleController.id = 0;
<<<<<<< HEAD
    particleController.duration  = 20*1000;
=======
    particleController.duration  = 10*1000;
>>>>>>> 017ea7fba39604e6762d378d06387107c5866e96
    particleController.reset();

    //single bang in 20 seconds
    pTimeIMU = millis();
<<<<<<< HEAD
    onceController = false;
    lockController = true;
=======
    imuDisplayTime = millis();
    voicesDisplayTime = millis();
    
    onceController = false;
    lockController = true;

    imuDisplayLock = false;
    voicesDisplayLock = false;
>>>>>>> 017ea7fba39604e6762d378d06387107c5866e96
  }

  if (lockController) {
    if (millis() - pTimeIMU > 5*1000) {
      lockController = false;
    }
  }
}


//display 
void displayData() {
  if (!imuDisplayLock) {

    if (millis() - imuDisplayTime > 12000) {
      imuDisplayLock = true;
    }

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
}
