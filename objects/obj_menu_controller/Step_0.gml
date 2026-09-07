/// @description Step Event: Navigation, Audio Management, Toast Timers & Action Execution

// Intelligence Level: 10/10

// Cursor subtle bobbing animation
cursor_offset_x += 0.08 * cursor_dir;
if (abs(cursor_offset_x) > 1.5) cursor_dir *= -1;

// Retro arrow animation ticker
arrow_anim_timer += 0.07;

// Toast notification decay timer logic
if (toast_timer > 0) {
    toast_timer--;
    if (toast_timer > 30) {
        toast_alpha = min(toast_alpha + 0.1, 1);
    } else {
        toast_alpha = max(toast_alpha - 0.05, 0);
    }
} else {
    toast_alpha = 0;
}

// Smooth cross-fade transition for Changelog
if (changelog_fade_state == 1) {
    changelog_fade_alpha += changelog_fade_speed;
    if (changelog_fade_alpha >= 1) {
        changelog_fade_alpha = 1;
        changelog_fade_state = 0;
        current_mode = 3;
    }
} else if (changelog_fade_state == 2) {
    changelog_fade_alpha -= changelog_fade_speed;
    if (changelog_fade_alpha <= 0) {
        changelog_fade_alpha = 0;
        changelog_fade_state = 0;
        current_mode = 0;
    }
}

switch (fade_state) {

    // ==========================================
    // --- STATE 0: FADE IN ---
    // ==========================================
    case 0:
        fade_alpha -= fade_speed;
        if (fade_alpha <= 0) {
            fade_alpha = 0;
            fade_state = 1;
        }
        break;

    // ==========================================
    // --- STATE 1: INTERACTIVE MENUS ---
    // ==========================================
    case 1:
        // Input Abstraction (Keyboard + Gamepad Support)
        var _gp_num = 0;
        var _gp_connected = gamepad_is_connected(_gp_num);
        var _gp_up = false, _gp_down = false, _gp_left = false, _gp_right = false;

        if (_gp_connected) {
            var _axis_v = gamepad_axis_value(_gp_num, gp_axislv);
            var _axis_h = gamepad_axis_value(_gp_num, gp_axislh);

            // Digital D-Pad checks
            _gp_up    = gamepad_button_check_pressed(_gp_num, gp_padu);
            _gp_down  = gamepad_button_check_pressed(_gp_num, gp_padd);
            _gp_left  = gamepad_button_check_pressed(_gp_num, gp_padl);
            _gp_right = gamepad_button_check_pressed(_gp_num, gp_padr);

            // Analog Stick Latched Debounce (Prevents 60FPS Hyper-Scrolling)
            if (abs(_axis_v) > 0.5) {
                if (!gp_axis_pressed_v) {
                    if (_axis_v < -0.5) _gp_up = true;
                    if (_axis_v > 0.5)  _gp_down = true;
                    gp_axis_pressed_v = true;
                }
            } else {
                gp_axis_pressed_v = false;
            }

            if (abs(_axis_h) > 0.5) {
                if (!gp_axis_pressed_h) {
                    if (_axis_h < -0.5) _gp_left = true;
                    if (_axis_h > 0.5)  _gp_right = true;
                    gp_axis_pressed_h = true;
                }
            } else {
                gp_axis_pressed_h = false;
            }
        }

        var _gp_conf = _gp_connected && gamepad_button_check_pressed(_gp_num, gp_face1);
        var _gp_canc = _gp_connected && gamepad_button_check_pressed(_gp_num, gp_face2);

        var _move_up    = keyboard_check_pressed(vk_up)    || keyboard_check_pressed(ord("W")) || _gp_up;
        var _move_down  = keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S")) || _gp_down;
        var _move_left  = keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A")) || _gp_left;
        var _move_right = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D")) || _gp_right;
        var _confirm    = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || _gp_conf;
        var _cancel     = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace) || _gp_canc;

        // --------------------------------------
        // CHANGELOG (mode 3, or mid-transition)
        // --------------------------------------
        if (current_mode == 3 || changelog_fade_state != 0) {
            if (changelog_fade_state == 0) {
                var _max_scroll = max(0, array_length(changelog_lines) - changelog_visible_lines);

                if (_move_up && changelog_scroll > 0) {
                    changelog_scroll--;
                    play_ui_blip(sfx_dialogue_asset);
                }
                if (_move_down && changelog_scroll < _max_scroll) {
                    changelog_scroll++;
                    play_ui_blip(sfx_dialogue_asset);
                }

                if (_confirm || _cancel) {
                    play_ui_blip(sfx_continue_asset);
                    changelog_fade_state = 2;
                }
            }
        }
        // --------------------------------------
        // ALL LIST-DRIVEN MODES (0, 1, 2, 4)
        // --------------------------------------
        else {
            var _active_list = undefined;
            var _cancel_mode = -1;

            switch (current_mode) {
                case 0: _active_list = menu_list_main;      _cancel_mode = -1; break;
                case 1: _active_list = menu_list_options;   _cancel_mode = 0;  break;
                case 2: _active_list = menu_list_jukebox;   _cancel_mode = 0;  break;
                case 4: _active_list = menu_list_cheats;    _cancel_mode = 0;  break;
            }

            if (_active_list != undefined) {
                menu_navigate(_active_list, _move_up, _move_down);

                if (_move_left)  menu_adjust_item(_active_list, -1);
                if (_move_right) menu_adjust_item(_active_list, 1);

                if (_confirm) {
                    menu_confirm_item(_active_list);
                }

                if (_cancel && _cancel_mode != -1) {
                    play_ui_blip(sfx_continue_asset);

                    if (current_mode == 2) {
                        play_jukebox_track(-1);
                    }

                    current_mode = _cancel_mode;
                }
            }
        }
        break;

    // ==========================================
    // --- STATE 2: FADE OUT & ROOM TRANSITION ---
    // ==========================================
    case 2:
        fade_alpha += fade_speed;

        if (current_playing_track != -1 && audio_is_playing(current_playing_track)) {
            audio_sound_gain(current_playing_track, (1 - fade_alpha) * (global.vol_bgm / 100), 0);
        }

        if (fade_alpha >= 1) {
            fade_alpha = 1;

            if (current_playing_track != -1 && audio_is_playing(current_playing_track)) {
                audio_stop_sound(current_playing_track);
            }

            if (pending_exit_to_title) {
                if (room_exists(rm_title_screen)) {
                    room_goto(rm_title_screen);
                } else {
                    game_restart();
                }
            } else {
                if (target_room != -1 && room_exists(target_room)) {
                    room_goto(target_room);
                } else {
                    room_goto_next();
                }
            }
        }
        break;
}