// Required Assets List:
// - spr_loading_bar
// - mus_menu
// - scr_load_settings
// - scr_drm_generate_question
// - scr_drm_answer_matches
// - get_localized_text

// ============================================================================
// CREATE EVENT
// Object: obj_init_controller
// Target: GameMaker LTS 2026.0+ (432x240 Widescreen @ 60 FPS)
// ============================================================================

// --- Global Settings & Engine Boot ---
if (script_exists(scr_load_settings)) {
    scr_load_settings();
} else {
    global.fullscreen = false;
    global.vol_bgm = 100;
    global.language = "EN";
    global.language_selected = false;
    global.startup_challenge_enabled = true;
}

if (!variable_global_exists("startup_challenge_enabled")) {
    global.startup_challenge_enabled = true;
}

language_selection_required = !global.language_selected;
language_selection_index = (global.language == "JP") ? 1 : 0;

window_set_fullscreen(global.fullscreen);

display_width = 432;
display_height = 240;
surface_resize(application_surface, display_width, display_height);

// --- Boot System Configuration ---
enable_drm           = false;
enable_loading_bar   = true;        // Set to false to bypass loading bar and skip to splash
load_time_seconds    = 1.5;         // Target duration in seconds
load_max             = max(1, round(load_time_seconds * game_get_speed(gamespeed_fps)));
load_timer           = 0;
load_progress_smooth = 0;          // Interpolated progress for spring easing

loading_text   = "Loading, please wait!";
gloss_offset   = 0;

// --- Unhandled Exception Crash Handler ---
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

// --- Crash Log Detection ---
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

// --- Dynamic Multi-Subject DRM Security Gate Engine ---
drm_passed = !enable_drm;

drm_difficulty   = 0; // 0 = Easy (Kids), 1 = Hard (Adults)
drm_topic_title  = ""; // Active Questioning Topic/Category Label
drm_correct_val  = ""; // Supports both numeric string and text string answers
drm_equation_str = "";

drm_user_input   = "";
drm_shake_timer  = 0;
drm_status_msg   = "SELECT DIFFICULTY TO BEGIN";

// Procedural Educational DRM Challenge Generator
function drm_generate_problem(_diff) {
    drm_difficulty = clamp(floor(_diff), 0, 1);
    var _question = scr_drm_generate_question(drm_difficulty);
    drm_topic_title = _question.topic_title;
    drm_equation_str = _question.question;
    drm_correct_val = _question.answer;
    drm_user_input = "";
    if (script_exists(get_localized_text)) {
        drm_status_msg = get_localized_text("challenge_enter");
    } else {
        drm_status_msg = "ENTER ANSWER";
    }
}

drm_generate_problem(0);

// Verification logic
function drm_verify_code() {
    if (scr_drm_answer_matches(drm_user_input, drm_correct_val)) {
        drm_passed = true;
        if (script_exists(get_localized_text)) {
            drm_status_msg = get_localized_text("challenge_granted");
        } else {
            drm_status_msg = "ACCESS GRANTED";
        }
        return true;
    } else {
        drm_shake_timer = 20;
        if (script_exists(get_localized_text)) {
            drm_status_msg = get_localized_text("challenge_wrong");
        } else {
            drm_status_msg = "INCORRECT ANSWER";
        }
        drm_user_input = "";
        return false;
    }
}

// --- Fade Sequence Controller ---
fade_state = 0;
fade_alpha = 1.0;
fade_speed = 0.03;

if (!enable_loading_bar && !has_crash_log && drm_passed && !language_selection_required) {
    fade_state = 2;
}

// --- Toast Notification System ---
toast_timer = 0;
toast_max   = round(1.5 * game_get_speed(gamespeed_fps));
toast_text  = "Copied Text!";

// --- Audio System Initialization ---
audio_stop_all();
menu_music_inst = -1;
var _bgm_vol = variable_global_exists("vol_bgm") ? global.vol_bgm : 100;
menu_music_inst = audio_play_sound(mus_menu, 1, true);
audio_sound_gain(menu_music_inst, _bgm_vol / 100, 0);