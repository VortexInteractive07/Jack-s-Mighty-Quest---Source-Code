/// @description Process Gameplay Loop, Speedometer, Toast Engine & Pause Systems

// UI Pulse Ticker
pulse_timer += 0.08;

// Toggle Speedometer Unit (KM/H <-> MPH) via 'U' Key
if (keyboard_check_pressed(ord("U"))) {
    use_kmh = !use_kmh;
}

// Toggle Toast Notifications via 'M' Key
if (keyboard_check_pressed(ord("M"))) {
    global.show_music_toast = !global.show_music_toast;
}

// =================================================================
// SPEEDOMETER CALCULATION ENGINE
// =================================================================
var _p_obj = asset_get_index("obj_player");
if (_p_obj != -1 && instance_exists(_p_obj)) {
    var _vx = 0;
    var _vy = 0;
    
    if (variable_instance_exists(_p_obj, "hsp")) _vx = _p_obj.hsp;
    else if (variable_instance_exists(_p_obj, "phy_speed_x")) _vx = _p_obj.phy_speed_x;
    
    if (variable_instance_exists(_p_obj, "vsp")) _vy = _p_obj.vsp;
    else if (variable_instance_exists(_p_obj, "phy_speed_y")) _vy = _p_obj.phy_speed_y;

    var _pix_per_frame = point_distance(0, 0, _vx, _vy);
    speed_px_sec = _pix_per_frame * 60;
    
    speed_mph = speed_px_sec * 0.045;
    speed_kmh = speed_mph * 1.60934;
    
    var _target_speed = use_kmh ? speed_kmh : speed_mph;
    display_speed = lerp(display_speed, _target_speed, 0.25);
} else {
    display_speed = lerp(display_speed, 0, 0.2);
}

// =================================================================
// TOAST ANIMATION STATE MACHINE (Top Left)
// =================================================================
if (global.show_music_toast) {
    switch (toast_state) {
        case 1: // Slide In
            toast_anim_timer += 0.06;
            var _t = clamp(toast_anim_timer, 0, 1);
            var _ease = 1 - power(1 - _t, 3);
            toast_slide_x = lerp(-220, toast_max_x, _ease);
            
            if (_t >= 1) {
                toast_state      = 2;
                toast_hold_timer = 180;
            }
            break;
            
        case 2: // Display / Hold
            toast_hold_timer--;
            toast_slide_x = toast_max_x;
            if (toast_hold_timer <= 0) {
                toast_state      = 3;
                toast_anim_timer = 0;
            }
            break;
            
        case 3: // Slide Out
            toast_anim_timer += 0.08;
            _t = clamp(toast_anim_timer, 0, 1);
            _ease = _t * _t;
            toast_slide_x = lerp(toast_max_x, -220, _ease);
            
            if (_t >= 1) toast_state = 0;
            break;
    }
} else {
    toast_state = 0;
}

// Title Card Timer Ticker & Auto-Disable
if (show_title_card) {
    title_card_timer++;
    if (title_card_timer >= title_card_duration) show_title_card = false;
}

// =================================================================
// DYNAMIC MUSIC PLAYLIST MONITOR
// =================================================================
var _boss_is_active = variable_global_exists("boss_active") && global.boss_active;

if (global.music_mode == 1 && !is_paused && !player_dead && !stage_cleared && !is_transitioning && !_boss_is_active) {
    if (variable_global_exists("title_playlist") && is_array(global.title_playlist) && array_length(global.title_playlist) > 0) {
        
        if (!variable_global_exists("title_music_started")) global.title_music_started = false;

        var _current_song = global.title_playlist[global.current_song_index];

        if (!audio_is_playing(_current_song)) {
            if (global.title_music_started) {
                global.current_song_index = (global.current_song_index + 1) % array_length(global.title_playlist);
                _current_song = global.title_playlist[global.current_song_index];
            }

            if (audio_exists(_current_song)) {
                audio_play_sound(_current_song, 100, false);
                global.title_music_started = true;
                
                if (global.show_music_toast) {
                    if (script_exists(asset_get_index("scr_get_song_info"))) {
                        var _info = scr_get_song_info(_current_song);
                        toast_title        = _info.title;
                        global.artist_name = _info.artist_name;
                        global.artist_type = _info.artist_type;
                    } else {
                        toast_title        = audio_get_name(_current_song);
                        global.artist_name = "Unknown Artist";
                        global.artist_type = "composer";
                    }
                    toast_state      = 1;
                    toast_anim_timer = 0;
                    toast_slide_x    = -220;
                }
            }
        }
    }
}

