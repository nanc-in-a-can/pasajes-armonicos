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
	| freq=60, ibuf= 0, offset=0.65, out=0, att=0.05, sust=1, rel=0.5, gate=1, amp=0.0001, rq=0.01 |
	var sig, pitch, env;
	env = EnvGen.ar(Env([0,1,1,0],[att,sust,rel]),gate, doneAction:2);
	pitch = freq;
	sig = VOsc3.ar(ibuf+Line.kr(1,3,sust), pitch+[0,1],pitch+[0.37,1.1],pitch+[0.43, -0.29], 0.25);
	sig= sig + RLPF.ar(BPF.ar(Crackle.ar(0.1,1000), pitch*Line.kr(1,3.5,sust), rq).distort.distort, freq*8*Line.kr(0.75, 1, sust*8), 0.01);

	Out.ar(
		out,
		Limiter.ar(sig*env*amp, 2) //TODO es provisional, quitar
	);
}).add;
)