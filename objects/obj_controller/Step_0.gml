/// @description Level Controller Step Logic - Pause, Audio, Timers, Death & Transitions

// Some older rooms do not place Mark. Spawn him beside Jack once per room.
if (!instance_exists(obj_mark) && instance_exists(obj_jack)) {
    var _jack_for_mark = instance_find(obj_jack, 0);
    var _mark_layer = layer_exists("Instances") ? "Instances" : layer_get_name(_jack_for_mark.layer);
    instance_create_layer(
        _jack_for_mark.x - (28 * _jack_for_mark.image_xscale),
        _jack_for_mark.y - 16,
        _mark_layer,
        obj_mark
    );
}
if (instance_exists(obj_mark) && instance_exists(obj_jack)) {
    var _mark_to_attach = instance_find(obj_mark, 0);
    var _jack_to_attach = instance_find(obj_jack, 0);
    _mark_to_attach.target = _jack_to_attach;
}

// --- 1. HUD VISUAL INTERPOLATION LOGIC ---
if (total_collectibles <= 0 && instance_exists(obj_gem)) {
    total_collectibles = instance_number(obj_gem);
}

var _target_hp = 0;

if (instance_exists(obj_jack)) {
    if (variable_instance_exists(obj_jack, "hp")) {
        _target_hp = obj_jack.hp;
    }
}

// Smooth the displayed health value toward Jack's current HP.
hp_visual_current = lerp(hp_visual_current, _target_hp, 0.25);

// Restore a requested autosave after the destination room has created Jack.
if (global.autosave_restore_pending && instance_exists(obj_jack)) {
    var _restore = global.autosave_restore_data;
    var _saved_player = instance_find(obj_jack, 0);
    _saved_player.x = clamp(_restore.x, 0, room_width);
    _saved_player.y = clamp(_restore.y, 0, room_height - 1);
    _saved_player.hp = clamp(_restore.hp, 1, _saved_player.max_hp);
    game_score = max(0, floor(_restore.score));
    player_lives = clamp(floor(_restore.lives), 1, 99);
    game_timer_ticks = max(0, floor(_restore.timer_ticks));
    global.game_score = game_score;
    global.game_lives = player_lives;
    global.time_attack_active = _restore.time_attack_active;
    global.time_attack_ticks = max(0, floor(_restore.time_attack_ticks));
    hp_visual_current = _saved_player.hp;
    var _mark_after_restore = instance_find(obj_mark, 0);
    if (_mark_after_restore != noone) {
        _mark_after_restore.target = _saved_player;
        _mark_after_restore.x = _saved_player.x - (28 * _saved_player.image_xscale);
        _mark_after_restore.y = _saved_player.y - 16;
    }
    global.autosave_restore_pending = false;
    autosave_timer = 0;
}

// Direct Asset Reference
var _snd_continue = sfx_dialogue_continue;
var _snd_death    = mus_life_lost;

// --- 2. INPUT PROCESSING & LOCAL PAUSE SYSTEM ---
var _gp_connected = gamepad_is_connected(0);
var _key_pause = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("P"))
    || (_gp_connected && gamepad_button_check_pressed(0, gp_start));
var _key_debug = keyboard_check_pressed(vk_f3);
var _pause_opened = false;
var _player_is_dead = false;
if (instance_exists(obj_jack)) {
    var _pause_player = instance_find(obj_jack, 0);
    _player_is_dead = variable_instance_exists(_pause_player, "is_dead") && _pause_player.is_dead;
}

if (_key_pause && !game_paused && state == TRANSITION_STATE.IDLE
    && !is_game_over && !game_over_pending && !life_lost_pending_restart
    && !_player_is_dead && death_notice_timer <= 0) {
    game_paused = true;
    _pause_opened = true;
    pause_page = 0;
    pause_option = 0;
    pause_music_was_playing = (bgm_handle != -1 && audio_is_playing(bgm_handle));
    if (pause_music_was_playing) audio_pause_sound(bgm_handle);
    instance_deactivate_all(true);
    if (audio_exists(_snd_continue)) scr_play_sfx(_snd_continue, 5, false);
}

// Transitions also set game_paused to freeze gameplay; only show the pause UI
// while the room is idle and the player explicitly opened the pause menu.
pause_slide = lerp(pause_slide, (game_paused && state == TRANSITION_STATE.IDLE) ? 1.0 : 0.0, 0.2);

