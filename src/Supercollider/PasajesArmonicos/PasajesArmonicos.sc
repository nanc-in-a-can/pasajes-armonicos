PasajesArmonicos {
	var <>pasaje;

	*initialize {
		var s = Server.local;
<<<<<<< HEAD
		s.options.numBuffers = 1024 * 32;
		s.options.numOutputBusChannels = 4;
		s.options.device = "ASIO";
		Can.defaultServerConfig;
=======
>>>>>>> 2e6a93a2f7b88887fa8abd0b85424cdf99dfea9b
		s.boot;
		s.waitForBoot({
			var baseDir = thisProcess.nowExecutingPath.dirname;
			(baseDir++"/interfaces/button.scd").load;
		})
	}

	play {
		var net = NetAddr("192.168.2.27", 7778);
		var msg = JSON.stringify(this.pasaje);
		net.sendMsg(\pasaje, msg);
	}

	*playDefault {
		var net = NetAddr("192.168.2.27", 7778);
		var msg = JSON.stringify((//add your data to initialize the instalation
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
		));
		net.sendMsg(\pasaje, msg);
	}
}