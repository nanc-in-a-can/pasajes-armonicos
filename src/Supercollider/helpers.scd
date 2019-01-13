(
var isNumArr_ = _.inject(true, {|bool, val| bool&&val.isNumber});
var isNumArr = {|el|
	if(el.isArray && el.isString.not,
		{if(isNumArr_.(el), {el}, {false})},
		{false}
	)
};

~getScale = {|max, value|
	var scalesOrderByPitechesPerOctave = Scale.names
	.collect({|name, i| [name, Scale.at(name).pitchesPerOctave]})
	.sort({|a, b| a[1] < b[1]})
	.collect({ |pair| Scale.at(pair[0])})
	// .postm("scales")
	;

	var totalScales = scalesOrderByPitechesPerOctave.size
	// .postm("\ntotalScales")
	;

	var index = min(max - 1, value).linlin(0, max, 0, totalScales).round
	// .postm('index')
	;

	scalesOrderByPitechesPerOctave[index]
};


~makeMelody = {|minSize, pasaje|
	var makeNotes = {
		|pasaje|
		var notesSeq = pasaje.keys.inject(List [], {|acc, key|
			var numArr = isNumArr.(pasaje[key]);
			var shouldAdd = pasaje[key].isNumber || pasaje[key].isString || pasaje[key].isSymbolWS || numArr.isArray;
			if(shouldAdd, {
				if(pasaje[key].isArray,
					{acc ++ pasaje[key]},
					{acc.add(pasaje[key])}
				)

			}, {acc})
		})
		.collect({|val| if(val.isNumber, {val.min(127)}, {val.ascii})})
		.flatten
		;

		var notesSeq_ = (notesSeq + notesSeq.minItem.abs).round.collect(_.linlin(0, 127, 53, 75));

		minSize.collect(notesSeq_.wrapAt(_))
	};

	var notes = makeNotes.(pasaje, 43);

	var makeDurs = {
		|pasaje, notes|

		var dursSeqFromKeys = pasaje.keys.asArray
		.collect(_.ascii)
		// .flatten
		;

		var dursSeqFromUserRhythms = pasaje.keys
		.asArray
		.collect(_.asString)
		.select("rhythm".matchRegexp(_))
		.collect({|val|
			var rhythms = pasaje[val.asSymbol];
			if(isNumArr.(rhythms) != false, {rhythms}, {[]})
		});

		var dursSeqFromUserRhythms_ = dursSeqFromUserRhythms.collect({
			|dursArr|
			dursArr.collect(_.linlin(0, (dursSeqFromUserRhythms.flatten.maxItem), 48, 122))
		});

		var dursSeq = (
			dursSeqFromKeys ++
			dursSeqFromUserRhythms_
			// []
		).scramble.flatten;

		notes.size.collect(dursSeq.wrapAt(_)).collect(_.linlin(48 /*1*/, 122 /*z*/, 1/43, 3))

	};

	var durs = makeDurs.(pasaje, notes);
//	UnitTest().assert(durs.size == notes.size, onFailure: {"durs are not equal in length to notes".error});
	Can.melody(durs, notes);
};

// ~makeMelody.(50, ~pasaje).collect(_.note)
)

