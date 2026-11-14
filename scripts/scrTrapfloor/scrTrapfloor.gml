/// @desc scrTrapfloor(slotCurrent)
/// @arg slotCurrent

function scrTrapfloor(_slotCurrent) {
	
	switch (phase) {
		
		case PHASE.ONE:
			
			audio_play_sound(sfxTrapFloor,1,false);
			
			phase = PHASE.TWO;
			
		case PHASE.TWO:
			
			// Move the dungeon view along -Y
			dvY -= dvY > -dvH ? fallRate : 0;
			
			// Accelerate the movement
			fallRate += fallRate < fallMax ? fallAccl : 0;
			
			// If the dungeon view is no longer in view
			if (dvY < -dvH) {
				
				// Set the dungeon view to be just below the view
				dvY = dvH;
				
				// Switch level
				scrSwitchlevel(currLvl+1,locX,locY);
				
				viewUpdate = true;
				
				// Update the dungeon view
				scrMain(state[mPREV]);
				
				phase = PHASE.THREE;
				
			}
			
		break;
		case PHASE.THREE:
			
			// Move the dungeon view along -Y
			dvY -= dvY >= 0 ? fallRate : 0;
			
			fallRate += fallRate < fallMax ? fallAccl : 0;
			
			// If the dungeon view is fully in view, yet a bit past the view top
			if (dvY < 0) {
				
				dvY = round(dvY);
				
				counter = -1;
				
				// If we land on a trap, fall down another level
				phase = _slotCurrent[CONTSLOT.BASESTRUCT] == SLOT.CORRIDORTRAP ? PHASE.ONE : PHASE.FOUR;
				
			}
			
		break;
		case PHASE.FOUR:
			
			// Shake the view
			if (counter mod 3 == 0) {
				
				dvY *= -1;
				
				dvY += dvY > 0 ? -1 : 1;
				
			}
			
			if (dvY == 0) phase = PHASE.FIVE;
			
		break;
		case PHASE.FIVE:
			
			// Reset variables
			fallRate = 7;
			phase    = PHASE.ONE;
			
			// Pop the stack
			fncPopaction(id);
			
		break;
		
	}
	
}