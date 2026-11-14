/// @desc libFragsizes(fragSize,fragments)
/// @arg fragSize
/// @arg fragments

function libFragsizes(_fragSize,_fragments) {
	
	var _walk = _fragments[FRAGCAT.WALK];
	var _beye = _fragments[FRAGCAT.BEYE];
	var _turn = _fragments[FRAGCAT.TURN];
	
	// Beye - Infinity
	_fragSize[@ FRAGSIZE.INFINITY] = [sprite_get_width(_beye[DIST.FOUR ][BEYEFRAG.INFINITY][0]),sprite_get_height(_beye[DIST.FOUR ][BEYEFRAG.INFINITY][0])];
	
	// Walk / Beye - dist 4
	_fragSize[@ FRAGSIZE.DIST4LR ] = [sprite_get_width(_walk[DIST.FOUR ][WALKFRAG.CORR    ][0][mMAIN]),sprite_get_height(_walk[DIST.FOUR ][WALKFRAG.CORR    ][0][mMAIN])];
	_fragSize[@ FRAGSIZE.DIST4TD ] = [sprite_get_width(_walk[DIST.FOUR ][WALKFRAG.CF      ][0][mMAIN]),sprite_get_height(_walk[DIST.FOUR ][WALKFRAG.CF      ][0][mMAIN])];
	_fragSize[@ FRAGSIZE.DIST4BE ] = [sprite_get_width(_beye[DIST.FOUR ][BEYEFRAG.WALL    ][0]       ),sprite_get_height(_beye[DIST.FOUR ][BEYEFRAG.WALL    ][0]       )];
	
	// Walk / Beye - dist 3
	_fragSize[@ FRAGSIZE.DIST3LR ] = [sprite_get_width(_walk[DIST.THREE][WALKFRAG.CORR    ][0][mMAIN]),sprite_get_height(_walk[DIST.THREE][WALKFRAG.CORR    ][0][mMAIN])];
	_fragSize[@ FRAGSIZE.DIST3TD ] = [sprite_get_width(_walk[DIST.THREE][WALKFRAG.CF      ][0][mMAIN]),sprite_get_height(_walk[DIST.THREE][WALKFRAG.CF      ][0][mMAIN])];
	_fragSize[@ FRAGSIZE.DIST3BE ] = [sprite_get_width(_beye[DIST.THREE][BEYEFRAG.WALL    ][0]       ),sprite_get_height(_beye[DIST.THREE][BEYEFRAG.WALL    ][0]       )];
	
	// Walk / Beye - dist 2
	_fragSize[@ FRAGSIZE.DIST2LR ] = [sprite_get_width(_walk[DIST.TWO  ][WALKFRAG.CORR    ][0][mMAIN]),sprite_get_height(_walk[DIST.TWO  ][WALKFRAG.CORR    ][0][mMAIN])];
	_fragSize[@ FRAGSIZE.DIST2TD ] = [sprite_get_width(_walk[DIST.TWO  ][WALKFRAG.CF      ][0][mMAIN]),sprite_get_height(_walk[DIST.TWO  ][WALKFRAG.CF      ][0][mMAIN])];
	_fragSize[@ FRAGSIZE.DIST2BE ] = [sprite_get_width(_beye[DIST.TWO  ][BEYEFRAG.WALL    ][0]       ),sprite_get_height(_beye[DIST.TWO  ][BEYEFRAG.WALL    ][0]       )];
	
	// Walk / Beye - dist 1
	_fragSize[@ FRAGSIZE.DIST1LR ] = [sprite_get_width(_walk[DIST.ONE  ][WALKFRAG.CORR    ][0][mMAIN]),sprite_get_height(_walk[DIST.ONE  ][WALKFRAG.CORR    ][0][mMAIN])];
	_fragSize[@ FRAGSIZE.DIST1TD ] = [sprite_get_width(_walk[DIST.ONE  ][WALKFRAG.CF      ][0][mMAIN]),sprite_get_height(_walk[DIST.ONE  ][WALKFRAG.CF      ][0][mMAIN])];
	_fragSize[@ FRAGSIZE.DIST1BE ] = [sprite_get_width(_beye[DIST.ONE  ][BEYEFRAG.WALL    ][0]       ),sprite_get_height(_beye[DIST.ONE  ][BEYEFRAG.WALL    ][0]       )];
	
	// Beye - Static
	_fragSize[@ FRAGSIZE.STATIC  ] = [sprite_get_width(_walk[DIST.ONE  ][WALKFRAG.STATIC  ][0][mMAIN]),sprite_get_height(_walk[DIST.ONE  ][WALKFRAG.STATIC  ][0][mMAIN])];
	
	// Turn
	_fragSize[@ FRAGSIZE.TURN    ] = [sprite_get_width(_turn[TURNFRAG.TCC2C][0][mLEFT]),sprite_get_height(_turn[TURNFRAG.TCC2C][0][mLEFT])];
	
}