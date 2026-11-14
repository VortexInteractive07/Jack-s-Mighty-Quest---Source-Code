/// Escape returns to the city stage.
if (font_exists(bitmapFont)) font_delete(bitmapFont);
if (instance_exists(input_controller)) with (input_controller) instance_destroy();
if (instance_exists(dungeon_library)) with (dungeon_library) instance_destroy();
if (instance_exists(dungeon_engine)) with (dungeon_engine) instance_destroy();
room_goto(rm_city);
