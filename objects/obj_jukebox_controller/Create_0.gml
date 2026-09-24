/// @description Create Event: Initialize Jukebox Controller & Diagonal Scrolling Background

display_set_gui_size(432, 240);

sfx_dialogue_asset = sfx_dialogue;
sfx_continue_asset = sfx_dialogue_continue;

// Theme Palette
color_navy_dark  = make_color_rgb(10, 25, 47);
color_navy_light = make_color_rgb(20, 45, 80);
color_gold       = make_color_rgb(212, 175, 55);
color_gold_light = make_color_rgb(245, 222, 179);
color_platinum   = make_color_rgb(229, 228, 226);

// Playlist Definition
playlist = scr_jukebox_ost_playlist();

playlist_total = array_length(playlist);
selected_index = 0;
scroll_offset  = 0;
visible_max    = 5;

current_playing_track = -1;
current_playing_index = -1;
is_playing            = false;
playback_position     = 0;
audio_gain_val        = variable_global_exists("vol_bgm") ? (global.vol_bgm / 100) : 1.0;

// Diagonal Scrolling Background Variables
bg_x = 0;
bg_y = 0;
bg_speed_x = 1.0;
bg_speed_y = -1.0;

play_ui_blip = function(_sfx) {
    if (_sfx != -1 && audio_exists(_sfx)) {
        var _snd_vol = variable_global_exists("vol_sfx") ? (global.vol_sfx / 100) : 1.0;
        var _play = audio_play_sound(_sfx, 1, false);
        audio_sound_gain(_play, _snd_vol, 0);
    }
};

load_and_play_track = function(_index) {
    if (current_playing_track != -1 && audio_is_playing(current_playing_track)) {
        audio_stop_sound(current_playing_track);
    }
    
    selected_index = _index;
    var _track_data = playlist[selected_index];
    
    if (audio_exists(_track_data.sound)) {
        current_playing_track = audio_play_sound(_track_data.sound, 5, true);
        audio_sound_gain(current_playing_track, audio_gain_val, 0);
        current_playing_index = selected_index;
        is_playing = true;
        play_ui_blip(sfx_continue_asset);
    }
};

toggle_playback_state = function() {
    if (is_playing) {
        if (current_playing_track != -1 && audio_is_playing(current_playing_track)) {
            audio_pause_sound(current_playing_track);
        }
        is_playing = false;
    } else {
        if (current_playing_index == selected_index && current_playing_track != -1) {
            audio_resume_sound(current_playing_track);
            is_playing = true;
        } else {
            load_and_play_track(selected_index);
        }
    }
    play_ui_blip(sfx_dialogue_asset);
};

get_current_lyrics = function() {
    var _track = playlist[selected_index];
    
    // Check if lyrics exist on selected track
    if (!variable_struct_exists(_track, "lyrics") || !is_array(_track.lyrics) || array_length(_track.lyrics) == 0) {
        return "UH OH! THE SELECTED SONG DOESN'T HAVE LYRICS YET!";
    }
    
    if (!is_playing || current_playing_index != selected_index) {
        return "(Paused / Select to Play)";
    }

    var _arr = _track.lyrics;
    var _len = array_length(_arr);
    
    var _current_text = "";
    for (var i = 0; i < _len; i++) {
        if (playback_position >= _arr[i].time) {
            _current_text = _arr[i].text;
        } else {
            break;
        }
    }
    return _current_text == "" ? "..." : _current_text;
};

fade_alpha  = 1;
fade_speed  = 0.05;
fade_state  = 0;
target_room = rm_main_menu;