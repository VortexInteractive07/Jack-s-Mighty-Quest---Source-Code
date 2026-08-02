/// @description Initialize Title Screen Engine

// --- Widescreen Canvas Initialization ---
surface_resize(application_surface, 426, 240);

blink_speed = 30; // Frames per toggle (30 frames at 60fps = 0.5 sec ON / 0.5 sec OFF)

// --- Development & Debug Flags ---
dev_mode = false; // Set to true to switch to spr_titlescreen_development!

// --- Animation & Input Triggers ---
transition_triggered = false;
blink_timer = 0;
typewriter_chars = 0;

// =================================================================
// LEVEL SELECT & CHEAT CODE CONFIGURATION
// =================================================================
level_select_unlocked = false; // Unlocked via cheat code or debug
selected_level_index  = 0;

// Level Definitions (Target room, Display title, Subtitle)
level_list = [
    { room_id: rm_game,   title: "Hmm, Empty?",       sub: "Act 1 - Subways" },
    { room_id: rm_game_2, title: "Enemies Ahead",     sub: "Act 2 - City Scape" },
    { room_id: rm_game_3, title: "Chamber of Secrets", sub: "Act 3 - Boss Level" }
];

// Cheat Code Sequence: Up, Down, Left, Right, "A" key, Enter
cheat_sequence = [vk_up, vk_down, vk_left, vk_right, ord("A"), vk_enter];
cheat_index    = 0; 

// =================================================================
// TRANSITION CONTROLLER (SHADERLESS)
// Options: "fade", "curtain", "wipe_right", "pixelate", "circle_iris", "diamond_wipe"
// =================================================================
transition_type  = "fade"; 
fade_state       = "in";          // States: "in", "idle", "out"
fade_progress    = 0.0;           
transition_speed = 0.025;         

target_room = rm_main_menu;        // Default target room

// =================================================================
// HOLIDAY & SPECIAL EVENT CALENDAR ENGINE
// =================================================================

// --- 1. MANUAL DATE OVERRIDE / CUSTOM EVENTS ---
// Set 'use_manual_date' to true if you want to test or force a specific date!
use_manual_date = false;
manual_month    = 7;  // 1 - 12
manual_day      = 26; // 1 - 31

// You can add your own custom dates here anytime! { month, day, text, color }
custom_events = [
    { month: 1,  day: 1,  text: "HAPPY NEW YEAR!", color: c_aqua }
];

// --- 2. GET CURRENT SYSTEM DATE (OR MANUAL OVERRIDE) ---
var _today_month = use_manual_date ? manual_month : date_get_month(date_current_datetime());
var _today_day   = use_manual_date ? manual_day   : date_get_day(date_current_datetime());
var _today_year  = date_get_year(date_current_datetime());

// --- 3. ISLAMIC LUNAR HOLIDAY CALCULATOR (Ramadan, Eid al-Fitr, Eid al-Adha) ---
// Estimates based on lunar conversion cycles for current and upcoming years
var _ramadan_start_m = 0; var _ramadan_start_d = 0; var _ramadan_end_m = 0; var _ramadan_end_d = 0;
var _eid_fitr_m      = 0; var _eid_fitr_d      = 0;
var _eid_adha_m      = 0; var _eid_adha_d      = 0;

switch (_today_year) {
    case 2025:
        _ramadan_start_m = 3;  _ramadan_start_d = 1;  _ramadan_end_m = 3;  _ramadan_end_d = 30;
        _eid_fitr_m      = 3;  _eid_fitr_d      = 31;
        _eid_adha_m      = 6;  _eid_adha_d      = 6;
        break;
    case 2026:
        _ramadan_start_m = 2;  _ramadan_start_d = 18; _ramadan_end_m = 3;  _ramadan_end_d = 19;
        _eid_fitr_m      = 3;  _eid_fitr_d      = 20;
        _eid_adha_m      = 5;  _eid_adha_d      = 27;
        break;
    case 2027:
        _ramadan_start_m = 2;  _ramadan_start_d = 8;  _ramadan_end_m = 3;  _ramadan_end_d = 8;
        _eid_fitr_m      = 3;  _eid_fitr_d      = 9;
        _eid_adha_m      = 5;  _eid_adha_d      = 16;
        break;
    default:
        // Generic approximation formula for years beyond 2027
        _ramadan_start_m = 2; _ramadan_start_d = 1; _ramadan_end_m = 3; _ramadan_end_d = 1;
        _eid_fitr_m      = 3; _eid_fitr_d      = 2;
        _eid_adha_m      = 5; _eid_adha_d      = 10;
        break;
}

// --- 4. EVALUATE ACTIVE HOLIDAY BANNER ---
active_event_text  = "";
active_event_color = c_yellow;

// A. Check Ramadan Range
var _is_ramadan = false;
if (_today_month == _ramadan_start_m && _today_month == _ramadan_end_m) {
    if (_today_day >= _ramadan_start_d && _today_day <= _ramadan_end_d) _is_ramadan = true;
} else if (_today_month == _ramadan_start_m && _today_day >= _ramadan_start_d) {
    _is_ramadan = true;
} else if (_today_month == _ramadan_end_m && _today_day <= _ramadan_end_d) {
    _is_ramadan = true;
}

