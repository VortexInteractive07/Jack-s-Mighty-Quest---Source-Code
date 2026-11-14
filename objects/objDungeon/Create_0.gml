/// @desc Init dungeon

//show_debug_overlay(true);
lines = false;

// System access
input = noone;
lib   = noone;

// Dungeon view
dvX = 0;
dvY = 0;
dvW = 0;
dvH = 0;

viewUpdate = true;

// Input flags
inputR = 0;
inputL = 0;
inputD = 0;

// Movement controllers
walk        = [1,0,-1,0,0,-1,0,1]; // [XXXX YYYY]
turn		= [1,2, 3,0,3, 0,1,2]; // [LLLL RRRR]
moveCounter = 0;
modValue    = 3; // Change anim speed here
imgInd      = 0;
image_speed = 0;

// Action controllers
actionStack = ds_stack_create();
action      = undefined;
phase       = PHASE.ONE;

// Trap controllers
fallRate = 7;
fallAccl = 0.40;
fallMax  = 11;

// Room controllers
roomEntered = false;
roomVisited = false;

// Draw sprites array
arrDraw = array_create(56,undefined);

// Minimap slot size
slotSize = sprite_get_height(sprMaptiles);

// Palette controller
palette = array_create(DUNGPAL.length,undefined);

palette[DUNGPAL.WALL  ] = sprPalDungWall;
palette[DUNGPAL.CORR  ] = sprPalDungCorr;
palette[DUNGPAL.IMGIND] = sprite_get_number(sprPalDungCorr)/2;

// Start location
//scrStartArea(DUNGEON.LALACAVE   ,DUNGLVL.LVL1,DUNGCOLOUR.BLUEDARK,STATE.NORTH ,14,13);
//scrStartArea(DUNGEON.NAHARUCAVE ,DUNGLVL.LVL1,DUNGCOLOUR.DESERT  ,STATE.EAST , 9, 6);
//scrStartArea(DUNGEON.MEDUSACAVE ,DUNGLVL.LVL1,DUNGCOLOUR.BLUEDARK,STATE.NORTH,12,11);
scrStartArea(DUNGEON.MEDUSATOWER,DUNGLVL.LVL1,DUNGCOLOUR.ORANGE  ,STATE.NORTH, 8,13);

state[mCURR] = STATE.EXIT;
inTransition = true;

locXnew = 0;
locYnew = 0;
facingX = walk[state[mPREV]  ];
facingY = walk[state[mPREV]+4];

counter = 0;

// Init lib dependant variables
alarm[0] = 1;

var _snd = audio_play_sound(mus_dungeons, 1, true);
audio_sound_loop_start(_snd, 0.998);