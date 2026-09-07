// ============================================================================
// CONFIGURATION & DISPLAY CONTROL
// ============================================================================
enable_loading_bar = true;     // Set to false to instantly jump to splash room
load_time_seconds  = 1.5;      // Target duration in seconds
load_max           = max(1, round(load_time_seconds * game_get_speed(gamespeed_fps)));
load_timer         = 0;
load_progress_smooth = 0;      // Interpolated progress for spring easing

loading_text  = "Loading, please wait!";
gloss_offset  = 0;

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
has_crash_log  = false;
crash_log_text = "";
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

// Fast-forward straight to fade out if loading feature is disabled and no crash log
if (!enable_loading_bar && !has_crash_log) {
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
audio_play_sound(mus_menu, 1, true);