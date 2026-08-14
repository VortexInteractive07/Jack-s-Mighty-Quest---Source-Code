/// @description Initialize Main Menu Controller (426x240 Classic Layout)

// Lock GUI canvas to exact 16:9 pixel-art display resolution
display_set_gui_size(426, 240);

// --- MENU OPTIONS ---
menu_options = [
    "PLAY GAME",
    "LOAD GAME",
    "TIME ATTACK",
    "CHEATS",
    "OPTIONS",
    "JUKEBOX"
];

menu_index = 0;
menu_total = array_length(menu_options);

// --- TARGET ROOM SETUP ---
// Routes to rm_intro first (with safety fallback to current room if not found)
var _intro_room = (asset_get_index("rm_intro") != -1) ? asset_get_index("rm_intro") : room;
target_room = _intro_room;

// --- LAYOUT & SPACING CONFIGURATION ---
start_y = 52;
line_spacing = 22;

// Cursor subtle motion
cursor_offset_x = 0;
cursor_dir = 1;

// --- STATE MACHINE & FADE OVERLAY ---
fade_alpha = 1;
fade_speed = 0.04;
fade_state = 0;

// --- BACKGROUND MUSIC ---
if (!audio_is_playing(mus_menu)) {
    audio_play_sound(mus_menu, 1, true);
}