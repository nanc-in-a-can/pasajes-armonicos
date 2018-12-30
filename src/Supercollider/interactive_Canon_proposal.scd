(
s.options.numBuffers = 1024 * 16;
Can.defaultServerConfig;
s.boot;
s.waitForBoot({
	var baseDir = thisProcess.nowExecutingPath.dirname;
	(baseDir++"/wavetable_Soundfiles.scd").load;
	(baseDir++"/synths.scd").load;
	(baseDir++"/player_withSynths.scd").load;
})
);
//~controls = (tempoScale: 1, hamp: 1, vdensity: 1);
//~controls.tempoScale = 1.0;
//~controls.hamp = 0.1;
//~controls.vdensity = 0.5;

( // canon // still not sure how to work with this //
var densityOfVoices = [5, 10, 20, 30].choose;
var sizeOfMelody = [30,50,80].choose;

~a = Can.converge(\myLiveCan,
	player: {|sym, canon|
		~makeTaskPlayer.(sym, ~controls, canon).play},
	melody: Can.melody(
		Array.fill(sizeOfMelody, { [8,16,4,6,12].reciprocal.choose }),
		Array.fill(sizeOfMelody, { [60,67,68,72,75,55,56,53].choose })),
	cp: (sizeOfMelody/2).round,
	voices: Can.convoices(
		Array.fill(densityOfVoices, { rrand(75, 95)/20 }),
		Array.fill(densityOfVoices, { rrand(-24, 12) }),
		Array.fill(densityOfVoices, { rrand(0.1, 1.0) }) ),
	repeat: inf)
);

//~a.play


(
m = NetAddr("127.0.0.1", 57120);

(
g = Window.new.front;
d = Button(g,Rect(300,250,50,20));
b = ControlSpec(0.0, 1.0, \linear, 0.001); // min, max, mapping, step
c = StaticText(g, Rect(200, 20, 150, 150)).align_(\center).background_(Color.white);
a = Slider(g, Rect(20, 50, 150, 20))
    .focusColor_(Color.blue(alpha:0.2))
    .background_(Color.black)
    .value_(0.5)
    .action_({
        c.string_(b.map(a.value).asString);
	m.sendMsg("/sliderz", b.map(a.value));

        // round the float so it will fit in the NumberBox
        });
a.action.value;

t = Slider2D(g, Rect(10, 100, 180, 180))
        .x_(0.5) // initial location of x
        .y_(1)   // initial location of y
        .action_({|sl|
	c.string_([\sliderX, sl.x, \sliderY, sl.y].asString);
	m.sendMsg("/sliderxy", sl.x, sl.y);
        });

d.states = [["Sound", Color.grey, Color.white], ["Silence", Color.white, Color.grey]];


d.action = { |view, i|
	if(view.value == 1) { ~a.play  } { "meh".postln};

};

g.front;
    CmdPeriod.doOnce({g.close});
);

(
r = OSCdef(\z, {|msg, time, addr, recvPort| [msg[0],msg[1]].postln;


	~controls.tempoScale = msg[1].linlin(0,1,0.1,2.0);

}, '/sliderz', m, 57120);
);

(
p = OSCdef(\xy, {|msg, time, addr, recvPort| [msg[0],msg[1],msg[2]].postln;

	~controls.hamp = msg[1];
	~controls.vdensity = msg[2];

}, '/sliderxy', m, 57120);
);

)








