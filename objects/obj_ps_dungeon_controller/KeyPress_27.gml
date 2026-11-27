/// During encounters, escape is a battle command; do not leave the dungeon.
if (instance_exists(dungeon_engine) && dungeon_engine.dungeon_map_open) {
	dungeon_engine.dungeon_map_open = false;
	exit;
}
if (instance_exists(dungeon_engine) && dungeon_engine.dungeon_battle_active) {
	dungeon_engine.dungeon_battle_message = "Choose RUN from the command menu to escape.";
	exit;
}

/// Escape returns to the city stage outside battle.
if (instance_exists(input_controller)) with (input_controller) instance_destroy();
if (instance_exists(dungeon_library)) with (dungeon_library) instance_destroy();
if (instance_exists(dungeon_engine)) with (dungeon_engine) instance_destroy();
room_goto(rm_city);
