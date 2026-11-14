/// @desc Flashing player arrow

if (global.debug > 0) {
	
	var _stateCurr = state[mCURR];
	var _statePrev = state[mPREV];
	var _action    = action;
	
	if (!inTransition and _stateCurr != STATE.ROOM and (_action == undefined or _action == ACTION.DOOR or _action == ACTION.CHEST)) {
		
		var _slotSize  = sprite_get_height(sprMaptiles);
		var _slotStart = 3*_slotSize;
		
		if (counter < 16) {
			
			switch (_stateCurr) {
				
				case STATE.EAST:
				case STATE.NORTH:
				case STATE.WEST:
				case STATE.SOUTH: draw_sprite(sprMaparrow,_stateCurr,dvX+_slotStart+(locX*(_slotSize)),dvY+_slotStart+(locY*(_slotSize))); break;
				default:          draw_sprite(sprMaparrow,_statePrev,dvX+_slotStart+(locX*(_slotSize)),dvY+_slotStart+(locY*(_slotSize)));
				
			}
			
		}
		
	}
	
}