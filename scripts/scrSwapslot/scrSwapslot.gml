/// @desc scrSwapslot(slotFacing,contSlot)
/// @arg slotFacing
/// @arg contSlot

function scrSwapslot(_slotFacing,_contSection) {
	
	switch (_slotFacing[_contSection]) {
		
		case SLOT.CHEST:      _slotFacing[@ _contSection] = undefined;           break;
		case SLOT.DOOR:       _slotFacing[@ _contSection] = SLOT.DOOROPEN;       break;
		case SLOT.DOORLOCKED: _slotFacing[@ _contSection] = SLOT.DOORLOCKEDOPEN; break;
		case SLOT.DOORMAGIC:  _slotFacing[@ _contSection] = SLOT.DOORMAGICOPEN;  break;
		case SLOT.GATE:       _slotFacing[@ _contSection] = SLOT.GATEOPEN;       break;
		case SLOT.ODIN:       _slotFacing[@ _contSection] = undefined;           break;
		
	}
	
}