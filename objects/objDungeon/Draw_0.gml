/// @desc Dungeon fragments + minimap

var _u = undefined;

var _arrLen = array_length(arrDraw);

// Palette controller
var _palSprWall   = palette[DUNGPAL.WALL  ];
var _palSprCorr   = palette[DUNGPAL.CORR  ];
var _palSprImgInd = palette[DUNGPAL.IMGIND];
var _palSprIndex  = palette[DUNGPAL.INDEX ];
var _palSrc       = PALSRC.SPRITE;

// Image index
var _imgInd = imgInd;

// Dungeon view position/size
var _dvX = dvX;
var _dvY = dvY;
var _dvW = dvW;
var _dvH = dvH;

// Sprite fragment sizes
var _infW  = lib.cat[CAT.FRAGSIZES][FRAGSIZE.INFINITY][mW];
var _infH  = lib.cat[CAT.FRAGSIZES][FRAGSIZE.INFINITY][mH];

var _02w   = lib.cat[CAT.FRAGSIZES][FRAGSIZE.DIST4LR ][mW];
var _13h   = lib.cat[CAT.FRAGSIZES][FRAGSIZE.DIST4TD ][mH];

var _46w   = lib.cat[CAT.FRAGSIZES][FRAGSIZE.DIST3LR ][mW];
var _57h   = lib.cat[CAT.FRAGSIZES][FRAGSIZE.DIST3TD ][mH];

var _810w  = lib.cat[CAT.FRAGSIZES][FRAGSIZE.DIST2LR ][mW];
var _911h  = lib.cat[CAT.FRAGSIZES][FRAGSIZE.DIST2TD ][mH];

var _1214w = lib.cat[CAT.FRAGSIZES][FRAGSIZE.DIST1LR ][mW];
var _1214h = lib.cat[CAT.FRAGSIZES][FRAGSIZE.DIST1LR ][mH];
var _1315w = lib.cat[CAT.FRAGSIZES][FRAGSIZE.DIST1TD ][mW];
var _1315h = lib.cat[CAT.FRAGSIZES][FRAGSIZE.DIST1TD ][mH];

var _16w   = lib.cat[CAT.FRAGSIZES][FRAGSIZE.STATIC  ][mW];
var _16h   = lib.cat[CAT.FRAGSIZES][FRAGSIZE.STATIC  ][mH];

var _be1h  = lib.cat[CAT.FRAGSIZES][FRAGSIZE.DIST1BE ][mH];

var _turnW = lib.cat[CAT.FRAGSIZES][FRAGSIZE.TURN    ][mW];
var _turnH = lib.cat[CAT.FRAGSIZES][FRAGSIZE.TURN    ][mH];

var _rot   = 0;
var _col   = c_white;
var _alpha = 1;

// Dist 4
if (arrDraw[ 0] != _u) draw_sprite_ext(arrDraw[ 0],_imgInd,_dvX+(_dvW/2)							,_dvY+((_dvH-_16h)/2)					, 1, 1,_rot,_col,_alpha); // Dist 4 Beye (Fixed/Inifinity)

fncPalswapset(_palSprWall,_palSprImgInd,_palSprIndex,_palSrc);
if (arrDraw[ 1] != _u) draw_sprite_ext(arrDraw[ 1],_imgInd,_dvX+(_02w*2)+_46w+_810w+_1214w+_infW	,_dvY+_1214h							, 1, 1,_rot,_col,_alpha); // Dist 4 Walk (Basestruct/Walls)
if (arrDraw[ 1] != _u) draw_sprite_ext(arrDraw[ 1],_imgInd,_dvX+(_02w*2)+_46w+_810w+_1214w+_infW	,_dvY+_1214h							, 1,-1,_rot,_col,_alpha); // Dist 4 Walk (Basestruct/Walls) Y-scaled
if (arrDraw[ 2] != _u) draw_sprite_ext(arrDraw[ 2],_imgInd,_dvX+_46w+_810w+_1214w					,_dvY+_1214h							,-1, 1,_rot,_col,_alpha); // Dist 4 Walk (Basestruct/Walls) X-scaled
if (arrDraw[ 2] != _u) draw_sprite_ext(arrDraw[ 2],_imgInd,_dvX+_46w+_810w+_1214w					,_dvY+_1214h							,-1,-1,_rot,_col,_alpha); // Dist 4 Walk (Basestruct/Walls) X-scaled & Y-scaled
shader_reset();

