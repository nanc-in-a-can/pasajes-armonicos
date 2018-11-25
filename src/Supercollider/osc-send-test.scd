(
var baseDir = thisProcess.nowExecutingPath.dirname;
var canon = File(baseDir++"/test.json", "r").readAllString.parseYAML;

(baseDir++"/nanc-in-a-can/init.scd").load;

var sender = NetAddr.new("127.0.0.1", 7777);

canon.size.do({|voiceIndex|
	var voice = canon[voiceIndex];
	Task({
		voice.at("onset").asFloat.wait;
		voice.at("durs").do({|dur, durIndex|
			sender.sendMsg(\voice_event, voiceIndex, durIndex);
			dur.asFloat.wait;
		})
	}).play
})
)

//para probar la recepción
// thisProcess.openUDPPort(7777);
// thisProcess.openPorts
// o.free;o = OSCFunc({|msg| msg.postln}, \foo,   recvPort: 7777)
// OSCFunc.trace(true);
