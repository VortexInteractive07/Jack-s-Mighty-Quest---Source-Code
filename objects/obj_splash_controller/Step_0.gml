/// @description Splash State Logic
if (splash_index >= array_length(splash_list)) exit;

// 1. Hard Skip Check (S / ESC -> Jump straight to Title Screen)
var _skip_all = can_skip && (
    keyboard_check_pressed(ord("S")) || 
    keyboard_check_pressed(vk_escape)
);

// 2. Next Splash Check (Space / Enter / Click -> Advance 1 Splash)
var _advance_pressed = can_skip && (
    keyboard_check_pressed(vk_space)  || 
    keyboard_check_pressed(vk_enter)  || 
    mouse_check_button_pressed(mb_left)
);

// --- INSTANT HARD SKIP TO TITLE ROOM ---
if (_skip_all) {
    room_goto(target_room);
    exit;
}

// --- NORMAL STATE MACHINE ---
switch (fade_state) {
    case 0: // --- FADE IN ---
        alpha += fade_speed;
        
        if (_advance_pressed) {
            alpha = 1;
            fade_state = 2; // Fast-forward to Fade Out for current splash
        } 
        else if (alpha >= 1) {
            alpha = 1;
            splash_timer = splash_hold_duration;
            fade_state = 1; // Transition to Hold
        }
        break;
        
    case 1: // --- HOLD ---
        splash_timer--;
        
        if (_advance_pressed || splash_timer <= 0) {
            fade_state = 2; // Transition to Fade Out
        }
        break;
        
    case 2: // --- FADE OUT ---
        alpha -= fade_speed;
        
        if (alpha <= 0) {
            alpha = 0;
            splash_index++;
            
            // Check if more splashes remain
            if (splash_index < array_length(splash_list)) {
                fade_state = 0; // Reset to Fade In for next splash
            } else {
                room_goto(target_room); // All splashes complete
            }
        }
        break;
}