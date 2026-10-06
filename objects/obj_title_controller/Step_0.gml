/// @description Title Screen Flow, Dialogue, & Level Select Control

// Developer Feature #1:
if (keyboard_check_pressed(ord("0"))) {
    room_goto(rm_splash_screen);
}

// Developer Feature #2:
if (keyboard_check_pressed(ord("9"))) {
    room_goto(rm_init);
}   

// ==========================================
// OST PLAYLIST & TOAST ANIMATION
// ==========================================
var _track_count = array_length(ost_playlist);

if (_track_count > 0 && fade_state != 4) {
    var _song_is_playing = audio_is_playing(current_sound_inst);

    // If a non-looping track finishes, sequence to the next random track
    if (!_song_is_playing) {
        if (_track_count > 1) {
            var _prev_index = current_track_index;
            do {
                current_track_index = irandom(_track_count - 1);
            } until (current_track_index != _prev_index);
        } else {
            current_track_index = 0;
        }

        var _next_track = ost_playlist[current_track_index];
        
        // Determine if target track is the title theme that should loop
        var _should_loop = false;
        if (struct_exists(_next_track, "is_title") && _next_track.is_title) {
            _should_loop = true;
        } else if (struct_exists(_next_track, "sound") && _next_track.sound == mus_title_theme) {
            _should_loop = true;
        }

        current_sound_inst = audio_play_sound(_next_track.sound, 10, _should_loop);
        audio_sound_gain(current_sound_inst, global.vol_bgm / 100, 0);
        toast_timer = 360; 
    }
}

if (toast_timer > 0) {
    toast_timer--;
    toast_y = lerp(toast_y, toast_target_y, toast_lerp_speed);
} else {
    toast_y = lerp(toast_y, -40, toast_lerp_speed);
}

var _gp_connected = gamepad_is_connected(0);
var _gp_start = _gp_connected && (gamepad_button_check_pressed(0, gp_face1) || gamepad_button_check_pressed(0, gp_start));
var _gp_cancel = _gp_connected && gamepad_button_check_pressed(0, gp_face2);

