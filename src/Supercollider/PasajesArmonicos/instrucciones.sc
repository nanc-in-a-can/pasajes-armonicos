+PasajesArmonicos{
	*instrucciones{
		var window;
		var string1, string2, string3, string4, string5, string5_1, string5_2, string6, string7, string8, string9, string10, string11;


		string1= "1. Arriba a la derecha en esta pantalla hay un botón que produce una estructura por default." ;
		string2= "Si quieres activar la instalación sin interactuar con este código puedes apretar este botón y disfrutar.";
		string3= "Sin embargo, queremos que tu voz, tus ideas, tus palabras y todo lo que tu quieras sea parte de este espacio.";
		string4= "Si decides interactuar con el código que compartimos contigo debes de escribir en la pantalla negra de un modo especial.";
		string5= "2. Para que la computadora \"escuche\" lo que escribes recuerda que tienes que seguir ciertas reglas de programación y siempre compilar el código (con el comando ctrl + enter).";
		string5_1= "Esta instalación funciona como un muro comunitario en donde puedes dejar un rastro de tu paso por esta conferencia. Este comentario convergerá con muchos otros aquí alojados creando una memoria";
		string5_2= "Una memoria sonora y visual de nuestra sincronía";
		string6= "3. El área donde puedes contarnos sobre ti esta debajo de la línea 23 (donde dice: \"to produce sound you must tell us a bit about yourself,\").";
		string7= "En esta area puedes decidir que compartir al escribir una clave y su respectivo valor.";
		string8= "La sintaxis para esto es";
		string9= "clave: \"valor\",";
		string10= "Fíjate bien en los dos puntos, las comillas, la coma al final para separar tu aporte de las otras líneas";
		string11= "4. Una vez que has escrito lo que quieras escribir no olvides compilar con ctrl ] enter. Hazlo tantas veces quieras explorando las diferencias de sonido y como los visuales despliegan información distinta.";

		window= Window("Instrucciones", Rect(200, 200, 1000, 400), true, scroll: false);


		window.drawFunc = {


			Pen.stringAtPoint("Instrucciones", Point(30,0), Font(Font.availableFonts[12], 35),color: Color.white);

			Pen.stringAtPoint(string1, Point(123,50), Font(Font.availableFonts[12], 15),color: Color.white);
			Pen.stringAtPoint(string2, Point(140,70), Font(Font.availableFonts[12], 15),color: Color.white);
			Pen.stringAtPoint(string3, Point(230,90), Font(Font.availableFonts[12], 15),color: Color.white);
			Pen.stringAtPoint(string4, Point(100,140), Font(Font.availableFonts[12], 15),color: Color.white);
			Pen.stringAtPoint(string5, Point(50,180), Font(Font.availableFonts[12], 15),color: Color.white);
			Pen.stringAtPoint(string5_1, Point(10,210), Font(Font.availableFonts[12], 15),color: Color(0.7, 0.5, 0.5));
			Pen.stringAtPoint(string5_2, Point(700,230), Font(Font.availableFonts[12], 15),color: Color(0.7, 0.5, 0.5));
			Pen.stringAtPoint(string6, Point(10,250), Font(Font.availableFonts[12], 15),color: Color.white);
			Pen.stringAtPoint(string7, Point(40,275), Font(Font.availableFonts[12], 15),color: Color.white);
			Pen.stringAtPoint(string8, Point(50,295), Font(Font.availableFonts[12], 15),color: Color.white);
			Pen.stringAtPoint(string9, Point(180,295), Font(Font.availableFonts[70], 15),color: Color.white);
			Pen.stringAtPoint(string10, Point(300,295), Font(Font.availableFonts[12], 15),color: Color.white);
			Pen.stringAtPoint(string11, Point(30,350), Font(Font.availableFonts[12], 15),color: Color.white);
			Pen.perform(\fill);




		};



		window.background= Color(0.05,0.05,0.05);
		window.front;
		window.alwaysOnTop = true;


		CmdPeriod.doOnce({if(window.isClosed.not, {window.close;})});
	}

	*instructions{
		var window;
		var string1, string2, string3, string4, string5, string5_1, string5_2, string6, string7, string8, string9, string10, string11;


		string1= "1. On the top-right part of the screen there is a botton that produces a default structure.";
		string2= "If you would like to listen and see the installation in action without having to interact much with this code you can push it and enjoy";

		string3= "But we want your voice, ideas, words and anything that you like to be part of this work.";
		string4= "If you decide to interact with the code we are sharing you must write in the black screen behind this one in a particular way";
		string5= "3. For the computer to \"listen\" whatever you are writting you will have to follow certain programming rules and always compile your code (ctrl + enter).";
		string5_1= "This installation works like a community wall in which you can leave a trace of your participation in this conference. Your commentary will converge with many others here allocated to form a memory";
		string5_2= "A sonic and visual memory of our synchrony";
		string6= "4. The area in which you could play with the code is below line 23 (where it says: \"to produce sound you must tell us a bit about yourself,\").";
		string7= "In these area you could decide freely what to share with us by writting a key and a value respectively";
		string8= "The syntax you should use is";
		string9= "key: \"value\",";
		string10= "Pay attention in the colon, the comillas and the comma at the end to separate your writing from others in the subsequent lines";
		string11= "5. Once you written something do not forget to compile with ctrl + enter! Do it as many times you want to and explore the sound and visual differences deployed around you";

		window= Window("Instrucciones", Rect(200, 200, 1000, 400), true, scroll: false);


		window.drawFunc = {


			Pen.stringAtPoint("Instructions", Point(30,0), Font(Font.availableFonts[12], 35),color: Color.white);

			Pen.stringAtPoint(string1, Point(123,50), Font(Font.availableFonts[12], 15),color: Color.white);
			Pen.stringAtPoint(string2, Point(140,70), Font(Font.availableFonts[12], 15),color: Color.white);
			Pen.stringAtPoint(string3, Point(230,90), Font(Font.availableFonts[12], 15),color: Color.white);
			Pen.stringAtPoint(string4, Point(100,140), Font(Font.availableFonts[12], 15),color: Color.white);
			Pen.stringAtPoint(string5, Point(50,180), Font(Font.availableFonts[12], 15),color: Color.white);
			Pen.stringAtPoint(string5_1, Point(10,210), Font(Font.availableFonts[12], 15),color: Color(0.7, 0.5, 0.5));
			Pen.stringAtPoint(string5_2, Point(700,230), Font(Font.availableFonts[12], 15),color: Color(0.7, 0.5,0.5));
			Pen.stringAtPoint(string6, Point(10,250), Font(Font.availableFonts[12], 15),color: Color.white);
			Pen.stringAtPoint(string7, Point(40,275), Font(Font.availableFonts[12], 15),color: Color.white);
			Pen.stringAtPoint(string8, Point(50,295), Font(Font.availableFonts[12], 15),color: Color.white);
			Pen.stringAtPoint(string9, Point(193,295), Font(Font.availableFonts[10], 20),color: Color.white);
			Pen.stringAtPoint(string10, Point(280,300), Font(Font.availableFonts[12], 15),color: Color.white);
			Pen.stringAtPoint(string11, Point(30,350), Font(Font.availableFonts[12], 15),color: Color.white);
			Pen.perform(\fill);


		};

		window.background= Color(0.05,0.05,0.05);
		window.front;
		window.alwaysOnTop = true;


		CmdPeriod.doOnce({if(window.isClosed.not, {window.close;})});

	}

}


