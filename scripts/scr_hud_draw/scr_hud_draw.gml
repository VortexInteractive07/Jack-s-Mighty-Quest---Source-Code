/// @function scr_draw_transition_overlay(_alpha, _gui_w, _gui_h)
/// @description Draws the selected full-screen transition style.
function scr_draw_transition_overlay(_alpha, _gui_w, _gui_h) {
    _alpha = clamp(_alpha, 0, 1);
    if (_alpha <= 0) return;

    var _style = variable_global_exists("fade_style") ? global.fade_style : "SMOOTH";
    if (_style == "OFF") return;
    if (_style == "BLACK") {
        if (_alpha >= 1) {
            draw_set_color(c_black);
            draw_set_alpha(1);
            draw_rectangle(0, 0, _gui_w, _gui_h, false);
        }
        draw_set_alpha(1);
        draw_set_color(c_white);
        return;
    }
    var _tile = 24;

    switch (_style) {
        case "GENESIS":
            // Use saturated Sega blue so the scene does not read as a gray wash.
            draw_set_color(make_color_rgb(0, 0, 255));
            draw_set_alpha(_alpha);
            draw_rectangle(0, 0, _gui_w, _gui_h, false);
            break;

        case "NES":
            // A four-step, hard-edged fade gives this mode a classic console feel.
            var _nes_alpha = ceil(_alpha * 4) / 4;
            draw_set_color(c_black);
            draw_set_alpha(_nes_alpha);
            draw_rectangle(0, 0, _gui_w, _gui_h, false);
            break;

        case "MOSAIC":
            draw_set_color(c_black);
            draw_set_alpha(1);
            for (var _row = 0; _row < ceil(_gui_h / _tile); _row++) {
                for (var _col = 0; _col < ceil(_gui_w / _tile); _col++) {
                    var _noise = ((_col * 37 + _row * 19 + _col * _row * 7) mod 100) / 100;
                    var _threshold = 0.04 + (_noise * 0.92);
                    if (_alpha >= _threshold) {
                        var _x1 = _col * _tile;
                        var _y1 = _row * _tile;
                        draw_rectangle(_x1, _y1, min(_x1 + _tile, _gui_w), min(_y1 + _tile, _gui_h), false);
                    }
                }
            }
            break;

        case "FLASH":
            var _flash_alpha = max(0, 1 - (abs(_alpha - 0.5) * 4)) * 0.75;
            draw_set_color(c_white);
            draw_set_alpha(_flash_alpha);
            draw_rectangle(0, 0, _gui_w, _gui_h, false);
            draw_set_color(c_black);
            draw_set_alpha(_alpha);
            draw_rectangle(0, 0, _gui_w, _gui_h, false);
            break;

        default:
            draw_set_color(c_black);
            draw_set_alpha(_alpha);
            draw_rectangle(0, 0, _gui_w, _gui_h, false);
            break;
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
}

/// @function scr_transition_black_hold_complete(_owner)
/// @description Keeps a BLACK-style transition covered for the configured duration.
function scr_transition_black_hold_complete(_owner) {
    if (!variable_global_exists("fade_style") || global.fade_style != "BLACK") {
        global.transition_black_hold_owner = noone;
        return true;
    }

    var _hold_seconds = variable_global_exists("fade_hold_seconds") ? global.fade_hold_seconds : 1;
    var _duration_ms = max(0, _hold_seconds) * 1000;
    if (_duration_ms <= 0) {
        global.transition_black_hold_owner = noone;
        return true;
    }

    if (!variable_global_exists("transition_black_hold_owner") || global.transition_black_hold_owner != _owner) {
        global.transition_black_hold_owner = _owner;
        global.transition_black_hold_until = current_time + _duration_ms;
        return false;
    }

    if (current_time < global.transition_black_hold_until) return false;

    global.transition_black_hold_owner = noone;
    return true;
}

/// @function scr_hud_draw(_controller)
/// @description Draw the gameplay HUD and controller overlays in GUI space.
function scr_hud_draw(_controller) {
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();

    draw_set_font(fnt_bitmap);
    scr_hud_draw_status(_controller, _gui_w);
    scr_hud_draw_pause(_controller, _gui_w, _gui_h);
    scr_hud_draw_game_over(_controller, _gui_w, _gui_h);
    scr_hud_draw_death_notice(_controller, _gui_w, _gui_h);
    scr_hud_draw_boss_bar(_gui_w);
    scr_hud_draw_transition(_controller, _gui_w, _gui_h);

    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}

/// @function scr_hud_draw_status(_controller, _gui_w)
/// @description Draw the health, score, collectibles, world, and timer panel.
function scr_hud_draw_status(_controller, _gui_w) {
    with (_controller) {
        if (pause_slide >= 1 || is_game_over) exit;

        var _hud_alpha = 1 - pause_slide;
        var _panel_x = 8;
        var _panel_y = 4;
        var _panel_w = _gui_w - 16;
        var _panel_h = 44;
        var _hp = 0;
        var _max_hp = 100;
        var _world_text = variable_instance_exists(id, "world_text") ? world_text : "1-1";
        var _seconds_left = max(0, max_time_seconds - floor(game_timer_ticks / game_get_speed(gamespeed_fps)));
        var _score_text = string(min(999999, max(0, game_score)));
        var _lives_text = string(max(0, player_lives));
        var _coin_text = string(max(0, collectibles_collected));

        if (instance_exists(obj_jack)) {
            var _player = instance_find(obj_jack, 0);
            _hp = max(0, hp_visual_current);
            _max_hp = max(1, _player.max_hp);
        }

        while (string_length(_score_text) < 6) _score_text = "0" + _score_text;
        while (string_length(_lives_text) < 2) _lives_text = "0" + _lives_text;
        while (string_length(_coin_text) < 2) _coin_text = "0" + _coin_text;

        // Draw in GUI space so the whole HUD stays attached to the viewport, not the camera.
        draw_set_alpha(_hud_alpha * 0.9);
        draw_set_color(c_black);
        draw_rectangle(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, false);
        draw_set_color(make_color_rgb(90, 105, 130));
        draw_rectangle(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, true);
        draw_set_color(c_aqua);
        draw_line(_panel_x + 1, _panel_y + 1, _panel_x + _panel_w - 1, _panel_y + 1);

        // Two rows keep translated labels and their values from fighting for the same space.
        var _cell_x = [14, 82, 156, 260, 320, 368];
        var _cell_w = [68, 74, 104, 60, 48, 50];
        var _hero_name = variable_global_exists("player_name") ? string_upper(global.player_name) : get_localized_text("jack_label");
        if (_hero_name == "") _hero_name = get_localized_text("jack_label");
        var _label = [
            _hero_name,
            get_localized_text("hp_label"),
            get_localized_text("score_label"),
            "$",
            get_localized_text("world_label"),
            get_localized_text("time_label")
        ];

        draw_set_alpha(_hud_alpha);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        for (var _i = 0; _i < 6; _i++) {
            var _label_scale = min(1, (_cell_w[_i] - 6) / max(1, string_width(_label[_i])));
            draw_set_color(make_color_rgb(180, 195, 215));
            draw_set_halign(fa_center);
            draw_text_transformed(_cell_x[_i] + (_cell_w[_i] * 0.5), 8, _label[_i], _label_scale, 1, 0);
            if (_i < 5) {
                draw_set_color(make_color_rgb(75, 88, 108));
                draw_line(_cell_x[_i] + _cell_w[_i], 7, _cell_x[_i] + _cell_w[_i], _panel_y + _panel_h - 4);
            }
        }

        draw_set_halign(fa_center);
        draw_set_color(c_white);
        draw_text(_cell_x[0] + (_cell_w[0] * 0.5), 24, "x" + _lives_text);

        var _hp_bar_x = _cell_x[1] + 5;
        var _hp_bar_y = 26;
        var _hp_bar_w = 40;
        var _hp_ratio = clamp(_hp / _max_hp, 0, 1);
        draw_set_color(c_dkgray);
        draw_rectangle(_hp_bar_x, _hp_bar_y, _hp_bar_x + _hp_bar_w, _hp_bar_y + 5, false);
        draw_set_color((_hp_ratio <= 0.25) ? c_red : c_lime);
        draw_rectangle(_hp_bar_x, _hp_bar_y, _hp_bar_x + (_hp_bar_w * _hp_ratio), _hp_bar_y + 5, false);
        draw_set_color(c_white);
        draw_set_halign(fa_left);
        draw_text(_hp_bar_x + _hp_bar_w + 4, 24, string(floor(_hp)));

        draw_set_halign(fa_center);
        draw_set_color(c_white);
        draw_text(_cell_x[2] + (_cell_w[2] * 0.5), 24, _score_text);
        draw_text(_cell_x[3] + (_cell_w[3] * 0.5), 24, "x" + _coin_text);
        draw_text(_cell_x[4] + (_cell_w[4] * 0.5), 24, _world_text);

        var _time_text = string(_seconds_left);
        var _shown_time = "T ";
        if (global.time_attack_active) {
            _time_text = string(floor(global.time_attack_ticks / game_get_speed(gamespeed_fps)));
            _shown_time = "A";
        }
        while (string_length(_time_text) < 3) _time_text = "0" + _time_text;
        draw_set_color((!global.time_attack_active && _seconds_left <= 60) ? c_yellow : c_white);
        draw_text(_cell_x[5] + (_cell_w[5] * 0.5), 24, _shown_time + _time_text);

        if (global.arcade_mode) {
            draw_set_halign(fa_right);
            draw_set_color(c_yellow);
            draw_text(_panel_x + _panel_w - 7, 35, "CREDIT " + string(global.arcade_credits));
        }
        draw_set_alpha(1);
    }
}

/// @function scr_hud_draw_pause(_controller, _gui_w, _gui_h)
function scr_hud_draw_pause(_controller, _gui_w, _gui_h) {
    with (_controller) {
        if (pause_slide <= 0) exit;
        var _ease_slide = power(pause_slide, 0.5);

        var _panel_w = (pause_page == 0) ? 300 : 388;
        var _panel_h = (pause_page == 0) ? 184 : 204;
        var _panel_x = (_gui_w - _panel_w) * 0.5;
        var _panel_y = (_gui_h - _panel_h) * 0.5;
        var _panel_offset = round((1 - _ease_slide) * 14);
        _panel_y += _panel_offset;

        draw_set_alpha(0.72 * _ease_slide);
        draw_set_color(c_black);
        draw_rectangle(0, 0, _gui_w, _gui_h, false);
        draw_set_alpha(_ease_slide);
        draw_set_color(make_color_rgb(7, 15, 28));
        draw_rectangle(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, false);
        draw_set_color(make_color_rgb(44, 69, 91));
        draw_rectangle(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, true);
        draw_set_color(c_aqua);
        draw_rectangle(_panel_x + 1, _panel_y + 1, _panel_x + _panel_w - 1, _panel_y + 3, false);

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_yellow);
        var _heading = get_localized_text("pause_title");
        if (pause_page == 1) _heading = get_localized_text("pause_options");
        if (pause_page == 2) _heading = get_localized_text("jukebox");
        if (pause_page == 3) _heading = get_localized_text("pause_confirm_title");
        draw_text(_gui_w / 2, _panel_y + 19, _heading);

        if (pause_page == 0) {
            draw_set_color(make_color_rgb(178, 195, 215));
            draw_text(_gui_w / 2, _panel_y + 40, get_localized_text("pause_prompt"));
        }
        draw_set_color(make_color_rgb(44, 69, 91));
        draw_line(_panel_x + 18, _panel_y + 51, _panel_x + _panel_w - 18, _panel_y + 51);

        draw_set_halign(fa_center);
        if (pause_page == 0) {
            for (var i = 0; i < pause_options_count; i++) {
                var _option_y = _panel_y + 70 + (i * 20);
                var _selected = (i == pause_option);
                var _label = get_localized_text(pause_label_keys[i]);
                if (_selected) {
                    draw_set_color(make_color_rgb(21, 44, 66));
                    draw_rectangle(_panel_x + 18, _option_y - 8, _panel_x + _panel_w - 18, _option_y + 8, false);
                    draw_set_color(c_aqua);
                    draw_rectangle(_panel_x + 18, _option_y - 8, _panel_x + 20, _option_y + 8, false);
                    draw_set_color(c_yellow);
                    draw_text(_panel_x + 31, _option_y, ">");
                }
                draw_set_color(_selected ? c_white : make_color_rgb(164, 177, 195));
                draw_text(_gui_w / 2, _option_y, _label);
            }
            draw_set_color(make_color_rgb(127, 145, 165));
            draw_text(_gui_w / 2, _panel_y + _panel_h - 10, get_localized_text("pause_controls"));
        } else if (pause_page == 1) {
            var _keys = ["bgm_volume", "sfx_volume", "language_setting", "player_physics", "scrolling_mode", "transition_style", "pause_back"];
            var _lang_codes = ["EN", "DE", "ES", "PL", "SH", "EG", "JG"];
            var _lang_names = ["english", "german", "spanish", "polish", "shakespearean", "engrish", "japangrish"];
            var _styles = ["SMOOTH", "NES", "GENESIS", "MOSAIC", "FLASH", "BLACK", "OFF"];
            var _style_keys = ["fade_style_smooth", "fade_style_nes", "fade_style_genesis", "fade_style_mosaic", "fade_style_flash", "fade_style_black", "fade_style_off"];
            for (var j = 0; j < array_length(_keys); j++) {
                var _row_y = _panel_y + 65 + j * 18;
                var _chosen = (j == pause_settings_index);
                var _value = "";
                switch (j) {
                    case 0: _value = string(global.vol_bgm) + "%"; break;
                    case 1: _value = string(global.vol_sfx) + "%"; break;
                    case 2:
                        var _lang_index = 0;
                        for (var _l = 0; _l < array_length(_lang_codes); _l++) if (global.language == _lang_codes[_l]) _lang_index = _l;
                        _value = get_localized_text(_lang_names[_lang_index]);
                        break;
                    case 3: _value = get_localized_text(global.player_physics_mode == "BOOTLEG" ? "physics_bootleg" : "physics_default"); break;
                    case 4: _value = get_localized_text(global.scrolling_mode == "JITTERY" ? "physics_jittery" : "physics_default"); break;
                    case 5:
                        var _style_index = 0;
                        for (var _s = 0; _s < array_length(_styles); _s++) if (global.fade_style == _styles[_s]) _style_index = _s;
                        _value = get_localized_text(_style_keys[_style_index]);
                        break;
                    case 6: _value = ""; break;
                }
                if (_chosen) {
                    draw_set_color(make_color_rgb(21, 44, 66));
                    draw_rectangle(_panel_x + 16, _row_y - 8, _panel_x + _panel_w - 16, _row_y + 8, false);
                    draw_set_color(c_aqua);
                    draw_rectangle(_panel_x + 16, _row_y - 8, _panel_x + 18, _row_y + 8, false);
                }
                draw_set_halign(fa_left);
                draw_set_color(_chosen ? c_white : make_color_rgb(164, 177, 195));
                draw_text(_panel_x + 28, _row_y, get_localized_text(_keys[j]));
                draw_set_halign(fa_right);
                draw_set_color(c_yellow);
                draw_text(_panel_x + _panel_w - 28, _row_y, _value);
            }
            draw_set_halign(fa_center);
            draw_set_color(make_color_rgb(127, 145, 165));
            draw_text(_gui_w / 2, _panel_y + _panel_h - 10, "UP/DOWN: MOVE   LEFT/RIGHT: CHANGE   ESC: BACK");
        } else if (pause_page == 2) {
            var _count = array_length(pause_jukebox_tracks);
            if (_count > 0) {
                var _start = max(0, min(pause_jukebox_index - 2, _count - 5));
                for (var k = _start; k < min(_count, _start + 5); k++) {
                    var _track_y = _panel_y + 68 + (k - _start) * 20;
                    var _track_selected = (k == pause_jukebox_index);
                    if (_track_selected) {
                        draw_set_color(make_color_rgb(21, 44, 66));
                        draw_rectangle(_panel_x + 18, _track_y - 8, _panel_x + _panel_w - 18, _track_y + 8, false);
                        draw_set_color(c_aqua);
                        draw_rectangle(_panel_x + 18, _track_y - 8, _panel_x + 20, _track_y + 8, false);
                    }
                    draw_set_halign(fa_left);
                    draw_set_color(_track_selected ? c_yellow : make_color_rgb(164, 177, 195));
                    draw_text(_panel_x + 30, _track_y, pause_jukebox_tracks[k].title);
                }
                draw_set_halign(fa_center);
                draw_set_color(c_white);
                draw_text(_gui_w / 2, _panel_y + _panel_h - 26, pause_jukebox_playing ? "NOW PLAYING" : "PAUSED");
            }
            draw_set_halign(fa_center);
            draw_set_color(make_color_rgb(127, 145, 165));
            draw_text(_gui_w / 2, _panel_y + _panel_h - 10, get_localized_text("pause_jukebox_help"));
        } else {
            var _yes_y = _panel_y + 91;
            var _no_y = _panel_y + 125;
            var _confirm_text = [get_localized_text("pause_confirm_yes"), get_localized_text("pause_confirm_no")];
            for (var c = 0; c < 2; c++) {
                var _cy = (c == 0) ? _yes_y : _no_y;
                var _csel = (c == pause_confirm_selection);
                if (_csel) {
                    draw_set_color(make_color_rgb(21, 44, 66));
                    draw_rectangle(_panel_x + 30, _cy - 9, _panel_x + _panel_w - 30, _cy + 9, false);
                    draw_set_color(c_aqua);
                    draw_rectangle(_panel_x + 30, _cy - 9, _panel_x + 32, _cy + 9, false);
                }
                draw_set_color(_csel ? c_yellow : make_color_rgb(164, 177, 195));
                draw_text(_gui_w / 2, _cy, _confirm_text[c]);
            }
            draw_set_color(make_color_rgb(127, 145, 165));
            draw_text(_gui_w / 2, _panel_y + _panel_h - 10, "ENTER: CONFIRM   ESC: KEEP PLAYING");
        }
        draw_set_alpha(1);
        draw_set_halign(fa_left);
    }
}

