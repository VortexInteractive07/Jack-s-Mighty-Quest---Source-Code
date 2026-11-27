/// @desc Init lib dependant

var _fragSize = lib.cat[CAT.FRAGSIZES];
var _dungLvl  = lib.cat[CAT.DUNGEONS ][currDung][currLvl];

// A save from an older or edited project can contain a valid room name but an
// out-of-range tile. Keep the restored explorer inside the selected floor.
locY = clamp(floor(locY), 0, array_length(_dungLvl) - 1);
locX = clamp(floor(locX), 0, array_length(_dungLvl[locY]) - 1);

// Dungeon view width / height
dvW = (2*(_fragSize[FRAGSIZE.DIST4LR][mW]+_fragSize[FRAGSIZE.DIST3LR][mW]+_fragSize[FRAGSIZE.DIST2LR][mW]+_fragSize[FRAGSIZE.DIST1LR][mW]))+_fragSize[FRAGSIZE.INFINITY][mW];
dvH = (2*(_fragSize[FRAGSIZE.DIST4TD][mH]+_fragSize[FRAGSIZE.DIST3TD][mH]+_fragSize[FRAGSIZE.DIST2TD][mH]+_fragSize[FRAGSIZE.DIST1TD][mH]))+_fragSize[FRAGSIZE.INFINITY][mH]+_fragSize[FRAGSIZE.STATIC][mH];

// Count non-undefined slots (for the minimap)
nSlots[mY] = fncSlotcount(_dungLvl, true,undefined);
nSlots[mX] = fncSlotcount(_dungLvl,false,undefined);

// Keep the debug minimap centered independently of the dungeon viewport.
mapOriginX = max(0, floor((room_width - (nSlots[mX] * slotSize)) / (2 * slotSize)));
mapOriginY = max(0, floor(8 / slotSize));

// Center the original 256x192 dungeon viewport in this project's 432x240 stage.
dvX = (room_width - dvW) * 0.5;
dvY = (room_height - dvH) * 0.5;
