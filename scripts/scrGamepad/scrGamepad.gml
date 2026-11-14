/// @desc scrGamepad()

/// @desc fncInitgamepad()

function fncInitgamepad() {
	
	if (gamepad_is_supported()) {
		
	    for (var _i=0; _i<gamepad_get_device_count(); _i++) {
			
	        if (gamepad_is_connected(_i)) {
				
				var _arrPad = array_create(PAD.length,0);
				
				_arrPad[@ PAD.ID     ] = _i;
				_arrPad[@ PAD.GUID   ] = gamepad_get_guid(_i);
				_arrPad[@ PAD.HATS   ] = gamepad_hat_count(_i);
				_arrPad[@ PAD.BUTTONS] = gamepad_button_count(_i);
				_arrPad[@ PAD.DESC   ] = gamepad_get_description(_i);
				//_arrPad[@ PAD.CONFIG ] = array_create(CONFIG.length);
				
				gamepad_set_axis_deadzone(   _i,0.5);
				gamepad_set_button_threshold(_i,0.1);
				
	            return _arrPad;
				
	        }
			
	    }
		
	}
	
}

/// @desc fncGetbutton(gamepad)
/// @arg gamepad

function fncGetbutton(_gamepad) {
	
	var _firstIndex = gp_face1; // Might not always be correct
	
	for (var _buttonIndex=_firstIndex; _buttonIndex<_firstIndex+_gamepad[PAD.BUTTONS]; _buttonIndex++) {
		
	    if (gamepad_button_check_pressed(_gamepad[PAD.ID],_buttonIndex) and _buttonIndex != gp_select) {
			
			return _buttonIndex;
			
		}
		
	}
	
	return 0;
	
}