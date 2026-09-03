/// @description Level Controller Step Logic - Pause, Audio, Timers & Transitions

// --- 1. HUD VISUAL INTERPOLATION LOGIC ---
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
            game_paused = false;
            instance_activate_all();
            room_restart();
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

// --- 3. GAME OVER MONITORING & RESTART CONTROLLER ---
if (is_game_over) {
    game_over_timer--;
    if (game_over_timer <= 0) {
        is_game_over = false;
        player_lives = 3;
        game_score = 0;
        game_timer_ticks = 0;
        if (room_exists(rm_splash_screen)) {
            room_goto(rm_splash_screen);
        } else {
            room_restart();
        }
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
if (audio_exists(mus_subway)) {
    if (!audio_is_playing(mus_subway) && state == TRANSITION_STATE.IDLE) {
        bgm_handle = audio_play_sound(mus_subway, 10, true);
        audio_sound_gain(bgm_handle, bgm_target_volume, 0);
    }
}