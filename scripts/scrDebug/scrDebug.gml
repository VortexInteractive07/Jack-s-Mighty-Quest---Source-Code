/// scrDebug()

function scrDebug() {
	
	if (input.start) global.debug += global.debug < 2 ? 1 : -global.debug;
	
	if (input.button4) palette[DUNGPAL.INDEX] += palette[DUNGPAL.INDEX] < DUNGCOLOUR.length-1 ? 1 : -(DUNGCOLOUR.length-2);
	
	if (moveCounter == 0) {
		
		if (input.button3) modValue = clamp(modValue < 10 ? modValue-1+(input.selectHeld*2) : modValue-2+(input.selectHeld*4),1,60);
		
	}
	
}