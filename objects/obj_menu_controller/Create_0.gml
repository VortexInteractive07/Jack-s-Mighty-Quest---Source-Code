/// @description Initialize Main Menu Controller (426x240 Sub-Menu Architecture)

// Lock GUI canvas to exact 16:9 pixel-art display resolution
display_set_gui_size(426, 240);

// --- NAVIGATION SUB-MODES ---
// 0 = MAIN MENU, 1 = OPTIONS, 2 = JUKEBOX
current_mode = 0; 

// --- MAIN MENU DATA ---
menu_options = [
    "Play Game",
    "Load Recent Game",
    "Time Attack",
    "Cheats",
    "Settings",
    "Sound Test",
    "Exit to Title Screen",
	"Exit Game"
];
menu_index = 0;
menu_total = array_length(menu_options);

// --- OPTIONS SUB-MENU DATA ---
opt_options = [
    "BGM VOLUME",
    "SFX VOLUME",
    "FULLSCREEN",
    "BACK TO MENU"
];
opt_index = 0;
opt_total = array_length(opt_options);

// Global Settings State
if (!variable_global_exists("vol_bgm"))     global.vol_bgm = 80;   // Scale: 0 to 100
if (!variable_global_exists("vol_sfx"))     global.vol_sfx = 80;   // Scale: 0 to 100
if (!variable_global_exists("fullscreen"))  global.fullscreen = false;

// --- JUKEBOX SUB-MENU DATA ---
juke_tracks = [
    { title: "MENU THEME",  asset: mus_menu },
	{ title: "MAGE MAALADIVAINA",  asset: mus_mage_maaladivaina },
	{ title: "SUBWAY STATION",     asset: mus_subway },
    { title: "CITYSCAPE",     asset: mus_city },
    { title: "BOSS BATTLE", asset: mus_boss },
    { title: "BACK TO MENU", asset: -1 }
];
juke_index = 0;
juke_total = array_length(juke_tracks);
current_playing_track = -1;

// --- TARGET ROOM SETUP ---
var _intro_room = (asset_get_index("rm_intro") != -1) ? asset_get_index("rm_intro") : room;
target_room = _intro_room;

// --- LAYOUT & SPACING CONFIGURATION ---
start_y = 52;
line_spacing = 18;

// Cursor motion animation
cursor_offset_x = 0;
cursor_dir = 1;

// --- STATE MACHINE & FADE OVERLAY ---
fade_alpha = 1;
fade_speed = 0.04;
fade_state = 0;

// --- INITIAL AUDIO SETUP ---
if (!audio_is_playing(mus_menu)) {
    audio_play_sound(mus_menu, 1, true);
}