// ==========================================
// STATE MACHINE
// ==========================================
switch (fade_state) {

    // --- STATE 0: FADE IN ---
    case 0:
        fade_alpha -= fade_speed;
        if (fade_alpha <= 0) {
            fade_alpha = 0;
            fade_state = 1;
        }
        break;

    // --- STATE 1: TITLE SCREEN ---
    case 1:
        // Secret Code Checker Logic
        if (keyboard_check_pressed(vk_anykey) && !secret_code_unlocked) {
            if (keyboard_check_pressed(secret_code_sequence[secret_code_index])) {
                secret_code_index++;
                if (secret_code_index >= array_length(secret_code_sequence)) {
                    secret_code_unlocked = true;
                    secret_code_index = 0;
                    if (audio_exists(sfx_dialogue_continue)) {
                        scr_play_sfx(sfx_dialogue_continue, 8, false);
                    }
                }
            } else {
                secret_code_index = 0;
            }
        }

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

        flash_timer++;
        if (flash_timer >= flash_interval) {
            flash_timer = 0;
            show_start_text = !show_start_text;
        }

        var _start_pressed = (
            keyboard_check_pressed(vk_space)  || 
            keyboard_check_pressed(vk_enter)  || 
            mouse_check_button_pressed(mb_left) ||
            _gp_start
        );

        var _coin_pressed = keyboard_check_pressed(ord("C"));
        if (global.arcade_mode && _coin_pressed) {
            global.arcade_credits = min(global.arcade_credits + 1, 99);
            show_start_text = true;
            if (audio_exists(sfx_coin)) {
                scr_play_sfx(sfx_coin, 5, false);
            }
        }

        if (_start_pressed) {
            if (global.arcade_mode && global.arcade_credits <= 0) {
                if (audio_exists(sfx_menu_blip)) {
                    scr_play_sfx(sfx_menu_blip, 5, false);
                }
                break;
            }

            if (global.arcade_mode) {
                global.arcade_credits--;
            }
            show_start_text = false;

            if (secret_code_unlocked) {
                // Secret mode: go to Level Select
                fade_state = 3;
                menu_index = 0;
                menu_alpha = 0;
            } else {
                // Normal mode: target is rm_main_menu
                scr_play_sfx(sfx_dialogue_continue, 1, false);
                target_room = room_exists(rm_main_menu) ? rm_main_menu : room;
                
                if (enable_dialogue && array_length(dialogue_lines) > 0) {
                    dialogue_phase = 0;
                    fade_state = 2;
                    in_dialogue = true;
                    dialogue_index = 0;
                    dialogue_char_index = 0;
                    dialogue_current_text = "";
                    char_count = 0;
                    typewriter_complete = false;
                    
                    if (audio_exists(sfx_dialogue_continue)) {
                        scr_play_sfx(sfx_dialogue_continue, 5, false);
                    }
                } else {
                    fade_state = 4;
                }
            }
        }
        break;

    // --- STATE 2: TECH DEMO DIALOGUE SEQUENCE ---
    case 2:
        if (in_dialogue) {
            var _total_lines = array_length(dialogue_lines);
            dialogue_arrow_timer++;
            
            var _skip_all_dialogue = keyboard_check_pressed(vk_escape) || _gp_cancel;
            
            if (_skip_all_dialogue) {
                in_dialogue = false;
                if (audio_exists(sfx_dialogue_continue)) {
                    scr_play_sfx(sfx_dialogue_continue, 5, false);
                }
                
                // Route to target_room directly (rm_main_menu or selected stage)
                if (target_room != -1 && room_exists(target_room)) {
                    fade_state = 4;
                } else {
                    target_room = room_exists(rm_main_menu) ? rm_main_menu : room;
                    fade_state = 4;
                }
                break;
            }

            if (_total_lines > 0) {
                var _raw_text = struct_exists(dialogue_lines[dialogue_index], "text") ? dialogue_lines[dialogue_index].text : "";
                
                var _target_text = string_replace_all(_raw_text, "/n", chr(10));
                _target_text = string_replace_all(_target_text, "\\n", chr(10));
                
                var _prev_char_count = floor(char_count);

                if (char_count < string_length(_target_text)) {
                    typewriter_complete = false;
                    char_count += dialogue_speed;
                    dialogue_char_index = char_count;
                    dialogue_current_text = string_copy(_target_text, 1, floor(char_count));
                    
                    var _curr_char_count = floor(char_count);

                    if (_curr_char_count > _prev_char_count) {
                        var _char = string_char_at(_target_text, _curr_char_count);

                        if (_char != " " && _char != chr(10) && _char != "\n") {
                            if (audio_exists(sfx_dialogue)) {
                                scr_play_sfx(sfx_dialogue, 1, false);
                            }
                        }
                    }
                } else {
                    char_count = string_length(_target_text);
                    dialogue_char_index = char_count;
                    dialogue_current_text = _target_text;
                    typewriter_complete = true;
                }

                var _advance_pressed = (
                    keyboard_check_pressed(vk_space)  || 
                    keyboard_check_pressed(vk_enter)  || 
                    mouse_check_button_pressed(mb_left) ||
                    _gp_start
                );

                if (_advance_pressed) {
                    if (audio_exists(sfx_dialogue_continue)) {
                        scr_play_sfx(sfx_dialogue_continue, 5, false);
                    }

                    if (char_count < string_length(_target_text)) {
                        char_count = string_length(_target_text);
                        dialogue_char_index = char_count;
                        dialogue_current_text = _target_text;
                        typewriter_complete = true;
                    } else {
                        dialogue_index++;
                        char_count = 0;
                        dialogue_char_index = 0;
                        dialogue_current_text = "";
                        typewriter_complete = false;

                        if (dialogue_index >= _total_lines) {
                            in_dialogue = false;
                            
                            if (target_room != -1 && room_exists(target_room)) {
                                fade_state = 4;
                            } else {
                                target_room = room_exists(rm_main_menu) ? rm_main_menu : room;
                                fade_state = 4;
                            }
                        }
                    }
                }
            } else {
                in_dialogue = false;
                if (target_room != -1 && room_exists(target_room)) {
                    fade_state = 4;
                } else {
                    target_room = room_exists(rm_main_menu) ? rm_main_menu : room;
                    fade_state = 4;
                }
            }
        }
        break;

    // --- STATE 3: LEVEL SELECT MENU ---
    case 3:
        menu_alpha = min(menu_alpha + 0.05, 1);
        
        var _move_back = keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("W")) || keyboard_check_pressed(ord("A"));
        var _move_fwd  = keyboard_check_pressed(vk_down) || keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("S")) || keyboard_check_pressed(ord("D"));
        var _move      = _move_fwd - _move_back;

        if (_move != 0) {
            menu_index += _move;
            var _opt_len = array_length(menu_options);
            if (menu_index < 0) menu_index = _opt_len - 1;
            if (menu_index >= _opt_len) menu_index = 0;
            
            if (audio_exists(sfx_dialogue)) {
                scr_play_sfx(sfx_dialogue, 1, false);
            }
        }
        
        // Escape returns back to standard Title Screen
        if (keyboard_check_pressed(vk_escape)) {
            fade_state = 1;
            show_start_text = true;
            break;
        }

        var _select = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter);
        if (_select) {
            var _selected = menu_options[menu_index];

            if (audio_exists(sfx_dialogue_continue)) {
                scr_play_sfx(sfx_dialogue_continue, 5, false);
            }
            
            var _target_dest = -1;
            if (struct_exists(_selected, "target")) {
                _target_dest = _selected.target;
            } else if (struct_exists(_selected, "target_room")) {
                _target_dest = _selected.target_room;
            }

            if (_target_dest == -3) { // Back to title action
                fade_state = 1;
                show_start_text = true;
            } else if (_target_dest == -2) {
                game_end();
            } else if (_target_dest != -1 && room_exists(_target_dest)) {
                // Set explicitly chosen level as target
                target_room = _target_dest;
                
                if (enable_dialogue && array_length(dialogue_lines) > 0) {
                    dialogue_phase = 1;
                    fade_state = 2;
                    in_dialogue = true;
                    dialogue_index = 0;
                    dialogue_char_index = 0;
                    dialogue_current_text = "";
                    char_count = 0;
                    typewriter_complete = false;
                } else {
                    fade_state = 4;
                }
            }
        }
        break;

    // --- STATE 4: FADE OUT & ROOM SWITCH ---
    case 4:
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