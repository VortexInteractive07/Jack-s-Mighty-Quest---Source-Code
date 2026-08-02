/// @description Apply Saved Sound Gain Upon Entering Settings Room
if (variable_global_exists("settings")) {
    audio_master_gain(global.settings.mus_volume);
}