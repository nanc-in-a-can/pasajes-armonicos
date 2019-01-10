(

~makePasaje = {
	|config|

	var notes = (
		\mexico:  Can.melody(
			durs: [1],
			notes: [60]
		)
	);

	var nationalityAvg = ~nationalities.values.collect(_.min(100).max(-100));

	var viscosityIndex = "someNumber";

	var nationalityInAvg, genderInAvg; //posiciones dentro del promedio ...
	// selects a region from all the wavetables +- 30

	var extraKeys; // ~pasaje.keys.postln.difference(Set[\nationality, \age, \gender])
	var net = NetAddr("localhost", 7777);
	~validateInputs.(config);
	net.sendMsg(\pasajes, viscosityIndex /*...*/);
	nil;
};



try{
	~makePasaje.(~pasaje);
} {|err| err.postln}


)


(
~getWaves = {
	|waves, viscosityIndex|
	(viscosityIndex - 30 .. viscosityIndex + 30).collect(waves.wrapAt(_))
};
~getWaves.((0..100), 30)
)


(
~validateInputs = {|config|
	if(// nationality is registered
		~nationalities.keys.includes(config.nationality).not,
		{
			("Please add your nationality \\"++config.nationality.asString+"to the ~nationalities list").throw
		}
	);

	if(// nationality is not inf or -inf
		~nationalities.values.includes(inf) || ~nationalities.values.includes(-inf) ,
		{
			"Infinity does not exist! Stop playing guapx on ~nationalities.".throw

		}
	);

	~cleanInputs.(config)
};
)

// OSCFunc( _.postln, \pasajes, recvPort: 7777);