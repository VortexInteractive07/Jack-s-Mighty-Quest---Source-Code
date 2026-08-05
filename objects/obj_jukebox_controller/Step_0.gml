/// @description Handle Navigation Matrix, Audio Dynamic Sync & UI Animations

ui_timer += 0.05;

var _up     = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var _down   = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var _left   = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));
var _right  = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
var _enter  = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
var _escape = keyboard_check_pressed(vk_escape);
var _stop   = keyboard_check_pressed(vk_backspace) || keyboard_check_pressed(ord("P"));

// Direct asset reference for UI sound
var _sfx_beep = sfx_textbox;

// Exit Protocol
if (_escape) {
    audio_stop_all();
    if (room_exists(rm_main_menu)) {
        room_goto(rm_main_menu);
    } else {
        game_restart();
    }
    exit;
}

// Global Stop Hook
if (_stop) {
    audio_stop_all();
    playing_track = noone;
    playing_asset = noone;
    now_playing_name = "None - Silence";
    current_lyric_text = "";
}

// --- Audio Equalizer Visualizer Processing ---
if (playing_track != noone && audio_is_playing(playing_track)) {
    for (var i = 0; i < 8; i++) {
        equalizer_heights[i] = lerp(equalizer_heights[i], random_range(2, 14), 0.3);
    }
} else {
    for (var i = 0; i < 8; i++) {
        equalizer_heights[i] = lerp(equalizer_heights[i], 0, 0.2);
    }
}

// --- Dynamic Lyric Sync System Runtime Check ---
if (playing_track != noone && audio_is_playing(playing_track)) {
    var _track_pos = audio_sound_get_track_position(playing_track);
    current_lyric_text = ""; 
    
    if (current_tab == 1 && songs_cursor < array_length(songs_list)) {
        var _song_struct = songs_list[songs_cursor];
        if (variable_struct_exists(_song_struct, "has_lyrics") && _song_struct.has_lyrics) {
            var _lyr_data = _song_struct.lyrics;
            var _len = array_length(_lyr_data);
            for (var i = 0; i < _len; i++) {
                if (_track_pos >= _lyr_data[i].time) {
                    current_lyric_text = _lyr_data[i].text;
                }
            }
        }
    }
}

// Tab Switching Matrix (0: OST, 1: SONGS, 2: SFX, 3: UNUSED)
if (_right) {
    current_tab = (current_tab + 1) % 4;
    if (audio_exists(_sfx_beep)) audio_play_sound(_sfx_beep, 1, false);
}
if (_left) {
    current_tab = (current_tab - 1 + 4) % 4;
    if (audio_exists(_sfx_beep)) audio_play_sound(_sfx_beep, 1, false);
}

