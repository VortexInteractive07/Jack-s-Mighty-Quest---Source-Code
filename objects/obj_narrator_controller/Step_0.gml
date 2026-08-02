// Monitor playback safely down to the millisecond floating point
if (narrator_audio != -1 && audio_is_playing(narrator_audio)) {
    audio_track_pos = audio_sound_get_track_position(narrator_audio);
} else {
    // Complete track closure logic -> proceed to title screen execution
    if (room == rm_voice_mode || room == rm_splash) {
        room_goto(rm_title);
        instance_destroy();
    }
}