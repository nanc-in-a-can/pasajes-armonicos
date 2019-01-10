
(
var r = {rrand(0.0, 1)};

//(~baseDir++"/nanc-in-a-can/init.scd").load;

var sender = NetAddr.new("127.0.0.1", 32000);
	Task({
		inf.do({
		    var x = r.();
		    var y = r.();
		    var z = r.();
			sender.sendMsg(\dirxyz, x, y, z);
			3.wait;
		})
	}).play;
thisProcess.openUDPPort(32000);
thisProcess.openPorts;
OSCFunc.trace(false);
o.free;o = OSCFunc({
	|msg|
	var x, y, z;
	x = msg[1];
	y = msg[2];
	z = msg[3];
	~controls.vdensity = y;
	~controls.hamp = x;
	~controls.tempoScale = z.linlin(0, 1, 0.1, 2);
	~controls.postln;
}, \dirxyz,   recvPort: 32000);
// o.free;
)

~controls.tempoScale = 1;
~controls.hamp = 0;
Scale.major.degreeToFreq([7, 8], 60, 1)