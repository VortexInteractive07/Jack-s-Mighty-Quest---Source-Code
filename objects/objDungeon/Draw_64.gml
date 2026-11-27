/// @desc Flashing player arrow

if (global.guidebook_open) {
    var _help_w = display_get_gui_width();
    var _help_h = display_get_gui_height();
    draw_set_color(c_black); draw_set_alpha(0.94); draw_rectangle(12, 12, _help_w - 12, _help_h - 12, false);
    draw_set_alpha(1); draw_set_color(c_aqua); draw_rectangle(12, 12, _help_w - 12, _help_h - 12, true);
    draw_set_color(c_yellow); draw_text(24, 22, string_lower("JMQ FIELD MANUAL  [F1 TO CLOSE]"));
    draw_set_color(c_white);
    draw_text(24, 46, string_lower("MOVE / TURN: ARROW KEYS"));
    draw_text(24, 62, string_lower("ACTION: FACE A CHEST OR DOOR, THEN PRESS A OR S"));
    draw_text(24, 78, string_lower("LOCKED DOORS NEED A DUNGEON KEY FROM A CHEST OR BATTLE"));
	draw_text(24, 94, string_lower("M: FLOOR MAP   WATCH FOR TRAPS AND LOCKED DOORS."));
    draw_text(24, _help_h - 32, string_lower("Press F1 again to return to the dungeon."));
    draw_set_color(c_white);
    exit;
}

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
draw_set_font(fnt_regular);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

