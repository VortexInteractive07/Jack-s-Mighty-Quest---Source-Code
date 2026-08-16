/// @description Title Screen Flow & Dialogue Control

// ==========================================
// OST PLAYLIST & TOAST ANIMATION (AUTOMATIC RANDOM)
// ==========================================
var _track_count = array_length(ost_playlist);

if (_track_count > 0 && fade_state != 3) {
    var _song_is_playing = audio_is_playing(current_sound_inst);

    if (!_song_is_playing) {
        if (_song_is_playing) {
            audio_stop_sound(current_sound_inst);
        }
        
        // Pick a random next track, avoiding immediate repetition if possible
        if (_track_count > 1) {
            var _prev_index = current_track_index;
            do {
                current_track_index = irandom(_track_count - 1);
            } until (current_track_index != _prev_index);
        } else {
            current_track_index = 0;
        }

        var _next_track = ost_playlist[current_track_index];
        current_sound_inst = audio_play_sound(_next_track.sound, 10, false);
        toast_timer = 360; 
    }
}

if (toast_timer > 0) {
    toast_timer--;
    toast_y = lerp(toast_y, toast_target_y, toast_lerp_speed);
} else {
    toast_y = lerp(toast_y, -40, toast_lerp_speed);
}

// ==========================================
// STATE MACHINE
// ==========================================
switch (fade_state) {

    // --- STATE 0: FADE IN ---
    case 0:
        fade_alpha -= fade_speed;
        if (fade_alpha <= 0) {
            fade_alpha = 0;
            fade_state = 1; // Title active
        }
        break;

    // --- STATE 1: TITLE SCREEN ---
    case 1:
        // Skip Splash Input ('S' or 'ESC')
        var _skip_splash = keyboard_check_pressed(ord("S")) || keyboard_check_pressed(vk_escape);

        if (splash_type_index < string_length(title_splash_text)) {
            if (_skip_splash) {
                splash_type_index = string_length(title_splash_text);
                splash_current_str = title_splash_text;
            } else {
                splash_type_index += splash_type_speed;
                splash_current_str = string_copy(title_splash_text, 1, floor(splash_type_index));
            }
        } else {
            splash_current_str = title_splash_text;
        }

        // Flashing "Press Start"
        flash_timer++;
        if (flash_timer >= flash_interval) {
            flash_timer = 0;
            show_start_text = !show_start_text;
        }

        // Check Start Input
        var _start_pressed = (
            keyboard_check_pressed(vk_space)  || 
            keyboard_check_pressed(vk_enter)  || 
            mouse_check_button_pressed(mb_left)
        );

        if (_start_pressed) {
            show_start_text = false;
            
            if (enable_dialogue && array_length(dialogue_lines) > 0) {
                fade_state = 2; // Move to Dialogue State
                in_dialogue = true;
                dialogue_index = 0;
                dialogue_char_index = 0;
                dialogue_current_text = "";
                
                if (asset_get_index("sfx_dialogue_continue") != -1) {
                    audio_play_sound(sfx_dialogue_continue, 5, false);
                }
            } else {
                fade_state = 3; // Fade Out directly to target_room
            }
        }
        break;

    // --- STATE 2: TECH DEMO DIALOGUE SEQUENCE ---
    case 2:
        if (in_dialogue) {
            var _total_lines = array_length(dialogue_lines);
            
            if (_total_lines > 0) {
                var _raw_text = dialogue_lines[dialogue_index].text;
                var _target_text = string_replace_all(_raw_text, "/n", "\n");
                _target_text = string_replace_all(_target_text, "\\n", "\n");
                
                var _prev_char_count = floor(dialogue_char_index);

                if (dialogue_char_index < string_length(_target_text)) {
                    dialogue_char_index += dialogue_speed;
                    dialogue_current_text = string_copy(_target_text, 1, floor(dialogue_char_index));
                    
                    var _curr_char_count = floor(dialogue_char_index);

                    // --- LETTER-BY-LETTER SFX TRIGGER ---
                    if (_curr_char_count > _prev_char_count) {
                        var _char = string_char_at(_target_text, _curr_char_count);

                        // Trigger sound on every letter (ignoring spaces & newlines)
                        if (_char != " " && _char != "\n") {
                            if (asset_get_index("sfx_dialogue") != -1) {
                                audio_play_sound(sfx_dialogue, 1, false);
                            }
                        }
                    }
                } else {
                    dialogue_current_text = _target_text;
                }

                var _advance_pressed = (
                    keyboard_check_pressed(vk_space)  || 
                    keyboard_check_pressed(vk_enter)  || 
                    mouse_check_button_pressed(mb_left)
                );

                if (_advance_pressed) {
                    if (asset_get_index("sfx_dialogue_continue") != -1) {
                        audio_play_sound(sfx_dialogue_continue, 5, false);
                    }

                    if (dialogue_char_index < string_length(_target_text)) {
                        dialogue_char_index = string_length(_target_text);
                        dialogue_current_text = _target_text;
                    } else {
                        dialogue_index++;
                        dialogue_char_index = 0;
                        dialogue_current_text = "";

                        if (dialogue_index >= _total_lines) {
                            in_dialogue = false;
                            fade_state = 3; // Dialogue done -> Fade Out directly
                        }
                    }
                }
            } else {
                in_dialogue = false;
                fade_state = 3;
            }
        }
        break;

    // --- STATE 3: FADE OUT & ROOM SWITCH ---
    case 3:
        fade_alpha += fade_speed;
        
        if (audio_is_playing(current_sound_inst)) {
            audio_sound_gain(current_sound_inst, 1 - fade_alpha, 0);
        }

        if (fade_alpha >= 1) {
            fade_alpha = 1;
            audio_stop_sound(current_sound_inst);
            room_goto(target_room);
        }
        break;
}