/// @description Controls Typewriter, Speech Audio, Voice-Sync, Choices, Backlog, & Inputs
/// Intelligence Level: 10/10

// --- 1. BACKLOG TOGGLE & NAVIGATION ---
var _gp_connected = gamepad_is_connected(0);
var _gp_up = _gp_connected && gamepad_button_check_pressed(0, gp_padu);
var _gp_down = _gp_connected && gamepad_button_check_pressed(0, gp_padd);
var _gp_confirm = _gp_connected && (gamepad_button_check_pressed(0, gp_face1) || gamepad_button_check_pressed(0, gp_start));
var _gp_cancel = _gp_connected && gamepad_button_check_pressed(0, gp_face2);
var _gp_history = _gp_connected && gamepad_button_check_pressed(0, gp_face4);

var _toggle_backlog = keyboard_check_pressed(ord("H")) || keyboard_check_pressed(vk_tab) || _gp_history;
if (_toggle_backlog && fade_state == 1 && !choice_active) {
    backlog_open = !backlog_open;
    backlog_scroll_index = 0;
    if (audio_exists(sfx_backlog_open)) {
        scr_play_sfx(sfx_backlog_open, 5, false);
    }
}

if (backlog_open) {
    var _scroll_up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")) || _gp_up;
    var _scroll_down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")) || _gp_down;
    
    if (_scroll_up) backlog_scroll_index = min(backlog_scroll_index + 1, max(0, array_length(dialogue_history) - 5));
    if (_scroll_down) backlog_scroll_index = max(backlog_scroll_index - 1, 0);
    
    if (keyboard_check_pressed(vk_escape) || _gp_cancel || _toggle_backlog) {
        backlog_open = false;
    }
    exit; 
}

// --- 2. INTERACTIVE CHOICE SELECTION HANDLING ---
if (choice_active) {
    var _choice_up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")) || _gp_up;
    var _choice_down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")) || _gp_down;
    var _choice_confirm = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter) || mouse_check_button_pressed(mb_left) || _gp_confirm;
    
    var _choice_count = is_array(choices_array) ? array_length(choices_array) : 0;
    if (_choice_count > 0) {
        if (_choice_up) {
            choice_selected_index = (choice_selected_index - 1 + _choice_count) % _choice_count;
            if (audio_exists(sfx_choice_select)) scr_play_sfx(sfx_choice_select, 5, false);
        }
        if (_choice_down) {
            choice_selected_index = (choice_selected_index + 1) % _choice_count;
            if (audio_exists(sfx_choice_select)) scr_play_sfx(sfx_choice_select, 5, false);
        }
        
        if (_choice_confirm) {
            if (audio_exists(sfx_choice_confirm)) scr_play_sfx(sfx_choice_confirm, 6, false);
            var _selected_choice = choices_array[choice_selected_index];
            
            if (variable_struct_exists(_selected_choice, "target_scene")) {
                scene_index = _selected_choice.target_scene;
            } else {
                scene_index++;
            }
            
            choice_active = false;
            choices_array = [];
            char_index = 0;
            current_text = "";
            text_finished = false;
        }
    }
    exit;
}

// --- 3. SCREEN SHAKE & PARTICLE UPDATING ---
if (shake_timer > 0) {
    shake_timer--;
    shake_x = random_range(-shake_intensity, shake_intensity);
    shake_y = random_range(-shake_intensity, shake_intensity);
    if (shake_timer <= 0) {
        shake_intensity = 0;
        shake_x = 0;
        shake_y = 0;
    }
}

if (is_array(particle_list)) {
    for (var _p = 0; _p < array_length(particle_list); _p++) {
        var _part = particle_list[_p];
        _part.y -= _part.spd;
        if (_part.y < 0) {
            _part.y = 144;
            _part.x = random(160);
        }
    }
}

var _advance = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter) || mouse_check_button_pressed(mb_left) || _gp_confirm;
var _skip    = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("S")) || _gp_cancel;

