/// @desc scrBeyesprite(state,locX,locY,dungLvl,contSlot,dist,checkLR,fragSet,fragBeye)
/// @arg state    The current/previous state
/// @arg locX     The player's X location
/// @arg locY     The player's Y location
/// @arg dungLvl  The current dungeon level
/// @arg contSlot The content array slot
/// @arg dist     Slot distance
/// @arg checkLR  Check left(-1) or right(1)
/// @arg fragSet  The index selecting the set of sprite fragments to use
/// @arg fragBeye The Bullseye/decor sprite fragments

function scrBeyesprite(_state,_locX,_locY,_dungLvl,_contSlot,_dist,_checkLR,_fragSet,_fragBeye) {
	
	var _u = undefined;
	
	var _insideArray = [array_length(_dungLvl[_locY])-1-_locX >= _dist,_locY >= _dist,_locX >= _dist,array_length(_dungLvl)-1-_locY >= _dist];
	
	if (!_insideArray[_state]) return _u;
	
	var _enws = [_locY,_locX+_dist,_locY-1,_locX+_dist-1,_locY+1,_locX+_dist-1,
				 _locY-_dist,_locX,_locY-_dist+1,_locX-1,_locY-_dist+1,_locX+1,
				 _locY,_locX-_dist,_locY+1,_locX-_dist+1,_locY-1,_locX-_dist+1,
				 _locY+_dist,_locX,_locY+_dist-1,_locX+1,_locY+_dist-1,_locX-1];
	
	var _slot = _dungLvl[_enws[(_state*6)]][_enws[(_state*6)+1]];
	
	var _beyeSprite = _u;
	
	switch (_contSlot) {
		
		case CONTSLOT.BASESTRUCT:
			
			#region BEYE WALL
			
			var _slotLend = _dungLvl[_enws[(_state*6)+2]][_enws[(_state*6)+3]][_contSlot];
			var _slotRend = _dungLvl[_enws[(_state*6)+4]][_enws[(_state*6)+5]][_contSlot];
			
			_slotLend = _checkLR == -1 and _slotLend != SLOT.WALL and _slotLend != SLOT.WALLFAKE;
			_slotRend = _checkLR ==  1 and _slotRend != SLOT.WALL and _slotRend != SLOT.WALLFAKE;
			
			switch (_slot[_contSlot]) {
				
				case SLOT.WALL:
				case SLOT.WALLFAKE:
					
					_beyeSprite = _slotLend or _slotRend ? _fragBeye[BEYEFRAG.WALLLR][_fragSet] : _fragBeye[BEYEFRAG.WALL][_fragSet];
					
				break;
				
			}
			
			#endregion
			
		break;
		case CONTSLOT.PASSAGE:
		case CONTSLOT.OBJECT:
			
			#region BEYE PASSAGE / OBJECT
			
			switch (_slot[_contSlot]) {
				
				case SLOT.CHEST:          _beyeSprite = _fragBeye[BEYEFRAG.CHEST     ][_fragSet]; break;
				case SLOT.DOOR:           _beyeSprite = _fragBeye[BEYEFRAG.EXITDR    ][_fragSet]; break;
				case SLOT.DOORLOCKED:     _beyeSprite = _fragBeye[BEYEFRAG.EXITDRLD  ][_fragSet]; break;
				case SLOT.DOORMAGIC:      _beyeSprite = _fragBeye[BEYEFRAG.EXITDRMC  ][_fragSet]; break;
				case SLOT.DOOROPEN:       
				case SLOT.DOORLOCKEDOPEN: _beyeSprite = _fragBeye[BEYEFRAG.EXITDRON  ][_fragSet]; break;
				case SLOT.DOORMAGICOPEN:  _beyeSprite = _fragBeye[BEYEFRAG.EXITDRMCON][_fragSet]; break;
				case SLOT.GATE:           _beyeSprite = _fragBeye[BEYEFRAG.EXITGE    ][_fragSet]; break;
				case SLOT.GATEOPEN:       _beyeSprite = _fragBeye[BEYEFRAG.EXITGEON  ][_fragSet]; break;
				case SLOT.ODIN:           _beyeSprite = _fragBeye[BEYEFRAG.ODIN      ][_fragSet]; break;
				case SLOT.STAIRSUP:       _beyeSprite = _fragBeye[BEYEFRAG.EXITSTAU  ][_fragSet]; break;
				case SLOT.STAIRSDOWN:     _beyeSprite = _fragBeye[BEYEFRAG.EXITSTAD  ][_fragSet]; break;
				
			}
			
			#endregion
			
		break;
		case CONTSLOT.DECOR:
			
			#region BEYE DECOR
			
			switch (_slot[_contSlot][0][_state]) {
				
				case SLOT.SKELETON: _beyeSprite = _fragBeye[BEYEFRAG.SKELETON][_fragSet];
				
			}
			
			#endregion
			
		break;
		
	}
	
	return _beyeSprite;
	
}