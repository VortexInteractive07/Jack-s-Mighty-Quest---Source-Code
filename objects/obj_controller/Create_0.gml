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
bgm_asset = -1;
bgm_target_volume = global.vol_bgm / 100;
bgm_enabled = true;

var _stage_bgm = mus_subway;
if (room == rm_city) _stage_bgm = mus_city;
if (room == rm_dungeons) _stage_bgm = mus_dungeons;

stop_level_audio = function() {
    bgm_enabled = false;
    if (bgm_handle != -1 && audio_is_playing(bgm_handle)) {
        audio_stop_sound(bgm_handle);
    }
    if (boss_clear_audio_id != -1 && audio_is_playing(boss_clear_audio_id)) {
        audio_stop_sound(boss_clear_audio_id);
    }
    bgm_handle = -1;
    bgm_asset = -1;
    boss_clear_audio_id = -1;
};

set_level_music = function(_asset) {
    if (bgm_handle != -1 && audio_is_playing(bgm_handle)) {
        audio_stop_sound(bgm_handle);
    }
    bgm_asset = _asset;
    bgm_handle = -1;
    bgm_enabled = true;
    if (audio_exists(bgm_asset)) {
        bgm_handle = audio_play_sound(bgm_asset, 10, true);
        if (bgm_handle != -1) {
            audio_sound_gain(bgm_handle, bgm_target_volume, 0);
        } else {
            show_debug_message("Could not start level music.");
        }
    } else {
        show_debug_message("Level music asset is unavailable.");
    }
};
set_level_music(_stage_bgm);

// --- 2. GUI & DISPLAY CONFIGURATION ---
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
boss_clear_audio_id        = -1;

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

stage_theme_effect = 0;
if (room == rm_city) stage_theme_effect = 1;
if (room == rm_dungeons) stage_theme_effect = 2;
stage_effect_particles = [];
if (stage_theme_effect != 0) {
    var _effect_width = camera_get_view_width(view_camera[0]);
    var _effect_height = camera_get_view_height(view_camera[0]);
    for (var _fx_i = 0; _fx_i < 48; _fx_i++) {
        array_push(stage_effect_particles, {
            x: random(_effect_width),
            y: random(_effect_height),
            speed: random_range(1, stage_theme_effect == 1 ? 4 : 1.5),
            size: random_range(1, 2),
            phase: random(360)
        });
    }
}

