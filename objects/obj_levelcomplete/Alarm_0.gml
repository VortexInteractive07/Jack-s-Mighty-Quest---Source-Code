/// @description Room Transition Delay Execution

// Stop stage BGM if still playing
if (asset_get_index("mus_subway") != -1) {
    var _bgm = asset_get_index("mus_subway");
    if (audio_is_playing(_bgm)) {
        audio_stop_sound(_bgm);
    }
}

// Stop victory jingle instance if still playing
if (level_audio_id != -1 && audio_is_playing(level_audio_id)) {
    audio_stop_sound(level_audio_id);
}

// Stop tally sound if still playing
if (snd_tally_tick_handle != -1 && audio_is_playing(snd_tally_tick_handle)) {
    audio_stop_sound(snd_tally_tick_handle);
}

// Transition to the target room
if (room_exists(target_level)) {
    room_goto(target_level);
}