if (_is_ramadan) {
    active_event_text  = "RAMADAN KAREEM!";
    active_event_color = c_lime;
}
// B. Check Eid al-Fitr
else if (_today_month == _eid_fitr_m && _today_day == _eid_fitr_d) {
    active_event_text  = "EID MUBARAK! (EID AL-FITR)";
    active_event_color = c_yellow;
}
// C. Check Eid al-Adha
else if (_today_month == _eid_adha_m && _today_day == _eid_adha_d) {
    active_event_text  = "EID MUBARAK! (EID AL-ADHA)";
    active_event_color = c_yellow;
}
// D. Maldivian National Holidays
else if (_today_month == 7 && _today_day == 26) {
    active_event_text  = "HAPPY INDEPENDENCE DAY!";
    active_event_color = c_yellow;
}
else if (_today_month == 11 && _today_day == 11) {
    active_event_text  = "HAPPY REPUBLIC DAY!";
    active_event_color = c_aqua;
}
else if (_today_month == 5 && _today_day == 1) {
    active_event_text  = "HAPPY LABOR DAY!";
    active_event_color = c_white;
}

// E. Custom Events Array Match
if (active_event_text == "") {
    for (var e = 0; e < array_length(custom_events); e++) {
        var _evt = custom_events[e];
        if (_evt.month == _today_month && _evt.day == _today_day) {
            active_event_text  = _evt.text;
            active_event_color = _evt.color;
            break;
        }
    }
}

// =================================================================
// START TEXT POOL & RANDOMIZER
// =================================================================
start_text_pool = [
    "Press [Enter] to Start!",
    "Press [Enter] to Begin Your Quest!",
    "Press [Enter] to Jump In!",
    "Hit [Enter] to Play!",
    "Press [Enter] to Continue...",
    "Why are you AFK-ing right now? Hit [Enter] to begin!",
    "Don't be shy, little one! Hit [Enter] to begin!",
    "Let's Smurf in! Press [Enter] to start!",
    "[Enter] Wo oste, hajimaru yo!",
    "Presso [Enter] zu beginne!",

    // --- Classic Arcade & High Hype ---
    "INSERT COIN... Just kidding, hit [Enter]!",
    "Ready Player One? Hit [Enter]!",
    "Press [Enter] to prove your worth!",
    "Destiny awaits! Smash that [Enter] key!",
    "Press [Enter] to kick off the adventure!",
    "An epic journey begins with a single [Enter]!",

    // --- Playful / Fourth-Wall ---
    "Are you just gonna stare at the menu? Press [Enter]!",
    "The [Enter] key is right there, tap it!",
    "Your keyboard called, it wants you to hit [Enter]!",
    "Take a breath, then smash [Enter]!",
    "No pressure, but [Enter] starts the game!",
    "Still loading your motivation? Hit [Enter]!",
	"Arr! Are ye ready? Press [Enter] to begin ye quest!",

    // --- Retro Engrish Style ---
    "PUSH [ENTER] KEY FOR MAKE GREAT START!",
    "PLEASE PUSH [ENTER] TO PLAY GAME NOW!",
    "LET'S GETS GOING! PUSH [ENTER] BUTTON!",
    "WELCOME TO SUPER ADVENTURE! HIT [ENTER]!",
    "YOUR HERO WAITING! PLEASE PRESSING [ENTER]!",
    "CONGRATULATION! PUSH [ENTER] FOR START!",

    // --- Multicart Bootleg NES Style ---
    "PLEASE TO SELECT BUTTON [ENTER] FOR START!",
    "WELCOME TO 9999-IN-1! PUSH [ENTER] TO PLAY!",
    "GOOD LUCK PLAYER! PRESS [ENTER] FOR ACTION NOW!",
    "WARNING! YOU MUST PRESS [ENTER] TO BEGINNING!",
    "CHOOSE START BUTTON [ENTER] FOR PLAY GAME!",
    "IT IS A HAPPY TIME! PUSH [ENTER] KEY!",
    "SELECT [ENTER] AND LET US GO TO FIGHTING!",
    "PUSH [ENTER] BUTTON AND DEFEAT THE BAD GUY!",

    // --- Multi-Language / Flavor ---
    "[ENTER] key wo ose! Battle Start!",
    "Drucken Sie [Enter] to begin!",
    "Y'all ready for this? Press [Enter]!"
];

randomize();
var _rand_index = irandom(array_length(start_text_pool) - 1);
start_message = start_text_pool[_rand_index];

// Splash text
splash_text = scr_title_splash(); 

// --- Title Theme Playlist ---
scr_title_music_arrangement();
global.title_playlist = array_shuffle(global.title_playlist);
global.current_song_index = 0;

var _first_song = global.title_playlist[global.current_song_index];
if (audio_exists(_first_song) && !audio_is_playing(_first_song)) {
    audio_stop_all();
    audio_play_sound(_first_song, 100, false); 
}

// Global Stats Tracker
if (!variable_global_exists("stats")) {
    global.stats = { total_deaths: 0, total_jumps: 0, time_played_sec: 0 };
}