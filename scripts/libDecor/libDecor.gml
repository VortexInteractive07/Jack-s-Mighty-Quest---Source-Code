/// @desc libDecor(E,N,W,S)
/// @arg E East
/// @arg N North
/// @arg W West
/// @arg S South

function libDecor(_E,_N,_W,_S) {
	
	var _u = undefined;
	
	var _e = STATE.EAST;
	var _n = STATE.NORTH;
	var _w = STATE.WEST;
	var _s = STATE.SOUTH;
	
	// The beye array to return
	var _arrBeye = [_E,_N,_W,_S];
	
	// The walk array to return
	var _arrWalk = [[_u,_u],[_u,_u],[_u,_u],[_u,_u]];
	
	// The walk array's direction-translating array
	var _dir     = [[_s,_n],[_e,_w],[_n,_s],[_w,_e]];
	
	// The beye array size
	var _arrLen  = array_length(_arrBeye);
	
	for (var _i=_e; _i<_arrLen; _i++) {
		
		// If the beye array's cell isnt undefined
		if (_arrBeye[_i] != _u) {
			
			// Set content in cells the translating array directs to
			_arrWalk[_dir[_i][mLEFT]][mLEFT] = _arrBeye[_i];
			_arrWalk[_dir[_i][mRGHT]][mRGHT] = _arrBeye[_i];
			
		}
		
	}
	
	// Return an array of arrays filled with decor content
	// in relation to which arguments were passed in
	return [_arrBeye,_arrWalk];
	
}