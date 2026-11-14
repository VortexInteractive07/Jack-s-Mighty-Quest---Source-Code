/// scrDoorclose(currLvl)
/// @arg currLvl The current dungeon level

function scrDoorclose(_currLvl) {
	
	for (var _yy=0; _yy<array_length(_currLvl); _yy++) {
		
		for (var _xx=0; _xx<array_length(_currLvl[_yy]); _xx++) {
			
			switch (_currLvl[_yy][_xx][CONTSLOT.PASSAGE]) {
				
				case SLOT.DOOROPEN:       _currLvl[@ _yy][_xx][CONTSLOT.PASSAGE] = SLOT.DOOR;       break;
				case SLOT.DOORLOCKEDOPEN: _currLvl[@ _yy][_xx][CONTSLOT.PASSAGE] = SLOT.DOORLOCKED; break;
				case SLOT.DOORMAGICOPEN:  _currLvl[@ _yy][_xx][CONTSLOT.PASSAGE] = SLOT.DOORMAGIC;  break;
				case SLOT.GATEOPEN:       _currLvl[@ _yy][_xx][CONTSLOT.PASSAGE] = SLOT.GATE;       break;
				
			}
			
		}
		
	}
	
}