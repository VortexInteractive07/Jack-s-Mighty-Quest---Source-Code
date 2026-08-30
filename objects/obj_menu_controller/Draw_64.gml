/// @description Render Multi-Mode Menu GUI (432x240 Resolution) — generic list-menu rendering & toast layer

var _gui_w = 432;
var _gui_h = 240;

// Base black canvas
draw_clear(c_black);

if (font_exists(fnt_bitmap)) draw_set_font(fnt_bitmap);

var _text_x = 52;

// Alpha value for Main Menu elements
var _main_alpha = 1 - changelog_fade_alpha;

// ==========================================
// 1. MAIN MENU & SUB-MODES RENDER
// ==========================================
if (_main_alpha > 0) {
    draw_set_alpha(_main_alpha);

    draw_sprite_stretched(spr_main_menu, 0, 0, 0, _gui_w, _gui_h);

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    switch (current_mode) {
        case 0: draw_menu_list(menu_list_main,      _text_x, start_y, line_spacing, _main_alpha); break;
        case 1: draw_menu_list(menu_list_options,   _text_x, start_y, line_spacing, _main_alpha); break;
        case 2: draw_menu_list(menu_list_jukebox,   _text_x, start_y, line_spacing, _main_alpha); break;
        case 4: draw_menu_list(menu_list_cheats,    _text_x, start_y, line_spacing, _main_alpha); break;
        case 5: draw_menu_list(menu_list_mannequin, _text_x, start_y, line_spacing, _main_alpha); break;
    }

    var _mode_label = "MAIN MENU";
    if (current_mode == 1) _mode_label = "SETTINGS";
    if (current_mode == 2) _mode_label = "JUKEBOX";
    if (current_mode == 4) _mode_label = "CHEATS";
    if (current_mode == 5) _mode_label = "MANNEQUIN SELECT";

    draw_set_halign(fa_left);
    draw_set_valign(fa_bottom);
    draw_text_color(12, _gui_h - 10, "ALPHA v1.0 | " + _mode_label, c_white, c_white, c_white, c_white, _main_alpha);

    draw_set_alpha(1);
}

// ==========================================
// 2. CHANGELOG SUB-MENU
// ==========================================
if (changelog_fade_alpha > 0) {
    draw_set_alpha(changelog_fade_alpha);

    var _start_changelog_y = 42;
    var _total_lines = array_length(changelog_lines);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    for (var i = 0; i < changelog_visible_lines; i++) {
        var _line_idx = changelog_scroll + i;
        if (_line_idx >= _total_lines) break;

        var _line_y = _start_changelog_y + (i * changelog_line_height);
        var _line_text = changelog_lines[_line_idx];

        var _c = c_white;
        if (string_pos("[", _line_text) > 0) _c = c_yellow;
        if (string_pos("+", _line_text) > 0) _c = c_lime;

        draw_text_color(28, _line_y, _line_text, _c, _c, _c, _c, changelog_fade_alpha);
    }

    draw_set_valign(fa_middle);
    draw_text_color(28, _gui_h - 26, "[PRESS ESC / ENTER TO GO BACK]", c_gray, c_gray, c_gray, c_gray, changelog_fade_alpha);

    draw_set_halign(fa_left);
    draw_set_valign(fa_bottom);
    draw_text_color(12, _gui_h - 10, "ALPHA v1.0 | CHANGELOG", c_white, c_white, c_white, c_white, changelog_fade_alpha);

    draw_set_alpha(1);
}

// Reset Alignments
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// ==========================================
// 3. TOAST NOTIFICATION BANNER
// ==========================================
if (toast_alpha > 0) {
    var _banner_h = 20;
    var _banner_y = _gui_h - _banner_h;
    
    draw_set_alpha(toast_alpha * 0.85);
    draw_set_color(c_black);
    draw_rectangle(0, _banner_y, _gui_w, _gui_h, false);

    draw_set_color(c_yellow);
    draw_rectangle(0, _banner_y, _gui_w, _banner_y + 1, false);

    draw_set_alpha(toast_alpha);
    if (font_exists(fnt_bitmap)) draw_set_font(fnt_bitmap);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_color(_gui_w / 2, _banner_y + (_banner_h / 2), toast_text, c_yellow, c_yellow, c_white, c_white, toast_alpha);
    
    // Reset alignments after drawing toast
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
}

// ==========================================
// 4. SCREEN FADE OVERLAY
// ==========================================
if (fade_alpha > 0) {
    draw_set_alpha(fade_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);

    draw_set_color(c_white);
    draw_set_alpha(1);
}