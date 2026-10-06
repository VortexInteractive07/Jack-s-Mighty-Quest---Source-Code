/// @function scr_title_ost_playlist()
/// @description Returns an array of track structs containing sound resource and display title.
function scr_title_ost_playlist() {
    return [
	    { sound: mus_title_theme,		         title: "Title Theme (Chiptune)",			  composer: "Xiancat, Pixel" },
        { sound: mus_raalhehge_monaigaa,         title: "Raalhehge Monaigaa",                 composer: "Pixel" },
        { sound: mus_gibberish,                  title: "Inaudible Lyrics?",                  composer: "Pixel" },
        { sound: mus_the_last_march,             title: "The Last March to Aetheria - Inst.", composer: "Pixel" },
        { sound: mus_no_bridge_to_cross,         title: "No Bridge to Cross",	    		  composer: "Pixel" }
	];
}