
(
var w;
var width= 300, height= 550;
var bottonPlay, botonTrans;
var playBotton, transBotton, static1, curatorialTextEsp, curatorialTextEng, curadoDeFresa, curatorialStatic;

"compila buttin".postln;


w = Window.new("Pasajes Armónicos", Rect(1050,210, width, height), false, false, scroll: true);

playBotton= "Con el botón de arriba es posible escuchar un pasaje aleatorio, un fragmento de una memoria vacía";
static1 = StaticText(w, Rect(5, 35, width -10, 25));
static1.stringColor = Color.white;
static1.string  = playBotton.asString;
static1.align = \center;

curatorialTextEsp= "Esta instalación produce una melodía que avanza simultáneamente a muchas velocidades. Esto nos permite escuchar diferentes segmentos melódicos al mismo tiempo; una forma peculiar de escucha. El propósito de esta instalación es, entre todos nosotros, producir una memoria de este encuentro. Una memoria que toma la forma de una línea de tiempo audible y visible. Sin embargo, en este espacio, el tiempo no es lineal. De esta manera, un tiempo que es lento, múltiple, simultáneo y constante atraviesa y des-articula esta memoria colectiva. Este tiempo-red nos permite escuchar instantes yuxtapuestos; Instantes que están relacionados por el afecto más que por la cronología. A pesar de toda la incertidumbre, hemos recorrido barrios, océanos, días y años para reunirnos aquí. Como diría Félix Gonzáles Torres: \"No temas a los relojes. Estamos sincronizados, ahora y por siempre\".";

curatorialTextEng= "This installation produces a melody that advances simultaneously at many speeds. This allows us to listen different melodic segments at the same time; a rather odd way of listening. The purpose of this installation is, among all of us, to produce a memory of this encounter. A memory that takes the form of a sonic time-line. However, in this space, time is non-lineal. Thus a time that is slow, multiple, simultaneous and constant traverses and de-articulates the time of this collective memory. This network-oriented time allows us to listen juxtapossed instants; instants that are related by affection rather than chronology. Despite all uncertainty, we have travelled through neighborhoods, oceans, days and years to meet. As Felix Gonzáles Torres would say: \"do not be afraid of the clocks [...] We are synchronized, now and forever.\"";

curadoDeFresa = StaticText(w, Rect(5, 20, width -10, 320));
curadoDeFresa.stringColor = Color.white;
curadoDeFresa.string  = curatorialTextEsp.asString;
curadoDeFresa.align = \center;

curatorialStatic = StaticText(w, Rect(5, 200, width -10, 420));
curatorialStatic.stringColor = Color.white;
curatorialStatic.string  = curatorialTextEng.asString;
curatorialStatic.align = \center;

bottonPlay = Button(w, Rect(5, 5, width -10, 30))
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

