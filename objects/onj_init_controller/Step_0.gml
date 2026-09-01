// Handle Transition Fades
if (fade_state == 0) {
    // Fade In from Black
    fade_alpha -= fade_speed;
    if (fade_alpha <= 0) {
        fade_alpha = 0;
        fade_state = 1;
    }
} else if (fade_state == 1) {
    // Active Loading or Crash Screen Display
    if (has_crash_log) {
        // Press Enter or Space to Dismiss Log and Continue
        if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
            file_delete("crash_log.txt");
            has_crash_log = false;
        }
        
        // Press C to Copy Log & Trigger Toast Notification
        if (keyboard_check_pressed(ord("C"))) {
            clipboard_set_text(crash_log_text);
            toast_timer = toast_max;
        }
    } else {
        load_timer++;
        gloss_offset += 1.5; // Animate glossy bar shimmer
        
        if (load_timer >= load_max) {
            fade_state = 2; // Trigger Fade Out Sequence
        }
    }
} else if (fade_state == 2) {
    // Fade Out to Black then transition to splash screen
    fade_alpha += fade_speed;
    if (fade_alpha >= 1.0) {
        fade_alpha = 1.0;
        room_goto(rm_splash_screen);
    }
}

// Countdown Toast Timer
if (toast_timer > 0) {
    toast_timer--;
}