fncPalswapset(_palSprCorr,_palSprImgInd,_palSprIndex,_palSrc);
if (arrDraw[ 3] != _u) draw_sprite_ext(arrDraw[ 3],_imgInd,_dvX+(_02w*2)+_46w+_810w+_1214w+_infW	,_dvY+_1214h							, 1, 1,_rot,_col,_alpha); // Dist 4 Walk (Basestruct/Intersection)
if (arrDraw[ 3] != _u) draw_sprite_ext(arrDraw[ 3],_imgInd,_dvX+(_02w*2)+_46w+_810w+_1214w+_infW	,_dvY+_1214h							, 1,-1,_rot,_col,_alpha); // Dist 4 Walk (Basestruct/Intersection) Y-scaled
if (arrDraw[ 4] != _u) draw_sprite_ext(arrDraw[ 4],_imgInd,_dvX+_46w+_810w+_1214w					,_dvY+_1214h							,-1, 1,_rot,_col,_alpha); // Dist 4 Walk (Basestruct/Intersection) X-scaled
if (arrDraw[ 4] != _u) draw_sprite_ext(arrDraw[ 4],_imgInd,_dvX+_46w+_810w+_1214w					,_dvY+_1214h							,-1,-1,_rot,_col,_alpha); // Dist 4 Walk (Basestruct/Intersection) X-scaled & Y-scaled
if (arrDraw[ 5] != _u) draw_sprite_ext(arrDraw[ 5],_imgInd,_dvX+_1315w								,_dvY+_57h+_911h+_1315h					, 1, 1,_rot,_col,_alpha); // Dist 4 Walk (Fixed/CF)
if (arrDraw[ 5] != _u) draw_sprite_ext(arrDraw[ 5],_imgInd,_dvX+_1315w								,_dvY+(_13h*2)+_57h+_911h+_1315h+_infH	, 1,-1,_rot,_col,_alpha); // Dist 4 Walk (Fixed/CF) Y-scaled
if (arrDraw[ 5] != _u) draw_sprite_ext(arrDraw[ 5],_imgInd,_dvX+_1315w								,_dvY+_57h+_911h+_1315h					,-1, 1,_rot,_col,_alpha); // Dist 4 Walk (Fixed/CF) X-scaled
if (arrDraw[ 5] != _u) draw_sprite_ext(arrDraw[ 5],_imgInd,_dvX+_1315w								,_dvY+(_13h*2)+_57h+_911h+_1315h+_infH	,-1,-1,_rot,_col,_alpha); // Dist 4 Walk (Fixed/CF) X-scaled & Y-scaled
shader_reset();

fncPalswapset(_palSprWall,_palSprImgInd,_palSprIndex,_palSrc);
if (arrDraw[ 6] != _u) draw_sprite_ext(arrDraw[ 6],_imgInd,_dvX+(_dvW/2)-1							,_dvY+_be1h								, 1, 1,_rot,_col,_alpha); // Dist 4 Beye (Basestruct/Walls)
if (arrDraw[ 6] != _u) draw_sprite_ext(arrDraw[ 6],_imgInd,_dvX+(_dvW/2)-1							,_dvY+_be1h								, 1,-1,_rot,_col,_alpha); // Dist 4 Beye (Basestruct/Walls) Y-scaled
if (arrDraw[ 7] != _u) draw_sprite_ext(arrDraw[ 7],_imgInd,_dvX+(_dvW/2)+1							,_dvY+_be1h								,-1, 1,_rot,_col,_alpha); // Dist 4 Beye (Basestruct/Walls) X-scaled
if (arrDraw[ 7] != _u) draw_sprite_ext(arrDraw[ 7],_imgInd,_dvX+(_dvW/2)+1							,_dvY+_be1h								,-1,-1,_rot,_col,_alpha); // Dist 4 Beye (Basestruct/Walls) X-scaled & Y-scaled
if (arrDraw[ 8] != _u) draw_sprite_ext(arrDraw[ 8],_imgInd,_dvX+(_dvW/2)							,_dvY+_dvH-(_13h+_57h+_911h+_1315h+_16h), 1, 1,_rot,_col,_alpha); // Dist 4 Beye (Passages)
if (arrDraw[ 8] != _u) draw_sprite_ext(arrDraw[ 8],_imgInd,_dvX+(_dvW/2)							,_dvY+_dvH-(_13h+_57h+_911h+_1315h+_16h),-1, 1,_rot,_col,_alpha); // Dist 4 Beye (Passages) X-scaled
shader_reset();

