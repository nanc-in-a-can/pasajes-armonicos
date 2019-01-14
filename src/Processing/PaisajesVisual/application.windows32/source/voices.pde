String strVoice = "";
Deque<String> voiceData;
int maxVoices  = 50;


void setupVoiceData() {
  voiceData = new ArrayDeque<String>();
}

/*
Display information about the voices
*/
void displayVoices() {
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
