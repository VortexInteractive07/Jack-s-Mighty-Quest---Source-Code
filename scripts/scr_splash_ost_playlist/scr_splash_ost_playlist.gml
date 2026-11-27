/// @function scr_splash_ost_playback()
/// @description Selects the splash tracks from the canonical jukebox playlist so lyrics stay in sync.
function scr_splash_ost_playback() {
    var _jukebox_tracks = scr_jukebox_ost_playlist();
    var _splash_sounds = [
        mus_monaigaa_alhavaa,
        mus_oafaraaiy_thah_ginavefaa,
        mus_reythi_aadha,
        mus_beru_alhavaa,
        mus_beyond_the_iron_cage,
        mus_raalhehge_monaigaa,
        mus_monaigaa_hithaa,
        mus_rey_kanda_gais,
        mus_reythi_reyge_balaalumey,
        mus_mage_maaladivaina,
        mus_fraying_string,
        mus_nil_diyawela,
        mus_seal_the_fountain
    ];
    var _splash_playlist = [];

    for (var _track_i = 0; _track_i < array_length(_jukebox_tracks); _track_i++) {
        var _track = _jukebox_tracks[_track_i];
        if (array_get_index(_splash_sounds, _track.sound) >= 0) {
            array_push(_splash_playlist, _track);
        }
    }

    return _splash_playlist;
}