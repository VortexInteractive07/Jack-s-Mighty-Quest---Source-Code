/// @desc libFragimages(fragImages,fragments)
/// @arg fragImages
/// @arg fragments

function libFragimages(_fragImages,_fragments) {
	
	_fragImages[@ FRAGIMAGES.WALK] = sprite_get_number(_fragments[FRAGCAT.WALK][DIST.ONE][WALKFRAG.CORR][0][mMAIN]);
	_fragImages[@ FRAGIMAGES.TURN] = sprite_get_number(_fragments[FRAGCAT.TURN][TURNFRAG.TCC2C][0][mLEFT]);
	
}