/// @description Process Inputs, Visualizer Math, Song Sync & Dynamic Language Switching

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

prompt_sine += 0.08;

var _goto_credits_or_restart = function() {
    var _rm_credits = asset_get_index("rm_credits");
    if (_rm_credits != -1 && room_exists(_rm_credits)) {
        room_goto(_rm_credits);
    } else {
        game_restart();
    }
};

// ============================================================================
// 1. VIDEO AUTO-END DETECTION (Mode 0)
// ============================================================================
if (play_mode == 0) {
    if (video_get_status() == video_status_closed) {
        _goto_credits_or_restart();
        exit;
    }
}

// ============================================================================
// 2. SONG TIMELINE & PREMIUM VISUALIZER MATH (Mode 1)
// ============================================================================
if (play_mode == 1 && audio_played && audio_is_playing(end_sequence_audio)) {
    var _track_pos = audio_sound_get_track_position(end_sequence_audio);
    var _target_line = 0;
    
    var _beat_freq = 4.2; 
    aura_pulse = (abs(sin(_track_pos * _beat_freq * pi)) * 0.45) + (abs(cos(_track_pos * (_beat_freq / 2) * pi)) * 0.25);
    
    for (var i = 0; i < vis_bars; i++) {
        var _wave1 = sin(_track_pos * 8.0 + (i * 0.2));
        var _wave2 = cos(_track_pos * 14.0 - (i * 0.5));
        var _wave3 = sin(_track_pos * 2.0) * cos(i * 0.8);
        
        var _combined = abs(_wave1 + _wave2 + _wave3) / 3.0;
        var _kick_weight = max(0, 1.0 - (i / vis_bars)); 
        var _target_height = (_combined * 50) + (aura_pulse * 90 * _kick_weight) + random(aura_pulse * 15);
        _target_height = clamp(_target_height, 2, 130);
        
        if (_target_height > vis_levels[i]) {
            vis_levels[i] = lerp(vis_levels[i], _target_height, 0.6); 
        } else {
            vis_levels[i] = lerp(vis_levels[i], _target_height, 0.15); 
        }
        
        if (vis_levels[i] > vis_peaks[i]) {
            vis_peaks[i] = vis_levels[i];
        } else {
            vis_peaks[i] -= 1.2;
        }
        vis_peaks[i] = max(vis_peaks[i], vis_levels[i]);
    }
    
    var _total_lyrics = array_length(text_array);
    if (_total_lyrics > 0) {
        for (var i = 0; i < _total_lyrics; i++) {
            if (variable_struct_exists(text_array[i], "time") && _track_pos >= text_array[i].time) {
                _target_line = i;
            } else {
                break;
            }
        }
        
        if (_target_line != current_line) {
            current_line = _target_line;
            var _full_lyric = variable_struct_exists(text_array[current_line], "text") ? text_array[current_line].text : "";
            char_index  = string_length(_full_lyric); 
            is_finished = true;
        }
    }
} else if (play_mode == 1 && audio_played && !audio_is_playing(end_sequence_audio)) {
    _goto_credits_or_restart();
    exit;
}

// ============================================================================
// 3. LANGUAGE MODE SYNC CHECK (Dynamic Switching Support)
// ============================================================================
if (!variable_global_exists("language_mode")) {
    global.language_mode = 0;
}

if (global.language_mode != _prev_language_mode) {
    _prev_language_mode = global.language_mode;
    if (play_mode != 1) {
        text_array = get_dialogue_demoend();
        current_line = clamp(current_line, 0, max(0, array_length(text_array) - 1));
        char_index = 0;
        is_finished = false;
        pause_timer = 0;
    }
}

// ============================================================================
// 4. INPUTS & CUTSCENE SKIP
// ============================================================================
var _key_pressed = keyboard_check_pressed(ord("D")) || keyboard_check_pressed(vk_down) || keyboard_check_pressed(vk_space);
var _key_held    = keyboard_check(ord("S")); 
var _key_skip    = keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_escape);

if (_key_skip) {
    if (play_mode == 0) video_close();
    if (audio_is_playing(end_sequence_audio)) {
        audio_stop_sound(end_sequence_audio);
    }
    _goto_credits_or_restart();
    exit;
}

// ============================================================================
// 5. MANUAL DIALOGUE ENGINE (Modes 2 & 3 ONLY)
// ============================================================================
var _num_dialogue_lines = array_length(text_array);

if (play_mode != 1 && _num_dialogue_lines > 0 && current_line < _num_dialogue_lines) {
    var _current_msg = text_array[current_line];
    var _full_text = variable_struct_exists(_current_msg, "text") ? _current_msg.text : "";
    var _msg_len = string_length(_full_text);

    if (beep_cooldown > 0) beep_cooldown--;
    print_speed = _key_held ? 2.0 : 0.35;

    if (_key_pressed) {
        var _sfx_text = asset_get_index("sfx_textbox");
        var _sfx_cont = asset_get_index("sfx_textbox_continue");
        
        if (show_dialogue && _sfx_text != -1 && audio_exists(_sfx_text)) {
            audio_stop_sound(_sfx_text);
            audio_play_sound(_sfx_text, 1, false);
        }
        
        if (!is_finished) {
            char_index = _msg_len;
            pause_timer = 0;
            is_finished = true; 
        } else {
            if (show_dialogue && _sfx_cont != -1 && audio_exists(_sfx_cont)) {
                audio_stop_sound(_sfx_cont);
                audio_play_sound(_sfx_cont, 1, false);
            }

            if (current_line < _num_dialogue_lines - 1) {
                current_line++;
                char_index = 0;
                is_finished = false;
            } else {
                if (audio_is_playing(end_sequence_audio)) {
                    audio_stop_sound(end_sequence_audio);
                }
                _goto_credits_or_restart();
                exit; 
            }
        }
    }

    if (!is_finished) {
        if (pause_timer > 0) {
            pause_timer--; 
        } else if (char_index < _msg_len) {
            var _prev_count = floor(char_index);
            char_index += print_speed;
            
            if (char_index >= _msg_len) { 
                char_index = _msg_len; 
                is_finished = true; 
            }
            
            var _curr_count = floor(char_index);
            var _current_char = string_char_at(_full_text, max(1, _curr_count));
            
            if (_current_char == "." || _current_char == "!" || _current_char == "?") {
                pause_timer = 12;
            } else if (_current_char == ",") {
                pause_timer = 6;
            }
            
            if (_curr_count > _prev_count && _current_char != " " && _current_char != "\n") {
                if (beep_cooldown == 0) {
                    if (show_dialogue) {
                        var _sfx_text = asset_get_index("sfx_textbox");
                        if (_sfx_text != -1 && audio_exists(_sfx_text)) {
                            audio_stop_sound(_sfx_text); 
                            audio_play_sound(_sfx_text, 1, false);
                        }
                    }
                    beep_cooldown = 4;                         
                }
            }
        } else {
            char_index = _msg_len;
            is_finished = true;
        }
    }
}