/// @description Level Controller Initialization - Non-Persistent (GM LTS 2026)

persistent = false;

// --- 1. AUDIO INTEGRATION & MUSIC MANAGEMENT ---
bgm_handle = -1;
bgm_target_volume = 1.0;

if (audio_exists(mus_subway)) {
    if (!audio_is_playing(mus_subway)) {
        bgm_handle = audio_play_sound(mus_subway, 10, true);
        audio_sound_gain(mus_subway, bgm_target_volume, 0);
    } else {
        bgm_handle = mus_subway;
    }
}

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
pause_option              = 0; // 0: Resume, 1: Restart, 2: Quit to Menu
show_debug_overlay_custom = false;
game_score                = 0;
player_lives              = 3;
max_lives                 = 5;

// Game Over Control
is_game_over              = false;
game_over_timer           = 0;
game_over_delay           = game_get_speed(gamespeed_fps) * 3.0;

// --- 5. TIMER & TIME LIMIT SYSTEM ---
game_timer_ticks = 0;
max_time_seconds = 599; // 9 mins 59 secs
time_exceeded    = false;

// --- 6. PARTICLE SYSTEM INITIALIZATION ---
sys_particles = part_system_create();
part_system_depth(sys_particles, -100);

show_debug_message("obj_controller initialized for current level instance.");