if (arrDraw[ 9] != _u) draw_sprite_ext(arrDraw[ 9],_imgInd,_dvX+(_dvW/2)							,_dvY+(_dvH/2)							, 1, 1,_rot,_col,_alpha); // Dist 4 Beye (Decor)
if (arrDraw[10] != _u) draw_sprite_ext(arrDraw[10],_imgInd,_dvX+_02w+_46w+_810w+_1214w+_infW		,_dvY+((_dvH-_16h)/2)					, 1, 1,_rot,_col,_alpha); // Dist 4 Walk (Decor)
if (arrDraw[11] != _u) draw_sprite_ext(arrDraw[11],_imgInd,_dvX+_02w+_46w+_810w+_1214w				,_dvY+((_dvH-_16h)/2)					,-1, 1,_rot,_col,_alpha); // Dist 4 Walk (Decor) X-scaled
if (arrDraw[12] != _u) draw_sprite_ext(arrDraw[12],_imgInd,_dvX+(_dvW/2)							,_dvY+(_dvH/2)							, 1, 1,_rot,_col,_alpha); // Dist 4 Beye (Objects)



// Dist 3
fncPalswapset(_palSprWall,_palSprImgInd,_palSprIndex,_palSrc);
if (arrDraw[13] != _u) draw_sprite_ext(arrDraw[13],_imgInd,_dvX+((_02w+_46w)*2)+_810w+_1214w+_infW	,_dvY+_1214h							, 1, 1,_rot,_col,_alpha); // Dist 3 Walk (Basestruct/Walls)
if (arrDraw[13] != _u) draw_sprite_ext(arrDraw[13],_imgInd,_dvX+((_02w+_46w)*2)+_810w+_1214w+_infW	,_dvY+_1214h							, 1,-1,_rot,_col,_alpha); // Dist 3 Walk (Basestruct/Walls) Y-scaled
if (arrDraw[14] != _u) draw_sprite_ext(arrDraw[14],_imgInd,_dvX+_810w+_1214w						,_dvY+_1214h							,-1, 1,_rot,_col,_alpha); // Dist 3 Walk (Basestruct/Walls) X-scaled
if (arrDraw[14] != _u) draw_sprite_ext(arrDraw[14],_imgInd,_dvX+_810w+_1214w						,_dvY+_1214h							,-1,-1,_rot,_col,_alpha); // Dist 3 Walk (Basestruct/Walls) X-scaled & Y-scaled
shader_reset();

fncPalswapset(_palSprCorr,_palSprImgInd,_palSprIndex,_palSrc);
if (arrDraw[15] != _u) draw_sprite_ext(arrDraw[15],_imgInd,_dvX+((_02w+_46w)*2)+_810w+_1214w+_infW	,_dvY+_1214h							, 1, 1,_rot,_col,_alpha); // Dist 3 Walk (Basestruct/Intersection)
if (arrDraw[15] != _u) draw_sprite_ext(arrDraw[15],_imgInd,_dvX+((_02w+_46w)*2)+_810w+_1214w+_infW	,_dvY+_1214h							, 1,-1,_rot,_col,_alpha); // Dist 3 Walk (Basestruct/Intersection) Y-scaled
if (arrDraw[16] != _u) draw_sprite_ext(arrDraw[16],_imgInd,_dvX+_810w+_1214w						,_dvY+_1214h							,-1, 1,_rot,_col,_alpha); // Dist 3 Walk (Basestruct/Intersection) X-scaled
if (arrDraw[16] != _u) draw_sprite_ext(arrDraw[16],_imgInd,_dvX+_810w+_1214w						,_dvY+_1214h							,-1,-1,_rot,_col,_alpha); // Dist 3 Walk (Basestruct/Intersection) X-scaled & Y-scaled
if (arrDraw[17] != _u) draw_sprite_ext(arrDraw[17],_imgInd,_dvX+_1315w								,_dvY+_911h+_1315h						, 1, 1,_rot,_col,_alpha); // Dist 3 Walk (Fixed/CF)
if (arrDraw[17] != _u) draw_sprite_ext(arrDraw[17],_imgInd,_dvX+_1315w								,_dvY+((_13h+_57h)*2)+_911h+_1315h+_infH, 1,-1,_rot,_col,_alpha); // Dist 3 Walk (Fixed/CF) Y-scaled
if (arrDraw[17] != _u) draw_sprite_ext(arrDraw[17],_imgInd,_dvX+_1315w								,_dvY+_911h+_1315h						,-1, 1,_rot,_col,_alpha); // Dist 3 Walk (Fixed/CF) X-scaled
if (arrDraw[17] != _u) draw_sprite_ext(arrDraw[17],_imgInd,_dvX+_1315w								,_dvY+((_13h+_57h)*2)+_911h+_1315h+_infH,-1,-1,_rot,_col,_alpha); // Dist 3 Walk (Fixed/CF) X-scaled & Y-scaled
shader_reset();

