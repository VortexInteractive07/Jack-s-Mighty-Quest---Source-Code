/// @description Clean Up Sound & Particle Memory On Level Unload

if (part_system_exists(sys_particles)) {
    part_system_destroy(sys_particles);
}

if (bgm_handle != -1 && audio_is_playing(bgm_handle)) {
    audio_stop_sound(bgm_handle);
    bgm_handle = -1;
}

if (game_over_music_id != -1 && audio_is_playing(game_over_music_id)) {
    audio_stop_sound(game_over_music_id);
}

if (life_lost_audio_id != -1 && audio_is_playing(life_lost_audio_id)) {
    audio_stop_sound(life_lost_audio_id);
}