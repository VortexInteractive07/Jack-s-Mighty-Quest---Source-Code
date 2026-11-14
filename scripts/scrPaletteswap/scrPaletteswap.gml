/// scrPaletteswap


/// @desc fncPalswapinit(shader)
/// @arg shader The shader to use

function fncPalswapinit(_shader) {
	
	global.pal = array_create(PAL.length,0);
	
	global.pal[PAL.SHADER ] = _shader;
	global.pal[PAL.TEXTURE] = shader_get_sampler_index(_shader,"texture");
	global.pal[PAL.TEXTUVS] = shader_get_uniform(_shader,"textUVs");
	global.pal[PAL.TEXSIZE] = shader_get_uniform(_shader,"texelSize");
	global.pal[PAL.INDEX  ] = shader_get_uniform(_shader,"index");
	
}


/// @desc fncPalswapset(palSource,palImage,palIndex,palEnum)
/// @arg palSource The palette source (sprite,surface,etc)
/// @arg palImage  The palette sprite's image index
/// @arg palIndex  The palette index
/// @arg palEnum   The palette enum

function fncPalswapset(_palSource,_palImage,_palIndex,_palEnum) {
	
	var _texture = undefined;
	var _texelW = 0;
	var _texelH = 0;
	
	shader_set(global.pal[PAL.SHADER]);
	
	switch (_palEnum) {
		
		case PALSRC.SPRITE:
			
			_texture = sprite_get_texture(_palSource,_palImage);
			var _textUVs = sprite_get_uvs(    _palSource,_palImage);
			_texelW = texture_get_texel_width( _texture);
			_texelH = texture_get_texel_height(_texture);
			
			texture_set_stage(	  global.pal[PAL.TEXTURE],_texture);
			gpu_set_texfilter_ext(global.pal[PAL.TEXTURE],false);
			
			shader_set_uniform_f(global.pal[PAL.TEXTUVS],_textUVs[0],_textUVs[1],_textUVs[2],_textUVs[3]); // L,T,R,B
			shader_set_uniform_f(global.pal[PAL.TEXSIZE],_texelW,_texelH);
			shader_set_uniform_f(global.pal[PAL.INDEX  ],_palIndex);
			
		break;
		case PALSRC.SURFACE:
			
			_texture = surface_get_texture(_palSource);
			_texelW = texture_get_texel_width( _texture);
			_texelH = texture_get_texel_height(_texture);
			
			texture_set_stage(	  global.pal[PAL.TEXTURE],_texture);
			gpu_set_texfilter_ext(global.pal[PAL.TEXTURE],false);
			
			shader_set_uniform_f(global.pal[PAL.TEXTUVS],_texelW,_texelH,1.0+_texelW,1.0+_texelH);
			shader_set_uniform_f(global.pal[PAL.TEXSIZE],_texelW,_texelH);
			shader_set_uniform_f(global.pal[PAL.INDEX  ],_palIndex);
			
		break;
		
	}
	
}