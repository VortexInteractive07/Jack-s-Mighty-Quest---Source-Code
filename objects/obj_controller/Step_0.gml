/// @description Main Controller Logic - Fades, Inputs, Timer, & Audio Management

if keyboard_check_pressed(ord("0")) {
	room_goto(rm_splash_screen);	
}	

// Define non-gameplay rooms where gameplay systems (pause, timer, HUD, music) should be dormant
var _is_non_gameplay_room = (room == room_first) || 
                            (string_pos("splash", string_lower(room_get_name(room))) > 0) || 
                            (string_pos("title", string_lower(room_get_name(room))) > 0) || 
                            (string_pos("menu", string_lower(room_get_name(room))) > 0) || 
                            (string_pos("intro", string_lower(room_get_name(room))) > 0);

// -----------------------------------------------------------------------------
// 1. INPUT PROCESSING & PAUSE SYSTEM
// -----------------------------------------------------------------------------
var _key_pause = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("P"));
var _key_debug = keyboard_check_pressed(vk_f3);

// Toggle Pause State (Only during actual gameplay rooms)
if (!_is_non_gameplay_room && _key_pause && state == TRANSITION_STATE.IDLE) {
    game_paused = !game_paused;
    
    if (game_paused) {
        instance_deactivate_all(true);
    } else {
        instance_activate_all();
    }
}

// Toggle Custom Debug Display
if (_key_debug) {
    show_debug_overlay_custom = !show_debug_overlay_custom;
}

// -----------------------------------------------------------------------------
// 2. ASCENDING GAME TIMER & DEATH LIMIT LOGIC
// -----------------------------------------------------------------------------
if (!_is_non_gameplay_room && !game_paused && state == TRANSITION_STATE.IDLE) {
    game_timer_ticks += 1;
    
    var _total_seconds = game_timer_ticks / game_get_speed(gamespeed_fps);
    
    // Check if player has exceeded the death threshold (09:59)
    if (_total_seconds > max_time_seconds && !time_exceeded) {
        time_exceeded = true;
        player_lives = 0;
        
        // Execute player elimination / life penalty logic safely
        if (instance_exists(obj_player)) {
            with (obj_player) {
                // If the player object has a custom death method or event trigger
                if (variable_instance_exists(id, "hp")) hp = 0;
                instance_destroy();
            }
        }
    }
}

// -----------------------------------------------------------------------------
// 3. ROOM TRANSITION & FADE STATE MACHINE
// -----------------------------------------------------------------------------
switch (state) {
    case TRANSITION_STATE.IDLE:
        fade_alpha = 0.0;
        break;
        
    case TRANSITION_STATE.FADE_OUT:
        fade_alpha += fade_speed;
        
        // Mute/lower audio on fade out
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
        
        // Restore music volume on fade in
        if (bgm_handle != -1 && audio_is_playing(bgm_handle)) {
            audio_sound_gain(bgm_handle, (1 - fade_alpha) * bgm_target_volume, 0);
        }
        
        if (fade_alpha <= 0.0) {
            fade_alpha = 0.0;
            state = TRANSITION_STATE.IDLE;
        }
        break;
}

// -----------------------------------------------------------------------------
// 4. BACKGROUND MUSIC MONITORING
// -----------------------------------------------------------------------------
// Control subway audio playback specifically during active gameplay rooms
if (!_is_non_gameplay_room && asset_get_index("mus_subway") != -1) {
    if (!audio_is_playing(mus_subway) && state == TRANSITION_STATE.IDLE) {
        bgm_handle = audio_play_sound(mus_subway, 10, true);
        audio_sound_gain(bgm_handle, bgm_target_volume, 0);
    }
} else if (_is_non_gameplay_room && bgm_handle != -1 && audio_is_playing(bgm_handle)) {
    // Stop subway track if returning to menu/splash screen
    audio_stop_sound(bgm_handle);
    bgm_handle = -1;
}