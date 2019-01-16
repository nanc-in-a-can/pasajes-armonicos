(
var f1, f2;
~registerOsc = {|canon|
	//Processing should send a message to /play @ localhost:32000 to trigger playback
	thisProcess.openUDPPort(32000);
	f1.free;
	f1 = OSCFunc({
		canon.play
	}, \play,   recvPort: 32000);

	//recieve xyz data from Processing
	thisProcess.openUDPPort(32000);
	thisProcess.openPorts;
	OSCFunc.trace(false);
	f2.free;
	f2 = OSCFunc({
		|msg|
		var x, y, z;
		x = msg[1];
		y = msg[2];
		z = msg[3];
		~combC2.set(\delayTime, z.explin(0.000001,1, 0.01, 0.002));
		~combC1.set(\delayTime, y.explin(0.000001,1, 0.01, 0.001));
		~pan.set(\pos1, x.linlin(0,1, 0, 0.4), \pos2, y.linlin(0,1, 0, 0.3), \pos3, z.linlin(0,1, 0, 0.5));
		~controls.vdensity = y;
		~controls.hamp = x;
		~controls.tempoScale = z.lincurve(0, 1, 0.3, 4, 2.5);
		~controls.postln;
	}, \dirxyz,   recvPort: 32000)
};
)

