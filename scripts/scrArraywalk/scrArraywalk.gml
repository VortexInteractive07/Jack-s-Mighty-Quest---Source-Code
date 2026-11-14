/// @desc scrArraywalk(state,stepX,stepY)
/// @arg state The current/previous state
/// @arg stepX The player's step along the X-axis (1,0,-1)
/// @arg stepY The player's step along the Y-axis (1,0,-1)

function scrArraywalk(_state,_stepX,_stepY) {
	
	var _inputD = inputD;
	var _locX   = locX;
	var _locY   = locY;
	
	var _nextSlot = lib.cat[CAT.DUNGEONS][currDung][currLvl][_locY+_stepY][_locX+_stepX];
	
	var _corr      = _nextSlot[CONTSLOT.BASESTRUCT] == SLOT.CORRIDOR;
	var _corrTrap  = _nextSlot[CONTSLOT.BASESTRUCT] == SLOT.CORRIDORTRAP;
	var _wallFake  = _nextSlot[CONTSLOT.BASESTRUCT] == SLOT.WALLFAKE;
	var _noObjects = _nextSlot[CONTSLOT.OBJECT    ] == undefined;
	
	// If we can move forward or backward to the next slot
	if ((_corr or _corrTrap or (_wallFake and _inputD == 0)) and _noObjects) {
		
		#region MOVE PLAYER
		
		// Set the fragments to use for the walk animation
		if (_inputD == 0) scrSetsprites(_state,0,_locX+_stepX,_locY+_stepY,FRAGCAT.WALK);
		
		// Move the player to the new location
		locX = _locX+_stepX;
		locY = _locY+_stepY;
		
		// Set image index start position
		imgInd = _inputD == 1 ? lib.cat[CAT.FRAGIMAGES][FRAGIMAGES.WALK]-1 : -1;
		
		// Set movement counter (animation duration)
		moveCounter = modValue*lib.cat[CAT.FRAGIMAGES][FRAGIMAGES.WALK];
		
		#endregion
		
	} else {
		
		// If we're not walking backwards
		if (_inputD == 0) {
			
			#region TRANSITION
			
			switch (_nextSlot[CONTSLOT.PASSAGE]) {
				
				// Trigger stairs transition
				case SLOT.STAIRSUP:
				case SLOT.STAIRSDOWN:
					
					audio_play_sound(sfxStairs,1,false);
					
					locXnew      = _locX+(_stepX*2);
					locYnew      = _locY+(_stepY*2);
					viewUpdate   = true;
					inTransition = true;
					counter      = 0;
					state[mPREV] = _state;
					state[mCURR] = STATE.EXIT;
					
				break;
				
				// Trigger passage transition
				case SLOT.GATEOPEN:
				case SLOT.DOOROPEN:
				case SLOT.DOORLOCKEDOPEN:
				case SLOT.DOORMAGICOPEN:
					
					var _otherSide = lib.cat[CAT.DUNGEONS][currDung][currLvl][_locY+(_stepY*2)][_locX+(_stepX*2)][CONTSLOT.BASESTRUCT];
					
					locXnew      = _otherSide == SLOT.WALL ? _locX : _locX+(_stepX*2);
					locYnew      = _otherSide == SLOT.WALL ? _locY : _locY+(_stepY*2);
					viewUpdate   = true;
					inTransition = true;
					counter      = 0;
					state[mPREV] = _state;
					state[mCURR] = STATE.EXIT;
					
				break;
				
			}
			
			#endregion
			
		} else {
			
			inputD = 0;
			
		}
		
		// If no triggers occured, do nothing
		
	}
	
}