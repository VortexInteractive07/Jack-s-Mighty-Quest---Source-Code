/// @description Level Controller Step Logic - Pause, Audio, Timers & Transitions

// --- 1. HUD VISUAL INTERPOLATION LOGIC ---
if (pending_restore_apply && variable_global_exists("pending_game_restore")
&& is_struct(global.pending_game_restore) && global.pending_game_restore.room_asset == room
&& instance_exists(obj_jack)) {
    global.pending_game_restore = undefined;
    pending_restore_apply = false;
}
if (instance_exists(obj_jack)) {
    var _standing_jack = instance_find(obj_jack, 0);
    if (!_standing_jack.is_dead && _standing_jack.hp > 0) {
        var _standing_mark = instance_exists(obj_mark) ? instance_find(obj_mark, 0) : noone;
        global.last_stand = {
            room_asset: room,
            x: _standing_jack.x,
            y: _standing_jack.y,
            mark_x: (_standing_mark != noone) ? _standing_mark.x : _standing_jack.x - 28,
            mark_y: (_standing_mark != noone) ? _standing_mark.y : _standing_jack.y - 16,
            hp: _standing_jack.hp
        };
    }
}
if (!variable_instance_exists(id, "autosave_timer")) autosave_timer = 0;
autosave_timer++;
if (autosave_timer >= max(1, floor(game_get_speed(gamespeed_fps) * 0.5))) {
    autosave_timer = 0;
    scr_save_slot_autosave();
}
if (total_collectibles <= 0 && instance_exists(obj_gem)) {
    total_collectibles = instance_number(obj_gem);
}

var _target_hp = 0;
var _target_max_hp = 100;

if (instance_exists(obj_jack)) {
    if (variable_instance_exists(obj_jack, "hp")) {
        _target_hp = obj_jack.hp;
    }
    if (variable_instance_exists(obj_jack, "max_hp")) {
        _target_max_hp = obj_jack.max_hp;
    }
}

// Smooth dual-layer health bar motion
hp_visual_current = lerp(hp_visual_current, _target_hp, 0.25);
hp_visual_catchup = lerp(hp_visual_catchup, hp_visual_current, 0.08);

// --- 2. INPUT PROCESSING & LOCAL PAUSE SYSTEM ---
var _key_pause = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("P"));
var _key_debug = keyboard_check_pressed(vk_f3);

if (keyboard_check_pressed(vk_f1)) {
    global.guidebook_open = !global.guidebook_open;
    global.inventory_open = false;
}
if (keyboard_check_pressed(ord("I")) && !global.guidebook_open) global.inventory_open = !global.inventory_open;
if (global.inventory_open || global.guidebook_open) {
    if (global.inventory_open) {
        var _items = global.inventory_items;
        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) global.inventory_index = max(0, global.inventory_index - 1);
        if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) global.inventory_index = min(array_length(_items) - 1, global.inventory_index + 1);
        if ((keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) && array_length(_items) > 0) {
            var _item = _items[global.inventory_index];
            if (_item.category == "FOOD" && _item.quantity > 0 && instance_exists(obj_jack)) {
                var _player = instance_find(obj_jack, 0);
                _player.hp = min(_player.max_hp, _player.hp + _item.heal);
                _item.quantity--;
                if (_item.quantity <= 0) {
                    global.inventory_items = array_delete(_items, global.inventory_index, 1);
                    global.inventory_index = max(0, global.inventory_index - 1);
                }
            }
        }
    }
    if (_key_pause || keyboard_check_pressed(vk_backspace)) {
        global.inventory_open = false;
        global.guidebook_open = false;
    }
    exit;
}

if (_key_pause && state == TRANSITION_STATE.IDLE && !is_game_over) {
    game_paused = !game_paused;
    pause_option = 0;
    
    if (audio_exists(sfx_dialogue_continue)) {
        audio_play_sound(sfx_dialogue_continue, 5, false);
    }
    
    if (game_paused) {
        instance_deactivate_all(true);
    } else {
        instance_activate_all();
    }
}

// Animate pause menu entry/exit slide
pause_slide = lerp(pause_slide, game_paused ? 1.0 : 0.0, 0.2);
pause_wave_timer += 0.08;

// Pause Menu Navigation Controls
if (game_paused) {
    var _key_up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
    var _key_down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
    var _key_select = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter);
    
    if (_key_up) {
        pause_option--;
        if (pause_option < 0) pause_option = pause_options_count - 1;
        if (audio_exists(sfx_dialogue_continue)) {
            audio_play_sound(sfx_dialogue_continue, 3, false);
        }
    }
    if (_key_down) {
        pause_option++;
        if (pause_option >= pause_options_count) pause_option = 0;
        if (audio_exists(sfx_dialogue_continue)) {
            audio_play_sound(sfx_dialogue_continue, 3, false);
        }
    }
    
    if (_key_select) {
        if (pause_option == 0) { // Continue
            game_paused = false;
            instance_activate_all();
        } else if (pause_option == 1) { // Restart
            restart_level();
        } else if (pause_option == 2) { // Main Menu
            game_paused = false;
            instance_activate_all();
            if (room_exists(exit_room)) {
                room_goto(exit_room);
            }
        }
    }
    exit;
}

