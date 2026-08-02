if (array_length(text_array) == 0) exit;
var _current_msg = text_array[current_line];
var _full_text = _current_msg.text;

if (beep_cooldown > 0) beep_cooldown--;

// --- Check Input Layer ---
var _key_pressed = keyboard_check_pressed(ord("D")) || keyboard_check_pressed(vk_down);
var _key_held    = keyboard_check(ord("S")); 
var _key_skip    = keyboard_check_pressed(ord("E"));

// --- INSTANT DIALOGUE SKIP LAYER ("E") ---
if (_key_skip) {
    instance_destroy(); // Instantly signals obj_splash_controller to proceed
    exit;
}

// Supercharge print speed if they are holding down the S key
if (_key_held && !is_finished) {
    print_speed = 2.0; 
} else {
    print_speed = 0.5; 
}

// Line progression and page completion mechanics via "D" or "Down Arrow"
if (_key_pressed) {
    if (global.show_subtitles || !global.narrator_mode) {
        audio_stop_sound(sfx_textbox);
        audio_play_sound(sfx_textbox, 1, false);
    }
    
    if (!is_finished) {
        char_index = string_length(_full_text);
        pause_timer = 0;
        is_finished = true;
    } else {
        if (current_line < array_length(text_array) - 1) {
            // --- CONTINUE TO NEXT LINE ---
            audio_play_sound(sfx_textbox_continue, 1, false); 
            current_line++;
            char_index = 0;
            is_finished = false;
        } else {
            instance_destroy(); 
            exit; 
        }
    }
}

// --- Text Spooling Engine ---
if (!is_finished) {
    if (pause_timer > 0) {
        pause_timer--; 
    } else if (char_index < string_length(_full_text)) {
        char_index += print_speed;
        var _next_char_index = max(1, floor(char_index)); 
        var _current_char = string_char_at(_full_text, _next_char_index);
        
        if (_current_char == "." || _current_char == "!" || _current_char == "?") pause_timer = 18;
        else if (_current_char == ",") pause_timer = 8;
        
        if (floor(char_index) > floor(char_index - print_speed) && _current_char != " " && _current_char != "\n") {
            if (beep_cooldown == 0) {
                // Play audio beeps only if subtitles are showing or narrator mode is disabled
                if (global.show_subtitles || !global.narrator_mode) {
                    audio_stop_sound(sfx_textbox); 
                    audio_play_sound(sfx_textbox, 1, false);
                }
                beep_cooldown = 4;                                     
            }
        }
    } else {
        is_finished = true;
    }
}