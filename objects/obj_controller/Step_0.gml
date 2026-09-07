/// @description Level Controller Step Logic - Pause, Audio, Timers & Transitions

// --- 1. HUD VISUAL INTERPOLATION LOGIC ---
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
    var _weather_wind = weather_wind ? 0.8 : 0.0;

    for (var _weather_i = 0; _weather_i < array_length(weather_drops); _weather_i++) {
        var _drop = weather_drops[_weather_i];
        _drop.y += _drop.speed;
        _drop.x -= _weather_wind;
        if (_drop.y > _weather_view_h + 20 || _drop.x < -20) {
            _drop.x = random(_weather_view_w + 32);
            _drop.y = random_range(-40, -5);
        }
    }

    if (irandom(720) == 0) {
        weather_flash_alpha = 0.45;
        if (audio_exists(sfx_thunder)) {
            var _thunder_id = audio_play_sound(sfx_thunder, 8, false);
            audio_sound_gain(_thunder_id, global.vol_sfx / 100, 0);
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
if (bgm_enabled && audio_exists(mus_subway)) {
    if (!audio_is_playing(mus_subway) && state == TRANSITION_STATE.IDLE) {
        bgm_handle = audio_play_sound(mus_subway, 10, true);
        audio_sound_gain(bgm_handle, bgm_target_volume, 0);
    }
}