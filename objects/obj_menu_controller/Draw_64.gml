/// @description Draw the resolution-aware multi-mode menu GUI and toast layer

// Intelligence Level: 10/10

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// Base black canvas
draw_clear(c_black);

// The menu controller uses the dialogue face; gameplay HUDs keep fnt_regular.
if (font_exists(fnt_dialogue)) draw_set_font(fnt_dialogue);

var _text_x = 52;
var _main_alpha = 1 - changelog_fade_alpha;

// ==========================================
// 1. MAIN MENU & SUB-MODES RENDER
// ==========================================
if (_main_alpha > 0) {
    draw_set_alpha(_main_alpha);

    if (current_mode == 0 && sprite_exists(spr_main_menu)) {
        var _menu_background = scr_texture_pack_sprite("spr_main_menu", spr_main_menu);
        var _background_x = (_gui_w - sprite_get_width(_menu_background)) / 2;
        var _background_y = (_gui_h - sprite_get_height(_menu_background)) / 2;
        draw_sprite(_menu_background, 0, _background_x, _background_y);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    switch (current_mode) {
        case 0: draw_menu_list(menu_list_main,      _text_x, start_y, line_spacing, _main_alpha); break;
        case 6:
            draw_set_color(c_black);
            draw_rectangle(12, 10, _gui_w - 12, _gui_h - 10, false);
            draw_set_color(c_aqua);
            draw_rectangle(12, 10, _gui_w - 12, _gui_h - 10, true);
            draw_set_halign(fa_center);
            draw_set_color(c_yellow);
            draw_text(_gui_w * 0.5, 22, "STORY / SAVE SLOTS");
            draw_set_halign(fa_left);
            var _slot_gap = min(16, max(11, floor((_gui_h - 72) / 10)));
            for (var _slot_i = 0; _slot_i < 10; _slot_i++) {
                var _slot_y = 39 + (_slot_i * _slot_gap);
                var _slot_save = save_slots[_slot_i];
                draw_set_color(_slot_i == save_slot_cursor ? c_yellow : c_white);
                var _slot_prefix = (_slot_i == save_slot_cursor) ? "> " : "  ";
                if (is_struct(_slot_save)) {
                    var _slot_name = string_copy(_slot_save.name, 1, (_gui_w < 360) ? 18 : 15);
                    draw_text(25, _slot_y, _slot_prefix + string(_slot_i + 1) + "  " + _slot_name);
                    if (_gui_w >= 360) {
                        draw_set_color(c_gray);
                        draw_text(240, _slot_y, "S" + string(_slot_save.score) + " L" + string(_slot_save.lives));
                        draw_text(340, _slot_y, string_upper(_slot_save.room));
                    }
                } else {
                    draw_text(25, _slot_y, _slot_prefix + string(_slot_i + 1) + "  EMPTY  -  NEW GAME");
                }
            }
            draw_set_halign(fa_center);
            draw_set_color(c_aqua);
            draw_text(_gui_w * 0.5, _gui_h - 20, "ENTER: SELECT   DEL x2: ERASE   ESC: BACK");
            break;
        case 7:
            draw_set_color(c_black);
            draw_rectangle(24, 48, _gui_w - 24, _gui_h - 48, false);
            draw_set_color(c_aqua);
            draw_rectangle(24, 48, _gui_w - 24, _gui_h - 48, true);
            draw_set_halign(fa_center);
            draw_set_color(c_yellow);
            draw_text(_gui_w * 0.5, 72, "NAME YOUR ADVENTURE");
            draw_set_color(c_white);
            draw_text(_gui_w * 0.5, 104, "TYPE A NAME (16 CHARACTERS MAX)");
            draw_set_color(c_yellow);
            draw_text(_gui_w * 0.5, 132, save_name_input + "_");
            draw_set_color(c_aqua);
            draw_text(_gui_w * 0.5, 164, "ENTER: START   ESC: BACK");
            break;
        case 8:
            draw_set_color(c_black); draw_rectangle(12, 10, _gui_w - 12, _gui_h - 10, false);
            draw_set_color(c_aqua); draw_rectangle(12, 10, _gui_w - 12, _gui_h - 10, true);
            draw_set_halign(fa_center); draw_set_color(c_yellow);
            draw_text(_gui_w * 0.5, 24, "ADD-ON MANAGER");
            draw_set_halign(fa_left); draw_set_color(c_white);
            draw_text(24, 52, "TEXTURE PACKS  (APPLY WITH ENTER; RESTART)");
            var _pack_visible_rows = max(1, min(3, floor((_gui_h - 160) / 18)));
            var _pack_start = clamp(content_manager_page - _pack_visible_rows + 1, 0, max(0, array_length(content_manager_packs) - _pack_visible_rows));
            var _pack_end = min(array_length(content_manager_packs), _pack_start + _pack_visible_rows);
            for (var _pack_i = _pack_start; _pack_i < _pack_end; _pack_i++) {
                var _pack = content_manager_packs[_pack_i];
                var _pack_y = 70 + (_pack_i - _pack_start) * 16;
                var _pack_selected = (_pack_i == content_manager_page);
                var _pack_active = (_pack.id == global.texture_pack);
                if (_pack_selected) {
                    draw_set_color(make_color_rgb(28, 34, 48));
                    draw_rectangle(20, _pack_y - 8, _gui_w - 20, _pack_y + 8, false);
                }
                draw_set_color(_pack_selected ? c_yellow : c_white);
                draw_text(28, _pack_y, (_pack_selected ? "> " : "  ") + string_copy(_pack.name, 1, 26) + (_pack_active ? "  [ACTIVE]" : ""));
            }
            draw_set_color(c_aqua);
            draw_text(24, 126, "BEHAVIOR / RESOURCE ADD-ONS (STORED TEMPLATES)");
            draw_set_color(c_white);
            var _addon_visible = min(array_length(content_manager_addons), 3);
            for (var _addon_i = 0; _addon_i < _addon_visible; _addon_i++) {
                var _addon = content_manager_addons[_addon_i];
                draw_text(28, 144 + _addon_i * 14, string_upper(_addon.kind) + ": " + string_copy(_addon.name, 1, 26));
            }
            if (array_length(content_manager_addons) == 0) {
                draw_set_color(c_gray);
                draw_text(28, 144, "No behavior/resource packs installed yet.");
            }
            draw_set_halign(fa_center); draw_set_color(c_aqua);
            draw_text(_gui_w * 0.5, _gui_h - 36, "ENTER: APPLY   N: CREATE   I: IMPORT");
            draw_text(_gui_w * 0.5, _gui_h - 20, "ARROWS: SELECT   ESC: BACK");
            break;
        case 9:
            draw_set_color(c_black); draw_rectangle(12, 10, _gui_w - 12, _gui_h - 10, false);
            draw_set_color(c_aqua); draw_rectangle(12, 10, _gui_w - 12, _gui_h - 10, true);
            draw_set_halign(fa_center); draw_set_color(c_yellow);
            draw_text(_gui_w * 0.5, 24, "CREATE A STARTER PACK");
            draw_set_halign(fa_left);
            var _kind_labels = ["Texture Pack", "Behavior Pack", "Resource Pack"];
            for (var _kind_i = 0; _kind_i < 3; _kind_i++) {
                draw_set_color(_kind_i == addon_create_type ? c_yellow : c_white);
                draw_text(32, 62 + _kind_i * 24, (_kind_i == addon_create_type ? "> " : "  ") + _kind_labels[_kind_i]);
            }
            draw_set_color(c_gray);
            draw_text(32, 142, "Creates a random .jmqpack folder for manual editing.");
            draw_text(32, 158, "Behavior/resource packs are starter templates.");
            draw_text(32, 174, "Built games cannot execute external GML code.");
            draw_set_halign(fa_center); draw_set_color(c_aqua);
            draw_text(_gui_w * 0.5, _gui_h - 20, "ARROWS: TYPE   ENTER: CREATE   ESC: BACK");
            break;
        case 10:
            draw_set_color(c_black); draw_rectangle(12, 10, _gui_w - 12, _gui_h - 10, false);
            draw_set_color(c_aqua); draw_rectangle(12, 10, _gui_w - 12, _gui_h - 10, true);
            draw_set_halign(fa_center); draw_set_color(c_yellow);
            draw_text(_gui_w * 0.5, 24, "IMPORT ADD-ON ARCHIVE");
            draw_set_halign(fa_left);
            var _import_labels = ["Texture Pack", "Behavior Pack", "Resource Pack"];
            for (var _import_i = 0; _import_i < 3; _import_i++) {
                draw_set_color(_import_i == addon_create_type ? c_yellow : c_white);
                draw_text(32, 62 + _import_i * 24, (_import_i == addon_create_type ? "> " : "  ") + _import_labels[_import_i]);
            }
            draw_set_color(c_gray);
            draw_text(32, 150, "Manifest may be at archive root or one folder below.");
            draw_set_halign(fa_center); draw_set_color(c_aqua);
            draw_text(_gui_w * 0.5, _gui_h - 20, "ARROWS: TYPE   ENTER: CHOOSE FILE   ESC: BACK");
            break;
        case 5:
            draw_set_color(c_black); draw_rectangle(16, 16, _gui_w - 16, _gui_h - 16, false);
            draw_set_color(c_aqua); draw_rectangle(16, 16, _gui_w - 16, _gui_h - 16, true);
            draw_set_color(c_yellow); draw_text(28, 26, "JMQ FIELD MANUAL");
            draw_set_color(c_white);
            if (guidebook_page == 0) {
                draw_text(28, 52, "GETTING STARTED");
                draw_text(28, 72, "Left/Right arrows: move");
                draw_text(28, 88, "D: jump / wall jump / double jump");
                draw_text(28, 104, "X / K: attack");
                draw_text(28, 120, "F: hold for rapid fire   G: Massacre volley");
                draw_text(28, 136, "P / Esc: pause");
                draw_text(28, 152, "I: inventory     F1: this manual");
                draw_text(28, 176, "Explore, collect gems, and reach the exit.");
            } else if (guidebook_page == 1) {
                draw_text(28, 52, "FIELD TIPS");
                draw_text(28, 72, "Jump again in midair for a double jump.");
                draw_text(28, 88, "Hold S while moving to sprint.");
                draw_text(28, 104, "Your plasma companion can assist in combat.");
                draw_text(28, 120, "Your save slot autosaves as you play.");
                draw_text(28, 136, "H / TAB: review intro dialogue history.");
                draw_text(28, 160, "Up/Down: next page   Enter/Esc: close");
            } else if (guidebook_page == 2) {
                draw_text(28, 52, "TEXTURE PACKS (WINDOWS)");
                draw_text(28, 72, "Settings > Add-On Manager > N creates one.");
                draw_text(28, 88, "I imports a ZIP/JMQPack archive.");
                draw_text(28, 104, "Manual installs go in save_directory/");
                draw_text(28, 120, "texture_packs/ as .jmqpack folders.");
                draw_text(28, 136, "Use pack.json and textures/; PNGs must");
                draw_text(28, 152, "match the original sprite frame sizes.");
                draw_text(28, 168, "Select in manager; restart to apply.");
                draw_text(28, 176, "Up/Down: pages   Enter/Esc: close");
            } else {
                draw_text(28, 52, "ADD-ON AUTHORING - START HERE");
                draw_text(28, 72, "Settings > Add-On Manager > N creates a pack.");
                draw_text(28, 88, "I imports ZIP/JMQPack by selected pack type.");
                draw_text(28, 104, "Texture packs use pack.json and textures/.");
                draw_text(28, 120, "Templates have addon.json, data/, assets/, source/.");
                draw_text(28, 136, "Only approved sprite textures load at runtime.");
                draw_text(28, 152, "GML must be added to the project, then rebuilt.");
                draw_text(28, 168, "README has formats, examples, and import notes.");
                draw_text(28, 176, "Up/Down: pages   Enter/Esc: close");
            }
            break;
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
            if (font_exists(fnt_regular)) draw_set_font(fnt_regular);

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
            var _lyric_song = jukebox_playlist[jukebox_selected_index];
            var _selected_song_has_lyrics = variable_struct_exists(_lyric_song, "lyrics")
                && is_array(_lyric_song.lyrics) && array_length(_lyric_song.lyrics) > 0;
            var _lyric_font = (jukebox_is_playing && _selected_song_has_lyrics) ? fnt_lyrics : fnt_regular;
            if (font_exists(_lyric_font)) draw_set_font(_lyric_font);
            _lyric_text = fit_jukebox_text(_lyric_text, _juke_w - (_pad * 2) - 12);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_color(_juke_w / 2, _lyric_y + (_lyric_h / 2), _lyric_text, jukebox_gold_light, jukebox_gold_light, jukebox_platinum, jukebox_platinum, 1);
            if (font_exists(fnt_regular)) draw_set_font(fnt_regular);

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
            if (font_exists(fnt_regular)) draw_set_font(fnt_regular);
            break;
        case 4: draw_menu_list(menu_list_cheats,    _text_x, start_y, line_spacing, _main_alpha); break;
    }

    var _mode_label = "MAIN MENU";
    switch (current_mode) {
        case 1: _mode_label = "SETTINGS"; break;
        case 2: _mode_label = "JUKEBOX"; break;
        case 4: _mode_label = "CHEATS"; break;
    }

    if (current_mode == 0 || current_mode == 1 || current_mode == 4) {
        var _footer_height = (_gui_h < 240) ? 18 : 24;
        draw_set_alpha(_main_alpha);
        draw_set_color(c_black);
        draw_rectangle(0, _gui_h - _footer_height, _gui_w, _gui_h, false);
        draw_set_color(c_aqua);
        draw_rectangle(0, _gui_h - _footer_height, _gui_w, _gui_h - _footer_height + 1, false);
        if (font_exists(fnt_dialogue)) draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var _menu_hint = (_gui_w < 600)
            ? ((current_mode == 0) ? "ARROWS: MOVE   ENTER: SELECT   F1: HELP" : "ARROWS: MOVE   ENTER: SELECT   ESC: BACK")
            : ((current_mode == 0) ? "ARROWS/WASD: MOVE    ENTER: SELECT    F1: HELP    ESC: TITLE" : "ARROWS/WASD: MOVE    LEFT/RIGHT: CHANGE    ENTER: SELECT    ESC: BACK");
        draw_text_color(_gui_w * 0.5, _gui_h - (_footer_height * 0.5), _menu_hint, c_aqua, c_aqua, c_white, c_white, _main_alpha);
        if (font_exists(fnt_dialogue)) draw_set_font(fnt_dialogue);
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

    if (font_exists(fnt_dialogue)) draw_set_font(fnt_dialogue);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_text_color(28, _gui_h - 26, "[PRESS ESC / ENTER TO GO BACK]", c_gray, c_gray, c_gray, c_gray, changelog_fade_alpha);
    if (font_exists(fnt_dialogue)) draw_set_font(fnt_dialogue);
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
