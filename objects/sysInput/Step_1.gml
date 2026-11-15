/// @desc Input setup

#region INPUT

right	    = keyboard_check_pressed(vk_right);
up		    = keyboard_check_pressed(vk_up);
left	    = keyboard_check_pressed(vk_left);
down	    = keyboard_check_pressed(vk_down);

rightHeld   = keyboard_check(vk_right);
upHeld	    = keyboard_check(vk_up);
leftHeld    = keyboard_check(vk_left);
downHeld    = keyboard_check(vk_down);

button1	    = keyboard_check_pressed(ord("A"));
button2	    = keyboard_check_pressed(ord("S"));
button3	    = keyboard_check_pressed(ord("D"));
button4	    = keyboard_check_pressed(ord("F"));

button1held = keyboard_check(ord("A"));
button2held = keyboard_check(ord("S"));
button3held = keyboard_check(ord("D"));
button4held = keyboard_check(ord("F"));

start	    = keyboard_check_pressed(ord("W")) or keyboard_check_pressed(vk_f3);
select	    = keyboard_check_pressed(ord("Q"));

startHeld   = keyboard_check(ord("W")) or keyboard_check(vk_f3);
selectHeld	= keyboard_check(ord("Q"));

if (is_array(gamepad)) {
	
	var _gamepad = gamepad;
	
	if (gamepad_is_connected(_gamepad[PAD.ID])) {
		
		if (_gamepad[PAD.HATS] > 0) {
			
			for (var _hatIndex=0; _hatIndex<_gamepad[PAD.HATS]; _hatIndex++) {
				
				if (gamepad_hat_value(_gamepad[PAD.ID],_hatIndex) > 0) {
					
					var _intValue	= ceil(gamepad_hat_value(_gamepad[PAD.ID],_hatIndex));
					var _inputR		= _intValue == 2 or _intValue ==  3 or _intValue ==  6 ?  1 : 0; // Translate "right"
					var _inputU		= _intValue == 1 or _intValue ==  9 or _intValue ==  3 ? -1 : 0; // Translate "up"
					var _inputL		= _intValue == 8 or _intValue == 12 or _intValue ==  9 ? -1 : 0; // Translate "left"
					var _inputD		= _intValue == 4 or _intValue ==  6 or _intValue == 12 ?  1 : 0; // Translate "down"
					var _hHoz		= _inputR-_inputL;
					var _hVer		= _inputD-_inputU;
					
					hatHoz			= _hHoz*hatHozFlag; // Check Pressed Horizontally
					hatVer			= _hVer*hatVerFlag; // Check Pressed Vertically
					
					hatHozFlag		= _hHoz != 0 ? 0 : 1; // Flag Horizontally
					hatVerFlag		= _hVer != 0 ? 0 : 1; // Flag Vertically
					
					hatHozHeld		= _hHoz; // Check Horizontally
					hatVerHeld		= _hVer; // Check Vertically
					
					break;
					
				}
				
			}
			
		}
		
		var _sHoz		 = sign(gamepad_axis_value(_gamepad[PAD.ID],gp_axislh));
		var _sVer		 = sign(gamepad_axis_value(_gamepad[PAD.ID],gp_axislv));
		
		lsHoz			 = _sHoz*lsHozFlag; // Check Pressed Horizontally
		lsVer			 = _sVer*lsVerFlag; // Check Pressed Vertically
		
		lsHozFlag		 = _sHoz != 0 ? 0 : 1; // Flag Horizontally
		lsVerFlag		 = _sVer != 0 ? 0 : 1; // Flag Vertically
		
		lsHozHeld		 = _sHoz; // Check Horizontally
		lsVerHeld		 = _sVer; // Check Vertically
		
		right		|= gamepad_button_check_pressed(_gamepad[PAD.ID],gp_padr);
		up			|= gamepad_button_check_pressed(_gamepad[PAD.ID],gp_padu);
		left		|= gamepad_button_check_pressed(_gamepad[PAD.ID],gp_padl);
		down		|= gamepad_button_check_pressed(_gamepad[PAD.ID],gp_padd);
		
		rightHeld	|= gamepad_button_check(_gamepad[PAD.ID],gp_padr);
		upHeld		|= gamepad_button_check(_gamepad[PAD.ID],gp_padu);
		leftHeld	|= gamepad_button_check(_gamepad[PAD.ID],gp_padl);
		downHeld	|= gamepad_button_check(_gamepad[PAD.ID],gp_padd);
		
		button1		|= gamepad_button_check_pressed(_gamepad[PAD.ID],gp_face3);
		button2		|= gamepad_button_check_pressed(_gamepad[PAD.ID],gp_face1);
		button3		|= gamepad_button_check_pressed(_gamepad[PAD.ID],gp_face4);
		button4		|= gamepad_button_check_pressed(_gamepad[PAD.ID],gp_face2);
		
		button1held	|= gamepad_button_check(_gamepad[PAD.ID],gp_face3);
		button2held	|= gamepad_button_check(_gamepad[PAD.ID],gp_face1);
		button3held	|= gamepad_button_check(_gamepad[PAD.ID],gp_face4);
		button4held	|= gamepad_button_check(_gamepad[PAD.ID],gp_face2);
		
		start		|= gamepad_button_check_pressed(_gamepad[PAD.ID],gp_start);
		select		|= gamepad_button_check_pressed(_gamepad[PAD.ID],gp_select);
		
		startHeld	|= gamepad_button_check(_gamepad[PAD.ID],gp_start);
		selectHeld	|= gamepad_button_check(_gamepad[PAD.ID],gp_select);
		
	}
	
}

hoz		= sign((right-left)+(lsHoz|hatHoz));
ver		= sign(( down-  up)+(lsVer|hatVer));
hozHeld	= sign((rightHeld-leftHeld)+(lsHozHeld|hatHozHeld));
verHeld	= sign(( downHeld-  upHeld)+(lsVerHeld|hatVerHeld));

#endregion

if (timer     > 0) timer--;
if (timerHeld > 0) timerHeld--;