if (game_paused) {
    var _key_up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")) || (_gp_connected && gamepad_button_check_pressed(0, gp_padu));
    var _key_down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")) || (_gp_connected && gamepad_button_check_pressed(0, gp_padd));
    var _key_left = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A")) || (_gp_connected && gamepad_button_check_pressed(0, gp_padl));
    var _key_right = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D")) || (_gp_connected && gamepad_button_check_pressed(0, gp_padr));
    var _key_select = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter) || (_gp_connected && gamepad_button_check_pressed(0, gp_face1));
    var _key_back = !_pause_opened && (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace) || (_gp_connected && gamepad_button_check_pressed(0, gp_face2)));
    var _settings_keys = ["bgm_volume", "sfx_volume", "language_setting", "player_physics", "scrolling_mode", "transition_style", "pause_back"];
    var _language_codes = ["EN", "DE", "ES", "PL", "SH", "EG", "JG"];
    var _fade_styles = ["SMOOTH", "NES", "GENESIS", "MOSAIC", "FLASH", "BLACK", "OFF"];

    if (pause_page == 0) {
        if (_key_back) {
            if (pause_jukebox_handle != -1) audio_stop_sound(pause_jukebox_handle);
            pause_jukebox_handle = -1;
            pause_jukebox_playing = false;
            game_paused = false;
            instance_activate_all();
            if (pause_music_was_playing && bgm_handle != -1) audio_resume_sound(bgm_handle);
            pause_music_was_playing = false;
        } else {
            if (_key_up) pause_option = (pause_option + pause_options_count - 1) mod pause_options_count;
            if (_key_down) pause_option = (pause_option + 1) mod pause_options_count;
            if (_key_select) {
                switch (pause_option) {
                    case 0:
                        game_paused = false;
                        instance_activate_all();
                        if (pause_music_was_playing && bgm_handle != -1) audio_resume_sound(bgm_handle);
                        pause_music_was_playing = false;
                        break;
                    case 1: restart_level(); break;
                    case 2: pause_page = 1; pause_settings_index = 0; break;
                    case 3:
                        pause_jukebox_tracks = scr_jukebox_ost_playlist();
                        pause_jukebox_index = 0;
                        pause_jukebox_handle = -1;
                        pause_jukebox_playing = false;
                        pause_page = 2;
                        break;
                    case 4:
                        pause_confirm_selection = 1;
                        pause_page = 3;
                        break;
                }
            }
        }
    } else if (pause_page == 1) {
        if (_key_back) pause_page = 0;
        else {
            if (_key_up) pause_settings_index = (pause_settings_index + array_length(_settings_keys) - 1) mod array_length(_settings_keys);
            if (_key_down) pause_settings_index = (pause_settings_index + 1) mod array_length(_settings_keys);
            var _adjust = _key_right ? 1 : (_key_left ? -1 : 0);
            if (_key_select && pause_settings_index == array_length(_settings_keys) - 1) pause_page = 0;
            else if (_adjust != 0 || _key_select) {
                switch (pause_settings_index) {
                    case 0:
                        global.vol_bgm = clamp(global.vol_bgm + ((_adjust == 0) ? 10 : _adjust * 10), 0, 100);
                        bgm_target_volume = global.vol_bgm / 100;
                        if (bgm_handle != -1) audio_sound_gain(bgm_handle, bgm_target_volume, 0);
                        break;
                    case 1: global.vol_sfx = clamp(global.vol_sfx + ((_adjust == 0) ? 10 : _adjust * 10), 0, 100); break;
                    case 2:
                        var _language_index = 0;
                        for (var _li = 0; _li < array_length(_language_codes); _li++) if (_language_codes[_li] == global.language) _language_index = _li;
                        global.language = _language_codes[(_language_index + ((_adjust == 0) ? 1 : _adjust) + array_length(_language_codes)) mod array_length(_language_codes)];
                        break;
                    case 3: global.player_physics_mode = (global.player_physics_mode == "DEFAULT") ? "BOOTLEG" : "DEFAULT"; break;
                    case 4: global.scrolling_mode = (global.scrolling_mode == "DEFAULT") ? "JITTERY" : "DEFAULT"; break;
                    case 5:
                        var _fi = 0;
                        for (var _f = 0; _f < array_length(_fade_styles); _f++) if (_fade_styles[_f] == global.fade_style) _fi = _f;
                        global.fade_style = _fade_styles[(_fi + ((_adjust == 0) ? 1 : _adjust) + array_length(_fade_styles)) mod array_length(_fade_styles)];
                        break;
                }
                scr_save_settings();
            }
        }
    } else if (pause_page == 2) {
        if (_key_back) {
            if (pause_jukebox_handle != -1) audio_stop_sound(pause_jukebox_handle);
            pause_jukebox_handle = -1;
            pause_jukebox_playing = false;
            pause_page = 0;
        } else {
            var _track_count = array_length(pause_jukebox_tracks);
            if (_track_count > 0 && _key_up) pause_jukebox_index = (pause_jukebox_index + _track_count - 1) mod _track_count;
            if (_track_count > 0 && _key_down) pause_jukebox_index = (pause_jukebox_index + 1) mod _track_count;
            if (_key_select && _track_count > 0) {
                if (pause_jukebox_playing && pause_jukebox_index == pause_jukebox_active_index) {
                    audio_stop_sound(pause_jukebox_handle);
                    pause_jukebox_handle = -1;
                    pause_jukebox_playing = false;
                } else {
                    if (pause_jukebox_handle != -1) audio_stop_sound(pause_jukebox_handle);
                    pause_jukebox_handle = audio_play_sound(pause_jukebox_tracks[pause_jukebox_index].sound, 5, true);
                    audio_sound_gain(pause_jukebox_handle, global.vol_bgm / 100, 0);
                    pause_jukebox_active_index = pause_jukebox_index;
                    pause_jukebox_playing = (pause_jukebox_handle != -1);
                }
            }
        }
    } else if (pause_page == 3) {
        if (_key_back) pause_page = 0;
        else {
            if (_key_up || _key_down || _key_left || _key_right) pause_confirm_selection = 1 - pause_confirm_selection;
            if (_key_select) {
                if (pause_confirm_selection == 0) {
                    if (pause_jukebox_handle != -1) audio_stop_sound(pause_jukebox_handle);
                    if (instance_exists(obj_jack)) {
                        var _save_player = instance_find(obj_jack, 0);
                        scr_game_autosave_write({
                            room_id: room,
                            x: _save_player.x,
                            y: _save_player.y,
                            hp: _save_player.hp,
                            score: game_score,
                            lives: player_lives,
                            timer_ticks: game_timer_ticks,
                            time_attack_active: global.time_attack_active,
                            time_attack_ticks: global.time_attack_ticks
                        });
                        if (!global.time_attack_active) scr_game_save_slot_write(global.active_save_slot, global.player_name, {
                            room_id: room,
                            x: _save_player.x,
                            y: _save_player.y,
                            hp: _save_player.hp,
                            score: game_score,
                            lives: player_lives,
                            timer_ticks: game_timer_ticks,
                            time_attack_active: global.time_attack_active,
                            time_attack_ticks: global.time_attack_ticks
                        });
                    }
                    stop_level_audio();
                    global.game_session_active = false;
                    begin_room_transition(exit_room);
                } else pause_page = 0;
            }
        }
    }
    if (state == TRANSITION_STATE.IDLE) exit;
}