fncPalswapset(_palSprWall,_palSprImgInd,_palSprIndex,_palSrc);
if (arrDraw[18] != _u) draw_sprite_ext(arrDraw[18],_imgInd,_dvX+(_dvW/2)-1							,_dvY+_be1h								, 1, 1,_rot,_col,_alpha); // Dist 3 Beye (Basestruct/Walls)
if (arrDraw[18] != _u) draw_sprite_ext(arrDraw[18],_imgInd,_dvX+(_dvW/2)-1							,_dvY+_be1h								, 1,-1,_rot,_col,_alpha); // Dist 3 Beye (Basestruct/Walls) Y-scaled
if (arrDraw[19] != _u) draw_sprite_ext(arrDraw[19],_imgInd,_dvX+(_dvW/2)+1							,_dvY+_be1h								,-1, 1,_rot,_col,_alpha); // Dist 3 Beye (Basestruct/Walls) X-scaled
if (arrDraw[19] != _u) draw_sprite_ext(arrDraw[19],_imgInd,_dvX+(_dvW/2)+1							,_dvY+_be1h								,-1,-1,_rot,_col,_alpha); // Dist 3 Beye (Basestruct/Walls) X-scaled & Y-scaled
if (arrDraw[20] != _u) draw_sprite_ext(arrDraw[20],_imgInd,_dvX+(_dvW/2)							,_dvY+_dvH-(_911h+_1315h+_16h+(_16h/4))	, 1, 1,_rot,_col,_alpha); // Dist 3 Beye (Passages)
if (arrDraw[20] != _u) draw_sprite_ext(arrDraw[20],_imgInd,_dvX+(_dvW/2)							,_dvY+_dvH-(_911h+_1315h+_16h+(_16h/4))	,-1, 1,_rot,_col,_alpha); // Dist 3 Beye (Passages) X-scaled
shader_reset();

if (arrDraw[21] != _u) draw_sprite_ext(arrDraw[21],_imgInd,_dvX+(_dvW/2)							,_dvY+(_dvH/2)							, 1, 1,_rot,_col,_alpha); // Dist 3 Beye (Decor)
if (arrDraw[22] != _u) draw_sprite_ext(arrDraw[22],_imgInd,_dvX+(_02w*2)+_46w+_810w+_1214w+_infW	,_dvY+((_dvH-_16h)/2)					, 1, 1,_rot,_col,_alpha); // Dist 3 Walk (Decor)
if (arrDraw[23] != _u) draw_sprite_ext(arrDraw[23],_imgInd,_dvX+_46w+_810w+_1214w					,_dvY+((_dvH-_16h)/2)					,-1, 1,_rot,_col,_alpha); // Dist 3 Walk (Decor) X-scaled
if (arrDraw[24] != _u) draw_sprite_ext(arrDraw[24],_imgInd,_dvX+(_dvW/2)							,_dvY+(_dvH/2)							, 1, 1,_rot,_col,_alpha); // Dist 3 Beye (Objects)



// Dist 2
fncPalswapset(_palSprWall,_palSprImgInd,_palSprIndex,_palSrc);
if (arrDraw[25] != _u) draw_sprite_ext(arrDraw[25],_imgInd,_dvX+((_02w+_46w+_810w)*2)+_1214w+_infW	,_dvY+_1214h							, 1, 1,_rot,_col,_alpha); // Dist 2 Walk (Basestruct/Walls)
if (arrDraw[25] != _u) draw_sprite_ext(arrDraw[25],_imgInd,_dvX+((_02w+_46w+_810w)*2)+_1214w+_infW	,_dvY+_1214h							, 1,-1,_rot,_col,_alpha); // Dist 2 Walk (Basestruct/Walls) Y-scaled
if (arrDraw[26] != _u) draw_sprite_ext(arrDraw[26],_imgInd,_dvX+_1214w								,_dvY+_1214h							,-1, 1,_rot,_col,_alpha); // Dist 2 Walk (Basestruct/Walls) X-scaled
if (arrDraw[26] != _u) draw_sprite_ext(arrDraw[26],_imgInd,_dvX+_1214w								,_dvY+_1214h							,-1,-1,_rot,_col,_alpha); // Dist 2 Walk (Basestruct/Walls) X-scaled & Y-scaled
shader_reset();

