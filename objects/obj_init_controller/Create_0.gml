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
}

window_set_fullscreen(global.fullscreen);

display_width = 432;
display_height = 240;
surface_resize(application_surface, display_width, display_height);

// --- Boot System Configuration ---
enable_drm           = false;       // Master Toggle: Set to false to bypass DRM completely
enable_loading_bar   = false;       // Set to false to bypass loading bar and skip to splash
load_time_seconds    = 1.5;        // Target duration in seconds
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
drm_failed = false;

drm_difficulty   = 0; // 0 = Easy (Kids), 1 = Hard (Adults)
drm_subject_id   = 0; // 0 = Math, 1 = English, 2 = Science, 3 = CS, 4 = History/Geo
drm_topic_title  = ""; // Active Questioning Topic/Category Label
drm_correct_val  = ""; // Supports both numeric string and text string answers
drm_equation_str = "";

drm_user_input   = "";
drm_shake_timer  = 0;
drm_status_msg   = "SELECT DIFFICULTY TO BEGIN";

// Layout Properties
drm_bar_width    = 360;
drm_bar_height   = 22;
drm_bar_x        = (display_width - drm_bar_width) / 2;
drm_bar_y        = 32;

// Procedural Educational DRM Challenge Generator
function drm_generate_problem(_diff) {
    drm_difficulty = _diff;
    drm_user_input = "";
    drm_status_msg = "ENTER ANSWER AND PRESS ENTER";
    
    drm_subject_id = irandom(4);
    
    // Declare all local variables at the function scope to satisfy GameMaker Feather (GM2044)
    var _n1 = 0;
    var _n2 = 0;
    var _n3 = 0;
    var _denom = 0;
    var _quot = 0;
    var _op_type = 0;
    var _eng_type = 0;
    var _sci_type = 0;
    var _cs_type = 0;
    var _geo_type = 0;
    var _hist_type = 0;
    var _words = noone;
    var _w = "";
    var _vowel_count = 0;
    var _char = "";
    var _planets = noone;
    var _idx = 0;
    var _bin_vals = noone;
    var _b_idx = 0;
    var _syl_words = noone;
    var _syl_counts = noone;
    var _s_idx = 0;
    var _hex_words = noone;
    var _hex_vals = noone;
    var _h_idx = 0;

    if (_diff == 0) {
        // ====================================================================
        // KIDS MODE (Basic Single-Step / Fundamental Concepts)
        // ====================================================================
        switch (drm_subject_id) {
            case 0: // MATH: Basic Single-step Operations
                _op_type = irandom(3);
                switch (_op_type) {
                    case 0: // Addition
                        drm_topic_title = "MATH: BASIC ADDITION";
                        _n1 = irandom_range(5, 25);
                        _n2 = irandom_range(1, 25);
                        drm_correct_val = string(_n1 + _n2);
                        drm_equation_str = string(_n1) + " + " + string(_n2) + " = ?";
                        break;
                        
                    case 1: // Subtraction
                        drm_topic_title = "MATH: BASIC SUBTRACTION";
                        _n1 = irandom_range(10, 40);
                        _n2 = irandom_range(1, _n1);
                        drm_correct_val = string(_n1 - _n2);
                        drm_equation_str = string(_n1) + " - " + string(_n2) + " = ?";
                        break;
                        
                    case 2: // Multiplication
                        drm_topic_title = "MATH: SINGLE-DIGIT MULTIPLICATION";
                        _n1 = irandom_range(2, 9);
                        _n2 = irandom_range(2, 9);
                        drm_correct_val = string(_n1 * _n2);
                        drm_equation_str = string(_n1) + " * " + string(_n2) + " = ?";
                        break;
                        
                    case 3: // Exact Integer Division
                        drm_topic_title = "MATH: EXACT INTEGER DIVISION";
                        _denom = irandom_range(2, 8);
                        _quot  = irandom_range(2, 9);
                        _n1    = _denom * _quot;
                        drm_correct_val = string(_quot);
                        drm_equation_str = string(_n1) + " / " + string(_denom) + " = ?";
                        break;
                }
                break;

            case 1: // ENGLISH: Letter Counts & Missing Vowels
                _eng_type = irandom(1);
                if (_eng_type == 0) {
                    drm_topic_title = "ENGLISH: WORD LETTER COUNT";
                    _words = ["APPLE", "BANANA", "CAT", "DRAGON", "ELEPHANT", "FROG", "GIRAFFE", "HOUSE"];
                    _w = _words[irandom(array_length(_words) - 1)];
                    drm_correct_val = string(string_length(_w));
                    drm_equation_str = "HOW MANY LETTERS IN '" + _w + "'?";
                } else {
                    drm_topic_title = "ENGLISH: MISSING VOWEL COUNT";
                    _words = ["GAME", "QUEST", "WATER", "TIGER", "PLANET", "ROCKET"];
                    _w = _words[irandom(array_length(_words) - 1)];
                    _vowel_count = 0;
                    for (var _i = 1; _i <= string_length(_w); _i++) {
                        _char = string_char_at(_w, _i);
                        if (_char == "A" || _char == "E" || _char == "I" || _char == "O" || _char == "U") {
                            _vowel_count++;
                        }
                    }
                    drm_correct_val = string(_vowel_count);
                    drm_equation_str = "HOW MANY VOWELS IN '" + _w + "'?";
                }
                break;

            case 2: // SCIENCE: States of Matter & Planetary Order
                _sci_type = irandom(1);
                if (_sci_type == 0) {
                    drm_topic_title = "SCIENCE: WATER FREEZING POINT";
                    drm_correct_val = "0";
                    drm_equation_str = "FREEZING POINT OF WATER IN CELSIUS?";
                } else {
                    drm_topic_title = "SCIENCE: SOLAR SYSTEM POSITION";
                    _planets = ["MERCURY", "VENUS", "EARTH", "MARS", "JUPITER", "SATURN"];
                    _idx = irandom(array_length(_planets) - 1);
                    drm_correct_val = string(_idx + 1);
                    drm_equation_str = "POSITION OF " + _planets[_idx] + " FROM SUN?";
                }
                break;

            case 3: // COMPUTER SCIENCE: Binary Bits & Byte Size
                _cs_type = irandom(1);
                if (_cs_type == 0) {
                    drm_topic_title = "COMP-SCI: BYTE CAPACITY";
                    drm_correct_val = "8";
                    drm_equation_str = "HOW MANY BITS ARE IN 1 BYTE?";
                } else {
                    drm_topic_title = "COMP-SCI: BINARY TO DECIMAL";
                    _bin_vals = ["0001", "0010", "0011", "0100", "0101", "0110", "0111", "1000"];
                    _b_idx = irandom(array_length(_bin_vals) - 1);
                    drm_correct_val = string(_b_idx + 1);
                    drm_equation_str = "DECIMAL VALUE OF BINARY " + _bin_vals[_b_idx] + "?";
                }
                break;

            case 4: // GEOGRAPHY: Continents & Oceans
                _geo_type = irandom(1);
                if (_geo_type == 0) {
                    drm_topic_title = "GEOGRAPHY: EARTH CONTINENTS";
                    drm_correct_val = "7";
                    drm_equation_str = "TOTAL NUMBER OF CONTINENTS ON EARTH?";
                } else {
                    drm_topic_title = "GEOGRAPHY: EARTH OCEANS";
                    drm_correct_val = "5";
                    drm_equation_str = "TOTAL NUMBER OF NAMED OCEANS ON EARTH?";
                }
                break;
        }
    } else {
        // ====================================================================
        // ADULTS MODE (Compound Multi-step Order of Operations & Advanced CS)
        // ====================================================================
        switch (drm_subject_id) {
            case 0: // MATH: Compound Order of Operations (PEMDAS)
                _op_type = irandom(3);
                switch (_op_type) {
                    case 0: // (A * B) - C
                        drm_topic_title = "MATH: MULTIPLY THEN SUBTRACT";
                        _n1 = irandom_range(6, 15);
                        _n2 = irandom_range(4, 12);
                        _n3 = irandom_range(5, 30);
                        drm_correct_val = string((_n1 * _n2) - _n3);
                        drm_equation_str = "(" + string(_n1) + " * " + string(_n2) + ") - " + string(_n3) + " = ?";
                        break;
                        
                    case 1: // A + (B * C)
                        drm_topic_title = "MATH: OPERATOR PRECEDENCE (PEMDAS)";
                        _n1 = irandom_range(15, 50);
                        _n2 = irandom_range(5, 12);
                        _n3 = irandom_range(3, 9);
                        drm_correct_val = string(_n1 + (_n2 * _n3));
                        drm_equation_str = string(_n1) + " + (" + string(_n2) + " * " + string(_n3) + ") = ?";
                        break;
                        
                    case 2: // (A / B) + C
                        drm_topic_title = "MATH: DIVISION AND SUMMATION";
                        _denom = irandom_range(3, 9);
                        _quot  = irandom_range(5, 15);
                        _n1    = _denom * _quot;
                        _n3    = irandom_range(10, 45);
                        drm_correct_val = string(_quot + _n3);
                        drm_equation_str = "(" + string(_n1) + " / " + string(_denom) + ") + " + string(_n3) + " = ?";
                        break;
                        
                    case 3: // (A - B) * C
                        drm_topic_title = "MATH: PARENTHETICAL EVALUATION";
                        _n2 = irandom_range(5, 20);
                        _n1 = _n2 + irandom_range(5, 15);
                        _n3 = irandom_range(4, 12);
                        drm_correct_val = string((_n1 - _n2) * _n3);
                        drm_equation_str = "(" + string(_n1) + " - " + string(_n2) + ") * " + string(_n3) + " = ?";
                        break;
                }
                break;

            case 1: // ENGLISH: Syllables & Advanced Word Length
                drm_topic_title = "ENGLISH: SYLLABLE COUNT EVALUATION";
                _syl_words = ["COMPUTER", "ALGORITHM", "ARCHITECTURE", "DEVELOPMENT", "SECURITY"];
                _syl_counts = ["3", "4", "5", "4", "4"];
                _s_idx = irandom(array_length(_syl_words) - 1);
                drm_correct_val = _syl_counts[_s_idx];
                drm_equation_str = "NUMBER OF SYLLABLES IN '" + _syl_words[_s_idx] + "'?";
                break;

            case 2: // SCIENCE: Elements & Constants
                _sci_type = irandom(1);
                if (_sci_type == 0) {
                    drm_topic_title = "SCIENCE: CHEMISTRY ATOMIC NUMBERS";
                    drm_correct_val = "6";
                    drm_equation_str = "ATOMIC NUMBER OF CARBON (C)?";
                } else {
                    drm_topic_title = "SCIENCE: WATER BOILING POINT";
                    drm_correct_val = "100";
                    drm_equation_str = "BOILING POINT OF WATER IN CELSIUS?";
                }
                break;

            case 3: // COMPUTER SCIENCE: Hexadecimal & Nibble Evaluation
                _cs_type = irandom(1);
                if (_cs_type == 0) {
                    drm_topic_title = "COMP-SCI: NIBBLE BIT CAPACITY";
                    drm_correct_val = "4";
                    drm_equation_str = "HOW MANY BITS IN A SINGLE NIBBLE?";
                } else {
                    drm_topic_title = "COMP-SCI: HEXADECIMAL TO DECIMAL";
                    _hex_words = ["0x0A", "0x0F", "0x10", "0x14", "0x20"];
                    _hex_vals  = ["10", "15", "16", "20", "32"];
                    _h_idx = irandom(array_length(_hex_words) - 1);
                    drm_correct_val = _hex_vals[_h_idx];
                    drm_equation_str = "DECIMAL VALUE OF HEX " + _hex_words[_h_idx] + "?";
                }
                break;

            case 4: // HISTORY / GEOGRAPHY: World Knowledge
                _hist_type = irandom(1);
                if (_hist_type == 0) {
                    drm_topic_title = "HISTORY: CENTURY YEAR SPAN";
                    drm_correct_val = "100";
                    drm_equation_str = "HOW MANY YEARS ARE IN 1 CENTURY?";
                } else {
                    drm_topic_title = "GEOGRAPHY: US STATES COUNT";
                    drm_correct_val = "50";
                    drm_equation_str = "TOTAL NUMBER OF US STATES?";
                }
                break;
        }
    }
}

drm_generate_problem(0);

// Verification logic
function drm_verify_code() {
    if (drm_user_input == "" || drm_user_input == "-") return false;
    
    if (string_upper(string_trim(drm_user_input)) == string_upper(string_trim(drm_correct_val))) {
        drm_passed = true;
        drm_failed = false;
        drm_status_msg = "ACCESS GRANTED!";
        return true;
    } else {
        drm_shake_timer = 20;
        drm_status_msg = "INCORRECT! RE-EVALUATE RESULT";
        drm_user_input = "";
        return false;
    }
}

// History tracking
key_history_list = ds_list_create();

// --- Fade Sequence Controller ---
fade_state = 0;
fade_alpha = 1.0;
fade_speed = 0.03;

if (!enable_loading_bar && !has_crash_log && drm_passed) {
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