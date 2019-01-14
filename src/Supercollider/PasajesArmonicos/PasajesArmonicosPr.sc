PasajesArmonicosPr {
	var <>pasaje;

	// register_ {|val|
	// 	^pasaje = val;
	// }
	//
	// getPasaje {
	// 	^pasaje;
	// }

	*defaultPasaje{
		^(//add your data to initialize the instalation
			//any key containing the string rhythms (i.e. rhythms1, myrhythms) and having an array of numbers as a value will bie used to generate rhythmic values
			nationality: \mexico,
			age: 33, // any number
			melodicThing: ([60, 63, 67]!10).flatten,
			rhythms: [1/4, 1/5, 1/4],
			rhythms2: (([1/4, 1/5, 1/4]*7/8)!3).flatten,
			rhythms3: "badInput",
			hugeNumber: 5,
			gender: \shouffsdfasdfasdfldntcare,
			wtf: "I'm \nbluasdfasdfae",
			verse: "cano n o asdf dfadfttt4 4 4 adga sg 454can on",
			gibberish: "asdlkj asldja daslda sj adajsdalksdj asj 34ljas dlkje54 sd0f9 we5n dsflkjsdf sdlfkj sdfs"
		);
	}

	// play {
	// 	// a /play message is required at port 32000 to initialize playback
	// 	~makeCanon.(this.getPasaje);
	// }

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
				var densityOfVoices = [35].choose;
				var sizeOfMelody = [30,50,80].choose;
				var melody = ~makeMelody.(sizeOfMelody, pasaje);
				var canon = Can.converge(\myLiveCan,
					player: {|sym, canon|
						~makeTaskPlayer.(sym, ~controls, canon)},
					melody: melody,
					cp: (sizeOfMelody*0.618).round,
					voices: Can.convoices(
						Array.series(40, 30, 1.2).scramble[0..densityOfVoices],
						// Array.fill(densityOfVoices, { rrand(75, 95)/2 }),
						Array.fill(densityOfVoices, { rrand(-24, 12) }),
						Array.fill(densityOfVoices, { rrand(0.1, 1.0) }) ),
					repeat: inf);

				var net = NetAddr.new("127.0.0.1", 32001);   // send canon json to localhost:32001
				var id = Date.localtime.asSortableString;
				var canonpath =(~baseDir++"/"++id++"-canon.json").replace("Supercollider", "JSONs");
				var configpath = (~baseDir++"/"++id++"-config.json").replace("Supercollider", "JSONs");
				var f = File(canonpath, "w");
				var f1 = File(configpath, "w");

				f.write(JSON.stringify(canon.canon));
				f.close;
				f1.write(JSON.stringify(pasaje));
				f1.close;
				~mixer.free;~pan.free;~combC1.free;~combC2.free;
				~mixer= Synth(\mixer_Pasajes);
				~pan= Synth(\pasajes_PanAz);
				~combC1= Synth(\pasajes_combC1, [\amp, 0.1]); // aqui se le puede mover a la amp antes de inicializar la chingadera si es necesario;
				~combC2= Synth(\pasajes_combC2, [\amp, 0.1]);
				~canon = canon;

				~registerOsc.(canon);
				net.sendMsg("/json", canonpath, configpath);
			};

			OSCFunc({|msg|
				// msg.postln;
				var pasaje = try(
					{JSON.parse(msg[1].asString)},
					{PasajesArmonicosPr.defaultPasaje}
				);
				~makeCanon.(pasaje);
			}, \pasaje, recvPort: 7778);
			"Pasajes Armónicos has been initialized!".postln;
		})
	}


	*playDefault {
		// var net = NetAddr("127.0.0.1", 32000);
		~makeCanon.(~pasaje);
		// net.sendMsg('/play');
	}
}

