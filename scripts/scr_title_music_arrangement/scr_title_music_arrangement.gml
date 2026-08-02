function scr_title_music_arrangement() {
    // Check local system date
    var _current_month = date_get_month(date_current_datetime());
    var _current_day   = date_get_day(date_current_datetime());

    // =================================================================
    // JULY 26TH INDEPENDENCE DAY EXCLUSIVITY OVERRIDE
    // =================================================================
if (_current_month == 7 && _current_day == 26) {
        global.title_playlist = [
            mus_josheh_genaimee, // Independence Day Exclusivity #1
            mus_o_wazan,          // Independence Day Exclusivity #2
			mus_gaumah_aiy_minivan_nooraanee, // Independence Day Exclusivity #3
        ];
    }  
    // =================================================================
    // STANDARD TITLE PLAYLIST
    // =================================================================
    else {
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
			mus_moodhu_raalhahge_taalam
        ];
    }

    // Reset playlist position index
    global.current_song_index = 0;
}