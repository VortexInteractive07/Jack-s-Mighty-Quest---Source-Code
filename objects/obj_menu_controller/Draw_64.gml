/// @description Draw GUI Event: v1.0 Rendering, Lists, Changelog & Overlays

// Intelligence Level: 10/10

var _gui_w = 432;
var _gui_h = 240;

draw_clear(c_black);

if (font_exists(fnt_bitmap)) draw_set_font(fnt_bitmap);

var _text_x = 48;
var _main_alpha = 1 - changelog_fade_alpha;

if (_main_alpha > 0) {
    draw_set_alpha(_main_alpha);

    if (sprite_exists(spr_main_menu)) {
        draw_sprite_stretched(spr_main_menu, 0, 0, 0, _gui_w, _gui_h);
    }

    // Keep the menu readable while leaving the artwork visible on the right.
    draw_set_alpha(0.82 * _main_alpha);
    draw_set_color(c_black);
    draw_rectangle(12, 29, 246, 204, false);
    draw_set_alpha(_main_alpha);
    draw_set_color(c_aqua);
    draw_rectangle(12, 29, 246, 31, false);
    draw_rectangle(12, 29, 246, 204, true);

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    switch (current_mode) {
        case 0: draw_menu_list(menu_list_main,    _text_x, start_y, line_spacing, _main_alpha); break;
        case 1: draw_menu_list(menu_list_options, _text_x, start_y, line_spacing, _main_alpha); break;
        case 2: draw_menu_list(menu_list_cheats,  _text_x, start_y, line_spacing, _main_alpha); break;
    }

    var _mode_label = get_localized_text("main_menu");
    switch (current_mode) {
        case 1: _mode_label = get_localized_text("settings"); break;
        case 2: _mode_label = get_localized_text("cheats_title"); break;
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text_color(24, 37, _mode_label, c_yellow, c_yellow, c_white, c_white, _main_alpha);
    draw_set_color(make_color_rgb(75, 88, 108));
    draw_line(24, 49, 234, 49);
    draw_set_color(c_white);
    draw_text_color(16, 216, "ARROWS MOVE   ENTER SELECT", c_silver, c_silver, c_white, c_white, _main_alpha);
    draw_set_halign(fa_right);
    draw_text_color(_gui_w - 10, 216, "VORTEX v1.0", c_gray, c_gray, c_silver, c_silver, _main_alpha);
}

if (current_mode == 4 || current_mode == 5) {
    draw_set_alpha(0.96);
    draw_set_color(make_color_rgb(5, 10, 22));
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1);
    draw_set_color(c_aqua);
    draw_rectangle(18, 17, _gui_w - 18, 19, false);
    draw_rectangle(18, 17, _gui_w - 18, _gui_h - 17, true);
    draw_set_font(fnt_bitmap);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    if (current_mode == 4) {
        draw_set_color(c_yellow);
        draw_text(216, 38, "FILE SELECT");
        draw_set_color(c_silver);
        draw_text(216, 57, "CHOOSE A SAVE FILE");

        for (var _slot = 0; _slot < 3; _slot++) {
            var _row_y = 88 + (_slot * 37);
            if (_slot == selected_save_slot) {
                draw_set_alpha(0.9);
                draw_set_color(make_color_rgb(18, 43, 67));
                draw_rectangle(35, _row_y - 14, _gui_w - 35, _row_y + 14, false);
                draw_set_alpha(1);
                draw_set_color(c_aqua);
                draw_rectangle(35, _row_y - 14, 37, _row_y + 14, false);
            }
            draw_set_color((_slot == selected_save_slot) ? c_yellow : c_white);
            draw_text(216, _row_y - 5, "FILE " + string(_slot + 1));
            var _save = save_slots[_slot];
            if (is_struct(_save)) {
                draw_set_color(c_white);
                draw_text(216, _row_y + 7, _save.name + "  " + scr_game_save_room_name(_save.room_id) + "  S" + string(floor(_save.score)));
            } else {
                draw_set_color(c_gray);
                draw_text(216, _row_y + 7, save_select_load_only ? "EMPTY FILE" : "EMPTY - ENTER TO BEGIN");
            }
        }

        draw_set_color(c_silver);
        draw_text(216, 207, "ARROWS: SELECT   ENTER: OPEN   DELETE: ERASE   ESC: BACK");
    } else {
        draw_set_color(c_yellow);
        draw_text(216, 36, "NAME YOUR ADVENTURER");
        draw_set_color(c_silver);
        draw_text(216, 59, "UP TO 12 CHARACTERS");
        draw_set_color(c_white);
        draw_text(216, 81, (name_entry_text == "") ? "_" : name_entry_text + "_");

        for (var _char_index = 0; _char_index < 38; _char_index++) {
            var _col = _char_index mod 6;
            var _row = _char_index div 6;
            var _char_x = 111 + (_col * 42);
            var _char_y = 104 + (_row * 14);
            var _char_label = (_char_index < 36) ? string_char_at(name_entry_chars, _char_index + 1) : ((_char_index == 36) ? "<" : "OK");
            if (_char_index == name_entry_cursor) {
                draw_set_color(make_color_rgb(18, 43, 67));
                draw_rectangle(_char_x - 13, _char_y - 7, _char_x + 13, _char_y + 7, false);
                draw_set_color(c_aqua);
                draw_rectangle(_char_x - 13, _char_y - 7, _char_x - 11, _char_y + 7, false);
                draw_set_color(c_yellow);
            } else draw_set_color(c_white);
            draw_text(_char_x, _char_y, _char_label);
        }

        draw_set_color(c_silver);
        draw_text(216, 212, "ARROWS: CHOOSE   ENTER: ADD   ESC: BACK");
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

if (changelog_fade_alpha > 0) {
    draw_set_alpha(changelog_fade_alpha);

    var _start_changelog_y = 32;
    var _total_lines = array_length(changelog_lines);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    for (var i = 0; i < changelog_visible_lines; i++) {
        var _line_idx = changelog_scroll + i;
        if (_line_idx >= _total_lines) break;

        var _line_y = _start_changelog_y + (i * changelog_line_height);
        var _line_text = changelog_lines[_line_idx];

        if (string_starts_with(_line_text, "---")) {
            var _line_center_y = _line_y + (changelog_line_height / 2);
            draw_set_color(c_dkgray);
            draw_line(24, _line_center_y, _gui_w - 24, _line_center_y);
            continue;
        }

        var _c = c_white;
        if (string_starts_with(_line_text, "[")) {
            _c = c_yellow;
        } else if (string_starts_with(_line_text, "+")) {
            _c = c_lime;
        } else if (string_starts_with(_line_text, "-")) {
            _c = c_red;
        } else if (string_starts_with(_line_text, "!")) {
            _c = make_color_rgb(255, 165, 64);
        }

        draw_text_color(24, _line_y, _line_text, _c, _c, _c, _c, changelog_fade_alpha);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_text_color(24, _gui_h - 18, "[PRESS ESC / ENTER TO GO BACK]", c_gray, c_gray, c_gray, c_gray, changelog_fade_alpha);
}

if (toast_alpha > 0) {
    var _banner_h = 22;
    var _banner_y = _gui_h - _banner_h;
    
    draw_set_alpha(toast_alpha * 0.9);
    draw_set_color(c_black);
    draw_rectangle(0, _banner_y, _gui_w, _gui_h, false);

    draw_set_alpha(toast_alpha);
    draw_set_color(c_yellow);
    draw_rectangle(0, _banner_y, _gui_w, _banner_y + 1, false);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_color(_gui_w / 2, _banner_y + (_banner_h / 2), toast_text, c_yellow, c_yellow, c_white, c_white, toast_alpha);
}

if (fade_alpha > 0) {
    scr_draw_transition_overlay(fade_alpha, _gui_w, _gui_h);
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
