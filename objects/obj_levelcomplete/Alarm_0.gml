/// @description Room Transition Delay Execution

// Stop all level audio channels cleanly
if (audio_is_playing(mus_subway)) {
    audio_stop_sound(mus_subway);
}

if (level_audio_id != -1 && audio_is_playing(level_audio_id)) {
    audio_stop_sound(level_audio_id);
}

if (snd_tally_tick_handle != -1 && audio_is_playing(snd_tally_tick_handle)) {
    audio_stop_sound(snd_tally_tick_handle);
}

// Transition to target room
if (room == rm_boss && global.time_attack_active) {
    global.time_attack_result_ticks = global.time_attack_ticks;
    if (global.time_attack_best_ticks < 0 || global.time_attack_ticks < global.time_attack_best_ticks) {
        global.time_attack_best_ticks = global.time_attack_ticks;
        scr_save_settings();
    }
    global.time_attack_active = false;
}

if (room_exists(target_level)) {
    room_goto(target_level);
}
