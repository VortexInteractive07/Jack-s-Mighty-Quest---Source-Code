/// @desc Last image + alarm[1]

if (sprite_index != -1) {
	
	if (alarm[1] == -1) {
		
		image_speed = 0;
		image_index = sprite_get_number(sprite_index)-1;
		
		alarm[1] = delay;
		
	}
	
}