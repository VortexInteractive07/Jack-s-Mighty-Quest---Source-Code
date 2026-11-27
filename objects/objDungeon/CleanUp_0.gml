/// @desc Destroy stack

scr_save_slot_autosave();

if (ds_exists(actionStack,ds_type_stack)) ds_stack_destroy(actionStack);
if (dungeon_music_id != -1 && audio_is_playing(dungeon_music_id)) audio_stop_sound(dungeon_music_id);
