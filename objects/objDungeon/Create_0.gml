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
modValue    = 2; // Faster movement makes the tower less punishing to navigate.
imgInd      = 0;
image_speed = 0;

// Action controllers
actionStack = ds_stack_create();
action      = undefined;
phase       = PHASE.ONE;

// Trap controllers
fallRate = 10; // Give more time to react to dungeon trap floors.
fallAccl = 0.40;
fallMax  = 11;

// Room controllers
roomEntered = false;
roomVisited = false;

// Dungeon progression and battle state shared across dungeon floors.
if (!variable_global_exists("dungeon_keys")) global.dungeon_keys = 0;
if (!variable_global_exists("dungeon_currency")) global.dungeon_currency = 0;
if (!variable_global_exists("dungeon_message")) global.dungeon_message = "";
if (!variable_global_exists("dungeon_message_timer")) global.dungeon_message_timer = 0;
global.dungeon_message = "";
global.dungeon_message_timer = 0;
if (!variable_global_exists("inventory_items")) {
	global.inventory_items = [
		{ id: "ration", name: "Trail Ration", category: "FOOD", quantity: 2, heal: 35 },
		{ id: "sidearm", name: "Service Sidearm", category: "WEAPON", quantity: 1, heal: 0 },
		{ id: "plasma_buddy", name: "Plasma Buddy", category: "GADGET", quantity: 1, heal: 0 },
		{ id: "rounds", name: "Sidearm Rounds", category: "AMMUNITION", quantity: 8, heal: 0 }
	];
}
if (!variable_global_exists("inventory_add")) {
	global.inventory_add = function(_id, _name, _category, _amount) {
		var _items = global.inventory_items;
		for (var _i = 0; _i < array_length(_items); _i++) {
			if (_items[_i].id == _id) {
				_items[_i].quantity += max(1, _amount);
				global.inventory_items = _items;
				return _items[_i].quantity;
			}
		}
		array_push(global.inventory_items, { id: _id, name: _name, category: _category, quantity: max(1, _amount), heal: 0 });
		return max(1, _amount);
	};
}

dungeon_battle_active = false;
dungeon_battle_message = "";
dungeon_battle_selection = 0;
dungeon_battle_menu_mode = 0; // 0 command, 1 fight, 2 act, 3 item
dungeon_battle_spare_ready = false;
dungeon_map_open = false;
dungeon_battle_hp = 100;
dungeon_battle_mp = 12;
dungeon_enemy_hp = 0;
dungeon_enemy_max_hp = 0;
dungeon_enemy_name = "";
dungeon_enemy_attack = 8;
dungeon_enemy_reward = 10;
dungeon_battle_options = ["FIGHT", "ACT", "ITEM", "SPARE", "FLEE"];
// Roll only after completed steps and keep encounters spaced apart.
dungeon_encounter_chance_percent = 4;
dungeon_encounter_cooldown_steps = 0;
dungeon_result_pause_frames = max(1, round(game_get_speed(gamespeed_fps) * 1.25));
dungeon_flee_pause_frames = max(1, round(game_get_speed(gamespeed_fps) * 0.5));

start_dungeon_battle = function() {
	if (dungeon_battle_active || global.dungeon_message_timer > 0) return;
	lines = false;
	var _monsters = ["CAVE SLIME", "WINGED FIEND", "DARK SOLDIER", "TOWER WYRM"];
	dungeon_enemy_name = _monsters[irandom(array_length(_monsters) - 1)];
	dungeon_enemy_hp = irandom_range(28, 48);
	dungeon_enemy_max_hp = dungeon_enemy_hp;
	dungeon_enemy_attack = irandom_range(6, 12);
	dungeon_enemy_reward = irandom_range(8, 18);
	dungeon_battle_selection = 0;
	dungeon_battle_menu_mode = 0;
	dungeon_battle_spare_ready = false;
	dungeon_battle_options = ["FIGHT", "ACT", "ITEM", "SPARE", "FLEE"];
	dungeon_battle_message = "A " + string_lower(dungeon_enemy_name) + " draws near!\nCommand?";
	dungeon_battle_active = true;
};

dungeon_set_message = function(_text) {
	global.dungeon_message = _text;
	global.dungeon_message_timer = 240;
};

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

if (variable_global_exists("pending_game_restore") && is_struct(global.pending_game_restore)
&& global.pending_game_restore.room_asset == rm_dungeons
&& variable_struct_exists(global.pending_game_restore, "dungeon_id")
&& variable_struct_exists(global.pending_game_restore, "dungeon_level")
&& variable_struct_exists(global.pending_game_restore, "dungeon_x")
&& variable_struct_exists(global.pending_game_restore, "dungeon_y")
&& variable_struct_exists(global.pending_game_restore, "dungeon_facing")
&& is_real(global.pending_game_restore.dungeon_x)
&& is_real(global.pending_game_restore.dungeon_y)
&& is_real(global.pending_game_restore.dungeon_facing)) {
	var _save_dung = global.pending_game_restore.dungeon_id;
	var _save_level = global.pending_game_restore.dungeon_level;
	if (is_real(_save_dung) && floor(_save_dung) == _save_dung && _save_dung >= 0 && _save_dung < DUNGEON.length
	&& is_real(_save_level) && floor(_save_level) == _save_level && _save_level >= 0 && _save_level < DUNGLVL.length) {
		currDung = _save_dung;
		currLvl = _save_level;
		locX = max(0, floor(global.pending_game_restore.dungeon_x));
		locY = max(0, floor(global.pending_game_restore.dungeon_y));
		state[mPREV] = clamp(global.pending_game_restore.dungeon_facing, STATE.EAST, STATE.SOUTH);
	}
	if (variable_struct_exists(global.pending_game_restore, "hp") && is_real(global.pending_game_restore.hp)) dungeon_battle_hp = clamp(global.pending_game_restore.hp, 1, 100);
	if (variable_struct_exists(global.pending_game_restore, "dungeon_mp") && is_real(global.pending_game_restore.dungeon_mp)) dungeon_battle_mp = clamp(global.pending_game_restore.dungeon_mp, 0, 12);
	if (variable_struct_exists(global.pending_game_restore, "dungeon_keys") && is_real(global.pending_game_restore.dungeon_keys)) global.dungeon_keys = max(0, global.pending_game_restore.dungeon_keys);
	if (variable_struct_exists(global.pending_game_restore, "dungeon_currency") && is_real(global.pending_game_restore.dungeon_currency)) global.dungeon_currency = max(0, global.pending_game_restore.dungeon_currency);
	global.pending_game_restore = undefined;
}
if (variable_global_exists("pending_game_restore") && is_struct(global.pending_game_restore)
&& global.pending_game_restore.room_asset == rm_dungeons) global.pending_game_restore = undefined;

state[mCURR] = STATE.EXIT;
inTransition = true;

locXnew = 0;
locYnew = 0;
facingX = walk[state[mPREV]  ];
facingY = walk[state[mPREV]+4];

counter = 0;

// Init lib dependant variables
alarm[0] = 1;

dungeon_music_id = audio_play_sound(mus_menu, 1, true);
if (dungeon_music_id != -1) {
	audio_sound_loop_start(dungeon_music_id, 0.998);
	if (variable_global_exists("vol_bgm")) audio_sound_gain(dungeon_music_id, global.vol_bgm / 100, 0);
}
