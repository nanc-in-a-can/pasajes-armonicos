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
				var id = Date.localtime.asSortableString;
				var canonpath =(~baseDir++"/"++id++"-canon.json").replace("Supercollider", "JSONs");
				var configpath = (~baseDir++"/../JSONs/"++id++"-config.json").replace("Supercollider", "JSONs");
				var f = File(canonpath, "w");
				var f1 = File(configpath, "w");

				f.write(JSON.stringify(canon.canon));
				f.close;
				f1.write(JSON.stringify(pasaje));
				f1.close;

				~mixer= Synth(\mixer_Pasajes);
				~pan= Synth(\pasajes_PanAz);
				~combC1= Synth(\pasajes_combC1, [\amp, 0.1]); // aqui se le puede mover a la amp antes de inicializar la chingadera si es necesario;
				~combC2= Synth(\pasajes_combC2, [\amp, 0.1]);
				~canon = canon;

				~registerOsc.(canon);

				net.sendMsg("/json", canonpath, configpath);
			};
			"Pasajes Armónicos has been initialized!".postln;
		})
	}

	*instructions {
		[
			"\n",
			"Instructions:",
			"Posting",
			"Some instructions",
			"one line at a time"
		].do(_.postln)
		^ "--------------------------->-->-->-->-->-->-->-->-->-->"
	}

	*playDefault {
		var net = NetAddr("127.0.0.1", 32000);
		~makeCanon.(~pasaje);
		net.sendMsg('/play');
	}
}