if (dungeon_battle_active) {
	// Compact status card with readable meters; preserve the central dungeon view.
	var _status_x = 8;
	var _status_y = 8;
	var _status_w = 132;
	var _status_h = 112;
	draw_set_color(c_black); draw_rectangle(_status_x, _status_y, _status_x + _status_w, _status_y + _status_h, false);
	draw_set_color(c_aqua); draw_rectangle(_status_x, _status_y, _status_x + _status_w, _status_y + _status_h, true);
	draw_set_color(c_yellow); draw_text(_status_x + 8, _status_y + 6, "JACK");
	draw_set_color(c_white); draw_text(_status_x + 8, _status_y + 24, "HP " + string(dungeon_battle_hp));
	draw_set_color(make_color_rgb(48, 54, 62)); draw_rectangle(_status_x + 48, _status_y + 28, _status_x + 120, _status_y + 38, false);
	draw_set_color(dungeon_battle_hp <= 30 ? c_red : make_color_rgb(30, 210, 125));
	draw_rectangle(_status_x + 48, _status_y + 28, _status_x + 48 + (72 * clamp(dungeon_battle_hp / 100, 0, 1)), _status_y + 38, false);
	draw_set_color(c_white); draw_text(_status_x + 8, _status_y + 42, "MP " + string(dungeon_battle_mp));
	draw_set_color(make_color_rgb(48, 54, 62)); draw_rectangle(_status_x + 48, _status_y + 46, _status_x + 120, _status_y + 56, false);
	draw_set_color(make_color_rgb(70, 150, 255));
	draw_rectangle(_status_x + 48, _status_y + 46, _status_x + 48 + (72 * clamp(dungeon_battle_mp / 12, 0, 1)), _status_y + 56, false);
	draw_set_color(c_white);
	draw_text(_status_x + 8, _status_y + 66, "COINS " + string(global.dungeon_currency));
	draw_text(_status_x + 8, _status_y + 84, "KEYS " + string(global.dungeon_keys));

	var _cmd_x = max(_status_x + _status_w + 12, _gui_w - 190);
	var _cmd_y = 8;
	var _cmd_w = max(150, _gui_w - _cmd_x - 8);

	var _battle_labels = [];
	var _battle_title = "COMMAND";
	if (dungeon_battle_menu_mode == 0) {
		_battle_labels = ["FIGHT", "ACT", "ITEM", "SPARE", "FLEE"];
	} else if (dungeon_battle_menu_mode == 1) {
		_battle_title = "FIGHT";
		_battle_labels = ["QUICK STRIKE", "HEAVY BLOW", "PSI BLAST", "BACK"];
	} else if (dungeon_battle_menu_mode == 2) {
		_battle_title = "ACT";
		_battle_labels = ["CHECK", "CALM", "BACK"];
	} else {
		_battle_title = "ITEM";
		for (var _food_i = 0; _food_i < array_length(global.inventory_items); _food_i++) {
			var _food = global.inventory_items[_food_i];
			if (_food.category == "FOOD" && _food.quantity > 0) array_push(_battle_labels, _food.name + " x" + string(_food.quantity));
		}
		array_push(_battle_labels, "BACK");
	}
	var _cmd_h = 62 + (array_length(_battle_labels) * 16);
	draw_set_color(c_black); draw_rectangle(_cmd_x, _cmd_y, _cmd_x + _cmd_w, _cmd_y + _cmd_h, false);
	draw_set_color(c_aqua); draw_rectangle(_cmd_x, _cmd_y, _cmd_x + _cmd_w, _cmd_y + _cmd_h, true);
	draw_set_color(c_yellow); draw_text(_cmd_x + 8, _cmd_y + 5, string_lower(dungeon_enemy_name));
	draw_set_color(c_white); draw_text(_cmd_x + 8, _cmd_y + 21, "HP " + string(max(0, dungeon_enemy_hp)) + " / " + string(max(1, dungeon_enemy_max_hp)));
	draw_set_color(make_color_rgb(48, 54, 62)); draw_rectangle(_cmd_x + 8, _cmd_y + 36, _cmd_x + _cmd_w - 8, _cmd_y + 42, false);
	draw_set_color(c_red);
	draw_rectangle(_cmd_x + 8, _cmd_y + 36, _cmd_x + 8 + ((_cmd_w - 16) * clamp(dungeon_enemy_hp / max(1, dungeon_enemy_max_hp), 0, 1)), _cmd_y + 42, false);
	draw_set_color(c_aqua); draw_text(_cmd_x + 8, _cmd_y + 46, string_lower(_battle_title));
	for (var _opt_i = 0; _opt_i < array_length(_battle_labels); _opt_i++) {
		var _option_y = _cmd_y + 62 + (_opt_i * 16);
		if (_opt_i == dungeon_battle_selection) {
			draw_set_color(make_color_rgb(28, 36, 52));
			draw_rectangle(_cmd_x + 4, _option_y - 1, _cmd_x + _cmd_w - 4, _option_y + 15, false);
		}
		draw_set_color(_opt_i == dungeon_battle_selection ? c_yellow : c_white);
		draw_text(_cmd_x + 12, _option_y, string_lower((_opt_i == dungeon_battle_selection ? "> " : "  ") + _battle_labels[_opt_i]));
	}

	draw_set_color(c_black); draw_rectangle(18, _gui_h - 78, _gui_w - 18, _gui_h - 8, false);
	draw_set_color(c_aqua); draw_rectangle(18, _gui_h - 78, _gui_w - 18, _gui_h - 8, true);
	draw_set_color(c_white); draw_text_ext(28, _gui_h - 68, string_lower(dungeon_battle_message), 14, _gui_w - 56);
	draw_set_halign(fa_center);
	draw_set_color(c_gray); draw_text(_gui_w * 0.5, _gui_h - 24, "ARROWS: SELECT    ENTER: CONFIRM    ESC: COMMANDS");
	draw_set_halign(fa_left);
	draw_set_color(c_white);
} else if (global.dungeon_message_timer > 0) {
	draw_set_color(c_black); draw_set_alpha(0.92); draw_rectangle(8, _gui_h - 58, _gui_w - 8, _gui_h - 28, false);
	draw_set_alpha(1); draw_set_color(c_aqua); draw_rectangle(8, _gui_h - 58, _gui_w - 8, _gui_h - 28, true);
	draw_set_color(c_white); draw_text_ext(16, _gui_h - 52, string_lower(global.dungeon_message), 12, _gui_w - 32);
}

if (!dungeon_battle_active) {
	// Persistent exploration strip keeps resources and controls visible without covering the view.
	draw_set_color(c_black); draw_set_alpha(0.9); draw_rectangle(0, _gui_h - 24, _gui_w, _gui_h, false);
	draw_set_alpha(1); draw_set_color(c_aqua); draw_rectangle(0, _gui_h - 24, _gui_w, _gui_h - 23, false);
	draw_set_color(c_yellow); draw_text(10, _gui_h - 19, "COINS " + string(global.dungeon_currency) + "   KEYS " + string(global.dungeon_keys));
	draw_set_halign(fa_right); draw_set_color(c_gray);
	draw_text(_gui_w - 10, _gui_h - 19, "ARROWS MOVE/TURN   A/S INTERACT   M MAP   F1 HELP");
	draw_set_halign(fa_left); draw_set_color(c_white);
}

