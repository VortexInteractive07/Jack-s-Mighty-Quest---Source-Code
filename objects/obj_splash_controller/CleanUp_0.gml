/// @description Memory & Audio Clean Up
if (audio_is_playing(splash_sound_inst)) {
    audio_stop_sound(splash_sound_inst);
}

draw_set_alpha(1.0);
draw_set_color(c_white);