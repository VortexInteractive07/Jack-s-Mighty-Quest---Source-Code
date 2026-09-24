/// @function scr_play_level_music(_room_id, _target_vol);
/// @description External OST handler. Plays the specified track for the active stage.
/// @param {Asset.GMRoom} _room_id Target room asset identifier.
/// @param {Real} _target_vol Normalized audio gain level (0.0 to 1.0).
/// @return {Sound} Dynamic audio handle pointing to active stream instance.

function scr_play_level_music(_room_id, _target_vol) {
    var _ost_track = -1;

    // --- Dynamic Room to Track Routing (Easily Extendable/Modifiable) ---
    switch (_room_id) {
        case rm_subway:
            _ost_track = mus_subway;
            break;

        case rm_city:
            _ost_track = mus_city;
            break;

        case rm_boss:
            _ost_track = mus_ranga_dhun_yeh;
            break;

        default:
            // Fallback track for unassigned stages
            _ost_track = mus_subway;
            break;
    }

    if (!audio_exists(_ost_track)) {
        return -1;
    }

    // Play or maintain continuous playback if track is already active
    var _handle = -1;
    if (!audio_is_playing(_ost_track)) {
        _handle = audio_play_sound(_ost_track, 10, true);
        audio_sound_gain(_ost_track, _target_vol, 0);
    } else {
        _handle = _ost_track;
        audio_sound_gain(_ost_track, _target_vol, 0);
    }

    return _handle;
}