if (_key_debug) {
    show_debug_overlay_custom = !show_debug_overlay_custom;
}

// --- 3. PLAYER DEATH MONITORING & RESTART CONTROLLER ---
if (instance_exists(obj_jack)) {
    if (obj_jack.is_dead && !death_resolution_active) {
        death_resolution_active = true;
        
        // Decrement remaining life count once upon death registration
        player_lives = max(0, player_lives - 1);
        global.game_lives = player_lives;
        global.game_score = game_score;
        var _instant_respawn = global.cheat_instant_respawn;
        death_notice_timer = _instant_respawn ? 0 : death_notice_duration;
        
        stop_level_audio();

        if (!_instant_respawn && audio_exists(_snd_death)) {
            life_lost_audio_id = audio_play_sound(_snd_death, 10, false);
            if (life_lost_audio_id != -1) {
                audio_sound_gain(life_lost_audio_id, global.vol_bgm / 100, 0);
            }
        } else {
            life_lost_audio_id = -1;
        }

        // Branch depending on remaining life count
        if (player_lives <= 0) {
            game_over_pending = true;
        } else {
            life_lost_pending_restart = true;
        }
    }
}

// Handle Game Over Screen
if (is_game_over) {
    var _continue_pressed = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)
        || (_gp_connected && (gamepad_button_check_pressed(0, gp_face1) || gamepad_button_check_pressed(0, gp_start)));
    var _exit_pressed = keyboard_check_pressed(vk_escape)
        || (_gp_connected && gamepad_button_check_pressed(0, gp_face2));

    if (_continue_pressed) {
        continue_after_game_over();
    } else if (_exit_pressed) {
        global.game_session_active = false;
        begin_room_transition(rm_title_screen);
    }
    exit;
}

