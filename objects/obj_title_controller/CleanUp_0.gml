/// @description Clean Up Audio Instances & Dynamic Memory

if (audio_is_playing(current_sound_inst)) {
    audio_stop_sound(current_sound_inst);
}