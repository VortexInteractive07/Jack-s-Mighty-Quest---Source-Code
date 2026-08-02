// --- Global Initialization ---
if (!variable_global_exists("language_mode")) { global.language_mode = 0; }
if (!variable_global_exists("narrator_mode")) { global.narrator_mode = false; }
if (!variable_global_exists("show_subtitles")) { global.show_subtitles = true; }
if (!variable_global_exists("dark_mode"))      { global.dark_mode = false; }

// --- Developer Settings ---
show_dev_disclaimer = false; // Toggle spr_dev_disclaimer inclusion

// --- Dynamic Splash Screen Sequence List ---
// Add any additional splash screen sprites directly to this array!
splash_screens = [
    spr_disclaimer
];

if (show_dev_disclaimer) {
    array_push(splash_screens, spr_dev_disclaimer);
}

// Select logo variant dynamically based on dark_mode setting
var _logo_sprite = global.dark_mode ? spr_vortex_logo_darkmode : spr_vortex_logo_lightmode;
array_push(splash_screens, _logo_sprite);
array_push(splash_screens, spr_vortex_presents);

// --- Sequence State Machine ---
current_splash_index = 0; // Current index inside splash_screens array
sub_state = 0;            // 0: Fade In | 1: Hold | 2: Fade Out
is_loading = false;       // Set to true when transitioning to spr_loading
is_skipping = false;      // Set to true for final global skip fade

depth = 0;

// --- Fade Timing Tuning ---
fade_alpha = 0;
fade_in_speed  = 0.02;  
fade_out_speed = 0.02;  

hold_timer = 0; 
hold_duration = 162;

target_room = rm_title;

// --- Audio ---
audio_stop_all();
if (global.narrator_mode && !instance_exists(obj_narrator_controller)) {
    instance_create_depth(0, 0, 0, obj_narrator_controller);
} else if (!global.narrator_mode) {
    audio_play_sound(mus_raalhehge_monaigaa, 10, false);
}