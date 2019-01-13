PasajesArmonicos {
	var <>pasaje;

	register_ {|val|
		^pasaje = val;
	}

	getPasaje {
		^pasaje;
	}

	play {
		// a /play message is required at port 32000 to initialize playback
		~makeCanon.(this.getPasaje);
	}

	*initialize {|dirname|
		var s = Server.local;
		s.options.numBuffers = 1024 * 32;
		Can.defaultServerConfig;
		s.boot;
		s.waitForBoot({
			~baseDir = thisProcess.nowExecutingPath.dirname;
			(~baseDir++"/wavetable_Soundfiles.scd").load;
			(~baseDir++"/synths.scd").load;
			(~baseDir++"/player_withSynths.scd").load;
			(~baseDir++"/helpers.scd").load;
			(~baseDir++"/register-osc.scd").load;
			(~baseDir++"/interfaces/code-test.scd").load;
			(~baseDir++"/interfaces/button.scd".load);

			//init controls
			~controls = (tempoScale: 1, hamp: 0, vdensity: 1);

			~makeCanon = {|pasaje|
				var densityOfVoices = [20].choose;
				var sizeOfMelody = [30,50,80].choose;
				var melody = ~makeMelody.(sizeOfMelody, pasaje);
				var canon = Can.converge(\myLiveCan,
					player: {|sym, canon|
						~makeTaskPlayer.(sym, ~controls, canon)},
					melody: melody,
					cp: (sizeOfMelody*0.618).round,
					voices: Can.convoices(
						Array.fill(densityOfVoices, { rrand(75, 95)/2 }),
						Array.fill(densityOfVoices, { rrand(-24, 12) }),
						Array.fill(densityOfVoices, { rrand(0.1, 1.0) }) ),
					repeat: inf);

				var net = NetAddr.new("127.0.0.1", 32001);   // send canon json to localhost:32001
				var id = UniqueID.next;
				var canonpath =(~baseDir++"/../JSONs/"++id++"-canon.json").postln;
				var configpath = (~baseDir++"/../JSONs/"++id++"-config.json").postln;
				var f = File("~/test.txt".standardizePath, "w");
				var f1 = File(configpath, "w");

				~mixer= Synth(\mixer_Pasajes);
				~pan= Synth(\pasajes_PanAz);
				~combC1= Synth(\pasajes_combC1, [\amp, 0.1]); // aqui se le puede mover a la amp antes de inicializar la chingadera si es necesario;
				~combC2= Synth(\pasajes_combC2, [\amp, 0.1]);
				~canon = canon;

				~registerOsc.(canon);

				f.write(JSON.stringify(canon.canon));
				f.close;
//				f1.write("hola"/*JSON.stringify(pasaje)*/);
//				f1.close();
				net.sendMsg("/json", canonpath, configpath);
			};
			"Pasajes Armónicos has been initialized!".postln;
		})
	}

	*instrucciones {
		var window;
		var width= 500, height= 400;
		var instructionsTextEng, instructionsStatic;
		var textView, ejemplos;




window = Window.new("Pasajes Armónicos", Rect(200,110, width, height), scroll: true);


		ejemplos= "elNombredeMiGato: \"Helena\", // copia y pega esta línea abajo de nationality";

		instructionsTextEng= "Instrucciones: 1. Arriba a la derecha en esta pantalla hay un botón que produce una estructura por default. Si quieres escuchar y ver la instalación en acción sin interactuar con este código puedes apretar este botón y disfrutar. Sin embargo queremos que tu voz, tus ideas, tus palabras y todo lo que tu quieras sea parte de este espacio. 2. Si decides interactuar con el código que compartimos contigo debes de escribir en la pantalla negra de un modo especial. 3. Para que la computadora \"escuche\" lo que escribes recuerda que tienes que seguir ciertas reglas de programación y siempre compilar el código (con el comando ctrl + enter). 4. El área donde puedes contarnos sobre ti esta debajo de la línea 23 (donde dice: \"to produce sound you must tell us a bit about yourself,\"). En esta area puedes decidir que compartir al escribir una clave y su respectivo valor. La sintaxis para esto es clave: \"valor\",. Fíjate bien en los dos puntos, las comillas, la coma al final para separar tu aporte de otros en otras líneas y donde están colocadas. 5. Una vez que has escrito lo que quieras escribir no olvides compilar. Hazlo tantas veces quieras explorando las diferencias de sonido y como los visuales despliegan información distinta.";


instructionsStatic = StaticText(window, Rect(5, -50, width -10, 320));
instructionsStatic.stringColor = Color.white;
instructionsStatic.string  = instructionsTextEng.asString;
instructionsStatic.align = \center;

		textView= TextView(window, Rect(5, 230, width -10, 100));
		textView.string = ejemplos;


window.background = Color(0.05,0.05,0.05);
window.front;
window.alwaysOnTop = true;
CmdPeriod.doOnce({window.close});

	}

	*instructions {
		var window;
var width= 500, height= 550;
var instructionsTextEng, instructionsStatic;




window = Window.new("Pasajes Armónicos", Rect(600,110, width, height), scroll: true);



instructionsTextEng= "This installation produces a melody that advances simultaneously at many speeds. This allows us to listen different melodic segments at the same time; a rather odd way of listening. The purpose of this installation is, among all of us, to produce a memory of this encounter. A memory that takes the form of a sonic time-line. However, in this space, time is non-lineal. Thus a time that is slow, multiple, simultaneous and constant traverses and de-articulates the time of this collective memory. This network-oriented time allows us to listen juxtapossed instants; instants that are related by affection rather than chronology. Despite all uncertainty, we have travelled through neighborhoods, oceans, days and years to meet. As Felix Gonzáles Torres would say: \"do not be afraid of the clocks [...] We are synchronized, now and forever.\"";


instructionsStatic = StaticText(window, Rect(5, 20, width -10, 320));
instructionsStatic.stringColor = Color.white;
instructionsStatic.string  = instructionsTextEng.asString;
instructionsStatic.align = \center;



window.background = Color(0.05,0.05,0.05);
window.front;
window.alwaysOnTop = true;
CmdPeriod.doOnce({window.close});

	}

	*playDefault {
		var net = NetAddr("127.0.0.1", 32000);
		~makeCanon.(~pasaje);
		net.sendMsg('/play');
	}
}
