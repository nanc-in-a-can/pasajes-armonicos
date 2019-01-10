JSONArray  json;

//defulta json path

String jsonPath = "C:/Users/thomas/Documents/pasajes-armonicos/src/Supercollider/../JSONs/canon.json";

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

void visualizeCanon(){
  for(Canon can : canons){
    can
  }
}
