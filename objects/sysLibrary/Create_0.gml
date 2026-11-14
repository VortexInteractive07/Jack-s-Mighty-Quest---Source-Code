/// @desc Init game library

var _nSlots = 16; // Max level slots per axis

cat = array_create_multi(undefined,0,[CAT.length]);

cat[CAT.FRAGMENTS ] = array_create_multi(undefined,0,[   FRAGCAT.length]);
cat[CAT.FRAGIMAGES] = array_create_multi(undefined,0,[FRAGIMAGES.length]);
cat[CAT.FRAGSIZES ] = array_create_multi(undefined,0,[  FRAGSIZE.length]);
cat[CAT.FRAGSETS  ] = array_create_multi(undefined,0,[   DUNGEON.length]);
cat[CAT.DUNGEONS  ] = array_create_multi(undefined,0,[   DUNGEON.length,DUNGLVL.length,_nSlots,_nSlots]);

cat[CAT.FRAGMENTS][FRAGCAT.WALK] = array_create_multi(undefined,0,[     DIST.length, WALKFRAG.length]);
cat[CAT.FRAGMENTS][FRAGCAT.BEYE] = array_create_multi(undefined,0,[     DIST.length, BEYEFRAG.length]);
cat[CAT.FRAGMENTS][FRAGCAT.TURN] = array_create_multi(undefined,0,[ TURNFRAG.length]);
cat[CAT.FRAGMENTS][FRAGCAT.ROOM] = array_create_multi(undefined,0,[ ROOMFRAG.length]);
cat[CAT.FRAGMENTS][FRAGCAT.ANIM] = array_create_multi(undefined,0,[ ANIMFRAG.length]);

// Set default library stats
libFragments(cat[CAT.FRAGMENTS]);
libFragimages(cat[CAT.FRAGIMAGES],cat[CAT.FRAGMENTS]);
libFragsizes(cat[CAT.FRAGSIZES],cat[CAT.FRAGMENTS]);
libFragsets(cat[CAT.FRAGSETS]);
libDungeons(cat[CAT.DUNGEONS]);