// Global Cutscene Skip
if (_skip && fade_state != 2) {
    io_clear();
    if (audio_exists(sfx_dialogue_continue)) {
        scr_play_sfx(sfx_dialogue_continue, 5, false);
    }
    if (audio_exists(sfx_static_glitch) && audio_is_playing(sfx_static_glitch)) {
        audio_stop_sound(sfx_static_glitch);
    }
    if (audio_exists(sfx_ambient_city) && audio_is_playing(sfx_ambient_city)) {
        audio_stop_sound(sfx_ambient_city);
    }
    if (voice_sync_inst != -1 && audio_is_playing(voice_sync_inst)) {
        audio_stop_sound(voice_sync_inst);
    }
    if (voice_sync_music_ducked && bgm_inst != -1 && audio_is_playing(bgm_inst)) {
        audio_sound_gain(bgm_inst, 1, 0);
    }
    voice_sync_active       = false;
    voice_sync_music_ducked = false;
    voice_sync_group_name   = "";
    fade_state = 2;
}

if (!is_array(cutscenes) || array_length(cutscenes) == 0) {
    cutscenes = [];
    scene_total = 0;
    exit;
}
scene_total = array_length(cutscenes);

var _slide = cutscenes[min(scene_index, max(0, scene_total - 1))];
var _spk = variable_struct_exists(_slide, "speaker") ? string_lower(_slide.speaker) : "";

if (string_pos("victor", _spk) > 0 || string_pos("sharp", _spk) > 0) {
    target_r = 45; target_g = 15; target_b = 15;
} else if (string_pos("charlotte", _spk) > 0) {
    target_r = 35; target_g = 15; target_b = 35;
} else if (string_pos("jack", _spk) > 0) {
    target_r = 40; target_g = 30; target_b = 15;
} else if (string_pos("mark", _spk) > 0) {
    target_r = 15; target_g = 25; target_b = 45;
} else if (string_pos("jason", _spk) > 0) {
    target_r = 25; target_g = 25; target_b = 30;
} else if (string_pos("jessica", _spk) > 0) {
    target_r = 30; target_g = 20; target_b = 40;
} else {
    target_r = 15; target_g = 20; target_b = 35;
}

bg_r = lerp(bg_r, target_r, 0.08);
bg_g = lerp(bg_g, target_g, 0.08);
bg_b = lerp(bg_b, target_b, 0.08);

