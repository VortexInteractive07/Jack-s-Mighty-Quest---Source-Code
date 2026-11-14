/// @desc scrMain(state)
/// @arg state The current/previous state

function scrMain(_state) {
	
	// Store the correct walk values based on which state we're in
	facingX = walk[_state  ];
	facingY = walk[_state+4];
	
	#region UPDATE VIEW
	
	// Update view
	if (viewUpdate) {
		
		// Set the fragments to use for the walk animation (Forward)
		scrSetsprites(_state,0,locX,locY,FRAGCAT.WALK);
		
		// Set image index start position (Forward)
		imgInd = lib.cat[CAT.FRAGIMAGES][FRAGIMAGES.WALK]-1;
		
		// Excuse to; create correct momentum when moving any direction except forward,
		// or trigger encounters directly after transition
		moveCounter = inputL|inputR|inputD == 1 ? -modValue : -1;
		
		// Reset input flags
		inputL = 0;
		inputR = 0;
		inputD = 0;
		
		viewUpdate = false;
		
	}
	
	#endregion
	
	// If we're not in the middle of an action, nor in a transition
	if (action == undefined and !inTransition) {
		
		var _slotCurrent = lib.cat[CAT.DUNGEONS][currDung][currLvl][locY        ][locX        ];
		var _slotFacing  = lib.cat[CAT.DUNGEONS][currDung][currLvl][locY+facingY][locX+facingX];
		
		#region WHEN NOT MOVING
		
		// If we stand still
		if (moveCounter == 0) {
			
			// Listen to input
			var _LRheld = input.hozHeld;
			var _UDheld = input.verHeld;
			var _B1orB2 = input.button1|input.button2;
			
			// Execute forward/backward walk
			if (_UDheld != 0) {
				
				inputD = _UDheld > 0 ? 1 : 0;
				
				// Change player location / transition / do nothing
				scrArraywalk(_state,inputD == 1 ? -facingX : facingX,inputD == 1 ? -facingY : facingY);
				
			}
			
			// Execute 90 degree left/right turn
			if (_LRheld != 0 and moveCounter == 0 and !inTransition) {
				
				inputR = _LRheld > 0 ? 1 : 0;
				inputL = _LRheld < 0 ? 1 : 0;
				
				// Set the fragments to use for the turn animation
				scrSetsprites(_state,_LRheld,locX,locY,FRAGCAT.TURN);
				
				// Set image index start position
				imgInd = inputL == 1 ? lib.cat[CAT.FRAGIMAGES][FRAGIMAGES.TURN] : -1;
				
				// Set movement counter (animation duration)
				moveCounter = modValue*lib.cat[CAT.FRAGIMAGES][FRAGIMAGES.TURN];
				
			}
			
			// Execute action
			if (_B1orB2 != 0 and moveCounter == 0 and !inTransition) {
				
				if (!ds_stack_empty(actionStack)) ds_stack_clear(actionStack);
				
				switch (_slotFacing[CONTSLOT.OBJECT]) {
					
					// Open chest
					case SLOT.CHEST: fncPushaction(id,ACTION.CHEST,true); break;
					
					// Odin joins the party
					case SLOT.ODIN: fncPushaction(id,ACTION.ODIN,true); break;
					
					default:
						
						switch (_slotFacing[CONTSLOT.PASSAGE]) {
							
							// Open door
							case SLOT.DOOR:
							case SLOT.DOORLOCKED:
							case SLOT.DOORMAGIC:
							case SLOT.GATE:
								
								fncPushaction(id,ACTION.DOOR,true);
								
							break;
							
							// Open inventory
							default:
								
								//fncPushaction(id,ACTION.INVENTORY,true);
								
						}
						
				}
				
			}
			
		}
		
		#endregion
		
		#region WHEN MOVING
		
		// If we don't stand still
		if (moveCounter != 0) {
			
			if (moveCounter > 0 and moveCounter mod modValue == 0) {
				
				// If we've just finished moving backwards, update dungeon view
				if (imgInd == 0 and inputD == 1) viewUpdate = true;
				
				// Else inc/dec image index
				else imgInd += inputL|inputD == 1 ? -1 : 1;
				
			}
			
			moveCounter += sign(-moveCounter);
			
			// If just when standing still
			if (moveCounter == 0) {
				
				// If we've just finished turning
				if (inputL|inputR == 1) {
					
					// Set the new cardinal state
					state[mCURR] = inputL == 1 ? turn[_state] : turn[_state+4];
					
					// Update dungeon view
					viewUpdate = true;
					
				} else {
					
					if (!ds_stack_empty(actionStack)) ds_stack_clear(actionStack);
					
					// Trigger encounter
					switch (_slotCurrent[CONTSLOT.BASESTRUCT]) {
						
						// Auto walk forward
						case SLOT.WALLFAKE: scrArraywalk(_state,facingX,facingY); break;
						
						// Fall down one level
						case SLOT.CORRIDORTRAP: fncPushaction(id,ACTION.FLOORTRAP,false); break;
						
						//default:
							
							//switch (_slotFacing[CONTSLOT.OBJECT]) {
								
							//	case SLOT.CHEST: fncPushaction(id,ACTION.CHEST); break;
							//	case SLOT.NPC:   fncPushaction(id,ACTION.NPC);   break;
							//	case SLOT.ENEMY: enemyEncounter = true;
							//	default:
									
							//		If (enemyEncounter) //fncPushaction(id,ACTION.BATTLE);
									
							//}
							
					}
					
					//enemyEncounter = false;
					
				}
				
			} else {
				
				//If (irandom(enemyRate) >= enemyRate-1) enemyEncounter = true;
				
			}
			
			// Arrow visible
			if (counter < 16) counter = 1;
			
		}
		
		#endregion
		
	}
	
}