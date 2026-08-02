/// @description Render Full Jukebox Matrix & Clean Horizontal UI Focus Layouts

var _gui_w = 320;
var _gui_h = 240;
var _shadow_offset = 1;

if (font_exists(fnt_bit)) draw_set_font(fnt_bit);
draw_set_valign(fa_top);

// -----------------------------------------------------------------
// SECTION 1: TOP HORIZONTAL TAB SELECTION SYSTEM (4 Columns)
// -----------------------------------------------------------------
var _tab_y = 10;
var _tab_width = 74; 
var _start_tab_x = 10;

// Tab 0: OST
var _t0 = (current_tab == 0) ? "[OST]" : " OST ";
draw_set_halign(fa_center);
draw_set_color(c_black); draw_text(_start_tab_x + (_tab_width*0) + _tab_width/2 + _shadow_offset, _tab_y + _shadow_offset, _t0);
draw_set_color((current_tab == 0) ? c_yellow : c_white); draw_text(_start_tab_x + (_tab_width*0) + _tab_width/2, _tab_y, _t0);

// Tab 1: SONGS
var _t1 = (current_tab == 1) ? "[SONGS]" : " SONGS ";
draw_set_color(c_black); draw_text(_start_tab_x + (_tab_width*1) + _tab_width/2 + _shadow_offset, _tab_y + _shadow_offset, _t1);
draw_set_color((current_tab == 1) ? c_yellow : c_white); draw_text(_start_tab_x + (_tab_width*1) + _tab_width/2, _tab_y, _t1);

// Tab 2: SFX
var _t2 = (current_tab == 2) ? "[SFX]" : " SFX ";
draw_set_color(c_black); draw_text(_start_tab_x + (_tab_width*2) + _tab_width/2 + _shadow_offset, _tab_y + _shadow_offset, _t2);
draw_set_color((current_tab == 2) ? c_yellow : c_white); draw_text(_start_tab_x + (_tab_width*2) + _tab_width/2, _tab_y, _t2);

// Tab 3: UNUSED
var _t3 = (current_tab == 3) ? "[UNUSED]" : " UNUSED ";
draw_set_color(c_black); draw_text(_start_tab_x + (_tab_width*3) + _tab_width/2 + _shadow_offset, _tab_y + _shadow_offset, _t3);
draw_set_color((current_tab == 3) ? c_yellow : c_white); draw_text(_start_tab_x + (_tab_width*3) + _tab_width/2, _tab_y, _t3);

// Boundary separator bar decoration
draw_set_color(c_dkgray);
draw_line(12, 26, _gui_w - 12, 26);

// -----------------------------------------------------------------
// SECTION 2: SLIDING LISTFIELD COLUMN ENGINE (Left-Aligned Layouts)
// -----------------------------------------------------------------
draw_set_halign(fa_left);
var _list_x = 26;
var _start_y = 34;
var _spacing = 13;