fncPalswapset(_palSprCorr,_palSprImgInd,_palSprIndex,_palSrc);
if (arrDraw[27] != _u) draw_sprite_ext(arrDraw[27],_imgInd,_dvX+((_02w+_46w+_810w)*2)+_1214w+_infW	,_dvY+_1214h							, 1, 1,_rot,_col,_alpha); // Dist 2 Walk (Basestruct/Intersection)
if (arrDraw[27] != _u) draw_sprite_ext(arrDraw[27],_imgInd,_dvX+((_02w+_46w+_810w)*2)+_1214w+_infW	,_dvY+_1214h							, 1,-1,_rot,_col,_alpha); // Dist 2 Walk (Basestruct/Intersection) Y-scaled
if (arrDraw[28] != _u) draw_sprite_ext(arrDraw[28],_imgInd,_dvX+_1214w								,_dvY+_1214h							,-1, 1,_rot,_col,_alpha); // Dist 2 Walk (Basestruct/Intersection) X-scaled
if (arrDraw[28] != _u) draw_sprite_ext(arrDraw[28],_imgInd,_dvX+_1214w								,_dvY+_1214h							,-1,-1,_rot,_col,_alpha); // Dist 2 Walk (Basestruct/Intersection) X-scaled & Y-scaled
if (arrDraw[29] != _u) draw_sprite_ext(arrDraw[29],_imgInd,_dvX+_1315w								,_dvY+_1315h							, 1, 1,_rot,_col,_alpha); // Dist 2 Walk (Fixed/CF)
if (arrDraw[29] != _u) draw_sprite_ext(arrDraw[29],_imgInd,_dvX+_1315w								,_dvY+((_13h+_57h+_911h)*2)+_1315h+_infH, 1,-1,_rot,_col,_alpha); // Dist 2 Walk (Fixed/CF) Y-scaled
if (arrDraw[29] != _u) draw_sprite_ext(arrDraw[29],_imgInd,_dvX+_1315w								,_dvY+_1315h							,-1, 1,_rot,_col,_alpha); // Dist 2 Walk (Fixed/CF) X-scaled
if (arrDraw[29] != _u) draw_sprite_ext(arrDraw[29],_imgInd,_dvX+_1315w								,_dvY+((_13h+_57h+_911h)*2)+_1315h+_infH,-1,-1,_rot,_col,_alpha); // Dist 2 Walk (Fixed/CF) X-scaled & Y-scaled
shader_reset();

fncPalswapset(_palSprWall,_palSprImgInd,_palSprIndex,_palSrc);
if (arrDraw[30] != _u) draw_sprite_ext(arrDraw[30],_imgInd,_dvX+(_dvW/2)-1							,_dvY+_be1h								, 1, 1,_rot,_col,_alpha); // Dist 2 Beye (Basestruct/Walls)
if (arrDraw[30] != _u) draw_sprite_ext(arrDraw[30],_imgInd,_dvX+(_dvW/2)-1							,_dvY+_be1h								, 1,-1,_rot,_col,_alpha); // Dist 2 Beye (Basestruct/Walls) Y-scaled
if (arrDraw[31] != _u) draw_sprite_ext(arrDraw[31],_imgInd,_dvX+(_dvW/2)+1							,_dvY+_be1h								,-1, 1,_rot,_col,_alpha); // Dist 2 Beye (Basestruct/Walls) X-scaled
if (arrDraw[31] != _u) draw_sprite_ext(arrDraw[31],_imgInd,_dvX+(_dvW/2)+1							,_dvY+_be1h								,-1,-1,_rot,_col,_alpha); // Dist 2 Beye (Basestruct/Walls) X-scaled & Y-scaled
if (arrDraw[32] != _u) draw_sprite_ext(arrDraw[32],_imgInd,_dvX+(_dvW/2)							,_dvY+_dvH-(_911h+_1315h+(_16h/2))		, 1, 1,_rot,_col,_alpha); // Dist 2 Beye (Passages)
if (arrDraw[32] != _u) draw_sprite_ext(arrDraw[32],_imgInd,_dvX+(_dvW/2)							,_dvY+_dvH-(_911h+_1315h+(_16h/2))		,-1, 1,_rot,_col,_alpha); // Dist 2 Beye (Passages) X-scaled
shader_reset();

