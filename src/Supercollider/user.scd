(
p = PasajesArmonicos.new;
p.pasaje = (
	// to produce sound you must tell us a bit about yourself,
	nationality: \mexico,

	age: 33, // any integer number /// cualquier número entero

	calleFavoritaEnCiudadDeMexico: "Xola",
	// you can add new keys, just add : after a word or set of words;
	libroFavorito: "La novela Luminosa de Mario Levrero",
	// es posible añadir claves. Solo añade dosPuntos: después de una palabra o arreglo de palabras como se muestra abajo;
	lachelamasCabronaSegunThom: "sol_(¡Guácala!)",


	// any key with the word rhythms in it will produce a rhythmic figure;
	alejandrosrhythms: [1/4, 1/5, 1/4],

	// any key with the word pitch will produce a pitch series;
	diegopitch: [60, 67, 72],

);

p.play;
)