if (current_tab == 0) {
    var _ost_total = array_length(ost_list);
    var _end_loop = min(ost_view_start + max_visible_items, _ost_total);
    for (var i = ost_view_start; i < _end_loop; i++) {
        var _draw_y = floor(_start_y + ((i - ost_view_start) * _spacing));
        var _display_title = ost_list[i].title;
        var _is_selected = (i == ost_cursor);
        draw_set_color(c_black);
        if (_is_selected) draw_text(_list_x - 12 + _shadow_offset, _draw_y + _shadow_offset, ">");
        draw_text(_list_x + _shadow_offset, _draw_y + _shadow_offset, _display_title);
        draw_set_color(_is_selected ? c_yellow : c_white);
        if (_is_selected) draw_text(_list_x - 12, _draw_y, ">");
        draw_text(_list_x, _draw_y, _display_title);
    }
} 
else if (current_tab == 1) {
    var _songs_total = array_length(songs_list);
    var _end_loop = min(songs_view_start + max_visible_items, _songs_total);
    for (var i = songs_view_start; i < _end_loop; i++) {
        var _draw_y = floor(_start_y + ((i - songs_view_start) * _spacing));
        var _display_title = songs_list[i].title;
        var _is_selected = (i == songs_cursor);
        draw_set_color(c_black);
        if (_is_selected) draw_text(_list_x - 12 + _shadow_offset, _draw_y + _shadow_offset, ">");
        draw_text(_list_x + _shadow_offset, _draw_y + _shadow_offset, _display_title);
        draw_set_color(_is_selected ? c_yellow : c_white);
        if (_is_selected) draw_text(_list_x - 12, _draw_y, ">");
        draw_text(_list_x, _draw_y, _display_title);
    }
}
else if (current_tab == 2) {
    var _sfx_total = array_length(sfx_list);
    var _end_loop = min(sfx_view_start + max_visible_items, _sfx_total);
    for (var i = sfx_view_start; i < _end_loop; i++) {
        var _draw_y = floor(_start_y + ((i - sfx_view_start) * _spacing));
        var _display_title = sfx_list[i].title;
        var _is_selected = (i == sfx_cursor);
        draw_set_color(c_black);
        if (_is_selected) draw_text(_list_x - 12 + _shadow_offset, _draw_y + _shadow_offset, ">");
        draw_text(_list_x + _shadow_offset, _draw_y + _shadow_offset, _display_title);
        draw_set_color(_is_selected ? c_yellow : c_white);
        if (_is_selected) draw_text(_list_x - 12, _draw_y, ">");
        draw_text(_list_x, _draw_y, _display_title);
    }
}
else {
    var _unused_total = array_length(unused_list);
    var _end_loop = min(unused_view_start + max_visible_items, _unused_total);
    for (var i = unused_view_start; i < _end_loop; i++) {
        var _draw_y = floor(_start_y + ((i - unused_view_start) * _spacing));
        var _display_title = unused_list[i].title;
        var _is_selected = (i == unused_cursor);
        draw_set_color(c_black);
        if (_is_selected) draw_text(_list_x - 12 + _shadow_offset, _draw_y + _shadow_offset, ">");
        draw_text(_list_x + _shadow_offset, _draw_y + _shadow_offset, _display_title);
        draw_set_color(_is_selected ? c_yellow : c_white);
        if (_is_selected) draw_text(_list_x - 12, _draw_y, ">");
        draw_text(_list_x, _draw_y, _display_title);
    }
}

// -----------------------------------------------------------------
// SECTION 3: BOUNDED SUB-HUD HUD FOOTER (Dynamic Text & Lyric Display)
// -----------------------------------------------------------------
draw_set_color(c_dkgray);
draw_line(12, _gui_h - 64, _gui_w - 12, _gui_h - 64);

draw_set_halign(fa_center);

// Render the Lyrics or track meta details cleanly
var _display_info_line = now_playing_name;
if (current_lyric_text != "") {
    _display_info_line = current_lyric_text;
}

// Lyric / Info String Bounded Render Output
draw_set_color(c_black);
draw_text_ext(_gui_w / 2 + _shadow_offset, (_gui_h - 58) + _shadow_offset, _display_info_line, 11, _gui_w - 28);
draw_set_color((current_lyric_text != "") ? c_lime : c_aqua); // Glow lime green for active vocals lines!
draw_text_ext(_gui_w / 2, _gui_h - 58, _display_info_line, 11, _gui_w - 28);

// Core Control Prompt Field
var _control_prompt = "A/D: TAB | W/S: NAV | ENTER: PLAY | ESC: BACK | P: STOP";
draw_set_color(c_black);
draw_text(_gui_w / 2 + _shadow_offset, (_gui_h - 16) + _shadow_offset, _control_prompt);
draw_set_color(c_gray);
draw_text(_gui_w / 2, _gui_h - 16, _control_prompt);

// System State Restoration
draw_set_halign(fa_left);