if (arrDraw[33] != _u) draw_sprite_ext(arrDraw[33],_imgInd,_dvX+(_dvW/2)							,_dvY+(_dvH/2)							, 1, 1,_rot,_col,_alpha); // Dist 2 Beye (Decor)
if (arrDraw[34] != _u) draw_sprite_ext(arrDraw[34],_imgInd,_dvX+((_02w+_46w)*2)+_810w+_1214w+_infW	,_dvY+((_dvH-_16h)/2)					, 1, 1,_rot,_col,_alpha); // Dist 2 Walk (Decor)
if (arrDraw[35] != _u) draw_sprite_ext(arrDraw[35],_imgInd,_dvX+_810w+_1214w						,_dvY+((_dvH-_16h)/2)					,-1, 1,_rot,_col,_alpha); // Dist 2 Walk (Decor) X-scaled
if (arrDraw[36] != _u) draw_sprite_ext(arrDraw[36],_imgInd,_dvX+(_dvW/2)							,_dvY+(_dvH/2)							, 1, 1,_rot,_col,_alpha); // Dist 2 Beye (Objects)



// Dist 1
fncPalswapset(_palSprWall,_palSprImgInd,_palSprIndex,_palSrc);
if (arrDraw[37] != _u) draw_sprite_ext(arrDraw[37],_imgInd,_dvX+((_02w+_46w+_810w+_1214w)*2)+_infW	,_dvY+_1214h							, 1, 1,_rot,_col,_alpha); // Dist 1 Walk (Basestruct/Walls)
if (arrDraw[37] != _u) draw_sprite_ext(arrDraw[37],_imgInd,_dvX+((_02w+_46w+_810w+_1214w)*2)+_infW	,_dvY+_1214h							, 1,-1,_rot,_col,_alpha); // Dist 1 Walk (Basestruct/Walls) Y-scaled
if (arrDraw[38] != _u) draw_sprite_ext(arrDraw[38],_imgInd,_dvX										,_dvY+_1214h							,-1, 1,_rot,_col,_alpha); // Dist 1 Walk (Basestruct/Walls) X-scaled
if (arrDraw[38] != _u) draw_sprite_ext(arrDraw[38],_imgInd,_dvX										,_dvY+_1214h							,-1,-1,_rot,_col,_alpha); // Dist 1 Walk (Basestruct/Walls) X-scaled & Y-scaled
shader_reset();

fncPalswapset(_palSprCorr,_palSprImgInd,_palSprIndex,_palSrc);
if (arrDraw[39] != _u) draw_sprite_ext(arrDraw[39],_imgInd,_dvX+((_02w+_46w+_810w+_1214w)*2)+_infW	,_dvY+_1214h							, 1, 1,_rot,_col,_alpha); // Dist 1 Walk (Basestruct/Intersection)
if (arrDraw[39] != _u) draw_sprite_ext(arrDraw[39],_imgInd,_dvX+((_02w+_46w+_810w+_1214w)*2)+_infW	,_dvY+_1214h							, 1,-1,_rot,_col,_alpha); // Dist 1 Walk (Basestruct/Intersection) Y-scaled
if (arrDraw[40] != _u) draw_sprite_ext(arrDraw[40],_imgInd,_dvX										,_dvY+_1214h							,-1, 1,_rot,_col,_alpha); // Dist 1 Walk (Basestruct/Intersection) X-scaled
if (arrDraw[40] != _u) draw_sprite_ext(arrDraw[40],_imgInd,_dvX										,_dvY+_1214h							,-1,-1,_rot,_col,_alpha); // Dist 1 Walk (Basestruct/Intersection) X-scaled & Y-scaled
if (arrDraw[41] != _u) draw_sprite_ext(arrDraw[41],_imgInd,_dvX+_1315w								,_dvY									, 1, 1,_rot,_col,_alpha); // Dist 1 Walk (Fixed/CF)
if (arrDraw[41] != _u) draw_sprite_ext(arrDraw[41],_imgInd,_dvX+_1315w								,_dvY+((_13h+_57h+_911h+_1315h)*2)+_infH, 1,-1,_rot,_col,_alpha); // Dist 1 Walk (Fixed/CF) Y-scaled
if (arrDraw[41] != _u) draw_sprite_ext(arrDraw[41],_imgInd,_dvX+_1315w								,_dvY									,-1, 1,_rot,_col,_alpha); // Dist 1 Walk (Fixed/CF) X-scaled
if (arrDraw[41] != _u) draw_sprite_ext(arrDraw[41],_imgInd,_dvX+_1315w								,_dvY+((_13h+_57h+_911h+_1315h)*2)+_infH,-1,-1,_rot,_col,_alpha); // Dist 1 Walk (Fixed/CF) X-scaled & Y-scaled
if (arrDraw[42] != _u) draw_sprite_ext(arrDraw[42],      0,_dvX+_16w								,_dvY+((_13h+_57h+_911h+_1315h)*2)+_infH, 1, 1,_rot,_col,_alpha); // Dist 1 Walk (Fixed/Static)
if (arrDraw[42] != _u) draw_sprite_ext(arrDraw[42],      0,_dvX+_16w								,_dvY+((_13h+_57h+_911h+_1315h)*2)+_infH,-1, 1,_rot,_col,_alpha); // Dist 1 Walk (Fixed/Static) X-scaled
shader_reset();

