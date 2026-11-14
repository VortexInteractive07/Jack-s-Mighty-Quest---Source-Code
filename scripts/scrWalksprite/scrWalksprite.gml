/// @desc scrWalksprite(state,locX,locY,dungLvl,contSlot,distCloser,distfarther,checkLR,fragSet,fragWalk,mainExt)
/// @arg state        The current/previous state
/// @arg locX	      The player's X location
/// @arg locY	      The player's Y location
/// @arg dungLvl      The current dungeon level
/// @arg contSlot     The content array slot
/// @arg distCloser	  Slot closer
/// @arg distfarther  Slot farther
/// @arg checkLR      Check left(-1) or right(1)
/// @arg fragSet      The index selecting the set of sprite fragments to use
/// @arg fragWalk     Walk sprite fragments
/// @arg mainExt	  Main or extended sprite

function scrWalksprite(_state,_locX,_locY,_dungLvl,_contSlot,_distCloser,_distfarther,_checkLR,_fragSet,_fragWalk,_mainExt) {
	
	var _u = undefined;
	
	var _insideArray = [array_length(_dungLvl[_locY])-1-_locX >= _distfarther,_locY >= _distfarther,_locX >= _distfarther,array_length(_dungLvl)-1-_locY >= _distfarther];
	
	// If we're not checking inside the array, return undefined
	if (!_insideArray[_state]) return _u;
	
	// East, north, west, south
	var _enws = [_locY+_checkLR,_locX+_distCloser,_locY+_checkLR,_locX+_distfarther,
				 _locY-_distCloser,_locX+_checkLR,_locY-_distfarther,_locX+_checkLR,
				 _locY-_checkLR,_locX-_distCloser,_locY-_checkLR,_locX-_distfarther,
				 _locY+_distCloser,_locX-_checkLR,_locY+_distfarther,_locX-_checkLR];
	
	var _slotCloser  = _dungLvl[_enws[(_state*4)  ]][_enws[(_state*4)+1]];
	var _slotFarther = _dungLvl[_enws[(_state*4)+2]][_enws[(_state*4)+3]];
	
	var _walkSprite = _u;
	
	switch (_contSlot) {
		
		case CONTSLOT.BASESTRUCT:
			
			#region WALK WALL
			
			switch (_slotFarther[_contSlot]) {
				
				case SLOT.WALL:
				case SLOT.WALLFAKE:
					
					switch (_slotCloser[_contSlot]) {
						
						case SLOT.WALL:
						case SLOT.WALLFAKE: _walkSprite = _fragWalk[WALKFRAG.WALL][_fragSet][_mainExt]; break;
						default: _walkSprite = _distCloser == -1 ? _fragWalk[WALKFRAG.WALL][_fragSet][_mainExt] : _fragWalk[WALKFRAG.CORRTAIL][_fragSet][_mainExt];
						
					}
					
				break;
				default:
					
					switch (_slotCloser[_contSlot]) {
						
						case SLOT.WALL:
						case SLOT.WALLFAKE: _walkSprite = _fragWalk[WALKFRAG.CORR][_fragSet][_mainExt]; break;
						default: _walkSprite = _fragWalk[WALKFRAG.CORRTAIL][_fragSet][_mainExt];
						
					}
					
			}
			
			#endregion
			
		break;
		case CONTSLOT.DECOR:
			
			#region WALK DECOR
			
			switch (_slotFarther[_contSlot][1][_state][max(0,_checkLR)]) {
				
				case SLOT.SKELETON: _walkSprite = _fragWalk[WALKFRAG.SKELETON][_fragSet][_mainExt]; break;
				
			}
			
			#endregion
			
		break;
		
	}
	
	return _walkSprite;
	
}