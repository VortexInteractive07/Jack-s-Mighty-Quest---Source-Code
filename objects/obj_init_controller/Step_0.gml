// ============================================================================
// STEP EVENT
// Object: obj_init_controller
// ============================================================================

if (fade_state == 0) {
    fade_alpha -= fade_speed;
    if (fade_alpha <= 0) {
        fade_alpha = 0;
        fade_state = 1;
        
        if (!enable_loading_bar && !has_crash_log && drm_passed) {
            fade_state = 2;
        }
    }
} else if (fade_state == 1) {
    if (has_crash_log) {
        if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
            file_delete("crash_log.txt");
            has_crash_log = false;
            if (!drm_passed && !enable_drm) {
                drm_passed = true;
            }
        }
        
        if (keyboard_check_pressed(ord("C"))) {
            clipboard_set_text(crash_log_text);
            toast_timer = toast_max;
        }
        
        if (keyboard_check(vk_down)) {
            crash_log_scroll += 2;
        }
        if (keyboard_check(vk_up)) {
            crash_log_scroll = max(0, crash_log_scroll - 2);
        }
    }
    else if (!drm_passed) {
        if (drm_shake_timer > 0) {
            drm_shake_timer--;
        }

        if (keyboard_check_pressed(vk_tab)) {
            drm_generate_problem(1 - drm_difficulty);
        }
        
        if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right)) {
            drm_generate_problem(drm_difficulty);
        }

        var _num_pressed = -1;
        
        if (keyboard_check_pressed(ord("0")) || keyboard_check_pressed(96)) {
            _num_pressed = 0;
        }
        
        for (var _k = ord("1"); _k <= ord("9"); _k++) {
            if (keyboard_check_pressed(_k)) {
                _num_pressed = _k - ord("0");
                break;
            }
        }
        if (_num_pressed == -1) {
            for (var _nk = 97; _nk <= 105; _nk++) {
                if (keyboard_check_pressed(_nk)) {
                    _num_pressed = _nk - 96;
                    break;
                }
            }
        }

        if (_num_pressed != -1 && string_length(drm_user_input) < 5) {
            drm_user_input += string(_num_pressed);
        }

        if (keyboard_check_pressed(ord("-")) || keyboard_check_pressed(109) || keyboard_check_pressed(189)) {
            if (string_length(drm_user_input) == 0) {
                drm_user_input = "-";
            }
        }

        if (keyboard_check_pressed(vk_backspace) && string_length(drm_user_input) > 0) {
            drm_user_input = string_copy(drm_user_input, 1, string_length(drm_user_input) - 1);
        }

        if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
            if (drm_verify_code()) {
                var _check_str = drm_user_input;
                if (string_char_at(_check_str, 1) == "-") {
                    _check_str = string_delete(_check_str, 1, 1);
                }
                if (_check_str != "" && string_digits(_check_str) == _check_str) {
                    ds_list_add(key_history_list, real(drm_user_input));
                }
                if (!enable_loading_bar) {
                    fade_state = 2;
                }
            }
        }
    }
    else if (drm_passed) {
        if (enable_loading_bar) {
            load_timer++;
            gloss_offset += 1.5;
            
            var _target_progress = clamp(load_timer / load_max, 0, 1);
            load_progress_smooth += (_target_progress - load_progress_smooth) * 0.15;
            
            if (load_timer >= load_max) {
                fade_state = 2;
            }
        } else {
            fade_state = 2;
        }
    }
} else if (fade_state == 2) {
    fade_alpha += fade_speed;
    if (fade_alpha >= 1.0) {
        fade_alpha = 1.0;
        if (room_exists(rm_splash_screen)) {
            room_goto(rm_splash_screen);
        }
    }
}

if (toast_timer > 0) {
    toast_timer--;
}