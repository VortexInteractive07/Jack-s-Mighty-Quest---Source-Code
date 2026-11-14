/// @desc scrAnimation(posX,posY,sprite,imgSpd,sfx,delay,palette)
/// @arg creator The instance creating this instance
/// @arg posX	 The X pixel position of the sprite
/// @arg posY	 The Y pixel position of the sprite
/// @arg sprite	 The sprite to animate
/// @arg imgSpd	 The sprite's animation speed
/// @arg sfx	 The sound to play (optional)
/// @arg delay	 The delay(in frames) until destruction of objAnimation
/// @arg palette The palette swap array

function scrAnimation(_creator,_posX,_posY,_sprite,_imgSpd,_sfx,_delay,_palette) {
	
	with (instance_create_layer(_posX,_posY,"Instances",objAnimation)) {
		
		creator      = _creator;
		input        = other.input;
		lib          = other.lib;
		
		sprite_index = _sprite;
		image_speed  = _imgSpd;
		sfx          = _sfx;
		delay        = _delay;
		palette      = _palette;
		
	}
	
}