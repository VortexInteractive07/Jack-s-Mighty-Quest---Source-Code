/// @description Activate this checkpoint when Jack touches it.
if (!variable_global_exists("checkpoint_room") || global.checkpoint_room != room || global.checkpoint_x != x || global.checkpoint_y != y) {
    global.checkpoint_room = room;
    global.checkpoint_x = x;
    global.checkpoint_y = y;
    if (audio_exists(sfx_dialogue_continue)) audio_play_sound(sfx_dialogue_continue, 5, false);
    show_debug_message("Checkpoint activated in " + string(room));
}

