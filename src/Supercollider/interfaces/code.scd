
PasajesArmonicos.instructions
//borrar el mundo que existe y definir lo que sea que quieres definir

PasajesArmonicos.playDefault


// Crear clase PasajesArmónicos
// instrucciones
// play default
// boton
// llenar de instrucciones que inviten
// validar inputs
// generar valores
// se manda a otra compu


(
~nationalities = ( // value must be your own assesment of privilege from 0 - 9;
	\mexico: 5,
	\colombia: 10,
	\none: 10
);

~nationalities[\mexico] = (~nationalities.values.sum/~nationalities.values.size);

~genders = ( // value must be your own assesment of privilege from 0 - 9;
	\male: 9
);

~socialRole = (

);

~positionInClassStruggle = ( // value must be your own assesment of privilege from 0 - 9;
	// \poor:
);

~race = (

);

~pasaje = (//add your data to initialize the instalation
	nationality: \mexico,
	age: 33, // any number
	gender: \male,
	wtf: "I'm blue"
	// socialClass:
);


//do not change below this line
try{
	~makePasaje.(~pasaje);
} {|err| err.postln}

)


