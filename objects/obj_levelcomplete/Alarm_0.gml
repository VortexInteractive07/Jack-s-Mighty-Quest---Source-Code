/// @description Room Transition Delay Execution

// Stop all level audio channels cleanly
if (instance_exists(obj_controller)) {
    var _controller = instance_find(obj_controller, 0);
    _controller.stop_level_audio();
}

if (level_audio_id != -1 && audio_is_playing(level_audio_id)) {
    audio_stop_sound(level_audio_id);
}

if (snd_tally_tick_handle != -1 && audio_is_playing(snd_tally_tick_handle)) {
    audio_stop_sound(snd_tally_tick_handle);
}

// Transition to target room
if (room_exists(target_level)) {
    room_goto(target_level);
}