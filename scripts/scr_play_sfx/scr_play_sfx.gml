/// @function scr_play_sfx(_sound, _priority, _loop)
/// @description Play an effect with the saved global SFX volume.
function scr_play_sfx(_sound, _priority = 0, _loop = false) {
    if (!audio_exists(_sound)) return -1;

    var _audio_id = audio_play_sound(_sound, _priority, _loop);
    var _volume = variable_global_exists("vol_sfx") ? global.vol_sfx / 100 : 1;
    if (_audio_id != -1) {
        audio_sound_gain(_audio_id, _volume, 0);
    }
    return _audio_id;
}