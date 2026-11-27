/// @desc Sprite engine

if (!variable_instance_exists(id, "autosave_timer")) autosave_timer = 0;
autosave_timer++;
if (autosave_timer >= max(1, floor(game_get_speed(gamespeed_fps) * 0.5))) {
	autosave_timer = 0;
	scr_save_slot_autosave();
}

if (keyboard_check_pressed(vk_f1)) global.guidebook_open = !global.guidebook_open;
if (global.guidebook_open) exit;

if (!dungeon_battle_active && global.dungeon_message_timer <= 0 && keyboard_check_pressed(ord("M"))) {
	dungeon_map_open = !dungeon_map_open;
	exit;
}
if (dungeon_map_open) exit;

if (global.dungeon_message_timer > 0) {
	global.dungeon_message_timer--;
	if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) global.dungeon_message_timer = 0;
	if (global.dungeon_message_timer > 0) exit;
}

if (dungeon_battle_active) {
	var _nav_left = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));
	var _nav_right = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
	var _nav_up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
	var _nav_down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
	if (_nav_left || _nav_up) dungeon_battle_selection = max(0, dungeon_battle_selection - 1);
	if (_nav_right || _nav_down) dungeon_battle_selection++;
	var _option_count = dungeon_battle_menu_mode == 0 ? 5 : (dungeon_battle_menu_mode == 1 ? 4 : (dungeon_battle_menu_mode == 2 ? 3 : 1));
	if (dungeon_battle_menu_mode == 3) {
		for (var _count_i = 0; _count_i < array_length(global.inventory_items); _count_i++) {
			if (global.inventory_items[_count_i].category == "FOOD" && global.inventory_items[_count_i].quantity > 0) _option_count++;
		}
	}
	dungeon_battle_selection = clamp(dungeon_battle_selection, 0, max(0, _option_count - 1));

	if (keyboard_check_pressed(vk_escape)) {
		dungeon_battle_menu_mode = 0;
		dungeon_battle_selection = 0;
		dungeon_battle_message = "Choose FLEE from the command menu to escape.";
	}

	if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
		var _turn_taken = false;
		var _fled = false;
		var _action_message = "";
		var _item_list = global.inventory_items;
		if (dungeon_battle_menu_mode == 0) {
			switch (dungeon_battle_selection) {
				case 0: dungeon_battle_menu_mode = 1; dungeon_battle_selection = 0; dungeon_battle_message = "Choose your attack."; break;
				case 1: dungeon_battle_menu_mode = 2; dungeon_battle_selection = 0; dungeon_battle_message = "Choose an action."; break;
				case 2: dungeon_battle_menu_mode = 3; dungeon_battle_selection = 0; dungeon_battle_message = "Choose an item."; break;
				case 3:
					if (dungeon_battle_spare_ready) {
						var _spare_coins = max(3, floor(dungeon_enemy_reward / 2));
						global.dungeon_currency += _spare_coins;
						dungeon_battle_active = false;
						dungeon_battle_message = dungeon_enemy_name + " is spared. Earned " + string(_spare_coins) + " coins.";
						global.dungeon_message = dungeon_battle_message;
						global.dungeon_message_timer = dungeon_result_pause_frames;
					} else {
						_action_message = dungeon_enemy_name + " is not ready to be spared.";
						_turn_taken = true;
					}
					break;
				case 4:
					if (irandom(99) < 55) {
						dungeon_battle_active = false;
						_fled = true;
						dungeon_battle_message = "You escaped safely.";
						global.dungeon_message = dungeon_battle_message;
						global.dungeon_message_timer = dungeon_flee_pause_frames;
					} else {
					_action_message = "You could not escape!";
					_turn_taken = true;
					}
					break;
			}
		} else if (dungeon_battle_menu_mode == 1) {
			switch (dungeon_battle_selection) {
				case 0:
					var _strike = irandom_range(12, 20);
					dungeon_enemy_hp -= _strike;
					_action_message = "Quick Strike deals " + string(_strike) + " damage!";
					_turn_taken = true;
					break;
				case 1:
					var _heavy = irandom_range(18, 28);
					dungeon_enemy_hp -= _heavy;
					_action_message = "Heavy Blow deals " + string(_heavy) + " damage!";
					_turn_taken = true;
					break;
				case 2:
					if (dungeon_battle_mp >= 3) {
						dungeon_battle_mp -= 3;
						var _blast = irandom_range(20, 30);
						dungeon_enemy_hp -= _blast;
						_action_message = "PSI Blast deals " + string(_blast) + " damage!";
						_turn_taken = true;
					} else dungeon_battle_message = "Not enough PSI energy!";
					break;
				case 3: dungeon_battle_menu_mode = 0; dungeon_battle_selection = 0; break;
			}
		} else if (dungeon_battle_menu_mode == 2) {
			switch (dungeon_battle_selection) {
				case 0:
					_action_message = dungeon_enemy_name + " HP " + string(max(0, dungeon_enemy_hp)) + ". Attack " + string(dungeon_enemy_attack) + ".";
					dungeon_battle_message = _action_message;
					dungeon_battle_spare_ready = (dungeon_enemy_hp <= 24);
					break;
				case 1:
					dungeon_battle_spare_ready = true;
					dungeon_enemy_attack = max(2, dungeon_enemy_attack - 2);
					_action_message = "You calm " + dungeon_enemy_name + ". It is ready to be spared.";
					_turn_taken = true;
					break;
				case 2: dungeon_battle_menu_mode = 0; dungeon_battle_selection = 0; break;
			}
		} else {
			var _food_indices = [];
			for (var _food_i = 0; _food_i < array_length(_item_list); _food_i++) {
				if (_item_list[_food_i].category == "FOOD" && _item_list[_food_i].quantity > 0) array_push(_food_indices, _food_i);
			}
			if (dungeon_battle_selection >= array_length(_food_indices)) {
				dungeon_battle_menu_mode = 0;
				dungeon_battle_selection = 0;
			} else {
				var _food_index = _food_indices[dungeon_battle_selection];
				var _food = _item_list[_food_index];
				var _heal = variable_struct_exists(_food, "heal") ? _food.heal : 35;
				dungeon_battle_hp = min(100, dungeon_battle_hp + _heal);
				_food.quantity--;
				if (_food.quantity <= 0) global.inventory_items = array_delete(_item_list, _food_index, 1);
				_action_message = "You use " + _food.name + " and recover HP.";
				_turn_taken = true;
			}
		}

		if (dungeon_enemy_hp <= 0 && dungeon_battle_active) {
			var _coins = dungeon_enemy_reward;
			global.dungeon_currency += _coins;
			dungeon_battle_message = dungeon_enemy_name + " defeated! Earned " + string(_coins) + " coins.";
			if (irandom(99) < 18) {
				global.dungeon_keys++;
				global.inventory_add("dungeon_key", "Dungeon Key", "KEY", 1);
				dungeon_battle_message += " Found a dungeon key!";
			}
			dungeon_battle_active = false;
			global.dungeon_message = dungeon_battle_message;
			global.dungeon_message_timer = dungeon_result_pause_frames;
		} else if (_turn_taken && dungeon_battle_active) {
			var _damage = dungeon_enemy_attack + irandom(4);
			dungeon_battle_hp -= _damage;
			dungeon_battle_message = _action_message + " " + dungeon_enemy_name + " hits you for " + string(_damage) + ".";
			if (dungeon_battle_hp <= 0) {
				dungeon_battle_hp = 40;
				dungeon_battle_active = false;
				dungeon_battle_message = "You retreat, battered but alive. HP restored to 40.";
				global.dungeon_message = dungeon_battle_message;
				global.dungeon_message_timer = dungeon_result_pause_frames;
			}
		} else if (_fled) {
			dungeon_battle_message = "You escaped safely.";
		} else if (_action_message != "") {
			dungeon_battle_message = _action_message;
		}
	}
	exit;
}

if (alarm[0] > -1) exit;

scrDebug();

counter = (counter+1)&31;

switch (state[mCURR]) {
	
	// Cardinal direction
	case STATE.EAST:
	case STATE.NORTH:
	case STATE.WEST:
	case STATE.SOUTH: scrMain(state[mCURR]); break;
	
	// Execute action
	case STATE.ACTION: scrAction(); break;
	
	// Dungeon room
	case STATE.ROOM: scrRoom(); break;
	
	// Transition
	case STATE.EXIT: scrExit(); break;
	case STATE.INIT: scrInit(); break;
	
}
