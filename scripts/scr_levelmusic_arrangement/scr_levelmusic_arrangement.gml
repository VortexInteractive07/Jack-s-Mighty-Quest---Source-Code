/// @function scr_levelmusic_arrangement()
/// @description Populates global.title_playlist with sound asset IDs
function scr_levelmusic_arrangement() {
    global.title_playlist = [
        mus_mujuraa,
        mus_mage_maaladivaina,
        mus_rey_kanda_gais,
        mus_nil_diyawela,
        mus_falhi_jahaa,
        mus_raalhehge_monaigaa,
        mus_alhavaa,
        mus_reythi_aadha,
        mus_reythi_reyge_balaalumey,
        mus_ranga_dhun_yeh,
        mus_monaigaa_hithaa,
        mus_moodhu_raalhahge_taalam,
        mus_monaigaa_alhavaa
    ];
}

/// @function scr_get_song_title(sound_id)
/// @param {Asset.GMSound} sound_id
/// @description Returns the formatted track display name for toast notifications
function scr_get_song_title(_sound) {
    if (!audio_exists(_sound)) return "UNKNOWN TRACK";

    switch (_sound) {
        case mus_mujuraa:               return "Mujuraa";
        case mus_mage_maaladivaina:     return "Mage Maaladivaina";
        case mus_rey_kanda_gais:        return "Rey Kanda Gais";
        case mus_nil_diyawela:          return "Nil Diyawela";
        case mus_falhi_jahaa:           return "Falhi Jahaa";
        case mus_raalhehge_monaigaa:    return "Raalhehge Monaigaa";
        case mus_alhavaa:               return "Alhavaa";
        case mus_reythi_aadha:          return "Reythi Aadha";
        case mus_reythi_reyge_balaalumey: return "Reythi Reyge Balaalumey";
        case mus_ranga_dhun_yeh:        return "Ranga Dhun Yeh";
        case mus_monaigaa_hithaa:       return "Monaigaa Hithaa";
        case mus_moodhu_raalhahge_taalam: return "Moodhu Raalhahge Taalam";
        case mus_monaigaa_alhavaa:      return "Monaigaa Alhavaa";

        default:
            // Fallback for any audio asset not explicitly mapped
            var _raw = audio_get_name(_sound);
            if (string_pos("mus_", _raw) == 1) _raw = string_delete(_raw, 1, 4);
            return string_upper(string_replace_all(_raw, "_", " "));
    }
}