// =================================================================
// EASTER EGG TOGGLE & RANDOM GLITCH ENGINE (Shift + S)
// =================================================================
if (keyboard_check_pressed(ord("S")) && keyboard_check(vk_shift)) {
    if (array_length(splash_sprites) > 0) {
        splash_active = !splash_active;
        splash_timer = 0;
        
        splash_index = irandom(array_length(splash_sprites) - 1);
        
        glitch_color    = make_color_rgb(irandom(255), irandom(255), irandom(255));
        glitch_offset_x = irandom_range(-12, 12);
        glitch_offset_y = irandom_range(-12, 12);
        glitch_scale_x  = choose(-1, 1);
        glitch_scale_y  = choose(-1, 1);
        
        var _sfx_text = asset_get_index("sfx_textbox");
        if (_sfx_text != -1 && audio_exists(_sfx_text)) audio_play_sound(_sfx_text, 1, false);
    }
}

// Process Real-time Glitch Effect jitter while active
if (splash_active) {
    splash_timer++;
    
    if (splash_timer % 4 == 0) {
        glitch_offset_x = irandom_range(-8, 8);
        glitch_offset_y = irandom_range(-8, 8);
        glitch_color    = make_color_rgb(irandom(255), irandom(255), irandom(255));
    }
    
    if (splash_timer % 15 == 0) {
        glitch_scale_x = choose(-1, 1);
        glitch_scale_y = choose(-1, 1);
    }
    
    var _spr = splash_sprites[splash_index];
    if (sprite_exists(_spr)) {
        glitch_subimage = (glitch_subimage + 0.2) % sprite_get_number(_spr);
    }
}

// Pause Menu Toggle (ESC)
if (keyboard_check_pressed(vk_escape) && !player_dead && !stage_cleared && !is_transitioning) {
    is_paused = !is_paused;
    global.game_paused = is_paused;
    
    var _sfx_text = asset_get_index("sfx_textbox");
    var _sfx_cont = asset_get_index("sfx_textbox_continue");
    
    if (is_paused) {
        if (!pause_music_enabled) audio_pause_all();
        
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
        pause_select_smooth = 0;
        if (_sfx_text != -1 && audio_exists(_sfx_text)) audio_play_sound(_sfx_text, 1, false);
    } else {
        instance_activate_all();
        if (!pause_music_enabled) audio_resume_all();
        
        if (surface_exists(pause_surface)) {
            surface_free(pause_surface);
            pause_surface = -1;
        }
        
        if (_sfx_cont != -1 && audio_exists(_sfx_cont)) audio_play_sound(_sfx_cont, 1, false);
    }
}

// Redesigned Pause Menu Mechanics
if (is_paused) {
    var _key_up      = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
    var _key_down    = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
    var _key_confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_space);
    var _sfx_text    = asset_get_index("sfx_textbox");
    var _sfx_cont    = asset_get_index("sfx_textbox_continue");
    
    pause_select_smooth = lerp(pause_select_smooth, pause_selection, 0.35);
    
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
                if (!pause_music_enabled) audio_resume_all();
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
                if (!pause_music_enabled) audio_resume_all();
                if (surface_exists(pause_surface)) surface_free(pause_surface);
                room_restart();
                break;
                
            case 2: // JUKEBOX
                is_paused = false;
                global.game_paused = false;
                instance_activate_all();
                if (!pause_music_enabled) audio_resume_all();
                if (surface_exists(pause_surface)) surface_free(pause_surface);
                var _rm_juke = asset_get_index("rm_jukebox");
                if (_rm_juke != -1 && room_exists(_rm_juke)) room_goto(_rm_juke);
                break;
                
            case 3: // RETURN TO MENU
                is_paused = false;
                global.game_paused = false;
                instance_activate_all();
                if (!pause_music_enabled) audio_resume_all();
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
                
            case 4: // EXIT GAME
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