if (dungeon_map_open) {
	var _map_level = lib.cat[CAT.DUNGEONS][currDung][currLvl];
	var _map_rows = array_length(_map_level);
	var _map_cols = (_map_rows > 0) ? array_length(_map_level[0]) : 0;
	var _map_cell = max(5, min(10, floor(min((_gui_w - 32) / max(1, _map_cols), (_gui_h - 56) / max(1, _map_rows)))));
	var _map_w = _map_cols * _map_cell;
	var _map_h = _map_rows * _map_cell;
	var _map_x = floor((_gui_w - _map_w) * 0.5);
	var _map_y = floor((_gui_h - _map_h) * 0.5) + 6;
	draw_set_color(c_black); draw_set_alpha(0.96);
	draw_rectangle(8, 8, _gui_w - 8, _gui_h - 8, false);
	draw_set_alpha(1); draw_set_color(c_aqua);
	draw_rectangle(8, 8, _gui_w - 8, _gui_h - 8, true);
	draw_set_halign(fa_center); draw_set_color(c_yellow);
	draw_text(_gui_w * 0.5, 14, "FLOOR MAP  [M / ESC TO CLOSE]");
	for (var _map_yi = 0; _map_yi < _map_rows; _map_yi++) {
		var _map_row = _map_level[_map_yi];
		if (!is_array(_map_row)) continue;
		for (var _map_xi = 0; _map_xi < min(_map_cols, array_length(_map_row)); _map_xi++) {
			var _map_slot = _map_row[_map_xi];
			if (!is_array(_map_slot)) continue;
			var _map_base = _map_slot[CONTSLOT.BASESTRUCT];
			var _map_object = _map_slot[CONTSLOT.OBJECT];
			var _map_passage = _map_slot[CONTSLOT.PASSAGE];
			var _tile_col = (_map_base == SLOT.WALL || _map_base == SLOT.WALLFAKE) ? make_color_rgb(45, 50, 62) : make_color_rgb(22, 32, 42);
			if (_map_base == SLOT.CORRIDORTRAP) _tile_col = make_color_rgb(120, 48, 40);
			if (_map_object == SLOT.CHEST) _tile_col = make_color_rgb(150, 112, 30);
			if (_map_passage == SLOT.STAIRSUP || _map_passage == SLOT.STAIRSDOWN) _tile_col = make_color_rgb(45, 105, 120);
			var _tile_x = _map_x + (_map_xi * _map_cell);
			var _tile_y = _map_y + (_map_yi * _map_cell);
			draw_set_color(_tile_col);
			draw_rectangle(_tile_x, _tile_y, _tile_x + _map_cell - 1, _tile_y + _map_cell - 1, false);
			if (_map_xi == locX && _map_yi == locY) {
				draw_set_color(c_yellow);
				draw_rectangle(_tile_x, _tile_y, _tile_x + _map_cell - 1, _tile_y + _map_cell - 1, true);
			}
		}
	}
	var _map_face = (facingY < 0) ? "^" : ((facingY > 0) ? "v" : ((facingX < 0) ? "<" : ">"));
	draw_set_color(c_yellow); draw_text(_map_x + (locX * _map_cell), _map_y + (locY * _map_cell), _map_face);
	draw_set_halign(fa_left); draw_set_color(c_white);
}

if (global.debug > 0) {
	
	var _stateCurr = state[mCURR];
	var _statePrev = state[mPREV];
	var _action    = action;
	
	if (!inTransition and _stateCurr != STATE.ROOM and (_action == undefined or _action == ACTION.DOOR or _action == ACTION.CHEST)) {
		
		var _slotSize  = sprite_get_height(sprMaptiles);
		var _mapX      = mapOriginX * _slotSize;
		var _mapY      = mapOriginY * _slotSize;
		
		if (counter < 16) {
			
			switch (_stateCurr) {
				
				case STATE.EAST:
				case STATE.NORTH:
				case STATE.WEST:
				case STATE.SOUTH: draw_sprite(sprMaparrow,_stateCurr,_mapX+(locX*_slotSize),_mapY+(locY*_slotSize)); break;
				default:          draw_sprite(sprMaparrow,_statePrev,_mapX+(locX*_slotSize),_mapY+(locY*_slotSize));
				
			}
			
		}
		
	}
	
}

if (variable_global_exists("save_write_failed") && global.save_write_failed) {
	draw_set_halign(fa_center);
	draw_set_color(c_red);
	draw_text(display_get_gui_width() * 0.5, 4, "AUTOSAVE FAILED - CHECK SAVE FOLDER");
	draw_set_halign(fa_left);
	draw_set_color(c_white);
}
