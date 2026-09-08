/// @description Create Event - obj_init_controller

// Required Assets Checklist:
// - mus_menu (Sound)
// - fnt_bitmap (Font)
// - rm_splash_screen (Room)

// ============================================================================
// CONFIGURATION & DISPLAY CONTROL
// ============================================================================
scr_load_settings();
window_set_fullscreen(global.fullscreen);

enable_loading_bar   = false;      // Set to false to instantly jump to splash room
enable_piracy_check  = false;      // Toggle anti-piracy trigger verification
load_time_seconds    = 1.5;       // Target duration in seconds
load_max             = max(1, round(load_time_seconds * game_get_speed(gamespeed_fps)));
load_timer           = 0;
load_progress_smooth = 0;        // Interpolated progress for spring easing

loading_text  = "Loading, please wait!";
gloss_offset  = 0;

// ============================================================================
// ANTI-PIRACY & KEY-CODE PASSCODE SYSTEM
// ============================================================================
is_pirated           = false;
show_passcode_prompt = false;
piracy_reason        = "";

user_input_code      = "";
correct_code         = "2026";    // Access passcode
max_code_length      = 8;
passcode_failed      = false;

if (enable_piracy_check) {
    // Check 1: DRM / Store Integration (Steam / Custom Marker File)
    var _has_valid_license = file_exists("steam_api.dll") || file_exists("license.dat");
    
    // Check 2: Directory Modification Anomaly Detection
    var lower_case_path = string_lower(game_save_id);
    var _invalid_dir = (string_pos("pirate", lower_case_path) > 0) || (string_pos("crack", lower_case_path) > 0);
    
    // Check 3: Modified Sandbox Signature Check
    var _tampered_exec = (parameter_count() > 0 && string_pos("free", string_lower(parameter_string(0))) > 0);

    if (!_has_valid_license || _invalid_dir || _tampered_exec) {
        show_passcode_prompt = true;
        keyboard_string = "";     // Reset keyboard buffer for input
    }
}

// ============================================================================
// 1. UNHANDLED EXCEPTION CRASH HANDLER
// ============================================================================
exception_unhandled_handler(function(_e) {
    var _file = file_text_open_write("crash_log.txt");
    if (_file != -1) {
        file_text_write_string(_file, "=== CRASH REPORT ===\n");
        file_text_write_string(_file, "TIMESTAMP: " + string(date_datetime_string(date_current_datetime())) + "\n");
        file_text_write_string(_file, "ROOM: " + room_get_name(room) + "\n");
        file_text_write_string(_file, "DETAILS:\n" + string(_e.longMessage) + "\n");
        file_text_write_string(_file, "=======================================\n");
        file_text_close(_file);
    }
    show_message_async("Jack's Mighty Quest Encountered an Error!\n\nCheck crash_log.txt for full details.");
    return 0;
});

// ============================================================================
// 2. READ PREVIOUS CRASH LOG DATA & PARSE METRICS
// ============================================================================
has_crash_log    = false;
crash_log_text   = "";
crash_log_scroll = 0;

if (file_exists("crash_log.txt")) {
    var _file = file_text_open_read("crash_log.txt");
    if (_file != -1) {
        while (!file_text_eof(_file)) {
            crash_log_text += file_text_read_string(_file) + "\n";
            file_text_readln(_file);
        }
        file_text_close(_file);
        has_crash_log = true;
    }
}

// ============================================================================
// 3. FADE SEQUENCE CONTROLLER
// State 0: Fade In | State 1: Active/Load | State 2: Fade Out
// ============================================================================
fade_state = 0;
fade_alpha = 1.0;
fade_speed = 0.03;

// Fast-forward straight to fade out if loading feature is disabled, no crash log, and not pirated/prompting
if (!enable_loading_bar && !has_crash_log && !is_pirated && !show_passcode_prompt) {
    fade_state = 2;
}

// ============================================================================
// 4. TOAST NOTIFICATION SYSTEM
// ============================================================================
toast_timer = 0;
toast_max   = round(1.5 * game_get_speed(gamespeed_fps));
toast_text  = "Copied Text!";

// ============================================================================
// 5. AUDIO INITIALIZATION
// ============================================================================
audio_stop_all();
var _menu_music_inst = audio_play_sound(mus_menu, 1, true);
audio_sound_gain(_menu_music_inst, global.vol_bgm / 100, 0);