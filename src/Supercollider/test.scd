PasajesArmonicos.initialize
PasajesArmonicos.instructions
PasajesArmonicos.playDefault

(
p = PasajesArmonicos.new;
p.register = (
	//add your data to initialize the instalation
	//any key containing the string rhythms (i.e. rhythms1, myrhythms) and having an array of numbers as a value will bie used to generate rhythmic values
	// midi posible 45-75
	nationality: \mexico,
	age: 33, // any number
	melodicThing: ([60, 63, 67]!10).flatten,
	rhythms: [1/4, 1/5, 1/4],
	rhythms2: (([1/4, 1/5, 1/4]*7/8)!3).flatten,
	rhythms3: "badInput",
	hugeNumber: 5,
	gender: \shouffsdfasdfasdfldntcare,
	wtf: "I'm \nbluasdfasdfae",
	verse: "cano n o asdf dfadfttt4 4 4 adga sg 454can on",
	gibberish: "asdlkj asldja daslda sj adajsdalksdj asj 34ljas dlkje54 sd0f9 we5n dsflkjsdf sdlfkj sdfs"
);


p.play;

NetAddr("127.0.0.1", 32000).sendMsg('/play');
)

~controls.tempoScale = 1

