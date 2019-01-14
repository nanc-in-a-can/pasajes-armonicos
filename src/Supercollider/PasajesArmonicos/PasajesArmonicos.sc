PasajesArmonicos {
	var <>pasaje;

	*initialize {
		var s = Server.local;
		s.boot;
		s.waitForBoot({
			var baseDir = thisProcess.nowExecutingPath.dirname;
			(baseDir++"/interfaces/button.scd").load;
		})
	}

	play {
		var net = NetAddr("localhost", 7778);
		var msg = JSON.stringify(this.pasaje);
		net.sendMsg(\pasaje, msg);
	}
}