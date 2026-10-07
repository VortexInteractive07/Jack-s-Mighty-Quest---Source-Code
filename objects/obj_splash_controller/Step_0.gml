/// @description State Machine, Input, Typewriter & Song Lyrics Engine

// --- SONG LYRICS TIMING TRACKER & MUSIC MODE SYSTEM ---
if (enable_bgm) {
    if (audio_is_playing(splash_sound_inst)) {
        if (enable_lyrics && current_track_index != -1 && array_length(lyric_list) > 0) {
            var _audio_pos = audio_sound_get_track_position(splash_sound_inst);
            
            while (current_lyric_index < array_length(lyric_list)
                && _audio_pos >= lyric_list[current_lyric_index].time) {
                current_lyric_text = lyric_list[current_lyric_index].text;
                current_lyric_index++;
            }
        }
    } else {
        current_lyric_text = "";
        
        switch (music_mode) {
            case 0: // ONLY ONCE
                break;
                
            case 1: // UNCOMMON
                if (track_delay_timer <= 0) {
                    track_delay_timer = irandom_range(uncommon_min_delay, uncommon_max_delay);
                } else {
                    track_delay_timer--;
                    if (track_delay_timer <= 0) {
                        play_random_track();
                    }
                }
                break;
                
            case 2: // CONTINUOUS
                play_random_track();
                break;
        }
    }
} else {
    current_lyric_text = "";
}

if (splash_index >= array_length(splash_list) || is_exiting) exit;

var _current_splash = splash_list[splash_index];
var _is_text_struct = is_struct(_current_splash);
var _is_dialogue    = _is_text_struct && struct_exists(_current_splash, "text");
var _instant        = _is_text_struct && struct_exists(_current_splash, "instant_display") && _current_splash.instant_display;

var _active_char_speed = max(0.01, (_is_text_struct && struct_exists(_current_splash, "speed"))
    ? _current_splash.speed
    : default_char_speed);

// Advance logo animation in Step so its speed is independent of draw passes.
if (last_splash_index != splash_index) {
    splash_frame = 0;
    last_splash_index = splash_index;
}
if (!_is_text_struct && sprite_exists(_current_splash)) {
    var _total_frames = sprite_get_number(_current_splash);
    var _target_speed = sprite_get_speed(_current_splash);
    var _speed_type = sprite_get_speed_type(_current_splash);
    var _frame_increment = (_speed_type == spritespeed_framespersecond)
        ? _target_speed / game_get_speed(gamespeed_fps)
        : _target_speed;

    if (variable_instance_exists(id, "splash_anim_speed")) {
        _frame_increment *= splash_anim_speed;
    }

    if (_total_frames > 1) {
        if (sprite_exists(spr_gamemaker_attribution) && _current_splash == spr_gamemaker_attribution) {
            splash_frame = (splash_frame + _frame_increment) % _total_frames;
        } else {
            splash_frame = min(splash_frame + _frame_increment, _total_frames - 1);
        }
    } else {
        splash_frame = 0;
    }
}

if (_is_dialogue && fade_state == 0) {
    alpha = 1;
    fade_state = 1;
}

// --- INPUT HANDLERS ---
var _gp_pressed = false;
var _gp_num = gamepad_get_device_count();
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
        if (enable_bgm && audio_is_playing(splash_sound_inst)) {
            audio_sound_gain(splash_sound_inst, 0, 500);
        }
        if (room_exists(target_room)) {
            room_goto(target_room);
        }
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

// --- SKIP ALL SPLASHES ---
if (_skip_all) {
    is_exiting = true;
    if (enable_bgm && audio_is_playing(splash_sound_inst)) {
        audio_sound_gain(splash_sound_inst, 0, 300);
    }
    if (room_exists(target_room)) {
        room_goto(target_room);
    }
    exit;
}

// --- TYPEWRITER & SFX LOGIC ---
if (_is_text_struct) {
    var _full_text = _is_dialogue ? _current_splash.text : _current_splash.raw_text;
    _full_text = scr_dialogue_format_text(_full_text);
    var _total_chars = string_length(_full_text);
    
    if (_instant) {
        char_count = _total_chars;
        typewriter_complete = true;
    } else if (!typewriter_complete) {
        char_count += _active_char_speed;
        
        var _current_char_idx = floor(char_count);
        if (_current_char_idx > last_sound_char && _current_char_idx <= _total_chars) {
            var _char_str = string_char_at(_full_text, _current_char_idx);
            if (_char_str != " " && _char_str != "\n" && _char_str != "\r") {
                if (audio_exists(sfx_dialogue)) {
                    scr_play_sfx(sfx_dialogue, 5, false);
                }
            }
            last_sound_char = _current_char_idx;
        }

        if (char_count >= _total_chars) {
            char_count = _total_chars;
            typewriter_complete = true;
        }
    }
}

// --- FADE & TRANSITION STATE MACHINE ---
switch (fade_state) {
    case 0: // FADE IN
        alpha += fade_speed;
        if (_advance_pressed) {
            alpha = 1;
            fade_state = 1;
            if (_is_text_struct) {
                var _full_text = _is_dialogue ? _current_splash.text : _current_splash.raw_text;
                char_count = string_length(_full_text);
                typewriter_complete = true;
            }
        } 
        else if (alpha >= 1) {
            alpha = 1;
            fade_state = 1;
        }
        break;
        
    case 1: // DISPLAY / HOLD
        if (!_is_dialogue) {
            splash_timer--;
        }
        
        if (_advance_pressed) {
            // Priority 1: Finish typewriter text instantly if still printing
            if (_is_text_struct && !typewriter_complete && !_instant) {
                var _full_text = _is_dialogue ? _current_splash.text : _current_splash.raw_text;
                char_count = string_length(_full_text);
                typewriter_complete = true;
                
                if (audio_exists(sfx_dialogue_continue)) {
                    scr_play_sfx(sfx_dialogue_continue, 5, false);
                }
            } 
            // Priority 2: Advance dialogue frame instantly without fading out
            else if (_is_dialogue) {
                if (audio_exists(sfx_dialogue_continue)) {
                    scr_play_sfx(sfx_dialogue_continue, 5, false);
                }
                _advance_splash();
            } 
            // Priority 3: Trigger fade-out for non-dialogue splashes
            else {
                fade_state = 2; 
            }
        }
        else if (!_is_dialogue && splash_timer <= 0) {
            fade_state = 2;
        }
        break;
        
    case 2: // FADE OUT
        alpha -= fade_speed;
        if (alpha <= 0) {
            alpha = 0;
            _advance_splash();
        }
        break;
}
