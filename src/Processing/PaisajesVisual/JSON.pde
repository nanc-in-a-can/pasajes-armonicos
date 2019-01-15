JSONArray  json;

//defulta json path

String jsonPath = "C:/Users/thomas/Documents/pasajes-armonicos/src/JSONs/20190114072341-canon.json";
boolean doneReadingJson = false;

void loadJson(String path) {
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

void visualizeCanon() {
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
