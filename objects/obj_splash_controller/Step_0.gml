/// @description State Machine, Input, Typewriter & Song Lyrics Engine

// --- SONG LYRICS TIMING TRACKER & MUSIC MODE SYSTEM ---
if (audio_is_playing(splash_sound_inst)) {
    if (enable_lyrics && current_track_index != -1 && array_length(lyric_list) > 0) {
        var _audio_pos = audio_sound_get_track_position(splash_sound_inst);
        
        if (current_lyric_index < array_length(lyric_list)) {
            if (_audio_pos >= lyric_list[current_lyric_index].time) {
                current_lyric_text = lyric_list[current_lyric_index].text;
                current_lyric_index++;
            }
        }
    }
} else {
    current_lyric_text = "";
    
    // --- BGM REPLAY LOGIC BASED ON MUSIC_MODE ---
    switch (music_mode) {
        case 0: // ONLY ONCE
            break;
            
        case 1: // UNCOMMON (Long wait between tracks)
            if (track_delay_timer <= 0) {
                track_delay_timer = irandom_range(uncommon_min_delay, uncommon_max_delay);
            } else {
                track_delay_timer--;
                if (track_delay_timer <= 0) {
                    play_random_track();
                }
            }
            break;
            
        case 2: // CONTINUOUS (Zero delay back-to-back)
            play_random_track();
            break;
    }
}

if (splash_index >= array_length(splash_list) || is_exiting) exit;

var _current_splash = splash_list[splash_index];
var _is_text_struct = is_struct(_current_splash);
var _is_dialogue   = _is_text_struct && struct_exists(_current_splash, "text");
var _is_standalone = _is_text_struct && struct_exists(_current_splash, "raw_text");

var _active_char_speed = (_is_text_struct && struct_exists(_current_splash, "speed")) 
    ? _current_splash.speed 
    : default_char_speed;

if (_is_dialogue && fade_state == 0) {
    alpha = 1;
    fade_state = 1;
}

// --- INPUT HANDLERS ---
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

var _advance_splash = function() {
    splash_index++;
    char_count = 0;
    last_sound_char = 0;
    typewriter_complete = false;
    
    if (splash_index >= array_length(splash_list)) {
        is_exiting = true;
        if (audio_is_playing(splash_sound_inst)) {
            audio_sound_gain(splash_sound_inst, 0, 1000);
        }
        room_goto(target_room);
        return;
    }
    
    var _next_splash = splash_list[splash_index];
    var _next_hold = (is_struct(_next_splash) && struct_exists(_next_splash, "hold")) 
        ? _next_splash.hold 
        : default_hold_duration;
        
    splash_timer = _next_hold;
    
    if (is_struct(_next_splash) && struct_exists(_next_splash, "text")) {
        alpha = 1;
        fade_state = 1;
    } else {
        alpha = 0;
        fade_state = 0;
    }
};

if (_skip_all) {
    is_exiting = true;
    if (audio_is_playing(splash_sound_inst)) {
        audio_sound_gain(splash_sound_inst, 0, 500);
    }
    room_goto(target_room);
    exit;
}

// --- TYPEWRITER & SFX LOGIC ---
if (_is_text_struct) {
    var _full_text = "";
    if (_is_dialogue)   _full_text = _current_splash.text;
    if (_is_standalone) _full_text = _current_splash.raw_text;
    
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
        prompt_blink_timer++;
        if (prompt_blink_timer >= 30) {
            prompt_visible = !prompt_visible;
            prompt_blink_timer = 0;
        }
    }
}

// --- FADE & TRANSITION STATE MACHINE ---
switch (fade_state) {
    case 0:
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
        
    case 1:
        if (!_is_dialogue) {
            splash_timer--;
        }
        
        if (_advance_pressed) {
            if (_is_text_struct && !typewriter_complete) {
                var _full_text = _is_dialogue ? _current_splash.text : _current_splash.raw_text;
                char_count = string_length(_full_text);
                typewriter_complete = true;
                
                if (audio_exists(sfx_dialogue_continue)) {
                    audio_play_sound(sfx_dialogue_continue, 5, false);
                }
            } else {
                var _next_is_dialogue = (splash_index + 1 < array_length(splash_list)) 
                    && is_struct(splash_list[splash_index + 1]) 
                    && struct_exists(splash_list[splash_index + 1], "text");

                if (_is_dialogue && _next_is_dialogue) {
                    if (audio_exists(sfx_dialogue_continue)) {
                        audio_play_sound(sfx_dialogue_continue, 5, false);
                    }
                    _advance_splash(); 
                } else {
                    fade_state = 2; 
                }
            }
        }
        else if (!_is_dialogue && splash_timer <= 0) {
            fade_state = 2;
        }
        break;
        
    case 2:
        alpha -= fade_speed;
        if (alpha <= 0) {
            alpha = 0;
            _advance_splash();
        }
        break;
}