/// @description Process Gameplay Loop, Toast Animation & Pause Engine

// UI Pulse Ticker
pulse_timer += 0.08;

// Toggle Toast Notifications with "M" key
if (keyboard_check_pressed(ord("M"))) {
    global.show_music_toast = !global.show_music_toast;
}

// =================================================================
// MINECRAFT JAVA-STYLE TOAST ANIMATION STATE MACHINE (Top Left)
// =================================================================
if (global.show_music_toast) {
    switch (toast_state) {
        case 1: // Slide Left In
            toast_anim_timer += 0.08;
            var _t = clamp(toast_anim_timer, 0, 1);
            var _ease = 1 - power(1 - _t, 3);
            toast_slide_x = lerp(-200, toast_max_x, _ease);
            
            if (_t >= 1) {
                toast_state      = 2; // Hold
                toast_hold_timer = 150; // 2.5 Seconds
            }
            break;
            
        case 2: // Display / Hold
            toast_hold_timer--;
            toast_slide_x = toast_max_x;
            if (toast_hold_timer <= 0) {
                toast_state      = 3; // Slide Right Out
                toast_anim_timer = 0;
            }
            break;
            
        case 3: // Slide Right Out
            toast_anim_timer += 0.08;
            var _t = clamp(toast_anim_timer, 0, 1);
            var _ease = _t * _t; // Quadratic ease in
            toast_slide_x = lerp(toast_max_x, display_get_gui_width() + 50, _ease);
            
            if (_t >= 1) {
                toast_state = 0; // Hidden
            }
            break;
    }
} else {
    toast_state = 0;
}

// Title Card Timer Ticker & Auto-Disable
if (show_title_card) {
    title_card_timer++;
    if (title_card_timer >= title_card_duration) {
        show_title_card = false;
    }
}

// =================================================================
// DYNAMIC MUSIC PLAYLIST MONITOR
// =================================================================
var _boss_is_active = variable_global_exists("boss_active") && global.boss_active;

if (global.music_mode == 1 && !is_paused && !player_dead && !stage_cleared && !is_transitioning && !_boss_is_active) {
    if (variable_global_exists("title_playlist") && is_array(global.title_playlist) && array_length(global.title_playlist) > 0) {
        
        if (!variable_global_exists("title_music_started")) {
            global.title_music_started = false;
        }

        var _current_song = global.title_playlist[global.current_song_index];

        if (!audio_is_playing(_current_song)) {
            if (global.title_music_started) {
                global.current_song_index = (global.current_song_index + 1) % array_length(global.title_playlist);
                _current_song = global.title_playlist[global.current_song_index];
            }

            if (audio_exists(_current_song)) {
                audio_play_sound(_current_song, 100, false);
                global.title_music_started = true;
                
                // Trigger Toast Notification for the new track
                if (global.show_music_toast) {
                    toast_title      = audio_get_name(_current_song);
                    toast_state      = 1;
                    toast_anim_timer = 0;
                    toast_slide_x    = -200;
                }
            }
        }
    }
}

// Easter Egg Toggle (Shift + S)
if (keyboard_check_pressed(ord("S")) && keyboard_check(vk_shift)) {
    if (array_length(splash_sprites) > 0) {
        splash_active = !splash_active;
        splash_timer = 0;
        splash_index = (splash_index + 1) % array_length(splash_sprites);
        var _sfx_text = asset_get_index("sfx_textbox");
        if (_sfx_text != -1 && audio_exists(_sfx_text)) audio_play_sound(_sfx_text, 1, false);
    }
}

// Pause Menu Toggle (ESC)
if (keyboard_check_pressed(vk_escape) && !player_dead && !stage_cleared && !is_transitioning) {
    is_paused = !is_paused;
    global.game_paused = is_paused;
    
    var _sfx_text = asset_get_index("sfx_textbox");
    var _sfx_cont = asset_get_index("sfx_textbox_continue");
    
    if (is_paused) {
        audio_pause_all();
        
        var _widescreen_w = 426;
        var _widescreen_h = 240;
        
        if (!surface_exists(pause_surface)) {
            pause_surface = surface_create(_widescreen_w, _widescreen_h);
        }
        surface_set_target(pause_surface);
        draw_surface(application_surface, 0, 0);
        surface_reset_target();
        
        instance_deactivate_all(true);
        instance_activate_object(id);
        
        var _cam_obj = asset_get_index("obj_camera");
        if (_cam_obj != -1 && instance_exists(_cam_obj)) instance_activate_object(_cam_obj);
        
        pause_selection = 0;
        if (_sfx_text != -1 && audio_exists(_sfx_text)) audio_play_sound(_sfx_text, 1, false);
    } else {
        instance_activate_all();
        audio_resume_all();
        
        if (surface_exists(pause_surface)) {
            surface_free(pause_surface);
            pause_surface = -1;
        }
        
        if (_sfx_cont != -1 && audio_exists(_sfx_cont)) audio_play_sound(_sfx_cont, 1, false);
    }
}

