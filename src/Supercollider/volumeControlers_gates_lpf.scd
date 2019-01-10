
// tree of Synths:  mixer is the final output; clean signal, combC1 and combC2 are the inputs of panning and panning is the input of mixer, mixer gets everything out;

// gate turns on and off synths without taking them out from the server;

~mixer.set(\gate, 1);

~combC1.set(\gate, 1);

~combC2.set(\gate, 1);

~pan.set(\gate, 1);

// control amplitude (these are the recomended levels)

~mixer.set(\amp, 10);

~combC1.set(\amp, 5);

~combC2.set(\amp, 5);

~pan.set(\amp, 5);

// controls the LPF of the panAz and the mixer;

~mixer.set(\cutFreq, 8000)

~pan.set(\cutFreq, 9000)


// see the synth tree
s.plotTree

// see the signal in dbs
s.meter
