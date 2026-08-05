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
    { room_id: rm_game_2, title: "Enemies Ahead",      sub: "Act 2 - City Scape" },
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
fade_state       = "in";         // States: "in", "idle", "out"
fade_progress    = 0.0;            
transition_speed = 0.025;         

target_room = rm_main_menu;        // Default target room

// =================================================================
// HOLIDAY & SPECIAL EVENT CALENDAR ENGINE
// =================================================================

// --- 1. MANUAL DATE OVERRIDE / CUSTOM EVENTS ---
use_manual_date = false;
manual_month    = 7;  // 1 - 12
manual_day      = 26; // 1 - 31

custom_events = [
    { month: 1,  day: 1,  text: "HAPPY NEW YEAR!", color: c_aqua }
];

// --- 2. GET CURRENT SYSTEM DATE ---
var _today_month = use_manual_date ? manual_month : date_get_month(date_current_datetime());
var _today_day   = use_manual_date ? manual_day   : date_get_day(date_current_datetime());
var _today_year  = date_get_year(date_current_datetime());

// --- 3. ISLAMIC LUNAR HOLIDAY CALCULATOR ---
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
else {
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
// START TEXT POOL (200 VARIATIONS)
// =================================================================
start_text_pool = [
    // 1 - 20: Standard & Conversational
    "Press [Enter] to Start!",
    "Press [Enter] to Begin Your Quest!",
    "Press [Enter] to Jump In!",
    "Hit [Enter] to Play!",
    "Press [Enter] to Continue...",
    "Why are you AFK-ing right now? Hit [Enter] to begin!",
    "Don't be shy, little one! Hit [Enter] to begin!",
    "Let's Smurf in! Press [Enter] to start!",
    "Ready Player One? Hit [Enter]!",
    "Press [Enter] to prove your worth!",
    "Destiny awaits! Smash that [Enter] key!",
    "Press [Enter] to kick off the adventure!",
    "An epic journey begins with a single [Enter]!",
    "Are you just gonna stare at the menu? Press [Enter]!",
    "The [Enter] key is right there, tap it!",
    "Your keyboard called, it wants you to hit [Enter]!",
    "Take a breath, then smash [Enter]!",
    "No pressure, but [Enter] starts the game!",
    "Still loading your motivation? Hit [Enter]!",
    "Y'all ready for this? Press [Enter]!",

    // 21 - 40: Bootleg / Engrish Style
    "PUSH [ENTER] KEY FOR MAKE GREAT START!",
    "PLEASE PUSH [ENTER] TO PLAY GAME NOW!",
    "LET'S GETS GOING! PUSH [ENTER] BUTTON!",
    "WELCOME TO SUPER ADVENTURE! HIT [ENTER]!",
    "YOUR HERO WAITING! PLEASE PRESSING [ENTER]!",
    "CONGRATULATION! PUSH [ENTER] FOR START!",
    "PLEASE TO SELECT BUTTON [ENTER] FOR START!",
    "WELCOME TO 9999-IN-1! PUSH [ENTER] TO PLAY!",
    "GOOD LUCK PLAYER! PRESS [ENTER] FOR ACTION NOW!",
    "WARNING! YOU MUST PRESS [ENTER] TO BEGINNING!",
    "CHOOSE START BUTTON [ENTER] FOR PLAY GAME!",
    "IT IS A HAPPY TIME! PUSH [ENTER] KEY!",
    "SELECT [ENTER] AND LET US GO TO FIGHTING!",
    "PUSH [ENTER] BUTTON AND DEFEAT THE BAD GUY!",
    "INSERT COIN OR JUST PUSH [ENTER] FRIEND!",
    "ALL YOUR BASE ARE BELONG TO [ENTER]!",
    "VERY NICE GAME! PLEASE HIT [ENTER] KEY!",
    "SUPER PLAYER MUST PRESS [ENTER] NOW!",
    "DO NOT WAIT, PUSH [ENTER] FOR GLORY!",
    "FAST ACTION START WITH [ENTER] BUTTON!",

    // 41 - 60: Multilingual & Localized Flavour
    "[Enter] Wo ose, hajimaru yo!",
    "Presso [Enter] zu beginne!",
    "Drucken Sie [Enter] to begin!",
    "Appuyez sur [Enter] pour commencer!",
    "Pulse [Enter] para comenzar!",
    "Premere [Enter] per iniziare!",
    "Pressione [Enter] para começar!",
    "Presis [Enter] start karein!",
    "Naжмите [Enter] для начала!",
    "Basilan [Enter] tusuna basin!",
    "Drücke [Enter] zum Starten!",
    "Haz click en [Enter] por favor!",
    "Tlačítko [Enter] pro zahájení!",
    "Naciśnij [Enter], aby zacząć!",
    "Pussh [Enter] kī shuru!",
    "Starten Sie mit [Enter]!",
    "Apretando [Enter] para la acción!",
    "Game start desu! Push [Enter]!",
    "Guten Tag! Press [Enter] to play!",
    "Bon appétit! Now hit [Enter]!",

    // 61 - 80: Pirate & Fantasy Theme
    "Arr! Are ye ready? Press [Enter] to begin ye quest!",
    "Ahoy matey! Press [Enter] to hoist the sails!",
    "By Blackbeard's ghost, hit [Enter] to set sail!",
    "Grab yer cutlass and press [Enter]!",
    "Treasure awaits those who press [Enter]!",
    "Avast ye landlubber! Smash [Enter]!",
    "Sail into danger with a tap of [Enter]!",
    "A pirate's life for thee! Press [Enter]!",
    "Batten down the hatches and press [Enter]!",
    "Heave-ho! Hit [Enter] to start the voyage!",
    "Invoke the ancient magic by pressing [Enter]!",
    "The dungeon doors open when you press [Enter]!",
    "A wizard is never late, he hits [Enter] precisely when he means to!",
    "Slay the dragon with a mighty [Enter] press!",
    "Drink an elixir of focus and hit [Enter]!",
    "Equip your sword and press [Enter]!",
    "The prophecy foretold your [Enter] press!",
    "Cast your spell by striking [Enter]!",
    "Venture into the unknown! Press [Enter]!",
    "May the odds be ever in your [Enter] favor!",

    // 81 - 100: Sci-Fi & Cyberpunk Tone
    "Initiating sequence... Press [Enter] to override!",
    "Terminal active. Press [Enter] to establish link.",
    "System online. Tap [Enter] for mainframe access.",
    "Cyber-deck ready. Hit [Enter] to jack in.",
    "AI core online. Press [Enter] to initialize.",
    "Hyperdrive engaged! Press [Enter] to warp.",
    "Warning: Sector 7 breach! Hit [Enter]!",
    "Bio-scan complete. Press [Enter] to spawn.",
    "Matrix handshake successful. Press [Enter]!",
    "Quantum portal unstable! Hit [Enter] now!",
    "Robots incoming! Press [Enter] to deploy defense.",
    "Reactor core stable. Press [Enter] to launch.",
    "Satellite link established. Hit [Enter]!",
    "Decoding sector parameters... Press [Enter].",
    "Nanites ready. Press [Enter] to reconstruct.",
    "Simulation loaded. Hit [Enter] to wake up.",
    "Firewall breached! Press [Enter] to counter.",
    "Overclocking CPU cores... Press [Enter]!",
    "Mecha pilot standby. Hit [Enter] to sync.",
    "Galaxy sector clean. Press [Enter] to proceed.",

    // 101 - 120: Sarcastic & Playful Teases
    "You could go outside, or you could press [Enter].",
    "Is your finger tired already? Just tap [Enter].",
    "Staring at title screens is a valid hobby, but [Enter] starts the game.",
    "Error 404: Player motivation not found. Press [Enter] anyway.",
    "Look at you, looking at this screen. Go on, hit [Enter].",
    "I bet you can't press [Enter] with your elbow.",
    "Do a barrel roll! Or just hit [Enter], whatever works.",
    "Achievement unlocked: Pro Procrastinator. Hit [Enter] to play.",
    "You have successfully stared at a static image for 3 seconds.",
    "Okay, we get it, the background art looks nice. Press [Enter].",
    "Keyboard warriors unite! Press [Enter] to battle.",
    "Plot twist: Pressing [Enter] does absolutely nothing. (Kidding, it starts the game).",
    "Warning: Excessive menu lingering may cause boredom. Press [Enter].",
    "Initializing high-tier gaming stance... Hit [Enter].",
    "Coffee levels low? Press [Enter] to compensate.",
    "Your cat is judging you for not pressing [Enter] yet.",
    "Press [Enter] to unlock absolute chaos.",
    "Legend says if you hold [Enter], nothing happens. Just tap it.",
    "Zero bugs found here. (Source: trust me bro). Hit [Enter].",
    "Why press many button when one [Enter] do trick?",

    // 121 - 140: Casual Chiptune / Retro Vibes
    "Frequencies aligned. Hit [Enter] for square wave bliss.",
    "Loading 8-bit assets into memory... Press [Enter].",
    "PSG sound chip initialized. Hit [Enter] to drop beat.",
    "FM synthesis engine standing by. Press [Enter].",
    "RAM cassette loaded successfully. Press [Enter].",
    "CRT monitor warmed up. Hit [Enter] to play.",
    "Sprites rendered. Press [Enter] for action.",
    "Scrolling background layer active. Hit [Enter].",
    "VBLANK synchronized. Press [Enter] now.",
    "ROM checksum verified. Hit [Enter] to boot.",
    "Overscan border clear. Press [Enter]!",
    "Palette swaps loaded. Hit [Enter] to start.",
    "Controller port 1 connected. Press [Enter].",
    "Sound channel 3 active. Hit [Enter] to jam.",
    "DIP switch configured. Press [Enter] to enter world.",
    "High score table ready. Hit [Enter] to make history.",
    "Continue countdown: 9... 8... Hit [Enter]!",
    "Bonus stage unlocked in your heart. Press [Enter].",
    "Extra life acquired! Hit [Enter] to use it.",
    "Power-up capsule descending. Press [Enter]!",

    // 141 - 160: Short, Punchy, & Epic
    "BEGIN.",
    "ENTER THE VOID.",
    "AWAKEN HERO.",
    "START IT UP.",
    "LET'S ROLL.",
    "BREAK THE LIMIT.",
    "CHARGE FORWARD.",
    "FEEL THE RHYTHM.",
    "UNLEASH POWER.",
    "SEIZE THE DAY.",
    "CLAIM VICTORY.",
    "RISE & SHINE.",
    "IGNITE THE SPARK.",
    "BREAK THE SEAL.",
    "CROSS THE LINE.",
    "TAKE THE PLUNGE.",
    "STEP INTO LIGHT.",
    "CONQUER ALL.",
    "STRIKE FAST.",
    "GAME ON.",

    // 161 - 180: Cozy & Chill Atmosphere
    "Brewing tea... while you press [Enter].",
    "Soft rain outside. Warm room inside. Press [Enter].",
    "Take your time, relax, and hit [Enter] when ready.",
    "A peaceful melody plays. Press [Enter] to join.",
    "Snuggle up with a cat and hit [Enter].",
    "Midnight coding session vibe. Press [Enter].",
    "No rush here. Hit [Enter] whenever you feel like it.",
    "Smooth jazz and retro pixels. Press [Enter].",
    "Breathe in, breathe out, then press [Enter].",
    "A cozy adventure awaits behind the [Enter] key.",
    "Starlight twinkling outside. Hit [Enter] to begin.",
    "Put on your favorite headphones and press [Enter].",
    "Peaceful vibes only. Hit [Enter] to enter zone.",
    "Warm fireplace crackling. Press [Enter] to start game.",
    "Slow down and enjoy the title screen. Or hit [Enter].",
    "Wrapped in a blanket of code. Press [Enter].",
    "Gentle breezes and chiptune tunes. Hit [Enter].",
    "A comforting cup of coffee is waiting. Press [Enter].",
    "Silence in the room, click of [Enter] on the board.",
    "Find your inner peace, then hit [Enter].",

    // 181 - 200: Mystery & Curiosity
    "What secrets lie beyond this screen? Press [Enter] to find out.",
    "A door stands before you. Hit [Enter] to open it.",
    "Whispers echo in the digital wind... Press [Enter].",
    "You feel a strange presence. Hit [Enter] to investigate.",
    "An unknown world is loading... Press [Enter] to enter.",
    "Shadows shift on the horizon. Press [Enter].",
    "The air grows heavy with anticipation. Hit [Enter].",
    "A glowing portal flickers. Press [Enter] to step through.",
    "Listen closely... Can you hear it? Press [Enter].",
    "A cryptic message flashes: Hit [Enter] to decode.",
    "The veil between worlds thins. Press [Enter].",
    "Uncharted territory ahead. Hit [Enter] to map it.",
    "An ancient relic hums with energy. Press [Enter].",
    "The path splits here. Hit [Enter] to choose.",
    "Something is watching from the code. Press [Enter].",
    "A hidden chapter unlocks with [Enter].",
    " Step across the threshold. Hit [Enter].",
    "The mystery deepens. Press [Enter] to uncover truth.",
    "A spark ignites in the dark. Hit [Enter].",
    "The ultimate journey begins with [Enter]."
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

// Stats verification
if (!variable_global_exists("stats")) {
    global.stats = {
        total_deaths: 0,
        total_jumps: 0,
        time_played_sec: 0
    };
}