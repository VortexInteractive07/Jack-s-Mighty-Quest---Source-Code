// 1. Handle Transition Fades & State Logic
if (fade_state == 0) {
    // Fade In from Black
    fade_alpha -= fade_speed;
    if (fade_alpha <= 0) {
        fade_alpha = 0;
        fade_state = 1;
        
        // Skip load state entirely if disabled
        if (!enable_loading_bar && !has_crash_log) {
            fade_state = 2;
        }
    }
} else if (fade_state == 1) {
    // Active Loading or Crash Screen Display
    if (has_crash_log) {
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