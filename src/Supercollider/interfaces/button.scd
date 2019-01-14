
(
var w;
var bottonPlay, botonTrans;
var playBotton, playBotton2, transBotton, static1, static2, curatorialTextEsp, curatorialTextEng, curadoDeFresa, curatorialStatic;

~widthB= 300; ~heightB= 150; ~xB= 1000; ~yB= 800;
//"compila button".postln;

/*"~widthB and ~heightB control the buttons size".postln;
"~xB and ~yB control button location".postln;*/

w = Window.new("Pasajes Armónicos", Rect(~xB,~yB, ~widthB, ~heightB), false, false, scroll: true);

playBotton= "Con el botón de arriba es posible escuchar un pasaje aleatorio";
static1 = StaticText(w, Rect(5, 45, ~widthB -10, 25));
static1.stringColor = Color.white;
static1.string  = playBotton.asString;
static1.align = \center;

playBotton2= "With this botton it is possible to listen to a default random passage";
static2 = StaticText(w, Rect(5, 95, ~widthB -10, 25));
static2.stringColor = Color.white;
static2.string  = playBotton2.asString;
static2.align = \center;

bottonPlay = Button(w, Rect(5, 5, ~widthB -10, 30))
        .states_([
	["Escucha un Pasaje aleatorio", Color(rrand(0.5,1.0),rrand(0.5,1.0),rrand(0.5,1.0)), Color.black]
        ])
        .action_({|button|

	PasajesArmonicos.playDefault; "a default canon".postln;


});


w.background = Color(0.05,0.05,0.05);
w.front;
w.alwaysOnTop = true;
CmdPeriod.doOnce({w.close});


)

