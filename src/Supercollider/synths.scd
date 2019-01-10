(
SynthDef(\pasajesPluck, {| freq=220, coef=0.9, amp=1, pan=0, out=0, dur=0 |
	var sig, env;

	sig= Pluck.ar(Saw.ar(freq*0.125), Impulse.ar(0), (freq*0.25).reciprocal, (freq*0.25).reciprocal, 1, coef, amp)*5;
	sig= Pan2.ar(Mix(sig), pan);

	env= EnvGen.kr(Env.perc(0.01, dur*1), doneAction:2);

	Out.ar(out, sig*env*amp)
}).add
);

(
SynthDef(\pasajesWavtab, {
	| freq=60, ibuf= 0, offset=0.65, out=48, att=0.05, sust=1, rel=0.5, gate=1, amp=0.0001, rq=0.01, outSpace=48 |
	var sig, pitch, env;
	env = EnvGen.ar(Env([0,1,1,0],[att,sust,rel]),gate, doneAction:2);
	pitch = freq;
	sig = VOsc3.ar(ibuf+Line.kr(1,3,sust), pitch+[0,1],pitch+[0.37,1.1],pitch+[0.43, -0.29], 0.25);
	sig= sig/* + RLPF.ar(BPF.ar(Crackle.ar(TExpRand.kr(0.6, 1.2, Dust.kr(10)),1000), pitch*Line.kr(1,3.5,sust), rq).distort.distort, freq*8*Line.kr(0.995, 0.999, sust*8), 0.1)*0.05*/;

	// out mixer
	Out.ar([out, 8, 10],sig*env*amp);
}).add;
);

(
// mezcladora // canal 99
SynthDef(\mixer_Pasajes, {|in=99, out=0, gate=1, pan= 0, amp=5, cutFreq=6000|
	var sig, env;
	sig= (In.ar(in,4)*0.05) + LPF.ar(In.ar(in,4), cutFreq, 0.8);
	sig= Compander.ar(sig, WhiteNoise.ar(0.99), 0.9, mul:0.9);
	env= EnvGen.kr(Env.adsr(0.2,1,0.1),gate, doneAction:0);
	Out.ar(out, sig*env*amp)
}).add;
);


(
// CombC Y
SynthDef(\pasajes_combC1, {
	|in=8, out=50, gate=1, delayTime=0.1, decayTime=0.2, amp=1|
	var sig, env;

	sig= Mix(CombC.ar(In.ar(in,2),1, delayTime*TExpRand.kr(1,1.01, Dust.kr(0.3)), decayTime, amp));
//	sig= FreqShift.ar(sig, -50);
	env= EnvGen.kr(Env.adsr(0.2,1,0.1),gate, doneAction:0);

	Out.ar(out, sig*env)
}).add;
);

(
// combC Z
SynthDef(\pasajes_combC2, {
	|in=10, out=50, gate=1, delayTime=0.1, decayTime=0.2, amp=1|
	var sig, env;

	sig= Mix(CombC.ar(In.ar(in,2),1, delayTime, decayTime, amp));
//	sig= FreqShift.ar(sig, -100);
	env= EnvGen.kr(Env.adsr(0.2,1,0.1),gate, doneAction:0);

	Out.ar(out, sig*env)
}).add;
);

(
// espacializador X // inputs: señal directa por 48, combC por 50 y distort por 52;
SynthDef(\pasajes_PanAz, { |numChan=4, in1=50, in2=52, in3=48, out=99, amp=1, gate=1, cutFreq=9000, pos1=0, pos2=0, pos3=0|
	var sig1, sig2, sig3, env;

	// Señal CombC1;
	sig1= LPF.ar(In.ar(in1,1), cutFreq, 0.8)+ (In.ar(in1,1)*0.05);
	sig1= PanAz.ar(2, sig1,     ((pos1+pos2)*1)%2pi)*1;
	// Señal CombC2;
	sig2= LPF.ar(In.ar(in2,1), cutFreq, 0.9)+ (In.ar(in2,1)*0.05);
	sig2= PanAz.ar(2, sig2, ((pos2+pos3)*1.2+1)%2pi)*1;
	// Señal Limpia;
	sig3= LPF.ar(In.ar(in3,1), cutFreq, 0.9)+ (In.ar(in3,1)*0.05);
	sig3= PanAz.ar(2, sig3, ((pos1+pos3)*1.5+3)%2pi)*1;

	env= EnvGen.kr(Env.adsr(0.2,1,0.1),gate, doneAction:0);

	Out.ar(out, (sig1+sig2+sig3)*env*amp);

}).add

);


