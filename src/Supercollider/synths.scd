(
SynthDef(\pasajesPluck, {| freq=220, coef=0.9, amp=1, pan=0, out=0, dur=0 |
	var sig, env;

	sig= Pluck.ar(Saw.ar(freq*0.125), Impulse.ar(0), (freq*0.25).reciprocal, (freq*0.25).reciprocal, 1, coef, amp)*5;
	sig= Pan2.ar(Mix(sig), pan);

	env= EnvGen.kr(Env.perc(0.01, dur*1), doneAction:2);

	Out.ar(out, sig*env)
}).add
);

(
SynthDef(\pasajesWavtab, {
	| freq=60, ibuf= 0, offset=0.65, out=99, att=0.05, sust=1, rel=0.5, gate=1, amp=0.0001, rq=0.01, outSpace=48 |
	var sig, pitch, env;
	env = EnvGen.ar(Env([0,1,1,0],[att,sust,rel]),gate, doneAction:2);
	pitch = freq;
	sig = VOsc3.ar(ibuf+Line.kr(1,3,sust), pitch+[0,1],pitch+[0.37,1.1],pitch+[0.43, -0.29], 0.25);
	sig= sig + RLPF.ar(BPF.ar(Crackle.ar(0.1,1000), pitch*Line.kr(1,3.5,sust), rq).distort.distort, freq*8*Line.kr(0.75, 1, sust*8), 0.01);

	// out mixer
	Out.ar([out, 8, 10],sig*env*amp);
}).add;
);

(
// mezcladora // canal 99
SynthDef(\mixer_Pasajes, {|in=99, out=0, gate=1, pan= 0, amp=0.5|
	var sig, env;
	sig= Pan2.ar(Compander.ar(In.ar(in,2), WhiteNoise.ar(0.99), 0.75, mul:0.9), pan);
	env= EnvGen.kr(Env.adsr(0.0001,1,0.1),gate, doneAction:0);
	Out.ar(out, sig*env*amp)
}).add;
);


(
// CombC Y
SynthDef(\pasajes_combC1, {
	|in=8, out=50, gate=1, delayTime=0.1, decayTime=0.2, amp=1|
	var sig, env;

	sig= Mix(CombC.ar(In.ar(in,2),1, delayTime*TExpRand.kr(1,1.01, Dust.kr(13)), decayTime, amp));
//	sig= FreqShift.ar(sig, -50);
	env= EnvGen.kr(Env.adsr(0.0001,1,0.1),gate, doneAction:0);

	Out.ar(out, sig*env)
}).add;
);

(
// combC Z
SynthDef(\pasajes_combC2, {
	|in=8, out=50, gate=1, delayTime=0.1, decayTime=0.2, amp=1|
	var sig, env;

	sig= Mix(CombC.ar(In.ar(in,2),1, delayTime, decayTime, amp));
//	sig= FreqShift.ar(sig, -100);
	env= EnvGen.kr(Env.adsr(0.0001,1,0.1),gate, doneAction:0);

	Out.ar(out, sig*env)
}).add;
);

(
// espacializador X // inputs: señal directa por 48, combC por 50 y distort por 52;
SynthDef(\pasajes_PanAz, { |numChan=4, in1=48, in2=50, in3=52, out=0, amp=1, pos=0, gate=1|
	var sig1, sig2, sig3, env;

	// Señal Directa;
	sig1= PanAz.ar(2, In.ar(in1,1), (pos*1)%2pi)*1;
	// Señal CombC;
	sig2= PanAz.ar(2, In.ar(in2,1), (pos*3)%2pi)*1;
	// Señal Distort;
	sig3= PanAz.ar(2, In.ar(in3,1), (pos*4)%2pi)*1;

	env= EnvGen.kr(Env.adsr(0.0001,1,0.1),gate, doneAction:0);

	Out.ar(out, (sig1+sig2+sig3)*env*amp);

}).add

);


