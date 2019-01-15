( //to play
var net = NetAddr("127.0.0.1", 32000);
// ~makeCanon.();
NetAddr("127.0.0.1", 32000).sendMsg('/play');
)



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
			4.wait;
		})
	}).play;
thisProcess.openUDPPort(32000);
thisProcess.openPorts;
/*OSCFunc.trace(false);
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
}, \dirxyz,   recvPort: 32000);*/
// o.free;
)

~controls.tempoScale = 10;
~controls.hamp = 0;
~controls.vdensity = 1;

~canon.canon.size
~canon.canon.collect(_.durs).collect(_.sum)