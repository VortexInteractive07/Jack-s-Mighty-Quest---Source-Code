/// @description Clean Up Sound & Particle Memory On Level Unload

if (part_system_exists(sys_particles)) {
    part_system_destroy(sys_particles);
}

if (bgm_handle != -1 && audio_is_playing(bgm_handle)) {
    audio_stop_sound(bgm_handle);
    bgm_handle = -1;
}