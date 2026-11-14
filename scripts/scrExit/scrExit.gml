/// @desc scrExit()

function scrExit() {
	
	if (counter mod 4 == 0) {
		
		// Fade out
		palette[DUNGPAL.IMGIND] += palette[DUNGPAL.IMGIND] < sprite_get_number(palette[DUNGPAL.WALL])/2 ? 1 : 0;
		
	}
	
	// If fully faded out
	if (palette[DUNGPAL.IMGIND] >= sprite_get_number(palette[DUNGPAL.WALL])/2) {
		
		var _slotFacing   = lib.cat[CAT.DUNGEONS][currDung][currLvl][locY+facingY    ][locX+facingX    ];
		var _slotFacingx2 = lib.cat[CAT.DUNGEONS][currDung][currLvl][locY+(2*facingY)][locX+(2*facingX)];
		var _playerLoc    = string(currDung)+"|"+string(currLvl)+"|"+string(state[mPREV])+"|"+string(locX)+"|"+string(locY);
		
		// Update level & player location
		switch (_slotFacing[CONTSLOT.PASSAGE]) {
			
			case SLOT.STAIRSUP:
			case SLOT.STAIRSDOWN:
				
				switch (_playerLoc) {
					
					// Palma
					case "0|6|3|14|13": break; // Lala Cave (Exit)
					case "1|6|3|12|11": break; // Medusa Cave (Exit)
					
					// Motavia
					case "3|6|2|9|6":   break; // Naharu Cave (Exit)
					
					// Stairs up/down to new level
					default: scrSwitchlevel(_slotFacing[CONTSLOT.PASSAGE] == SLOT.STAIRSUP ? currLvl-1 : currLvl+1,locXnew,locYnew);
					
				}
				
			break;
			case SLOT.GATEOPEN:
			case SLOT.DOOROPEN:
			case SLOT.DOORLOCKEDOPEN:
			case SLOT.DOORMAGICOPEN:
				
				// Is the other side of the passage blocked or not?
				switch (_slotFacingx2[CONTSLOT.BASESTRUCT]) {
					
					// If it's blocked:
					case SLOT.WALL:
						
						switch (_playerLoc) {
							
							// Palma
							case "2|6|3|8|13": room_goto(rm_credits); exit; // Medusa Tower (Exit)
							
							// Enter / leave a dungeon room
							default: roomEntered = !roomEntered;
							
						}
						
					break;
					
					// If it's NOT blocked: 
					default:
						
						// Place the player on the other side of the passage
						locX = locXnew;
						locY = locYnew;
						
				}
				
			break;
			
		}
		
		// If dungeon room entered, set room fragments ...
		if (roomEntered) scrSetsprites(0,0,0,0,FRAGCAT.ROOM);
		
		// ... else, update the dungeon view
		else scrMain(state[mPREV]);
		
		// Time to fade in!
		state[mCURR] = STATE.INIT;
		
	}
	
}