// Pause Menu Mechanics
if (is_paused) {
    var _key_up      = keyboard_check_pressed(vk_up);
    var _key_down    = keyboard_check_pressed(vk_down);
    var _key_confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("A"));
    var _sfx_text    = asset_get_index("sfx_textbox");
    var _sfx_cont    = asset_get_index("sfx_textbox_continue");
    
    if (_key_up) {
        pause_selection--;
        if (pause_selection < 0) pause_selection = pause_total - 1;
        if (_sfx_text != -1 && audio_exists(_sfx_text)) audio_play_sound(_sfx_text, 1, false);
    }
    
    if (_key_down) {
        pause_selection++;
        if (pause_selection >= pause_total) pause_selection = 0;
        if (_sfx_text != -1 && audio_exists(_sfx_text)) audio_play_sound(_sfx_text, 1, false);
    }
    
    if (_key_confirm) {
        switch (pause_selection) {
            case 0: // RESUME
                is_paused = false;
                global.game_paused = false;
                instance_activate_all();
                audio_resume_all();
                if (surface_exists(pause_surface)) {
                    surface_free(pause_surface);
                    pause_surface = -1;
                }
                if (_sfx_cont != -1 && audio_exists(_sfx_cont)) audio_play_sound(_sfx_cont, 1, false);
                break;
                
            case 1: // RESTART LEVEL
                is_paused = false;
                global.game_paused = false;
                instance_activate_all();
                audio_resume_all();
                if (surface_exists(pause_surface)) surface_free(pause_surface);
                room_restart();
                break;
                
            case 2: // JUKEBOX
                is_paused = false;
                global.game_paused = false;
                instance_activate_all();
                audio_resume_all();
                if (surface_exists(pause_surface)) surface_free(pause_surface);
                var _rm_juke = asset_get_index("rm_jukebox");
                if (_rm_juke != -1 && room_exists(_rm_juke)) room_goto(_rm_juke);
                break;
                
            case 3: // RETURN TO MENU
                is_paused = false;
                global.game_paused = false;
                instance_activate_all();
                audio_resume_all();
                application_surface_draw_enable(true);
                
                if (surface_exists(pause_surface)) {
                    surface_free(pause_surface);
                    pause_surface = -1;
                }
                
                var _rm_menu = asset_get_index("rm_main_menu");
                if (_rm_menu != -1 && room_exists(_rm_menu)) {
                    room_goto(_rm_menu);
                } else {
                    game_restart();
                }
                break;
                
            case 4: // QUIT GAME
                game_end();
                break;  
        }
    }
    exit;
}

// Stage Timer Countdown
if (!stage_cleared && !player_dead) {
    if (stage_time > 0) {
        stage_time -= 1;
    } else {
        player_dead = true;
        death_reason = "time";
        
        var _p_obj = asset_get_index("obj_player");
        if (_p_obj != -1 && instance_exists(_p_obj)) {
            _p_obj.hp = 0;
            _p_obj.state = 3; 
        }
        
        global.player_lives -= 1; 
        audio_stop_all();
        var _mus_lost = asset_get_index("mus_life_lost");
        if (_mus_lost != -1 && audio_exists(_mus_lost)) audio_play_sound(_mus_lost, 10, false);
        is_transitioning = true;
        transition_timer = 0;
    }
}

// Player Context Reference
var _p_obj = asset_get_index("obj_player");
var _player_valid = (_p_obj != -1 && instance_exists(_p_obj));

// Low HP Warning Alarm
if (_player_valid && !player_dead && !stage_cleared) {
    if (_p_obj.hp <= 15 && _p_obj.hp > 0) {
        low_hp_beep_timer += 1;
        if (low_hp_beep_timer >= 40) {
            low_hp_beep_timer = 0;
            var _sfx_alarm = asset_get_index("sfx_low_hp_alarm");
            if (_sfx_alarm != -1 && audio_exists(_sfx_alarm)) audio_play_sound(_sfx_alarm, 5, false);
        }
    } else {
        low_hp_beep_timer = 0;
    }
}

// Void Detection
if (_player_valid && !player_dead && !stage_cleared) {
    if (_p_obj.y > room_height + 64) { 
        player_dead = true;
        death_reason = "void";
        _p_obj.hp = 0;
        _p_obj.state = 3; 
        global.player_lives -= 1; 
        
        audio_stop_all();
        var _mus_lost = asset_get_index("mus_life_lost");
        if (_mus_lost != -1 && audio_exists(_mus_lost)) audio_play_sound(_mus_lost, 10, false);
        is_transitioning = true;
        transition_timer = 0;
    }
}

// Room Transition Processing
if (is_transitioning) {
    transition_timer += 1;
    if (transition_timer >= 120) { 
        is_transitioning = false;
        
        if (global.player_lives <= 0) {
            global.player_lives = 3;
            global.player_score = 0;
            global.gems_collected = 0;
            
            application_surface_draw_enable(true);
            
            var _rm_go = asset_get_index("rm_gameover");
            if (_rm_go != -1 && room_exists(_rm_go)) {
                room_goto(_rm_go);
            } else {
                room_restart();
            }
        } else {
            room_restart();
        }
    }
}

// Debug Toggle
if (keyboard_check_pressed(vk_f1)) {
    show_debug = !show_debug;
}