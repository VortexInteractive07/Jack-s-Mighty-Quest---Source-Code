/// @description State Machine, Input, & Typewriter Engine
if (splash_index >= array_length(splash_list) || is_exiting) exit;

var _current_splash = splash_list[splash_index];
var _is_text = is_struct(_current_splash);

// Active character speed for this splash frame
var _active_char_speed = (_is_text && struct_exists(_current_splash, "speed")) 
    ? _current_splash.speed 
    : default_char_speed;

// Text splashes show background frame immediately
if (_is_text && fade_state == 0) {
    alpha = 1;
    fade_state = 1;
}

// --- INPUT HANDLERS (Keyboard, Mouse, Gamepad) ---
var _gp_num = gamepad_get_device_count();
var _gp_pressed = false;
for (var i = 0; i < _gp_num; i++) {
    if (gamepad_is_connected(i)) {
        if (gamepad_button_check_pressed(i, gp_face1) || gamepad_button_check_pressed(i, gp_start)) {
            _gp_pressed = true;
            break;
        }
    }
}

var _skip_all = can_skip && (
    keyboard_check_pressed(ord("S")) || 
    keyboard_check_pressed(vk_escape)
);

var _advance_pressed = can_skip && (
    keyboard_check_pressed(vk_space)  || 
    keyboard_check_pressed(vk_enter)  || 
    mouse_check_button_pressed(mb_left) ||
    _gp_pressed
);

// Helper function to transition safely between splashes
var _advance_splash = function() {
    splash_index++;
    char_count = 0;
    last_sound_char = 0;
    typewriter_complete = false;
    
    if (splash_index >= array_length(splash_list)) {
        is_exiting = true;
        audio_sound_gain(mus_raalhehge_monaigaa, 0, 1000); // Smooth audio fade-out
        room_goto(target_room);
        return;
    }
    
    var _next_splash = splash_list[splash_index];
    var _next_hold = (is_struct(_next_splash) && struct_exists(_next_splash, "hold")) 
        ? _next_splash.hold 
        : default_hold_duration;
        
    splash_timer = _next_hold;
    
    if (is_struct(_next_splash)) {
        alpha = 1;
        fade_state = 1;
    } else {
        alpha = 0;
        fade_state = 0;
    }
};

// --- HARD SKIP ALL ---
if (_skip_all) {
    is_exiting = true;
    room_goto(target_room);
    exit;
}

// --- TYPEWRITER & SFX LOGIC ---
if (_is_text) {
    var _full_text = struct_exists(_current_splash, "text") ? _current_splash.text : "";
    var _total_chars = string_length(_full_text);
    
    if (!typewriter_complete) {
        char_count += _active_char_speed;
        
        var _current_char_idx = floor(char_count);
        if (_current_char_idx > last_sound_char && _current_char_idx <= _total_chars) {
            var _char_str = string_char_at(_full_text, _current_char_idx);
            if (_char_str != " " && _char_str != "\n" && _char_str != "\r") {
                if (audio_exists(sfx_dialogue)) {
                    audio_play_sound(sfx_dialogue, 5, false);
                }
            }
            last_sound_char = _current_char_idx;
        }

        if (char_count >= _total_chars) {
            char_count = _total_chars;
            typewriter_complete = true;
        }
    } else {
        // Blink timer for the "continue" prompt
        prompt_blink_timer++;
        if (prompt_blink_timer >= 30) {
            prompt_visible = !prompt_visible;
            prompt_blink_timer = 0;
        }
    }
}

// --- FADE & TRANSITION STATE MACHINE ---
switch (fade_state) {
    case 0: // Fade In (Sprites)
        alpha += fade_speed;
        if (_advance_pressed) {
            alpha = 1;
            fade_state = 2;
        } 
        else if (alpha >= 1) {
            alpha = 1;
            fade_state = 1;
        }
        break;
        
    case 1: // Hold / Typing State
        // Only countdown hold duration for graphic sprites (not text dialogue)
        if (!_is_text) {
            splash_timer--;
        }
        
        if (_advance_pressed) {
            if (_is_text && !typewriter_complete) {
                // Instantly complete current text block
                var _full_text = struct_exists(_current_splash, "text") ? _current_splash.text : "";
                char_count = string_length(_full_text);
                typewriter_complete = true;
                
                if (audio_exists(sfx_dialogue_continue)) {
                    audio_play_sound(sfx_dialogue_continue, 5, false);
                }
            } else {
                if (audio_exists(sfx_dialogue_continue)) {
                    audio_play_sound(sfx_dialogue_continue, 5, false);
                }
                
                var _next_is_text = (splash_index + 1 < array_length(splash_list)) && is_struct(splash_list[splash_index + 1]);
                if (_is_text && _next_is_text) {
                    _advance_splash(); 
                } else {
                    fade_state = 2; 
                }
            }
        }
        // Auto-advance ONLY triggers for graphic splash assets when their timer runs out
        else if (!_is_text && splash_timer <= 0) {
            fade_state = 2;
        }
        break;
        
    case 2: // Fade Out
        alpha -= fade_speed;
        if (alpha <= 0) {
            alpha = 0;
            _advance_splash();
        }
        break;
}