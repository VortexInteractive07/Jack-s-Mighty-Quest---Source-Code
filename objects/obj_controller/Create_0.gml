/// @description Level Controller Initialization - Non-Persistent (GM LTS 2026)
scr_load_settings();
window_set_fullscreen(global.fullscreen);

persistent = false;

if (!variable_global_exists("game_session_active") || !global.game_session_active) {
    global.game_session_active = true;
    global.game_lives = 3;
    global.game_score = 0;
}

exit_room = rm_main_menu;

// --- 1. AUDIO INTEGRATION & MUSIC MANAGEMENT ---
bgm_handle = -1;
bgm_target_volume = global.vol_bgm / 100;
bgm_enabled = true;

if (audio_exists(mus_subway)) {
    if (!audio_is_playing(mus_subway)) {
        bgm_handle = audio_play_sound(mus_subway, 10, true);
        audio_sound_gain(mus_subway, bgm_target_volume, 0);
    } else {
        bgm_handle = mus_subway;
    }
}

stop_level_audio = function() {
    bgm_enabled = false;
    if (bgm_handle != -1 && audio_is_playing(bgm_handle)) {
        audio_stop_sound(bgm_handle);
    }
    if (audio_is_playing(mus_subway)) {
        audio_stop_sound(mus_subway);
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

// --- 4. GAMEPLAY, HUD & LIFE SYSTEM ---
game_paused               = false;
pause_option              = 0; // 0: CONTINUE, 1: RESTART, 2: MAIN MENU
show_debug_overlay_custom = false;
game_score                = global.game_score;
player_lives              = global.game_lives;
max_lives                 = 5;
collectibles_collected    = 0;
total_collectibles        = 0;
level_state               = "ACTIVE";
weather_enabled           = global.experimental_weather;
weather_type              = global.weather_type;
weather_intensity         = global.weather_intensity;
weather_wind              = global.weather_wind;
weather_drops             = [];
weather_flash_alpha       = 0;
weather_timer             = 0;

var _weather_view_w = camera_get_view_width(view_camera[0]);
var _weather_view_h = camera_get_view_height(view_camera[0]);
var _weather_drop_count = 120;
if (weather_intensity == "LOW") _weather_drop_count = 48;
if (weather_intensity == "HIGH") _weather_drop_count = 240;
if (weather_intensity == "EXTREME") _weather_drop_count = 420;
for (var _weather_i = 0; _weather_i < _weather_drop_count; _weather_i++) {
    var _weather_speed = random_range(4, 8);
    if (weather_intensity == "LOW") _weather_speed = random_range(2, 4);
    if (weather_intensity == "HIGH") _weather_speed = random_range(5, 9);
    if (weather_intensity == "EXTREME") _weather_speed = random_range(7, 12);
    array_push(weather_drops, {
        x: random(_weather_view_w),
        y: random(_weather_view_h),
        speed: _weather_speed,
        length: random_range(8, 18),
        size: random_range(1, 2)
    });
}
life_lost_audio_id         = -1;
life_lost_pending_restart  = false;
game_over_pending          = false;
death_resolution_active    = false;
game_over_music_id         = -1;

add_score = function(_amount) {
    game_score = max(0, game_score + max(0, _amount));
    global.game_score = game_score;
};

register_collectible = function(_value) {
    collectibles_collected++;
    add_score(_value);
};

damage_player = function(_amount) {
    if (!instance_exists(obj_jack) || is_game_over) return;

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

    instance_deactivate_object(obj_jack);
    instance_deactivate_object(obj_mark);
    instance_deactivate_object(obj_camera);
    instance_deactivate_object(obj_laser);
    instance_deactivate_object(obj_gem);
    instance_deactivate_object(obj_plasma_wave);

    if (audio_exists(mus_gameover)) {
        game_over_music_id = audio_play_sound(mus_gameover, 10, false);
        audio_sound_gain(game_over_music_id, global.vol_bgm / 100, 0);
    }
};

resolve_player_death = function() {
    if (death_resolution_active || is_game_over) return;

    death_resolution_active = true;
    player_lives = max(0, player_lives - 1);
    global.game_lives = player_lives;
    global.game_score = game_score;

    if (audio_exists(mus_life_lost)) {
        life_lost_audio_id = audio_play_sound(mus_life_lost, 10, false);
        audio_sound_gain(life_lost_audio_id, global.vol_bgm / 100, 0);
    }

    if (player_lives <= 0) {
        game_over_pending = true;
    } else {
        life_lost_pending_restart = true;
    }
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

// Game Over Control
is_game_over              = false;
game_over_timer           = 0;
game_over_delay           = game_get_speed(gamespeed_fps) * 3.0;

// Dynamic HUD Interpolation Variables
hp_visual_current         = 0;
hp_visual_catchup         = 0;

// --- 5. SONIC MANIA PLUS PAUSE ANIMATION SYSTEM ---
pause_slide               = 0.0; // 0.0 (Unpaused) to 1.0 (Fully Visible)
pause_wave_timer          = 0;   // Dynamic wave shine for selected items
pause_options_count       = 3;
pause_labels              = ["CONTINUE", "RESTART", "MAIN MENU"];

// --- 6. TIMER & TIME LIMIT SYSTEM ---
game_timer_ticks = 0;
max_time_seconds = 599; // 9 mins 59 secs
time_exceeded    = false;

// --- 7. PARTICLE SYSTEM INITIALIZATION ---
sys_particles = part_system_create();
part_system_depth(sys_particles, -100);

show_debug_message("obj_controller initialized for current level instance.");