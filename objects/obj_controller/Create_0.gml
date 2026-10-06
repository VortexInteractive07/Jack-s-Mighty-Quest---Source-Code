/// @description Level Controller Initialization - Non-Persistent (GM LTS 2026)

// --- 0. CORE STATE & GLOBAL INITIALIZATION ---
scr_load_settings();
window_set_fullscreen(global.fullscreen);

persistent = false;

if (!variable_global_exists("game_session_active") || !global.game_session_active) {
    global.game_session_active = true;
    global.game_lives = 3;
    global.game_score = 0;
}

exit_room = rm_main_menu;

// Game Over & Life State Initialization (Declared FIRST to avoid scope errors in functions)
is_game_over              = false;
game_paused               = false;
pause_option              = 0; // 0: CONTINUE, 1: RESTART, 2: MAIN MENU
show_debug_overlay_custom = false;
game_score                = global.game_score;
player_lives              = global.game_lives;
collectibles_collected    = 0;
total_collectibles        = 0;
level_state               = "ACTIVE";

// Dynamic HUD Interpolation Variables
hp_visual_current         = 0;

// Timer & Time Limit System
game_timer_ticks          = 0;
max_time_seconds          = 599; // 9 mins 59 secs
time_exceeded             = false;

// Audio & Death State Trackers
life_lost_audio_id        = -1;
life_lost_pending_restart = false;
game_over_pending         = false;
death_resolution_active   = false;
game_over_music_id        = -1;
death_notice_timer        = 0;
death_notice_duration     = round(game_get_speed(gamespeed_fps) * 1.25);

// --- 1. AUDIO INTEGRATION & EXTERNAL MUSIC SYSTEM ---
bgm_handle = -1;
bgm_target_volume = global.vol_bgm / 100;
bgm_enabled = true;

// Delegate music stream initialization to external OST script handler
bgm_handle = scr_play_level_music(room, bgm_target_volume);

stop_level_audio = function() {
    bgm_enabled = false;
    if (bgm_handle != -1 && audio_is_playing(bgm_handle)) {
        audio_stop_sound(bgm_handle);
    }
    bgm_handle = -1;
};

// --- 2. GUI & DISPLAY CONFIGURATION ---
display_set_gui_size(432, 240); // Standard retro widescreen scale
gui_width  = display_get_gui_width();
gui_height = display_get_gui_height();

// --- 3. LOCAL FADE CONTROLLER ---
enum TRANSITION_STATE {
    IDLE,
    FADE_OUT,
    FADE_IN
}

state       = TRANSITION_STATE.FADE_IN;
fade_alpha  = 1.0;
fade_speed  = 0.04;
fade_color  = c_black;
next_room   = -1;

// --- 4. GAMEPLAY METHODS & CONTROLLER FUNCTIONS ---
add_score = function(_amount) {
    game_score = max(0, game_score + max(0, _amount));
    global.game_score = game_score;
};

register_collectible = function(_value) {
    collectibles_collected++;
    add_score(_value);
};

damage_player = function(_amount) {
    if (!instance_exists(obj_jack) || is_game_over || global.cheat_godmode) return;

    var _player = instance_find(obj_jack, 0);
    if (_player.is_dead) return;

    _player.hp = max(0, _player.hp - max(0, _amount));
    if (_player.hp <= 0) {
        scr_trigger_player_death();
    }
};

restart_level = function() {
    game_paused = false;
    is_game_over = false;
    level_state = "ACTIVE";
    instance_activate_all();
    room_restart();
};

trigger_game_over = function() {
    if (is_game_over) return;

    is_game_over = true;
    game_over_pending = false;
    level_state = "GAME_OVER";
    global.game_lives = 0;
    global.game_score = game_score;

    stop_level_audio();

        instance_deactivate_all(true); // Freeze all gameplay objects during game over

    game_over_music_id = audio_play_sound(mus_gameover, 10, false);
    audio_sound_gain(game_over_music_id, global.vol_bgm / 100, 0);
};

continue_after_game_over = function() {
    if (!is_game_over) return;

    if (global.arcade_mode) {
        if (global.arcade_credits <= 0) {
            global.game_session_active = false;
            if (room_exists(rm_title_screen)) room_goto(rm_title_screen);
            return;
        }
        global.arcade_credits--;
    }

    if (game_over_music_id != -1 && audio_is_playing(game_over_music_id)) {
        audio_stop_sound(game_over_music_id);
    }

    global.game_session_active = true;
    global.game_lives = 3;
    global.game_score = 0;
    player_lives = 3;
    game_score = 0;
    game_timer_ticks = 0;
    is_game_over = false;
    level_state = "ACTIVE";
    room_restart();
};

// --- 6. PAUSE ANIMATION SYSTEM ---
pause_slide          = 0.0; // 0.0 (Unpaused) to 1.0 (Fully Visible)
pause_options_count  = 3;
pause_labels         = [get_localized_text("continue"), get_localized_text("restart"), get_localized_text("main_menu")];

// --- 7. PARTICLE SYSTEM INITIALIZATION ---
sys_particles = part_system_create();
part_system_depth(sys_particles, -100);

show_debug_message("obj_controller initialized for current level instance.");