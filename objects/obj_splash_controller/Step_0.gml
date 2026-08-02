// --- INTRO SKIP (T or TAB) ---
// Jump straight to the last splash screen (Presents)
if (!is_loading && !is_skipping) {
    if (keyboard_check_pressed(ord("T")) || keyboard_check_pressed(vk_tab)) {
        current_splash_index = array_length(splash_screens) - 1;
        sub_state = 0;
        fade_alpha = 0;
        hold_timer = 0;
        exit;
    }
}

// --- DEBUG ROOM SKIPS ---

// --- GLOBAL SKIP TO TITLE FADE (0 or ESC) ---
if (keyboard_check_pressed(ord("0")) || keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("E"))) {
    if (!is_skipping) {
        is_skipping = true;
    }
    exit;
}

// --- SEQUENTIAL STATE MACHINE ---
if (is_skipping) {
    audio_stop_all(); 
    fade_alpha += fade_out_speed;
    if (fade_alpha >= 1) {
        fade_alpha = 1;
        room_goto(rm_title);
    }
} else if (is_loading) {
    audio_stop_all();
    room_goto(target_room);
} else {
    // Process current splash screen in sequence
    switch (sub_state) {
        case 0: // Fade In
            fade_alpha += fade_in_speed;
            if (fade_alpha >= 1) {
                fade_alpha = 1;
                sub_state = 1;
            }
            break;
            
        case 1: // Hold
            hold_timer++;
            if (hold_timer >= hold_duration || keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
                sub_state = 2;
                hold_timer = 0;
            }
            break;
            
        case 2: // Fade Out
            fade_alpha -= fade_out_speed;
            if (fade_alpha <= 0) {
                fade_alpha = 0;
                current_splash_index++;
                
                // If we finished all splash screens, transition to loading screen
                if (current_splash_index >= array_length(splash_screens)) {
                    target_room = rm_title;
                    is_loading = true;
                } else {
                    sub_state = 0; // Reset to Fade In for next screen
                }
            }
            break;
    }
}