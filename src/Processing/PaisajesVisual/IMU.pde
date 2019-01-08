// Serial port state.
Serial       port;
final String serialConfigFile = "serialconfig.txt";
boolean      printSerial = true;

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
    port = new Serial(this, savedPort, 115200);
    port.bufferUntil('\n');
    // Check if saved port is in available ports.
    for (int i = 0; i < availablePorts.length; ++i) {
      if (availablePorts[i].equals(savedPort)) {
        selectedPort = i;
      }
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
      roll  = float(list[3]); // Roll = Z
      pitch = float(list[2]); // Pitch = Y 
      yaw   = float(list[1]); // Yaw/Heading = X
      imuStr= roll+" "+pitch+" "+yaw;
      imuData.addLast(imuStr);
      if (imuData.size() > maxDequeValues) {
        imuData.removeFirst();
      }
    }
  }
}

//display 
void displayData() {
  textFont(font);

  int x = 20;
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
