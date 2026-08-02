/// @description Initialize Controller, System Parameters & Dynamic Music Engine

// Widescreen Engine Setup (426x240 - True 16:9)
var _widescreen_w = 426;
var _widescreen_h = 240;

// Surface & Rendering Configuration
application_surface_draw_enable(false);
gpu_set_texfilter(false);

surface_resize(application_surface, _widescreen_w, _widescreen_h);
display_set_gui_size(_widescreen_w, _widescreen_h);

if (view_enabled) {
    view_visible[0] = true;
    camera_set_view_size(view_camera[0], _widescreen_w, _widescreen_h);
}

// Gameplay Mechanics States
stage_cleared      = false;
player_dead        = false;
death_reason       = "";
is_transitioning   = false;
transition_timer   = 0;
stage_time         = 12000; 
low_hp_beep_timer  = 0;
show_debug         = false;

// Boss Encounters State Flag
global.boss_active = false;

// Title Card State Variables - Duration 150 frames (2.5s at 60 FPS)
show_title_card     = true; 
title_card_timer    = 0;    
title_card_duration = 150;  

// UI Interpolation & Animations
hp_display_smooth  = 100;
pulse_timer        = 0;

// Music Toast Notification System Variables (Minecraft Java Style - Top Left)
if (!variable_global_exists("show_music_toast")) {
    global.show_music_toast = false; // Toggleable via 'M' key
}

toast_state       = 0;   // 0: Hidden, 1: Sliding In, 2: Displaying, 3: Sliding Out
toast_anim_timer  = 0;   // Progress frame ticker
toast_slide_x     = -200; // Off-screen left position
toast_max_x       = 10;   // Resting position on top-left
toast_hold_timer  = 0;   // Hold duration counter
toast_title       = "";

// Safe Asset Indexing helper array for splash screen
splash_sprites = [];
var _vortex_logo = asset_get_index("spr_vortex_logo");
var _vortex_presents = asset_get_index("spr_vortex_presents");
var _title = asset_get_index("spr_title");
var _main_menu = asset_get_index("spr_main_menu");

if (_vortex_logo != -1) array_push(splash_sprites, _vortex_logo);
if (_vortex_presents != -1) array_push(splash_sprites, _vortex_presents);
if (_title != -1) array_push(splash_sprites, _title);
if (_main_menu != -1) array_push(splash_sprites, _main_menu);

splash_index       = 0;
splash_timer       = 0;
splash_active      = false;

// Pause Menu State Engine
is_paused          = false;
global.game_paused = false;
pause_selection    = 0;
pause_options      = ["RESUME", "RESTART LEVEL", "JUKEBOX", "RETURN TO MENU", "EXIT GAME"]; 
pause_total        = array_length(pause_options);
pause_surface      = -1; 

// Global Variable Safety Initializations
if (!variable_global_exists("player_lives"))       global.player_lives = 3;
if (!variable_global_exists("player_score"))       global.player_score = 0;
if (!variable_global_exists("gems_collected"))     global.gems_collected = 0;
if (!variable_global_exists("current_song_index")) global.current_song_index = 0;

// Force audio engine out of any leftover pause state
audio_resume_all();

// Set music mode default if not defined (Mode 1 = Playlist, Mode 2 = Stage Music)
if (!variable_global_exists("music_mode") || global.music_mode == 0) {
    global.music_mode = 1;
}

// Ensure audio is stopped only right before playing room BGM
audio_stop_all();

switch (global.music_mode) {
    case 1: // RANDOM PLAYLIST ENGINE
        randomize();
        if (script_exists(asset_get_index("scr_levelmusic_arrangement"))) {
            scr_levelmusic_arrangement();
        }

        if (variable_global_exists("title_playlist") && is_array(global.title_playlist) && array_length(global.title_playlist) > 0) {
            global.title_playlist = array_shuffle(global.title_playlist);
            global.current_song_index = 0;
            global.title_music_started = false;

            var _first_song = global.title_playlist[global.current_song_index];
            if (audio_exists(_first_song) && !audio_is_playing(_first_song)) {
                audio_play_sound(_first_song, 100, false);
                global.title_music_started = true;
                
                // Trigger Minecraft-style Toast Notification
                if (global.show_music_toast) {
                    toast_title      = audio_get_name(_first_song);
                    toast_state      = 1; // Start Slide In
                    toast_anim_timer = 0;
                    toast_slide_x    = -200;
                }
            }
        }
        break;

    case 2: // DESIGNATED STAGE MUSIC
        if (script_exists(asset_get_index("scr_level_arrangement"))) {
            var _designated_track = scr_level_arrangement(2);
            if (_designated_track != -1 && audio_exists(_designated_track)) {
                audio_play_sound(_designated_track, 100, true);
                
                // Trigger Minecraft-style Toast Notification
                if (global.show_music_toast) {
                    toast_title      = audio_get_name(_designated_track);
                    toast_state      = 1; // Start Slide In
                    toast_anim_timer = 0;
                    toast_slide_x    = -200;
                }
            }
        }
        break;
}