if (room == rm_city || room == rm_dungeons) {
    var _instance_layer = "Instances";
    var _wall = noone;
    instance_create_layer(16, 0, _instance_layer, obj_camera);
    instance_create_layer(48, 224, _instance_layer, obj_jack);
    instance_create_layer(16, 208, _instance_layer, obj_mark);

    _wall = instance_create_layer(-16, 0, _instance_layer, obj_wall);
    _wall.image_yscale = 15;
    _wall = instance_create_layer(0, 224, _instance_layer, obj_wall);
    _wall.image_xscale = 263;
    _wall = instance_create_layer(4208, 0, _instance_layer, obj_wall);
    _wall.image_yscale = 15;

    if (room == rm_city) {
        // --- SECTION 1: DOWNTOWN ROOFTOPS (x: 200 - 1100) ---
        // Building 1: Low rooftop
        _wall = instance_create_layer(256, 176, _instance_layer, obj_wall); _wall.image_xscale = 6;
        instance_create_layer(304, 150, _instance_layer, obj_gem);

        // Building 2: Mid-tier rooftop
        _wall = instance_create_layer(416, 140, _instance_layer, obj_wall); _wall.image_xscale = 5;
        instance_create_layer(456, 114, _instance_layer, obj_gem);

        // Fire escape wall-jump tower
        _wall = instance_create_layer(560, 60, _instance_layer, obj_wall); _wall.image_xscale = 1; _wall.image_yscale = 10;
        _wall = instance_create_layer(576, 88, _instance_layer, obj_wall); _wall.image_xscale = 8;
        instance_create_layer(640, 62, _instance_layer, obj_gem);

        // Ground laser security barrier (encourages taking the high route)
        instance_create_layer(780, 210, _instance_layer, obj_laser);

        // Landing fire-escape
        _wall = instance_create_layer(880, 160, _instance_layer, obj_wall); _wall.image_xscale = 6;
        instance_create_layer(928, 134, _instance_layer, obj_gem);

        _wall = instance_create_layer(1056, 136, _instance_layer, obj_wall); _wall.image_xscale = 5;

        // --- SECTION 2: THE NEON SKYBRIDGE (x: 1200 - 2300) ---
        instance_create_layer(1220, 210, _instance_layer, obj_laser);

        // Stepped skybridge platforms
        _wall = instance_create_layer(1280, 168, _instance_layer, obj_wall); _wall.image_xscale = 5;
        _wall = instance_create_layer(1424, 132, _instance_layer, obj_wall); _wall.image_xscale = 6;
        instance_create_layer(1472, 106, _instance_layer, obj_gem);

        // High suspended crane beam
        _wall = instance_create_layer(1600, 96, _instance_layer, obj_wall); _wall.image_xscale = 7;
        instance_create_layer(1656, 70, _instance_layer, obj_gem);

        // Lower hazard zone with stepping stone
        instance_create_layer(1840, 210, _instance_layer, obj_laser);
        _wall = instance_create_layer(1808, 156, _instance_layer, obj_wall); _wall.image_xscale = 5;
        instance_create_layer(1848, 130, _instance_layer, obj_gem);

        // Double wall-jump shaft
        _wall = instance_create_layer(1984, 52, _instance_layer, obj_wall); _wall.image_xscale = 1; _wall.image_yscale = 11;
        _wall = instance_create_layer(2064, 52, _instance_layer, obj_wall); _wall.image_xscale = 1; _wall.image_yscale = 11;
        _wall = instance_create_layer(2000, 76, _instance_layer, obj_wall); _wall.image_xscale = 4;
        instance_create_layer(2032, 50, _instance_layer, obj_gem);

        _wall = instance_create_layer(2160, 160, _instance_layer, obj_wall); _wall.image_xscale = 5;

        // --- SECTION 3: METRO PLAZA (x: 2350 - 3300) ---
        instance_create_layer(2400, 210, _instance_layer, obj_laser);
        _wall = instance_create_layer(2448, 164, _instance_layer, obj_wall); _wall.image_xscale = 5;

        _wall = instance_create_layer(2608, 128, _instance_layer, obj_wall); _wall.image_xscale = 6;
        instance_create_layer(2656, 102, _instance_layer, obj_gem);

        _wall = instance_create_layer(2784, 156, _instance_layer, obj_wall); _wall.image_xscale = 5;
        instance_create_layer(2824, 130, _instance_layer, obj_gem);

        instance_create_layer(2940, 210, _instance_layer, obj_laser);

        // High plaza clock tower
        _wall = instance_create_layer(3040, 80, _instance_layer, obj_wall); _wall.image_xscale = 1; _wall.image_yscale = 9;
        _wall = instance_create_layer(3056, 112, _instance_layer, obj_wall); _wall.image_xscale = 6;
        instance_create_layer(3104, 86, _instance_layer, obj_gem);

        _wall = instance_create_layer(3200, 164, _instance_layer, obj_wall); _wall.image_xscale = 6;
        instance_create_layer(3248, 138, _instance_layer, obj_gem);

        // --- SECTION 4: THE BOSS ARENA (x: 3380 - 4000) ---
        // Arena exit gate (closed until boss is defeated)
        var _boss_gate = instance_create_layer(4000, 0, _instance_layer, obj_wall);
        _boss_gate.image_yscale = 15;

        // Elevated combat vantage platforms inside the arena for aerial stomps and dodging
        _wall = instance_create_layer(3472, 156, _instance_layer, obj_wall); _wall.image_xscale = 4;
        _wall = instance_create_layer(3808, 156, _instance_layer, obj_wall); _wall.image_xscale = 4;

        // Spawn the Boss
        var _boss = instance_create_layer(3760, 174, _instance_layer, obj_melonhead_proto);
        _boss.gate = _boss_gate;
    } else {
        for (var _dungeon_platform_x = 448; _dungeon_platform_x <= 3552; _dungeon_platform_x += 512) {
            _wall = instance_create_layer(_dungeon_platform_x, (_dungeon_platform_x mod 3 == 0) ? 144 : 176, _instance_layer, obj_wall);
            _wall.image_xscale = 4;
        }

        instance_create_layer(768, 188, _instance_layer, obj_gem);
        instance_create_layer(1536, 116, _instance_layer, obj_gem);
        instance_create_layer(2304, 188, _instance_layer, obj_gem);
        instance_create_layer(3072, 116, _instance_layer, obj_gem);
        instance_create_layer(1900, 210, _instance_layer, obj_laser);
        instance_create_layer(3300, 210, _instance_layer, obj_laser);
    }

    instance_create_layer(4176, 192, _instance_layer, obj_levelcomplete);
}

show_debug_message("obj_controller initialized for current level instance.");