/// @function scr_hud_draw_game_over(_controller, _gui_w, _gui_h)
function scr_hud_draw_game_over(_controller, _gui_w, _gui_h) {
    with (_controller) {
        if (!is_game_over) exit;
        draw_set_color(c_black);
        draw_set_alpha(0.85);
        draw_rectangle(0, 0, _gui_w, _gui_h, false);
        draw_set_alpha(1);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_black);
        draw_text((_gui_w / 2) + 1, (_gui_h / 2) - 9, get_localized_text("game_over"));
        draw_set_color(c_red);
        draw_text(_gui_w / 2, (_gui_h / 2) - 10, get_localized_text("game_over"));
        draw_set_color(c_black);
        draw_text((_gui_w / 2) + 1, (_gui_h / 2) + 17, get_localized_text("continue_start"));
        draw_set_color(c_yellow);
        draw_text(_gui_w / 2, (_gui_h / 2) + 16, get_localized_text("continue_start"));

        if (global.arcade_mode && global.arcade_credits <= 0) {
            draw_set_color(c_black);
            draw_text((_gui_w / 2) + 1, (_gui_h / 2) + 37, get_localized_text("no_credits"));
            draw_set_color(c_white);
            draw_text(_gui_w / 2, (_gui_h / 2) + 36, get_localized_text("no_credits"));
        }
    }
}

