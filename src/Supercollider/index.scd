(
s.options.numBuffers = 1024 * 32;
Can.defaultServerConfig;
s.boot;
s.waitForBoot({
	~baseDir = thisProcess.nowExecutingPath.dirname;
	(~baseDir++"/wavetable_Soundfiles.scd").load;
	(~baseDir++"/synths.scd").load;
	(~baseDir++"/player_withSynths.scd").load;
	(~baseDir++"/helpers.scd").load;
	(~baseDir++"/interfaces/code-test.scd").load;

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
	melody: ~makeMelody.(sizeOfMelody, ~pasaje),
	cp: (sizeOfMelody/2).round,
	voices: Can.convoices(
		Array.fill(densityOfVoices, { rrand(75, 95)/2 }),
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
	~mixer= Synth(\mixer_Pasajes);
	~pan= Synth(\pasajes_PanAz);
	~combC1= Synth(\pasajes_combC1, [\amp, 1.5]); // aqui se le puede mover a la amp antes de inicializar la chingadera si es necesario;
	~combC2= Synth(\pasajes_combC2, [\amp, 1.5]);
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
	~combC2.set(\delayTime, z.explin(0.000001,1, 0.01, 0.002));
	~combC1.set(\delayTime, y.explin(0.000001,1, 0.01, 0.001));
	~pan.set(\pos1, x.linlin(0,1, 0, 4), \pos2, y.linlin(0,1, 0, 3), \pos3, z.linlin(0,1, 0, 3.5));
	~controls.vdensity = y;
	~controls.hamp = x;
	~controls.tempoScale = z.linlin(0, 1, 0.1, 2);
	~controls.postln;
}, \dirxyz,   recvPort: 32000)
)

//~netAddr= NetAddr("127.0.0.1", 32000);

//~netAddr.sendMsg('/play')

//s.meter

// s.plotTree;