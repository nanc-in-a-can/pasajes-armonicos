s.boot
~controls = (tempoScale: 1, hamp: 1, vdensity: 1);
~controls.tempoScale = 1
~controls.hamp = 0.2
~controls.vdensity = 1
~tempoScale = 4;
~makeTaskPlayer.(\def, ~controls, ThePresetCan.pyramidCanon.canon).play
(
~makeTaskPlayer = {|def, controls, canon|
	var makeVoicesState = {|canon|
		(0..canon.size - 1).inject((), {|acc, i|
			acc[i] = (
				voiceIndex: (i - (canon.size -1)).abs,
				data: canon[i],
				nextIndex: 0,
				nextSoundAt: canon[i].onset*1000, // in ms
			)
		});
	};

	var shouldPlayVoice = {|voicesState| // this generates the inner state of shouldPlayVoice
		var totalVoices = voicesState.keys.size;
		var unit = 1/totalVoices; // uses the number of voices to determine a unit of percentage for each index. i.e. For four voices our unit is 0.25
		{|percentage, voiceIndex| // percentage of voices to play: 1 plays all 0 plays none
			// if voicesState has four voices (indexes 0 - 3), then a percentage >= to 0.25 allows voice `0` to be played, >= 0.5 allows voices `0` and `1`, etc...
			// we multiply voiceIndex*unit to know if a given index should be played
			// thus for a fourVoice voicesState, the minimum percentage to allow all voices to be played would be 0.75 or unit*3 (our last index)
			((unit*voiceIndex) <= percentage);

		}
	};

	var harmonicAmplitude = {|maxSounds, percentage, currentNoteIndex|
		var numSounds = (maxSounds*percentage).floor.max(1).asInteger;
		var mapper = (0..numSounds - 1);
		var offset = mapper.choose;
		var startingIndex = (currentNoteIndex - offset).max(0);
		var total = mapper+startingIndex;
		var first = total[0];
		var last  = total[total.size - 1];
		[first, last];
	};

	var player = Tdef(def, {
		var elapsed = 0;
		var voicesState = makeVoicesState.(canon);
		var shouldPlayVoice_ = shouldPlayVoice.(voicesState); // we avoid recalculating the value of `unit` every time
		var numVoices = canon.size;
		var finishedCanons = 0;
		var globalNextSoundAt = 0;
		inf.do({|i|
			var iterateVoices = globalNextSoundAt <= elapsed;

			if(iterateVoices, { // basic optimization to avoid iteration of voicesState every 1ms
				var nextSoundsAt = List [];

				voicesState.do({|voice|
					nextSoundsAt.add(voice.nextSoundAt); // build a list of the nextSoundAt to get the next value for globalNextSoundAt

					if(voice.nextSoundAt <= elapsed, { // check if `voice` shouldPlay it's next sound
						var currentIndex = voice.nextIndex;
						var dur = voice.data.durs[currentIndex] ? inf;
						var hamp = harmonicAmplitude.(6, controls.hamp, currentIndex);
						var notes = voice.data.notes[hamp[0]..hamp[1]];

						// update voice state
						voice.nextIndex = voice.nextIndex + 1;
						voice.nextSoundAt = elapsed + (dur * 1000);

						// // play sound or update finishedCanons
						// if(dur != inf,
						// 	{(freq: note.midicps, dur: dur/~tempoScale).play;},
						// 	{finishedCanons = finishedCanons + 1}
					// );

						if(dur == inf,
							{finishedCanons = finishedCanons + 1},
							if(shouldPlayVoice_.(controls.vdensity, voice.voiceIndex), {(freq: notes.midicps, dur: if(dur != inf, {dur/controls.tempoScale}, {0})).play;})

						);
					});
				});

				//update globalNextSoundAt
				globalNextSoundAt = nextSoundsAt.minItem;
			});

			if(finishedCanons == numVoices, {player.stop});

			elapsed = elapsed+(1*controls.tempoScale); // update elapsed time, ~tempoScale changes the value by which `elapsed` is updated, by this, the "interal time of the canon" go faster or slower.  If ~tempoScale is > 1 it goes faster than it's original tempo, if < 1 it goes slower.

			0.001.wait; // iterate every 1ms
		})
	});
	player;
};
)
