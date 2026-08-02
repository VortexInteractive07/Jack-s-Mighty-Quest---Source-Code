/// @description Crash-Proof Resource Cleanup

// 1. Surface Memory Cleanup (Prevents VRAM leaks from the video renderer fix)
if (variable_instance_exists(id, "vid_surf") && surface_exists(vid_surf)) {
    surface_free(vid_surf);
}

// 2. Native Video Player Cleanup
if (variable_instance_exists(id, "play_mode") && play_mode == 0) {
    video_close();
}

// 3. Audio Cleanup
if (variable_instance_exists(id, "audio_played") && variable_instance_exists(id, "end_sequence_audio")) {
    if (audio_played && audio_exists(end_sequence_audio) && audio_is_playing(end_sequence_audio)) {
        audio_stop_sound(end_sequence_audio);
    }
}