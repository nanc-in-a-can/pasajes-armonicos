(
s.options.numBuffers = 1024 * 32;
Can.defaultServerConfig;
s.boot;
s.waitForBoot({
	~baseDir = thisProcess.nowExecutingPath.dirname;
	(~baseDir++"/wavetable_Soundfiles.scd").load;
	(~baseDir++"/synths.scd").load;
	(~baseDir++"/player_withSynths.scd").load;

	//init controls
	~controls = (tempoScale: 1, hamp: 0, vdensity: 1);
})
);


( // canon // still not sure how to work with this //
var densityOfVoices = [5, 10, 20, 30].choose;
var sizeOfMelody = [30,50,80].choose;

var canon = Can.converge(\myLiveCan,
	player: {|sym, canon|
		~makeTaskPlayer.(sym, ~controls, canon)},
	melody: Can.melody(
		Array.fill(sizeOfMelody, { [8,16,4,6,12].reciprocal.choose }),
		Array.fill(sizeOfMelody, { [60,67,68,72,75,55,56,53].choose })),
	cp: (sizeOfMelody/2).round,
	voices: Can.convoices(
		Array.fill(densityOfVoices, { rrand(75, 95)/20 }),
		Array.fill(densityOfVoices, { rrand(-24, 12) }),
		Array.fill(densityOfVoices, { rrand(0.1, 1.0) }) ),
	repeat: inf);

var net = NetAddr.new("127.0.0.1", 32001);   // send canon json to localhost:32001
var jsonpath = (~baseDir++"/../JSONs/canon.json");
f= File(jsonpath, "w");
f.write(JSON.stringify(canon.canon));
f.close;
net.sendMsg("/json", jsonpath);
~canon = canon;
);



(//Processing should send a message to /play @ localhost:32000 to trigger playback
thisProcess.openUDPPort(32000);
o = OSCFunc({
	~canon.play
}, \play,   recvPort: 32000);
)


(//recieve xyz data from Processing
thisProcess.openUDPPort(32000);
thisProcess.openPorts;
OSCFunc.trace(false);
p = OSCFunc({
	|msg|
	var x, y, z;
	x = msg[1];
	y = msg[2];
	z = msg[3];
	~controls.vdensity = y;
	~controls.hamp = x;
	~controls.tempoScale = z.linlin(0, 1, 0.1, 2);
	~controls.postln;
}, \dirxyz,   recvPort: 32000)
)


(//test to play canon
b = NetAddr.new("127.0.0.1", 32000);    // create the NetAddr
b.sendMsg("/play");
)