/// @function scr_levelmusic_arrangement()
/// @description Populates global.title_playlist with sound asset IDs
function scr_levelmusic_arrangement() {
    global.title_playlist = [
        mus_mujuraa,               // Naifaru Dhohokkobe
        mus_dhaaru_ofu_maaiy,
        mus_naanaavee_seedhaa_loabi,
        mus_ofu_maaiy,    
        mus_dhuru_dhuru_gaavey,    // Holhudhoo Abdulla
        mus_kaaku_keenhey_kuree,
        mus_vadaigannavashey,
        mus_falhi_jahaa,           // PixelForge07
        mus_mage_maaladivaina,     // Sinhala
        mus_nil_diyawela,          
        mus_rey_kanda_gais,        // Monaigaa Alhavaa (PixelForge07)
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

/// @function scr_get_song_info(sound_id)
/// @param {Asset.GMSound} sound_id
/// @description Returns a struct containing title, artist_name, and artist_type
function scr_get_song_info(_sound) {
    var _info = {
        title: "UNKNOWN TRACK",
        artist_name: "Unknown Artist",
        artist_type: "composer" // "composer" or "artist"
    };

    if (!audio_exists(_sound)) return _info;

    switch (_sound) {
        // --- Naifaru Dhohokkobe ---
        case mus_mujuraa:
            _info.title = "Mujuraa";
            _info.artist_name = "Naifaru Dhohokkobe";
            _info.artist_type = "artist";
            break;

        case mus_dhaaru_ofu_maaiy:
            _info.title = "Dhaaru Ofu Maaiy";
            _info.artist_name = "Naifaru Dhohokkobe";
            _info.artist_type = "artist";
            break;

        case mus_naanaavee_seedhaa_loabi:
            _info.title = "Naanaavee Seedhaa Loabi";
            _info.artist_name = "Naifaru Dhohokkobe";
            _info.artist_type = "artist";
            break;

        case mus_ofu_maaiy:
            _info.title = "Ofu Maaiy";
            _info.artist_name = "Naifaru Dhohokkobe";
            _info.artist_type = "artist";
            break;

        // --- Holhudhoo Abdulla ---
        case mus_dhuru_dhuru_gaavey:
            _info.title = "Dhuru Dhuru Gaavey";
            _info.artist_name = "Holhudhoo Abdulla";
            _info.artist_type = "artist";
            break;

        case mus_kaaku_keenhey_kuree:
            _info.title = "Kaaku Keenhey Kuree";
            _info.artist_name = "Holhudhoo Abdulla";
            _info.artist_type = "artist";
            break;

        case mus_vadaigannavashey:
            _info.title = "Vadaigannavashey";
            _info.artist_name = "Holhudhoo Abdulla";
            _info.artist_type = "artist";
            break;

        // --- PixelForge07 Tracks ---
        case mus_falhi_jahaa:
            _info.title = "Falhi Jahaa";
            _info.artist_name = "PixelForge07";
            _info.artist_type = "composer";
            break;

        // --- Sinhala Tracks ---
        case mus_mage_maaladivaina:
            _info.title = "Mage Maaladivaina";
            _info.artist_name = "Sinhala Group";
            _info.artist_type = "artist";
            break;

        case mus_nil_diyawela:
            _info.title = "Nil Diyawela";
            _info.artist_name = "Sinhala Group";
            _info.artist_type = "artist";
            break;

        // --- Monaigaa Alhavaa Tracks (PixelForge07) ---
        case mus_rey_kanda_gais:
            _info.title = "Rey Kanda Gais";
            _info.artist_name = "PixelForge07";
            _info.artist_type = "composer";
            break;

        case mus_raalhehge_monaigaa:
            _info.title = "Raalhehge Monaigaa";
            _info.artist_name = "PixelForge07";
            _info.artist_type = "composer";
            break;

        case mus_alhavaa:
            _info.title = "Alhavaa";
            _info.artist_name = "PixelForge07";
            _info.artist_type = "composer";
            break;

        case mus_reythi_aadha:
            _info.title = "Reythi Aadha";
            _info.artist_name = "PixelForge07";
            _info.artist_type = "composer";
            break;

        case mus_reythi_reyge_balaalumey:
            _info.title = "Reythi Reyge Balaalumey";
            _info.artist_name = "PixelForge07";
            _info.artist_type = "composer";
            break;

        case mus_ranga_dhun_yeh:
            _info.title = "Ranga Dhun Yeh";
            _info.artist_name = "PixelForge07";
            _info.artist_type = "composer";
            break;

        case mus_monaigaa_hithaa:
            _info.title = "Monaigaa Hithaa";
            _info.artist_name = "PixelForge07";
            _info.artist_type = "composer";
            break;

        case mus_moodhu_raalhahge_taalam:
            _info.title = "Moodhu Raalhahge Taalam";
            _info.artist_name = "PixelForge07";
            _info.artist_type = "composer";
            break;

        case mus_monaigaa_alhavaa:
            _info.title = "Monaigaa Alhavaa";
            _info.artist_name = "PixelForge07";
            _info.artist_type = "composer";
            break;

        default:
            // Fallback for any audio asset not explicitly mapped
            var _raw = audio_get_name(_sound);
            if (string_pos("mus_", _raw) == 1) _raw = string_delete(_raw, 1, 4);
            _info.title = string_upper(string_replace_all(_raw, "_", " "));
            _info.artist_name = "Unknown Artist";
            _info.artist_type = "composer";
            break;
    }

    return _info;
}

/// @function scr_get_song_title(sound_id)
/// @param {Asset.GMSound} sound_id
/// @description Backwards compatibility wrapper that returns string title
function scr_get_song_title(_sound) {
    var _info = scr_get_song_info(_sound);
    return _info.title;
}