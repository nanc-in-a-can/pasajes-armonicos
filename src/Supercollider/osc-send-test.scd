
(
var r = {rrand(0.0, 1)};

//(~baseDir++"/nanc-in-a-can/init.scd").load;

var sender = NetAddr.new("127.0.0.1", 7777);
	Task({
		inf.do({
		    var x = r.();
		    var y = r.();
		    var z = r.();
			sender.sendMsg(\dirxyz, x, y, z);
			1.wait;
		})
	}).play;
thisProcess.openUDPPort(7777);
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
	~controls.tempoScale = z.linlin(0, 1, 0.1, 4);
	~controls.postln;
}, \dirxyz,   recvPort: 7777)
)


