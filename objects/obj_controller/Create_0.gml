/// @description Main Gameplay Controller - Station Track, Engine & Timer Manager

// -----------------------------------------------------------------------------
// 1. PERSISTENCE & SINGLETON MANAGEMENT
// -----------------------------------------------------------------------------
// Prevent duplicate controller instances across room transitions
if (instance_number(object_index) > 1) {
    instance_destroy();
    exit;
}

// Ensure the controller persists across room transitions
persistent = false;

// -----------------------------------------------------------------------------
// 2. AUDIO INTEGRATION & MUSIC MANAGEMENT
// -----------------------------------------------------------------------------
bgm_handle = -1;
bgm_target_volume = 1.0;
bgm_fade_speed = 0.05;

// Safely play and loop subway station theme
if (asset_get_index("mus_subway") != -1) {
    if (!audio_is_playing(mus_subway)) {
        bgm_handle = audio_play_sound(mus_subway, 10, true);
        audio_sound_gain(mus_subway, bgm_target_volume, 0);
    } else {
        bgm_handle = mus_subway;
    }
}

// -----------------------------------------------------------------------------
// 3. FONT & GUI SYSTEM CONFIGURATION
// -----------------------------------------------------------------------------
// Apply default custom bitmap font across the controller setup
if (asset_get_index("fnt_bitmap") != -1) {
    draw_set_font(fnt_bitmap);
} else {
    show_debug_message("WARNING: fnt_bitmap missing from project assets!");
}

// GUI Dimensions & Scale Parameters
gui_width  = display_get_gui_width();
gui_height = display_get_gui_height();

// -----------------------------------------------------------------------------
// 4. ROOM TRANSITION & FADE CONTROLLER
// -----------------------------------------------------------------------------
enum TRANSITION_STATE {
    IDLE,
    FADE_OUT,
    FADE_IN
}

state           = TRANSITION_STATE.IDLE;
fade_alpha      = 0.0;
fade_speed      = 0.04;
fade_color      = c_black;
next_room       = -1;

// -----------------------------------------------------------------------------
// 5. GAMEPLAY & HUD CONTROLLER VARIABLES
// -----------------------------------------------------------------------------
game_paused               = false;
show_debug_overlay_custom = false; // Renamed to avoid built-in read-only variable conflict
game_score                = 0;
player_lives              = 3;

// -----------------------------------------------------------------------------
// 6. TIMER & TIME LIMIT SYSTEM
// -----------------------------------------------------------------------------
game_timer_ticks = 0;    // Tracks internal frames passed
max_time_seconds = 599;  // Time limit before death (9 minutes, 59 seconds = 599s)
time_exceeded    = false;

// -----------------------------------------------------------------------------
// 7. PARTICLE SYSTEM INITIALIZATION
// -----------------------------------------------------------------------------
// Central particle system handle for ambient environment effects
sys_particles   = part_system_create();
part_system_depth(sys_particles, -100);

show_debug_message("obj_controller initialized successfully.");