if (_key_debug) {
    show_debug_overlay_custom = !show_debug_overlay_custom;
}

// Weather keeps simulating during player death and game-over presentation.
if (weather_enabled && !game_paused) {
    weather_timer++;
    weather_flash_alpha = max(0, weather_flash_alpha - 0.08);

    var _weather_view_w = camera_get_view_width(view_camera[0]);
    var _weather_view_h = camera_get_view_height(view_camera[0]);
    var _weather_wind = weather_wind ? max(0.8, wind_speed_mph / 50 * 2.4) : 0.0;

    for (var _weather_i = 0; _weather_i < array_length(weather_drops); _weather_i++) {
        var _drop = weather_drops[_weather_i];
        _drop.y += _drop.speed;
        _drop.x -= _weather_wind;
        if (_drop.y > _weather_view_h + 20 || _drop.x < -20) {
            _drop.x = random(_weather_view_w + 32);
            _drop.y = random_range(-40, -5);
        }
    }

    weather_thunder_timer--;
    if (weather_thunder_timer <= 0) {
        weather_thunder_timer = stage2_storm ? irandom_range(1800, 3600) : irandom_range(900, 2400);
        weather_flash_alpha = stage2_storm ? 0.32 : 0.25;
        if (audio_exists(sfx_thunder)) {
            var _thunder_id = audio_play_sound(sfx_thunder, 8, false);
            audio_sound_gain(_thunder_id, global.vol_sfx / 100, 0);
        }
    }
}

if (stage_theme_effect != 0 && !game_paused && !is_game_over) {
    var _effect_view_w = camera_get_view_width(view_camera[0]);
    var _effect_view_h = camera_get_view_height(view_camera[0]);
    for (var _fx_i = 0; _fx_i < array_length(stage_effect_particles); _fx_i++) {
        var _effect = stage_effect_particles[_fx_i];
        _effect.y += _effect.speed;
        _effect.phase += 2;
        if (stage_theme_effect == 1) {
            _effect.x -= 0.6;
            if (_effect.y > _effect_view_h + 8 || _effect.x < -8) {
                _effect.x = random(_effect_view_w + 16);
                _effect.y = random_range(-24, -4);
            }
        } else {
            _effect.x += sin(_effect.phase) * 0.35;
            if (_effect.y > _effect_view_h + 8) {
                _effect.y = random_range(-24, -4);
                _effect.x = random(_effect_view_w);
            }
        }
    }
}

// --- 3. GAME OVER MONITORING & RESTART CONTROLLER ---
if (is_game_over) {
    var _continue_pressed = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
    var _exit_pressed = keyboard_check_pressed(vk_escape);

    if (_continue_pressed) {
        continue_after_game_over();
    } else if (_exit_pressed) {
        global.game_session_active = false;
        if (room_exists(rm_title_screen)) room_goto(rm_title_screen);
    }
    exit;
}

if (game_over_pending) {
    if (life_lost_audio_id == -1 || !audio_is_playing(life_lost_audio_id)) {
        trigger_game_over();
    }
    exit;
}

if (life_lost_pending_restart) {
    if (life_lost_audio_id == -1 || !audio_is_playing(life_lost_audio_id)) {
        life_lost_pending_restart = false;
        death_resolution_active = false;
        room_restart();
    }
    exit;
}

// --- 4. ASCENDING GAME TIMER & DEATH LIMIT LOGIC ---
if (!game_paused && state == TRANSITION_STATE.IDLE) {
    game_timer_ticks += 1;
    
    var _total_seconds = game_timer_ticks / game_get_speed(gamespeed_fps);
    
    if (_total_seconds > max_time_seconds && !time_exceeded) {
        time_exceeded = true;
        player_lives = 0;
        
        if (instance_exists(obj_jack)) {
            with (obj_jack) {
                hp = 0;
                if (script_exists(scr_trigger_player_death)) {
                    scr_trigger_player_death();
                }
            }
        }
    }
}

// --- 5. ROOM TRANSITION & FADE STATE MACHINE ---
switch (state) {
    case TRANSITION_STATE.IDLE:
        fade_alpha = 0.0;
        break;
        
    case TRANSITION_STATE.FADE_OUT:
        fade_alpha += fade_speed;
        
        if (bgm_handle != -1 && audio_is_playing(bgm_handle)) {
            audio_sound_gain(bgm_handle, max(0, 1 - fade_alpha), 0);
        }
        
        if (fade_alpha >= 1.0) {
            fade_alpha = 1.0;
            if (room_exists(next_room)) {
                room_goto(next_room);
                state = TRANSITION_STATE.FADE_IN;
            } else {
                state = TRANSITION_STATE.IDLE;
            }
        }
        break;
        
    case TRANSITION_STATE.FADE_IN:
        fade_alpha -= fade_speed;
        
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
if (bgm_enabled && bgm_asset != -1 && audio_exists(bgm_asset)) {
    if ((bgm_handle == -1 || !audio_is_playing(bgm_handle)) && state == TRANSITION_STATE.IDLE) {
        bgm_handle = audio_play_sound(bgm_asset, 10, true);
        if (bgm_handle != -1) {
            audio_sound_gain(bgm_handle, bgm_target_volume, 0);
        } else {
            show_debug_message("Could not restart level music.");
        }
    }
}
