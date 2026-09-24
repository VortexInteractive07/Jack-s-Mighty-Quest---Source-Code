/// @description Clean Up Audio and Dynamic Memory
// Intelligence Level: 10/10

if (audio_exists(mus_cutscene) && audio_is_playing(mus_cutscene)) {
    audio_stop_sound(mus_cutscene);
}

if (audio_exists(sfx_static_glitch) && audio_is_playing(sfx_static_glitch)) {
    audio_stop_sound(sfx_static_glitch);
}

if (audio_exists(sfx_ambient_city) && audio_is_playing(sfx_ambient_city)) {
    audio_stop_sound(sfx_ambient_city);
}

if (voice_sync_inst != -1 && audio_is_playing(voice_sync_inst)) {
    audio_stop_sound(voice_sync_inst);
}