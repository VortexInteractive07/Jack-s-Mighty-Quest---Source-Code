/// @description Step Event - obj_init_controller

// 1. Handle Transition Fades & State Logic
if (fade_state == 0) {
    // Fade In from Black
    fade_alpha -= fade_speed;
    if (fade_alpha <= 0) {
        fade_alpha = 0;
        fade_state = 1;
        
        // Skip load state entirely if disabled and no active blockers present
        if (!enable_loading_bar && !has_crash_log && !is_pirated && !show_passcode_prompt) {
            fade_state = 2;
        }
    }
} else if (fade_state == 1) {
    // Active Loading, Passcode Challenge, Piracy Trap, or Crash Screen Display
    if (show_passcode_prompt) {
        // Keyboard buffer capture for security code
        if (string_length(keyboard_string) <= max_code_length) {
            user_input_code = keyboard_string;
        } else {
            keyboard_string = user_input_code;
        }

        // Handle Backspace
        if (keyboard_check_pressed(vk_backspace)) {
            user_input_code = string_copy(user_input_code, 1, max(0, string_length(user_input_code) - 1));
            keyboard_string = user_input_code;
        }

        // Code Validation on ENTER
        if (keyboard_check_pressed(vk_enter)) {
            if (user_input_code == correct_code) {
                show_passcode_prompt = false;
                is_pirated           = false;
                passcode_failed      = false;
            } else {
                show_passcode_prompt = false;
                is_pirated           = true;
                piracy_reason        = "INVALID SECURITY CODE ENTERED.\nUNAUTHORIZED ACCESS DENIED.";
            }
        }
    } else if (is_pirated) {
        // Anti-Piracy soft lock state - prevents game progression
        if (keyboard_check_pressed(vk_escape)) {
            game_end();
        }
    } else if (has_crash_log) {
        // Dismiss Log & Continue
        if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
            file_delete("crash_log.txt");
            has_crash_log = false;
            
            if (!enable_loading_bar) {
                fade_state = 2;
            }
        }
        
        // Copy Log to Clipboard & Trigger Toast
        if (keyboard_check_pressed(ord("C"))) {
            clipboard_set_text(crash_log_text);
            toast_timer = toast_max;
        }
        
        // Scroll Log View
        if (keyboard_check(vk_down)) {
            crash_log_scroll += 2;
        }
        if (keyboard_check(vk_up)) {
            crash_log_scroll = max(0, crash_log_scroll - 2);
        }
    } else {
        // Increment Load Progress
        if (enable_loading_bar) {
            load_timer++;
            gloss_offset += 1.5;
            
            // Smooth progress interpolation
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
    // Fade Out to Black then Transition Room
    fade_alpha += fade_speed;
    if (fade_alpha >= 1.0) {
        fade_alpha = 1.0;
        room_goto(rm_splash_screen);
    }
}

// 2. Toast Countdown Timer
if (toast_timer > 0) {
    toast_timer--;
}