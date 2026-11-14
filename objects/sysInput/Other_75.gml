/// @desc Gamepad lost/found

switch (async_load[? "event_type"]) {
	
	case "gamepad discovered": if (is_array(gamepad)) gamepad[PAD.ID] = async_load[? "pad_index"]; break;
	case "gamepad lost":       if (is_array(gamepad)) gamepad[PAD.ID] = -1;                        break;
	
}