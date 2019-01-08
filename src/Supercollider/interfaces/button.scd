
(
w = Window.new("The Four Noble Truths");

b = Button(w, Rect(20, 20, 40, 30))
        .states_([
            ["Play Default", Color.blue, Color.clear]
        ])
        .action_({
	try{
		~makePasaje.(~pasaje).postln;
	} {|error|
		"error".postln;
		error.postln

	}
	//             ~makePasaje.(~pasaje);//default
        });
w.front;
)