switch (fade_state) {
    case 0: // Fade In
        if (global.fade_style == "OFF") fade_alpha = 0; else fade_alpha -= fade_speed;
        if (fade_alpha <= 0) {
            fade_alpha = 0;
            fade_state = 1;
        }
        break;

    case 1: // Active Cutscene
        var _raw_text = variable_struct_exists(_slide, "text") ? _slide.text : "";
        _raw_text = sanitize_cutscene_text(_raw_text);

        var _target_text = _raw_text;
        var _prev_count = floor(char_index);

        var _has_voice_sync_group = variable_struct_exists(_slide, "voice_sync_group");
        var _voice_sync_ready     = enable_victor_voice_sync_mode && audio_exists(sfx_victor_monologue_vo);
        var _voice_sync_applies   = _has_voice_sync_group && _voice_sync_ready && (_slide.voice_sync_group != voice_sync_completed_group);

        var _voice_sync_just_completed = false;

        // SFX Triggers
        if (variable_struct_exists(_slide, "sfx")) {
            if (_slide.sfx == sfx_victor_laugh && !_voice_sync_applies) {
                if (!variable_instance_exists(id, "laugh_played") || !laugh_played) {
                    if (audio_exists(sfx_victor_laugh)) scr_play_sfx(sfx_victor_laugh, 9, false);
                    laugh_played = true;
                }
            }
            if (_slide.sfx == sfx_screen_off) {
                if (!variable_instance_exists(id, "screen_off_played") || !screen_off_played) {
                    if (audio_exists(sfx_screen_off)) scr_play_sfx(sfx_screen_off, 9, false);
                    screen_off_played = true;
                }
            }
            if (_slide.sfx == sfx_siren_distant) {
                if (!variable_instance_exists(id, "siren_played") || !siren_played) {
                    if (audio_exists(sfx_siren_distant)) scr_play_sfx(sfx_siren_distant, 8, false);
                    siren_played = true;
                }
            }
            if (_slide.sfx == sfx_static_glitch) {
                if (!variable_instance_exists(id, "glitch_playing") || !glitch_playing) {
                    if (audio_exists(sfx_static_glitch) && !audio_is_playing(sfx_static_glitch)) {
                        scr_play_sfx(sfx_static_glitch, 8, true);
                    }
                    glitch_playing = true;
                }
            }
            if (_slide.sfx == sfx_ambient_city) {
                if (!variable_instance_exists(id, "city_ambient_playing") || !city_ambient_playing) {
                    if (audio_exists(sfx_ambient_city) && !audio_is_playing(sfx_ambient_city)) {
                        scr_play_sfx(sfx_ambient_city, 8, true);
                    }
                    city_ambient_playing = true;
                }
            }
        }

        if (_voice_sync_applies) {
            if (!voice_sync_active) {
                if (voice_sync_inst != -1 && audio_is_playing(voice_sync_inst)) {
                    audio_stop_sound(voice_sync_inst);
                }
                voice_sync_inst       = scr_play_sfx(sfx_victor_monologue_vo, 10, false);
                voice_sync_start_time = current_time;
                voice_sync_duration   = audio_sound_length(sfx_victor_monologue_vo) * 1000;
                voice_sync_group_name = _slide.voice_sync_group;
                voice_sync_active     = true;

                voice_sync_timeline = [];
                voice_sync_group_start_index = scene_index;
                var _vs_scan = scene_index;
                while (_vs_scan < scene_total
                    && variable_struct_exists(cutscenes[_vs_scan], "voice_sync_group")
                    && cutscenes[_vs_scan].voice_sync_group == _slide.voice_sync_group) {
                    var _vs_lines = variable_struct_exists(cutscenes[_vs_scan], "sync_lines") ? cutscenes[_vs_scan].sync_lines : [];
                    for (var _vs_li = 0; _vs_li < array_length(_vs_lines); _vs_li++) {
                        array_push(voice_sync_timeline, {
                            t: _vs_lines[_vs_li].t,
                            txt: _vs_lines[_vs_li].txt,
                            slide_offset: _vs_scan - scene_index
                        });
                    }
                    _vs_scan++;
                }
                voice_sync_group_end_index = _vs_scan - 1;

                if (bgm_inst != -1 && audio_is_playing(bgm_inst)) {
                    audio_sound_gain(bgm_inst, 0.15, 400);
                    voice_sync_music_ducked = true;
                }
            }

            var _vs_elapsed = (current_time - voice_sync_start_time) / 1000;
            var _vs_active_txt = "";
            var _vs_active_offset = 0;
            for (var _vs_ti = 0; _vs_ti < array_length(voice_sync_timeline); _vs_ti++) {
                if (voice_sync_timeline[_vs_ti].t <= _vs_elapsed) {
                    _vs_active_txt = voice_sync_timeline[_vs_ti].txt;
                    _vs_active_offset = voice_sync_timeline[_vs_ti].slide_offset;
                } else {
                    break;
                }
            }

            current_text = sanitize_cutscene_text(_vs_active_txt);
            scene_index  = voice_sync_group_start_index + _vs_active_offset;
            text_finished = false;

            var _vs_vo_playing = (voice_sync_inst != -1) && audio_is_playing(voice_sync_inst);
            if (!_vs_vo_playing || _vs_elapsed >= (voice_sync_duration / 1000)) {
                voice_sync_active = false;
                voice_sync_completed_group = voice_sync_group_name;
                voice_sync_group_name = "";
                _voice_sync_just_completed = true;

                if (voice_sync_music_ducked && bgm_inst != -1 && audio_is_playing(bgm_inst)) {
                    audio_sound_gain(bgm_inst, 1, 600);
                }
                voice_sync_music_ducked = false;

                siren_played = false;
                glitch_played = false;
                city_ambient_playing = false;
                laugh_played = false;
                screen_off_played = false;

                scene_index = voice_sync_group_end_index + 1;

                if (scene_index < scene_total) {
                    char_index = 0;
                    current_text = "";
                    text_finished = false;
                } else {
                    fade_state = 2;
                }
            }
        } else {
            if (char_index < string_length(_target_text)) {
                char_index += char_speed;
                current_text = string_copy(_target_text, 1, floor(char_index));
                text_finished = false;

                var _curr_count = floor(char_index);
                if (_curr_count > _prev_count) {
                    var _sfx = variable_struct_exists(_slide, "sfx") ? _slide.sfx : -1;
                    _sfx = resolve_sfx(_sfx, _slide.speaker);
                    
                    if (string_pos("jack", _spk) > 0) {
                        if (_sfx == -1 || _sfx == sfx_dialogue) _sfx = sfx_jack_speak;
                    } 
                    
                    if (_sfx != -1 && _sfx != sfx_victor_laugh && _sfx != sfx_screen_off && audio_exists(_sfx)) {
                        audio_stop_sound(_sfx);
                        scr_play_sfx(_sfx, 10, false);
                    }
                }
            } else {
                current_text = _target_text;
                text_finished = true;

                if (variable_instance_exists(id, "glitch_playing") && glitch_playing) {
                    if (audio_exists(sfx_static_glitch) && audio_is_playing(sfx_static_glitch)) {
                        audio_stop_sound(sfx_static_glitch);
                    }
                    glitch_playing = false;
                }

                if (variable_instance_exists(id, "city_ambient_playing") && city_ambient_playing) {
                    if (audio_exists(sfx_ambient_city) && audio_is_playing(sfx_ambient_city)) {
                        audio_stop_sound(sfx_ambient_city);
                    }
                    city_ambient_playing = false;
                }
            }
        }

        if (_advance && !voice_sync_active && !_voice_sync_just_completed) {
            if (audio_exists(sfx_dialogue_continue)) {
                scr_play_sfx(sfx_dialogue_continue, 5, false);
            }
            if (audio_exists(sfx_static_glitch) && audio_is_playing(sfx_static_glitch)) {
                audio_stop_sound(sfx_static_glitch);
            }
            if (audio_exists(sfx_ambient_city) && audio_is_playing(sfx_ambient_city)) {
                audio_stop_sound(sfx_ambient_city);
            }

            if (!text_finished) {
                char_index = string_length(_target_text);
                current_text = _target_text;
                text_finished = true;
                glitch_playing = false;
                city_ambient_playing = false;
            } else {
                array_insert(dialogue_history, 0, {
                    speaker: variable_struct_exists(_slide, "speaker") ? _slide.speaker : "Unknown",
                    text: _target_text
                });
                if (array_length(dialogue_history) > max_backlog_entries) {
                    array_pop(dialogue_history);
                }

                if (variable_struct_exists(_slide, "choices") && is_array(_slide.choices) && array_length(_slide.choices) > 0) {
                    choice_active = true;
                    choices_array = _slide.choices;
                    choice_selected_index = 0;
                } else {
                    scene_index++;
                }

                siren_played = false;
                glitch_played = false;
                city_ambient_playing = false;
                laugh_played = false;
                screen_off_played = false;
                
                if (scene_index < scene_total) {
                    char_index = 0;
                    current_text = "";
                    text_finished = false;
                } else {
                    fade_state = 2;
                }
            }
        }
        break;

    case 2: // Fade Out & Change Room
        if (global.fade_style == "OFF") fade_alpha = 1; else fade_alpha += fade_speed;
        
        if (audio_exists(sfx_static_glitch) && audio_is_playing(sfx_static_glitch)) {
            audio_stop_sound(sfx_static_glitch);
        }
        if (audio_exists(sfx_ambient_city) && audio_is_playing(sfx_ambient_city)) {
            audio_stop_sound(sfx_ambient_city);
        }
        if (voice_sync_inst != -1 && audio_is_playing(voice_sync_inst)) {
            audio_stop_sound(voice_sync_inst);
        }
        if (bgm_inst != -1 && audio_is_playing(bgm_inst)) {
            audio_sound_gain(bgm_inst, max(0, 1 - fade_alpha), 0);
        }

        if (fade_alpha >= 1) {
            fade_alpha = 1;
            if (!scr_transition_black_hold_complete(id)) break;
            if (audio_exists(mus_cutscene) && audio_is_playing(mus_cutscene)) {
                audio_stop_sound(mus_cutscene);
            }
            if (room_exists(target_room)) {
                room_goto(target_room);
            }
        }
        break;
}
