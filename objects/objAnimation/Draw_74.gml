/// @desc Sprite

switch (palette) {
	
	case undefined:
		
		draw_self();
		
	break;
	default:
		
		fncPalswapset(palette[DUNGPAL.WALL],palette[DUNGPAL.IMGIND],palette[DUNGPAL.INDEX],PALSRC.SPRITE);
		draw_self();
		draw_sprite_ext(sprite_index,image_index,x,y,-1,1,0,c_white,1);
		shader_reset();
		
}