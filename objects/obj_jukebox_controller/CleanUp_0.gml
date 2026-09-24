/// @description Clean Up Event: Prevent Audio Leaks

if (current_playing_track != -1 && audio_is_playing(current_playing_track)) {
    audio_stop_sound(current_playing_track);
}