fncPalswapset(_palSprWall,_palSprImgInd,_palSprIndex,_palSrc);
if (arrDraw[43] != _u) draw_sprite_ext(arrDraw[43],_imgInd,_dvX+(_dvW/2)-2							,_dvY+_be1h								, 1, 1,_rot,_col,_alpha); // Dist 1 Beye (Basestruct/Walls)
if (arrDraw[43] != _u) draw_sprite_ext(arrDraw[43],_imgInd,_dvX+(_dvW/2)-2							,_dvY+_be1h								, 1,-1,_rot,_col,_alpha); // Dist 1 Beye (Basestruct/Walls) Y-scaled
if (arrDraw[44] != _u) draw_sprite_ext(arrDraw[44],_imgInd,_dvX+(_dvW/2)+2							,_dvY+_be1h								,-1, 1,_rot,_col,_alpha); // Dist 1 Beye (Basestruct/Walls) X-scaled
if (arrDraw[44] != _u) draw_sprite_ext(arrDraw[44],_imgInd,_dvX+(_dvW/2)+2							,_dvY+_be1h								,-1,-1,_rot,_col,_alpha); // Dist 1 Beye (Basestruct/Walls) X-scaled & Y-scaled
if (arrDraw[45] != _u) draw_sprite_ext(arrDraw[45],_imgInd,_dvX+(_dvW/2)							,_dvY+_dvH-_16h							, 1, 1,_rot,_col,_alpha); // Dist 1 Beye (Passages)
if (arrDraw[45] != _u) draw_sprite_ext(arrDraw[45],_imgInd,_dvX+(_dvW/2)							,_dvY+_dvH-_16h							,-1, 1,_rot,_col,_alpha); // Dist 1 Beye (Passages) X-scaled
shader_reset();

if (arrDraw[46] != _u) draw_sprite_ext(arrDraw[46],_imgInd,_dvX+(_dvW/2)							,_dvY+(_dvH/2)							, 1, 1,_rot,_col,_alpha); // Dist 1 Beye (Decor)
if (arrDraw[47] != _u) draw_sprite_ext(arrDraw[47],_imgInd,_dvX+((_02w+_46w+_810w)*2)+_1214w+_infW	,_dvY+((_dvH-_16h)/2)					, 1, 1,_rot,_col,_alpha); // Dist 1 Walk (Decor)
if (arrDraw[48] != _u) draw_sprite_ext(arrDraw[48],_imgInd,_dvX+_1214w								,_dvY+((_dvH-_16h)/2)					,-1, 1,_rot,_col,_alpha); // Dist 1 Walk (Decor) X-scaled
if (arrDraw[49] != _u and !inTransition) draw_sprite_ext(arrDraw[49],_imgInd,_dvX+(_dvW/2)			,_dvY+(_dvH/2)							, 1, 1,_rot,_col,_alpha); // Dist 1 Beye (Objects)



// Turn
fncPalswapset(_palSprWall,_palSprImgInd,_palSprIndex,_palSrc);
if (arrDraw[_arrLen-6] != _u) draw_sprite_ext(arrDraw[_arrLen-6],_imgInd,_dvX+_turnW				,_dvY+_turnH-_16h						, 1, 1,_rot,_col,_alpha); // Turn Wall Right
if (arrDraw[_arrLen-6] != _u) draw_sprite_ext(arrDraw[_arrLen-6],_imgInd,_dvX+_turnW				,_dvY+_turnH-_16h						, 1,-1,_rot,_col,_alpha); // Turn Wall Right Y-scaled
if (arrDraw[_arrLen-5] != _u) draw_sprite_ext(arrDraw[_arrLen-5],_imgInd,_dvX+_turnW				,_dvY+_turnH-_16h						, 1, 1,_rot,_col,_alpha); // Turn Wall Left
if (arrDraw[_arrLen-5] != _u) draw_sprite_ext(arrDraw[_arrLen-5],_imgInd,_dvX+_turnW				,_dvY+_turnH-_16h						, 1,-1,_rot,_col,_alpha); // Turn Wall Left Y-scaled
shader_reset();

