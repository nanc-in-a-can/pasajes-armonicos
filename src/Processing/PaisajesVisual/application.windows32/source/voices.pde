String strVoice = "";
Deque<String> voiceData;
int maxVoices  = 50;


void setupVoiceData() {
  voiceData = new ArrayDeque<String>();
}

/*
Display information about the voices
 */
void displayVoices(PGraphics pg) {
  if (!voicesDisplayLock) {

    if (millis() - voicesDisplayTime > 12000) {
      voicesDisplayLock = true;
    }

    int x = width - 135;
    int y = 20;

    try {
      pg.beginDraw();
      pg.textFont(font);
      pg.fill(255);
      for (String voice : voiceData) {
        pg.text(voice, x, y);
        y+=15;
      }
      pg.endDraw();
    } 
    catch (java.util.ConcurrentModificationException exception) {
    } 
    catch (Throwable throwable) {
    }
  }
}
