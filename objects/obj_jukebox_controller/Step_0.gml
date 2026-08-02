/// @description Handle Navigation Matrix Loops & Virtual Sliding Offsets

var _up     = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var _down   = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var _left   = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));
var _right  = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
var _enter  = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
var _escape = keyboard_check_pressed(vk_escape);
var _stop   = keyboard_check_pressed(vk_backspace) || keyboard_check_pressed(ord("P"));

// Exit Protocol
if (_escape) {
    audio_stop_all();
    if (room_exists(rm_main_menu)) room_goto(rm_main_menu);
    exit;
}

// Global Stop Hook
if (_stop) {
    audio_stop_all();
    playing_track = noone;
    now_playing_name = "None - Silence";
    current_lyric_text = "";
}

// --- Dynamic Lyric Sync System Runtime Check ---
if (playing_track != noone && audio_is_playing(playing_track)) {
    var _track_pos = audio_sound_get_track_position(playing_track);
    current_lyric_text = ""; // Clear string before loop evaluation
    
    // Scan matching active index structures from the active Tab pattern matrix
    if (current_tab == 1 && songs_list[songs_cursor].has_lyrics) {
        var _lyr_data = songs_list[songs_cursor].lyrics;
        var _len = array_length(_lyr_data);
        for (var i = 0; i < _len; i++) {
            if (_track_pos >= _lyr_data[i].time) {
                current_lyric_text = _lyr_data[i].text;
            }
        }
    }
}

// Tab Switching Matrix (4 Tabs Total: 0, 1, 2, 3)
if (_right) {
    current_tab++;
    if (current_tab > 3) current_tab = 0;
    if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
}
if (_left) {
    current_tab--;
    if (current_tab < 0) current_tab = 3;
    if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
}

// =================================================================
// TAB PATTERN 0: STANDARD BGM OST MOVEMENT LOGIC
// =================================================================
if (current_tab == 0) {
    var _ost_total = array_length(ost_list);
    if (_down) { ost_cursor++; if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false); }
    if (_up) { ost_cursor--; if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false); }
    
    if (ost_cursor < 0) { ost_cursor = _ost_total - 1; ost_view_start = max(0, _ost_total - max_visible_items); }
    if (ost_cursor >= _ost_total) { ost_cursor = 0; ost_view_start = 0; }
    
    if (ost_cursor < ost_view_start) ost_view_start = ost_cursor;
    if (ost_cursor >= ost_view_start + max_visible_items) ost_view_start = ost_cursor - max_visible_items + 1;
    
    if (_enter && _ost_total > 0) {
        audio_stop_all();
        var _song = ost_list[ost_cursor];
        if (audio_exists(_song.asset)) {
            audio_sound_gain(_song.asset, 1.0, 0);
            if (_song.loops) audio_sound_loop_start(_song.asset, _song.loop_start);
            playing_track = audio_play_sound(_song.asset, 10, _song.loops);
            now_playing_name = _song.fullname; 
            current_lyric_text = "";
        }
    }
} 
// =================================================================
// TAB PATTERN 1: VOCALS & LORE SONGS MOVEMENT LOGIC
// =================================================================
else if (current_tab == 1) {
    var _songs_total = array_length(songs_list);
    if (_down) { songs_cursor++; if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false); }
    if (_up) { songs_cursor--; if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false); }
    
    if (songs_cursor < 0) { songs_cursor = _songs_total - 1; songs_view_start = max(0, _songs_total - max_visible_items); }
    if (songs_cursor >= _songs_total) { songs_cursor = 0; songs_view_start = 0; }
    
    if (songs_cursor < songs_view_start) songs_view_start = songs_cursor;
    if (songs_cursor >= songs_view_start + max_visible_items) songs_view_start = songs_cursor - max_visible_items + 1;
    
    if (_enter && _songs_total > 0) {
        audio_stop_all();
        var _song = songs_list[songs_cursor];
        if (audio_exists(_song.asset)) {
            audio_sound_gain(_song.asset, 1.0, 0);
            if (_song.loops) audio_sound_loop_start(_song.asset, _song.loop_start);
            playing_track = audio_play_sound(_song.asset, 10, _song.loops);
            now_playing_name = _song.fullname;
            current_lyric_text = "";
        }
    }
}
// =================================================================
// TAB PATTERN 2: SOUND EFFECTS MOVEMENT LOGIC
// =================================================================
else if (current_tab == 2) {
    var _sfx_total = array_length(sfx_list);
    if (_down) { sfx_cursor++; if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false); }
    if (_up) { sfx_cursor--; if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false); }
    
    if (sfx_cursor < 0) { sfx_cursor = _sfx_total - 1; sfx_view_start = max(0, _sfx_total - max_visible_items); }
    if (sfx_cursor >= _sfx_total) { sfx_cursor = 0; sfx_view_start = 0; }
    
    if (sfx_cursor < sfx_view_start) sfx_view_start = sfx_cursor;
    if (sfx_cursor >= sfx_view_start + max_visible_items) sfx_view_start = sfx_cursor - max_visible_items + 1;
    
    if (_enter && _sfx_total > 0) {
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
// TAB PATTERN 3: UNUSED ARCHIVED CONTENT MOVEMENT LOGIC
// =================================================================
else {
    var _unused_total = array_length(unused_list);
    if (_down) { unused_cursor++; if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false); }
    if (_up) { unused_cursor--; if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false); }
    
    if (unused_cursor < 0) { unused_cursor = _unused_total - 1; unused_view_start = max(0, _unused_total - max_visible_items); }
    if (unused_cursor >= _unused_total) { unused_cursor = 0; unused_view_start = 0; }
    
    if (unused_cursor < unused_view_start) unused_view_start = unused_cursor;
    if (unused_cursor >= unused_view_start + max_visible_items) unused_view_start = unused_cursor - max_visible_items + 1;
    
    if (_enter && _unused_total > 0) {
        audio_stop_all();
        var _unused = unused_list[unused_cursor];
        if (audio_exists(_unused.asset)) {
            audio_sound_gain(_unused.asset, 1.0, 0);
            playing_track = audio_play_sound(_unused.asset, 10, _unused.loops);
            now_playing_name = _unused.fullname;
            current_lyric_text = "";
        }
    }
}