// Wait for life loss sound/animation before triggering Game Over screen
if (game_over_pending) {
    if (life_lost_audio_id == -1 || !audio_is_playing(life_lost_audio_id)) {
        game_over_pending = false;
        trigger_game_over();
    }
    exit;
}

// Wait for life loss sound/animation before restarting level
if (life_lost_pending_restart) {
    if (life_lost_audio_id == -1 || !audio_is_playing(life_lost_audio_id)) {
        life_lost_pending_restart = false;
        death_resolution_active = false;
        begin_room_transition(room);
    }
    exit;
}

// --- 4. ASCENDING GAME TIMER & DEATH LIMIT LOGIC ---
if (!game_paused && state == TRANSITION_STATE.IDLE && !death_resolution_active) {
    game_timer_ticks += 1;
    if (global.time_attack_active) global.time_attack_ticks += 1;

    autosave_timer++;
    if (autosave_timer >= game_get_speed(gamespeed_fps)) {
        autosave_timer = 0;
        if (instance_exists(obj_jack) && !obj_jack.is_dead && !is_game_over) {
            var _autosave_player = instance_find(obj_jack, 0);
            scr_game_autosave_write({
                room_id: room,
                x: _autosave_player.x,
                y: _autosave_player.y,
                hp: _autosave_player.hp,
                score: game_score,
                lives: player_lives,
                timer_ticks: game_timer_ticks,
                time_attack_active: global.time_attack_active,
                time_attack_ticks: global.time_attack_ticks
            });
            if (!global.time_attack_active) scr_game_save_slot_write(global.active_save_slot, global.player_name, {
                room_id: room,
                x: _autosave_player.x,
                y: _autosave_player.y,
                hp: _autosave_player.hp,
                score: game_score,
                lives: player_lives,
                timer_ticks: game_timer_ticks,
                time_attack_active: global.time_attack_active,
                time_attack_ticks: global.time_attack_ticks
            });
        }
    }
    
    var _total_seconds = game_timer_ticks / game_get_speed(gamespeed_fps);
    
    if (_total_seconds > max_time_seconds && !time_exceeded) {
        time_exceeded = true;
        if (!global.cheat_godmode) {
            if (instance_exists(obj_jack)) {
                with (obj_jack) {
                    if (script_exists(scr_trigger_player_death)) {
                        scr_trigger_player_death();
                    }
                }
            }
        }
    }
}

if (death_notice_timer > 0) {
    death_notice_timer--;
}

// --- 5. ROOM TRANSITION & FADE STATE MACHINE ---
switch (state) {
    case TRANSITION_STATE.IDLE:
        fade_alpha = 0.0;
        break;
        
    case TRANSITION_STATE.FADE_OUT:
        if (global.fade_style == "OFF") fade_alpha = 1; else fade_alpha += fade_speed;
        
        if (bgm_handle != -1 && audio_is_playing(bgm_handle)) {
            audio_sound_gain(bgm_handle, max(0, 1 - fade_alpha), 0);
        }
        
        if (fade_alpha >= 1.0) {
            fade_alpha = 1.0;
            if (room_exists(next_room)) {
                if (!scr_transition_black_hold_complete(id)) break;
                room_goto(next_room);
                state = TRANSITION_STATE.FADE_IN;
            } else {
                state = TRANSITION_STATE.IDLE;
            }
        }
        break;
        
    case TRANSITION_STATE.FADE_IN:
        if (global.fade_style == "OFF") fade_alpha = 0; else fade_alpha -= fade_speed;
        
        if (bgm_handle != -1 && audio_is_playing(bgm_handle)) {
            audio_sound_gain(bgm_handle, (1 - fade_alpha) * bgm_target_volume, 0);
        }
        
        if (fade_alpha <= 0.0) {
            fade_alpha = 0.0;
            state = TRANSITION_STATE.IDLE;
        }
        break;
}

// --- 6. BACKGROUND MUSIC MONITORING ---
if (bgm_enabled && state == TRANSITION_STATE.IDLE && !death_resolution_active && !is_game_over) {
    if (bgm_handle == -1 || !audio_is_playing(bgm_handle)) {
        if (script_exists(scr_play_level_music)) {
            bgm_handle = scr_play_level_music(room, bgm_target_volume);
        }
    }
}
