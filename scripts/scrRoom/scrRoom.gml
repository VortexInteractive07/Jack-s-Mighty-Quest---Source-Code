/// @desc scrRoom()

function scrRoom() {
	
	if (roomVisited) {
		
		roomVisited  = false;
		inTransition = true;
		state[mCURR] = STATE.EXIT;
		
	} else {
		
		if (input.button1 or input.button2) roomVisited = true;
		
	}
	
}