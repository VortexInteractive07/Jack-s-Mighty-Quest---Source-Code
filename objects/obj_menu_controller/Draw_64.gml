/// @description Draw the resolution-aware multi-mode menu GUI and toast layer

// Intelligence Level: 10/10

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// Base black canvas
draw_clear(c_black);

// Set default font (direct reference eliminates per-frame asset lookup overhead)
if (font_exists(fnt_bitmap)) draw_set_font(fnt_bitmap);

var _text_x = 52;
var _main_alpha = 1 - changelog_fade_alpha;

// ==========================================
// 1. MAIN MENU & SUB-MODES RENDER
// ==========================================
if (_main_alpha > 0) {
    draw_set_alpha(_main_alpha);

    if (sprite_exists(spr_main_menu)) {
        var _menu_background = scr_texture_pack_sprite("spr_main_menu", spr_main_menu);
        var _background_x = (_gui_w - sprite_get_width(_menu_background)) / 2;
        var _background_y = (_gui_h - sprite_get_height(_menu_background)) / 2;
        draw_sprite(_menu_background, 0, _background_x, _background_y);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    switch (current_mode) {
        case 0: draw_menu_list(menu_list_main,      _text_x, start_y, line_spacing, _main_alpha); break;
        case 1: draw_menu_list(menu_list_options,   _text_x, start_y, line_spacing, _main_alpha); break;
        case 2:
            var _juke_w = _gui_w;
            var _juke_h = _gui_h;
            var _compact = (_juke_w < 400 || _juke_h < 220);
            var _pad = _compact ? 8 : 16;
            var _lyric_y = _compact ? 8 : 12;
            var _lyric_h = _compact ? 18 : 22;
            var _header_y = _lyric_y + _lyric_h + 4;
            var _header_h = _compact ? 20 : 26;
            var _list_y = _header_y + _header_h + 4;
            var _footer_y = _juke_h - 26;
            var _list_x = _pad;
            var _list_w = _juke_w - (_pad * 2);
            var _list_h;
            var _info_x;
            var _info_y;
            var _info_w;
            var _info_h;
            var _row_h;

            draw_clear(jukebox_navy_dark);
            draw_set_alpha(1);
            draw_set_color(c_white);
            if (font_exists(fnt_bitmap)) draw_set_font(fnt_bitmap);

            if (sprite_exists(spr_vortex_logo_darkmode)) {
                var _bg_sprite = spr_vortex_logo_darkmode;
                var _bg_tw = sprite_get_width(_bg_sprite);
                var _bg_th = sprite_get_height(_bg_sprite);
                if (_bg_tw > 0 && _bg_th > 0) {
                    for (var _bg_x = jukebox_bg_x - _bg_tw; _bg_x < _juke_w + _bg_tw; _bg_x += _bg_tw) {
                        for (var _bg_y = jukebox_bg_y - _bg_th; _bg_y < _juke_h + _bg_th; _bg_y += _bg_th) {
                            draw_sprite_ext(_bg_sprite, 0, _bg_x, _bg_y, 1, 1, 0, c_white, 0.25);
                        }
                    }
                }
            }

            draw_set_alpha(1);
            draw_set_color(jukebox_gold);
            draw_rectangle(8, 8, _juke_w - 8, _juke_h - 8, true);

            draw_set_alpha(1);
            draw_set_color(c_black);
            draw_rectangle(_pad, _lyric_y, _juke_w - _pad, _lyric_y + _lyric_h, false);
            draw_set_color(jukebox_gold);
            draw_rectangle(_pad, _lyric_y, _juke_w - _pad, _lyric_y + _lyric_h, true);

            var _lyric_text = jukebox_current_lyrics();
            if (font_exists(fnt_bitmap)) draw_set_font(fnt_bitmap);
            _lyric_text = fit_jukebox_text(_lyric_text, _juke_w - (_pad * 2) - 12);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_color(_juke_w / 2, _lyric_y + (_lyric_h / 2), _lyric_text, jukebox_gold_light, jukebox_gold_light, jukebox_platinum, jukebox_platinum, 1);

            draw_set_color(jukebox_navy_dark);
            draw_rectangle(_pad, _header_y, _juke_w - _pad, _header_y + _header_h, false);
            draw_set_color(jukebox_gold);
            draw_rectangle(_pad, _header_y, _juke_w - _pad, _header_y + _header_h, true);
            var _header_text = fit_jukebox_text("OFFICIAL PRESIDENTIAL ARCHIVE JUKEBOX", _juke_w - (_pad * 2) - 12);
            draw_text_color(_juke_w / 2, _header_y + (_header_h / 2), _header_text, jukebox_gold, jukebox_gold, jukebox_gold_light, jukebox_gold_light, 1);

            if (_compact) {
                _row_h = (_juke_h < 210) ? 14 : 16;
                _list_h = min((_row_h * jukebox_visible_max) + 8, _footer_y - _list_y - 30);
                _list_h = max(_row_h + 8, _list_h);
                _info_x = _pad;
                _info_y = _list_y + _list_h + 3;
                _info_w = _list_w;
                _info_h = max(18, _footer_y - _info_y - 3);
            } else {
                _list_h = _footer_y - _list_y - 6;
                _list_w = floor((_juke_w - (_pad * 3)) * 0.54);
                _info_x = _list_x + _list_w + 8;
                _info_y = _list_y;
                _info_w = _juke_w - _info_x - _pad;
                _info_h = _list_h;
                _row_h = 24;
            }

            draw_set_color(c_black);
            draw_rectangle(_list_x, _list_y, _list_x + _list_w, _list_y + _list_h, false);
            draw_set_color(jukebox_gold);
            draw_rectangle(_list_x, _list_y, _list_x + _list_w, _list_y + _list_h, true);

            var _visible_tracks = min(jukebox_visible_max, max(1, floor((_list_h - 8) / _row_h)));
            var _render_end = min(array_length(jukebox_playlist), jukebox_scroll_offset + _visible_tracks);
            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            for (var _track_idx = jukebox_scroll_offset; _track_idx < _render_end; _track_idx++) {
                var _item_y = _list_y + 4 + ((_track_idx - jukebox_scroll_offset) * _row_h);
                var _song = jukebox_playlist[_track_idx];
                var _is_selected = (_track_idx == jukebox_selected_index);
                var _is_active = (_track_idx == jukebox_playing_index && jukebox_is_playing);

                if (_is_selected) {
                    draw_set_color(jukebox_navy_light);
                    draw_rectangle(_list_x + 2, _item_y, _list_x + _list_w - 2, _item_y + _row_h, false);
                    draw_set_color(jukebox_gold);
                    draw_rectangle(_list_x + 2, _item_y, _list_x + _list_w - 2, _item_y + _row_h, true);
                }

                var _prefix = _is_active ? "> " : (_is_selected ? "* " : "  ");
                var _song_text = fit_jukebox_text(_prefix + _song.title, _list_w - 16);
                var _song_color = _is_selected ? jukebox_gold_light : jukebox_platinum;
                draw_text_color(_list_x + 8, _item_y + (_row_h / 2), _song_text, _song_color, _song_color, _song_color, _song_color, 1);
            }

            draw_set_color(c_black);
            draw_rectangle(_info_x, _info_y, _info_x + _info_w, _info_y + _info_h, false);
            draw_set_color(jukebox_gold);
            draw_rectangle(_info_x, _info_y, _info_x + _info_w, _info_y + _info_h, true);

            var _selected_song = jukebox_playlist[jukebox_selected_index];
            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            if (_compact) {
                var _compact_info = "TRACK " + string(jukebox_selected_index + 1) + "/" + string(array_length(jukebox_playlist)) + " | " + _selected_song.composer;
                draw_text_color(_info_x + 6, _info_y + (_info_h / 2), fit_jukebox_text(_compact_info, _info_w - 12), jukebox_gold_light, jukebox_gold_light, jukebox_gold_light, jukebox_gold_light, 1);
            } else {
                draw_text_color(_info_x + 8, _info_y + 12, "TRACK DETAILS", jukebox_gold, jukebox_gold, jukebox_gold, jukebox_gold, 1);
                draw_set_color(jukebox_gold);
                draw_line(_info_x + 8, _info_y + 22, _info_x + _info_w - 8, _info_y + 22);
                draw_text_color(_info_x + 8, _info_y + 40, "TITLE:", jukebox_platinum, jukebox_platinum, jukebox_platinum, jukebox_platinum, 1);
                draw_text_color(_info_x + 8, _info_y + 56, fit_jukebox_text(_selected_song.title, _info_w - 16), jukebox_gold_light, jukebox_gold_light, jukebox_gold_light, jukebox_gold_light, 1);
                draw_text_color(_info_x + 8, _info_y + 82, "COMPOSER:", jukebox_platinum, jukebox_platinum, jukebox_platinum, jukebox_platinum, 1);
                draw_text_color(_info_x + 8, _info_y + 98, fit_jukebox_text(_selected_song.composer, _info_w - 16), jukebox_gold_light, jukebox_gold_light, jukebox_gold_light, jukebox_gold_light, 1);
                var _status = (jukebox_playing_index == jukebox_selected_index) ? (jukebox_is_playing ? "PLAYING" : "PAUSED") : "READY";
                draw_text_color(_info_x + 8, _info_y + 120, "STATUS: " + _status, jukebox_platinum, jukebox_platinum, jukebox_platinum, jukebox_platinum, 1);
            }

            draw_set_color(jukebox_navy_dark);
            draw_rectangle(_pad, _footer_y, _juke_w - _pad, _juke_h - 8, false);
            draw_set_color(jukebox_gold);
            draw_rectangle(_pad, _footer_y, _juke_w - _pad, _juke_h - 8, true);
            if (font_exists(fnt_regular)) draw_set_font(fnt_regular);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            var _controls = _compact ? "ENTER PLAY/PAUSE | P PAUSE | ESC BACK" : "ARROWS SELECT | ENTER PLAY/PAUSE | P PAUSE | ESC BACK";
            draw_text_color(_juke_w / 2, _footer_y + ((_juke_h - 8 - _footer_y) / 2), fit_jukebox_text(_controls, _juke_w - (_pad * 2) - 8), jukebox_gold, jukebox_gold, jukebox_gold_light, jukebox_gold_light, 1);
            if (font_exists(fnt_bitmap)) draw_set_font(fnt_bitmap);
            break;
        case 4: draw_menu_list(menu_list_cheats,    _text_x, start_y, line_spacing, _main_alpha); break;
    }

    var _mode_label = "MAIN MENU";
    switch (current_mode) {
        case 1: _mode_label = "SETTINGS"; break;
        case 2: _mode_label = "JUKEBOX"; break;
        case 4: _mode_label = "CHEATS"; break;
    }

    if (current_mode != 2) {
        draw_set_halign(fa_left);
        draw_set_valign(fa_bottom);
        draw_text_color(12, _gui_h - 10, "ALPHA v1.0 | " + _mode_label, c_white, c_white, c_white, c_white, _main_alpha);

        var _menu_hint = (current_mode == 0)
            ? ((_gui_w <= 320) ? "MOVE  ENTER OK  ESC TITLE" : "ARROWS/WASD MOVE  ENTER SELECT  ESC TITLE")
            : ((_gui_w <= 320) ? "MOVE  ENTER CHANGE  ESC BACK" : "ARROWS/WASD MOVE  ENTER CHANGE  ESC BACK");
        if (font_exists(fnt_regular)) draw_set_font(fnt_regular);
        draw_set_valign((_gui_w <= 320) ? fa_middle : fa_bottom);
        if (_gui_w <= 320) {
            draw_set_halign(fa_center);
            draw_text_color(_gui_w / 2, _gui_h - 29, _menu_hint, c_gray, c_gray, c_gray, c_gray, _main_alpha);
        } else {
            draw_set_halign(fa_right);
            draw_text_color(_gui_w - 12, _gui_h - 10, _menu_hint, c_gray, c_gray, c_gray, c_gray, _main_alpha);
        }
        if (font_exists(fnt_bitmap)) draw_set_font(fnt_bitmap);
    }
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

        // Horizontal Line Separator for "---"
        if (string_starts_with(_line_text, "---")) {
            var _line_center_y = _line_y + (changelog_line_height / 2);
            draw_set_color(c_dkgray);
            draw_line(28, _line_center_y, _gui_w - 28, _line_center_y);
            continue;
        }

        // Color Formatting Parser
        var _c = c_white;
        if (string_starts_with(_line_text, "[")) {
            _c = c_yellow;
        } else if (string_starts_with(_line_text, "+")) {
            _c = c_lime;
        } else if (string_starts_with(_line_text, "-")) {
            _c = c_red;
        }

        draw_text_color(28, _line_y, _line_text, _c, _c, _c, _c, changelog_fade_alpha);
    }

    if (font_exists(fnt_regular)) draw_set_font(fnt_regular);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_text_color(28, _gui_h - 26, "[PRESS ESC / ENTER TO GO BACK]", c_gray, c_gray, c_gray, c_gray, changelog_fade_alpha);
    if (font_exists(fnt_bitmap)) draw_set_font(fnt_bitmap);
}

// ==========================================
// 3. TOAST NOTIFICATION BANNER
// ==========================================
if (toast_alpha > 0) {
    var _banner_h = 20;
    var _banner_y = _gui_h - _banner_h;
    
    draw_set_alpha(toast_alpha * 0.85);
    draw_set_color(c_black);
    draw_rectangle(0, _banner_y, _gui_w, _gui_h, false);

    draw_set_alpha(toast_alpha);
    draw_set_color(c_yellow);
    draw_rectangle(0, _banner_y, _gui_w, _banner_y + 1, false);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_color(_gui_w / 2, _banner_y + (_banner_h / 2), toast_text, c_yellow, c_yellow, c_white, c_white, toast_alpha);
}

// ==========================================
// 4. SCREEN FADE OVERLAY
// ==========================================
if (fade_alpha > 0) {
    draw_set_alpha(fade_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
}

// ==========================================
// GLOBAL DRAW STATE RESET
// ==========================================
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);