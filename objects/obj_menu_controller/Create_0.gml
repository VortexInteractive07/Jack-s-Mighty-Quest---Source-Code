/// @description Initialize Widescreen Canvas & Menu Matrix Systems

// ============================================================================
// 1. DYNAMIC WIDESCREEN RESOLUTION HOOKS (Supports 426x240 / 432x240 Aspect Ratio)
// ============================================================================
var _widescreen_w = 432; 
var _widescreen_h = 240;

// Force view system to be active so rendering never collapses into pitch black
view_enabled = true;
view_visible[0] = true;

surface_resize(application_surface, _widescreen_w, _widescreen_h);
display_set_gui_size(_widescreen_w, _widescreen_h);

if (view_camera[0] != -1) {
    camera_set_view_size(view_camera[0], _widescreen_w, _widescreen_h);
}

// --- Method Definitions ---
scr_save_settings_json = function() {
    var _file_target = "settings.json";
    var _json_string = json_stringify(global.settings);
    var _file = file_text_open_write(_file_target);
    file_text_write_string(_file, _json_string);
    file_text_close(_file);
};

// --- Initialize Menu Core Matrix ---
options_list = [
    "PLAY GAME", 
    "LOAD GAME", 
    "TIME ATTACK", 
    "CHEATS", 
    "OPTIONS",
    "JUKEBOX", 
    "STATISTICS", 
    "CREDITS", 
    "ABOUT",
    "VOICE ACTING TEST",
    "MODE 7 TEST",
    "PARALLAX SCROLLING TEST",
    "MODS",
    "TEXTURE PACKS",
	"CONCLUDE GAMEPLAY",
	"RETURN TO SPLSH SCREEN",
    "RETURN TO TITLE SCREEN",
];

current_menu_selection = 0;
menu_total = array_length(options_list);

// --- Scrolling Viewport Architecture Setup ---
max_visible_items = 6;  
scroll_offset = 0;      

// --- Typography Scaling Configuration ---
text_scale = 1.0; 

// --- Dynamic Modal Notification System ---
is_info_open = false; 
info_text = "";

// --- File Configuration System (JSON Initialization) ---
save_filename = "settings.json";

global.settings = {
    sfx_volume: 1.0,
    mus_volume: 1.0,
    fullscreen: false,
    text_speed: 1.0
};

if (file_exists(save_filename)) {
    var _file = file_text_open_read(save_filename);
    var _json_string = "";
    while (!file_text_eof(_file)) {
        _json_string += file_text_readln(_file);
    }
    file_text_close(_file);
    
    try {
        var _loaded_data = json_parse(_json_string);
        if (is_struct(_loaded_data)) {
            if (variable_struct_exists(_loaded_data, "sfx_volume")) global.settings.sfx_volume = _loaded_data.sfx_volume;
            if (variable_struct_exists(_loaded_data, "mus_volume")) global.settings.mus_volume = _loaded_data.mus_volume;
            if (variable_struct_exists(_loaded_data, "fullscreen")) global.settings.fullscreen = _loaded_data.fullscreen;
            if (variable_struct_exists(_loaded_data, "text_speed")) global.settings.text_speed = _loaded_data.text_speed;
        }
    } catch (_exception) {
        scr_save_settings_json();
    }
    window_set_fullscreen(global.settings.fullscreen);
} else {
    scr_save_settings_json();
}

// --- Audio Controller Core Pipeline ---
var menu_music = mus_menu;

audio_stop_all();
if (audio_exists(menu_music)) {
    if (!audio_is_playing(menu_music)) {
        audio_play_sound(menu_music, 100, true);
    }
}

// Stats verification
if (!variable_global_exists("stats")) {
    global.stats = {
        total_deaths: 0,
        total_jumps: 0,
        time_played_sec: 0
    };
}