/// @function scr_hud_draw_death_notice(_controller, _gui_w, _gui_h)
function scr_hud_draw_death_notice(_controller, _gui_w, _gui_h) {
    with (_controller) {
        if (death_notice_timer <= 0 || is_game_over) exit;
        var _notice_alpha = min(1, death_notice_timer / 12);
        var _notice_y = _gui_h * 0.42;
        draw_set_alpha(_notice_alpha * 0.82);
        draw_set_color(c_black);
        draw_rectangle(0, _notice_y - 18, _gui_w, _notice_y + 34, false);
        draw_set_alpha(_notice_alpha);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_red);
        draw_text(_gui_w / 2, _notice_y - 7, get_localized_text("life_lost"));
        draw_set_color(c_white);
        var _lives_message = (player_lives <= 1)
            ? get_localized_text("last_life")
            : get_localized_text("lives_left") + ": " + string(player_lives);
        draw_text(_gui_w / 2, _notice_y + 14, _lives_message);
        draw_set_alpha(1);
    }
}

/// @function scr_hud_draw_boss_bar(_gui_w)
/// @description Place the boss status panel below the main HUD to avoid overlap.
function scr_hud_draw_boss_bar(_gui_w) {
    if (room != rm_boss || !instance_exists(obj_boss_pumpkin)) return;
    var _boss = instance_find(obj_boss_pumpkin, 0);
    var _bar_w = 180;
    var _bar_x = (_gui_w - _bar_w) / 2;
    var _bar_y = 32;
    var _boss_ratio = clamp(_boss.hp / max(1, _boss.max_hp), 0, 1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_black);
    draw_rectangle(_bar_x - 2, _bar_y - 2, _bar_x + _bar_w + 2, _bar_y + 24, false);
    draw_set_color(c_white);
    draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + 5, false);
    draw_set_color(c_red);
    draw_rectangle(_bar_x, _bar_y, _bar_x + (_bar_w * _boss_ratio), _bar_y + 5, false);
    draw_set_color(c_yellow);
    draw_text(_gui_w / 2, _bar_y + 7, "MELON HEAD");
}

/// @function scr_hud_draw_transition(_controller, _gui_w, _gui_h)
function scr_hud_draw_transition(_controller, _gui_w, _gui_h) {
    with (_controller) {
        if (fade_alpha <= 0) exit;
        scr_draw_transition_overlay(fade_alpha, _gui_w, _gui_h);
    }
}
