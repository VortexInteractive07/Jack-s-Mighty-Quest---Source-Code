/// @description Render Widescreen Modernized Jukebox UI

if (font_exists(fnt_bit)) draw_set_font(fnt_bit);
draw_set_valign(fa_top);

// -----------------------------------------------------------------
// BACKGROUND & CONTAINER GLASSES
// -----------------------------------------------------------------
draw_set_color(make_color_rgb(12, 14, 22));
draw_rectangle(0, 0, gui_w, gui_h, false);

// Header Panel
draw_set_color(make_color_rgb(20, 24, 38));
draw_rectangle(8, 6, gui_w - 8, 30, false);
draw_set_color(make_color_rgb(45, 55, 80));
draw_rectangle(8, 6, gui_w - 8, 30, true);

// Main Content Panel
draw_set_color(make_color_rgb(18, 22, 34));
draw_rectangle(8, 34, gui_w - 8, 178, false);
draw_set_color(make_color_rgb(38, 48, 70));
draw_rectangle(8, 34, gui_w - 8, 178, true);

// Footer / Now Playing Panel
draw_set_color(make_color_rgb(14, 18, 28));
draw_rectangle(8, 182, gui_w - 8, 234, false);
draw_set_color(make_color_rgb(38, 48, 70));
draw_rectangle(8, 182, gui_w - 8, 234, true);

// -----------------------------------------------------------------
// SECTION 1: HEADER TABS
// -----------------------------------------------------------------
var _tabs = ["OST MUSIC", "LORE SONGS", "SOUND FX", "ARCHIVED"];
var _tab_width = (gui_w - 24) / 4;
var _start_x = 12;

tab_target_x = _start_x + (current_tab * _tab_width);
tab_draw_x   = lerp(tab_draw_x, tab_target_x, 0.35);

draw_set_color(make_color_rgb(0, 220, 255));
draw_rectangle(tab_draw_x, 26, tab_draw_x + _tab_width, 28, false);

for (var i = 0; i < 4; i++) {
    var _tx = _start_x + (i * _tab_width) + (_tab_width / 2);
    var _is_active = (current_tab == i);
    
    draw_set_halign(fa_center);
    draw_set_color(_is_active ? c_white : make_color_rgb(110, 125, 150));
    draw_text(_tx, 12, _tabs[i]);
}

// -----------------------------------------------------------------
// SECTION 2: SCROLLABLE LIST FIELD
// -----------------------------------------------------------------
draw_set_halign(fa_left);
var _list_x    = 24;
var _start_y   = 40;
var _spacing   = 19;

var _current_list = ost_list;
var _current_cursor = ost_cursor;
var _current_view = ost_view_start;

switch (current_tab) {
    case 1: _current_list = songs_list;  _current_cursor = songs_cursor;  _current_view = songs_view_start;  break;
    case 2: _current_list = sfx_list;    _current_cursor = sfx_cursor;    _current_view = sfx_view_start;    break;
    case 3: _current_list = unused_list; _current_cursor = unused_cursor; _current_view = unused_view_start; break;
}

var _total_items = array_length(_current_list);
var _end_loop    = min(_current_view + max_visible_items, _total_items);

cursor_target_y = _start_y + ((_current_cursor - _current_view) * _spacing);
cursor_draw_y   = lerp(cursor_draw_y, cursor_target_y, 0.4);

if (_total_items > 0) {
    draw_set_color(make_color_rgb(30, 45, 70));
    draw_rectangle(14, cursor_draw_y - 2, gui_w - 22, cursor_draw_y + 14, false);
    draw_set_color(make_color_rgb(0, 180, 220));
    draw_rectangle(14, cursor_draw_y - 2, 16, cursor_draw_y + 14, false);
}

for (var i = _current_view; i < _end_loop; i++) {
    var _draw_y   = floor(_start_y + ((i - _current_view) * _spacing));
    var _item     = _current_list[i];
    var _is_selected = (i == _current_cursor);
    var _is_playing  = (playing_asset == _item.asset && playing_track != noone && audio_is_playing(playing_track));
    
    if (_is_playing) {
        draw_set_color(make_color_rgb(0, 255, 180));
        draw_text(_list_x - 6, _draw_y, ">");
    }
    
    draw_set_color(_is_selected ? c_white : make_color_rgb(130, 145, 170));
    draw_text(_list_x + 8, _draw_y, _item.title);
}

if (_total_items > max_visible_items) {
    var _bar_x = gui_w - 14;
    var _bar_y = 40;
    var _bar_h = 130;
    
    draw_set_color(make_color_rgb(25, 32, 48));
    draw_rectangle(_bar_x, _bar_y, _bar_x + 3, _bar_y + _bar_h, false);
    
    var _thumb_h = max(12, (_bar_h / _total_items) * max_visible_items);
    var _thumb_y = _bar_y + ((_bar_h - _thumb_h) * (_current_cursor / max(1, _total_items - 1)));
    
    draw_set_color(make_color_rgb(0, 180, 220));
    draw_rectangle(_bar_x, _thumb_y, _bar_x + 3, _thumb_y + _thumb_h, false);
}

// -----------------------------------------------------------------
// SECTION 3: NOW PLAYING & LYRIC HUD FOOTER
// -----------------------------------------------------------------
var _eq_x = gui_w - 50;
var _eq_y = 198;
for (var e = 0; e < 8; e++) {
    var _h = equalizer_heights[e];
    draw_set_color(make_color_rgb(0, 220, 255));
    draw_rectangle(_eq_x + (e * 4), _eq_y - _h, _eq_x + (e * 4) + 2, _eq_y, false);
}

draw_set_halign(fa_left);

var _info_string = now_playing_name;
var _is_lyric = false;

if (current_lyric_text != "") {
    _info_string = "\"" + current_lyric_text + "\"";
    _is_lyric = true;
}

draw_set_color(make_color_rgb(100, 120, 150));
draw_text(16, 186, _is_lyric ? "LYRIC SYNC:" : "NOW PLAYING:");

draw_set_color(_is_lyric ? make_color_rgb(80, 255, 160) : c_white);
draw_text_ext(16, 197, _info_string, 11, gui_w - 75);

var _prompt = "[A/D] TAB  [W/S] SELECT  [ENTER] PLAY  [P/BKSP] STOP  [ESC] BACK";
draw_set_halign(fa_center);
draw_set_color(make_color_rgb(80, 95, 120));
draw_text(gui_w / 2, 221, _prompt);

draw_set_halign(fa_left);