fncPalswapset(_palSprCorr,_palSprImgInd,_palSprIndex,_palSrc);
if (arrDraw[_arrLen-4] != _u) draw_sprite_ext(arrDraw[_arrLen-4],_imgInd,_dvX+_turnW				,_dvY+_turnH-_16h						, 1, 1,_rot,_col,_alpha); // Turn CF Right
if (arrDraw[_arrLen-4] != _u) draw_sprite_ext(arrDraw[_arrLen-4],_imgInd,_dvX+_turnW				,_dvY+_turnH-_16h						, 1,-1,_rot,_col,_alpha); // Turn CF Right Y-scaled
if (arrDraw[_arrLen-3] != _u) draw_sprite_ext(arrDraw[_arrLen-3],_imgInd,_dvX+_turnW				,_dvY+_turnH-_16h						, 1, 1,_rot,_col,_alpha); // Turn CF Left
if (arrDraw[_arrLen-3] != _u) draw_sprite_ext(arrDraw[_arrLen-3],_imgInd,_dvX+_turnW				,_dvY+_turnH-_16h						, 1,-1,_rot,_col,_alpha); // Turn CF Left Y-scaled
shader_reset();



// Room
fncPalswapset(_palSprWall,_palSprImgInd,_palSprIndex,_palSrc);
if (arrDraw[_arrLen-2] != _u) draw_sprite_ext(arrDraw[_arrLen-2],      0,_dvX						,_dvY									, 1, 1,_rot,_col,_alpha); // Room Wall
shader_reset();

fncPalswapset(_palSprCorr,_palSprImgInd,_palSprIndex,_palSrc);
if (arrDraw[_arrLen-1] != _u) draw_sprite_ext(arrDraw[_arrLen-1],      0,_dvX						,_dvY+_dvH								, 1, 1,_rot,_col,_alpha); // Room CF
shader_reset();



if (lines) draw_sprite(sprLines,0,x,y);



if (global.debug > 0) {
	
	var _stateCurr = state[mCURR];
	var _action    = action;
	
	if (!inTransition and _stateCurr != STATE.ROOM and (_action == undefined or _action == ACTION.DOOR or _action == ACTION.CHEST)) {
		
		var _slotSize  = slotSize;
		var _slotStart = 3*_slotSize;
		var _mapCellX  = round((_dvX+_slotStart)/_slotSize);
		var _mapCellY  = round((_dvY+_slotStart)/_slotSize);
		var _mapLength = nSlots[mX];
		var _mapHeight = nSlots[mY];
		
		// Stretched minimap background
		draw_sprite_stretched(sprMapbackground,0,(_mapCellX*_slotSize)-1,(_mapCellY*_slotSize)-1,(_mapLength*(_slotSize))+1,(_mapHeight*(_slotSize))+1);
		
		// Fill/show minimap layer
		if (!layer_get_visible("Minimap")) minimap_create(lib.cat[CAT.DUNGEONS][currDung][currLvl],_mapCellX,_mapCellY,_mapLength,_mapHeight);
		
		if (global.debug > 1) {
			
			//var _fontSize = sprite_get_height(sprFont);
			
			//draw_text(_slotStart-1,(_mapHeight*(_slotSize))+(_fontSize*2),moveCounter);
			//draw_text(_slotStart-1,(_mapHeight*(_slotSize))+(_fontSize*3),modValue);
			//draw_text(_slotStart-1,(_mapHeight*(_slotSize))+(_fontSize*4),_palSprIndex);
			//draw_text(_slotStart-1,(_mapHeight*(_slotSize))+(_fontSize*5),action);
			//draw_text(_slotStart-1,(_mapHeight*(_slotSize))+(_fontSize*6),ds_stack_top(actionStack));
			
		}
		
	} else {
		
		// Clear/hide minimap layer
		if (layer_get_visible("Minimap")) minimap_remove();
		
	}
	
} else {
	
	// Clear/hide minimap layer
	if (layer_get_visible("Minimap")) minimap_remove();
	
}