// =================================================================
// TAB PATTERN 0: STANDARD BGM OST
// =================================================================
if (current_tab == 0) {
    var _total = array_length(ost_list);
    if (_down) { ost_cursor++; if (audio_exists(_sfx_beep)) audio_play_sound(_sfx_beep, 1, false); }
    if (_up)   { ost_cursor--; if (audio_exists(_sfx_beep)) audio_play_sound(_sfx_beep, 1, false); }
    
    if (ost_cursor < 0) { ost_cursor = _total - 1; ost_view_start = max(0, _total - max_visible_items); }
    if (ost_cursor >= _total) { ost_cursor = 0; ost_view_start = 0; }
    
    if (ost_cursor < ost_view_start) ost_view_start = ost_cursor;
    if (ost_cursor >= ost_view_start + max_visible_items) ost_view_start = ost_cursor - max_visible_items + 1;
    
    if (_enter && _total > 0) {
        audio_stop_all();
        var _song = ost_list[ost_cursor];
        if (audio_exists(_song.asset)) {
            audio_sound_gain(_song.asset, 1.0, 0);
            if (_song.loops) audio_sound_loop_start(_song.asset, _song.loop_start);
            playing_track = audio_play_sound(_song.asset, 10, _song.loops);
            playing_asset = _song.asset;
            now_playing_name = _song.fullname; 
            current_lyric_text = "";
        }
    }
} 
// =================================================================
// TAB PATTERN 1: VOCALS & LORE SONGS
// =================================================================
else if (current_tab == 1) {
    var _total = array_length(songs_list);
    if (_down) { songs_cursor++; if (audio_exists(_sfx_beep)) audio_play_sound(_sfx_beep, 1, false); }
    if (_up)   { songs_cursor--; if (audio_exists(_sfx_beep)) audio_play_sound(_sfx_beep, 1, false); }
    
    if (songs_cursor < 0) { songs_cursor = _total - 1; songs_view_start = max(0, _total - max_visible_items); }
    if (songs_cursor >= _total) { songs_cursor = 0; songs_view_start = 0; }
    
    if (songs_cursor < songs_view_start) songs_view_start = songs_cursor;
    if (songs_cursor >= songs_view_start + max_visible_items) songs_view_start = songs_cursor - max_visible_items + 1;
    
    if (_enter && _total > 0) {
        audio_stop_all();
        var _song = songs_list[songs_cursor];
        if (audio_exists(_song.asset)) {
            audio_sound_gain(_song.asset, 1.0, 0);
            if (_song.loops) audio_sound_loop_start(_song.asset, _song.loop_start);
            playing_track = audio_play_sound(_song.asset, 10, _song.loops);
            playing_asset = _song.asset;
            now_playing_name = _song.fullname;
            current_lyric_text = "";
        }
    }
}
// =================================================================
// TAB PATTERN 2: SOUND EFFECTS
// =================================================================
else if (current_tab == 2) {
    var _total = array_length(sfx_list);
    if (_down) { sfx_cursor++; if (audio_exists(_sfx_beep)) audio_play_sound(_sfx_beep, 1, false); }
    if (_up)   { sfx_cursor--; if (audio_exists(_sfx_beep)) audio_play_sound(_sfx_beep, 1, false); }
    
    if (sfx_cursor < 0) { sfx_cursor = _total - 1; sfx_view_start = max(0, _total - max_visible_items); }
    if (sfx_cursor >= _total) { sfx_cursor = 0; sfx_view_start = 0; }
    
    if (sfx_cursor < sfx_view_start) sfx_view_start = sfx_cursor;
    if (sfx_cursor >= sfx_view_start + max_visible_items) sfx_view_start = sfx_cursor - max_visible_items + 1;
    
    if (_enter && _total > 0) {
        var _sfx = sfx_list[sfx_cursor];
        if (audio_exists(_sfx.asset)) {
            audio_sound_gain(_sfx.asset, 1.0, 0);
            audio_play_sound(_sfx.asset, 12, false);
            now_playing_name = _sfx.fullname;
            current_lyric_text = "";
        }
    }
}
// =================================================================
// TAB PATTERN 3: UNUSED ARCHIVED CONTENT
// =================================================================
else {
    var _total = array_length(unused_list);
    if (_down) { unused_cursor++; if (audio_exists(_sfx_beep)) audio_play_sound(_sfx_beep, 1, false); }
    if (_up)   { unused_cursor--; if (audio_exists(_sfx_beep)) audio_play_sound(_sfx_beep, 1, false); }
    
    if (unused_cursor < 0) { unused_cursor = _total - 1; unused_view_start = max(0, _total - max_visible_items); }
    if (unused_cursor >= _total) { unused_cursor = 0; unused_view_start = 0; }
    
    if (unused_cursor < unused_view_start) unused_view_start = unused_cursor;
    if (unused_cursor >= unused_view_start + max_visible_items) unused_view_start = unused_cursor - max_visible_items + 1;
    
    if (_enter && _total > 0) {
        audio_stop_all();
        var _unused = unused_list[unused_cursor];
        if (audio_exists(_unused.asset)) {
            audio_sound_gain(_unused.asset, 1.0, 0);
            playing_track = audio_play_sound(_unused.asset, 10, _unused.loops);
            playing_asset = _unused.asset;
            now_playing_name = _unused.fullname;
            current_lyric_text = "";
        }
    }
}