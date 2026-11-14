/// @desc scrSwitchlevel(nextLvl,destX,destY)
/// @arg nextLvl The level to switch to
/// @arg destX   Player X destination
/// @arg destY   Player Y destination

function scrSwitchlevel(_nextLvl,_destX,_destY) {
	
	// If the player enters a new level
	if (currLvl != _nextLvl) {
		
		// Close all doors on the current level
		scrDoorclose(lib.cat[CAT.DUNGEONS][currDung][currLvl]);
		
		// Change level
		currLvl = _nextLvl;
		
		// Update the amount of non-undefined slots for the new level
		nSlots[mY] = fncSlotcount(lib.cat[CAT.DUNGEONS][currDung][currLvl], true,undefined);
		nSlots[mX] = fncSlotcount(lib.cat[CAT.DUNGEONS][currDung][currLvl],false,undefined);
		
	}
	
	// Place the player on the new location
	locX = _destX;
	locY = _destY;
	
}