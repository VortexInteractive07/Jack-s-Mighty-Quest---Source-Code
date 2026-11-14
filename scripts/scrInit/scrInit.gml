/// @desc scrInit()

function scrInit() {
	
	if (counter mod 4 == 0) {
		
		// Fade in and reset index
		palette[DUNGPAL.IMGIND] += palette[DUNGPAL.IMGIND] < sprite_get_number(palette[DUNGPAL.WALL])-1 ? 1 : -palette[DUNGPAL.IMGIND];
		
	}
	
	// If fully faded in and index 0
	if (palette[DUNGPAL.IMGIND] == 0) {
		
		// Exit transition
		inTransition = false;
		
		// Enter dungeon room state ...
		if (roomEntered) state[mCURR] = STATE.ROOM;
		
		// ... else, enter/return to the start/previous cardinal state
		else state[mCURR] = state[mPREV];
		
	}
	
}