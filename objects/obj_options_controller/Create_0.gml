/// @description Initialize Widescreen Options & Safe JSON Storage Engine

view_w = 426;
view_h = 240;

// Options Menu Matrix
options_menu = [
    "MASTER VOLUME",
    "SFX VOLUME",
    "MUSIC VOLUME",
    "DISPLAY MODE",
    "ASPECT LOCK",
    "TEXT SPEED",
    "SCREEN SHAKE",
    "FLASH REDUCTION",
    "BACKGROUND AUDIO",
    "UI COLOR SCHEME",
    "RESET DEFAULT",
    "BACK TO MENU"
];

current_selection = 0;
total_options = array_length(options_menu);

pulse_timer = 0;
prev_mouse_x = window_mouse_get_x();
prev_mouse_y = window_mouse_get_y();

// Ambient Particles
bg_particles = array_create(16);
for (var i = 0; i < 16; i++) {
    bg_particles[i] = {
        x: random(view_w),
        y: random(view_h),
        spd: random_range(0.2, 0.6),
        size: random_range(1, 2)
    };
}

// Global Settings Struct Initializer
if (!variable_global_exists("settings")) {
    global.settings = {};
}

// --- Buffer-Based JSON Save Handler ---
scr_save_settings_json = function() {
    var _file_name = "settings.json";
    var _json_string = json_stringify(global.settings);
    
    var _buf = buffer_create(string_byte_length(_json_string) + 1, buffer_fixed, 1);
    buffer_write(_buf, buffer_string, _json_string);
    buffer_save(_buf, _file_name);
    buffer_delete(_buf);
};

// --- Buffer-Based JSON Load Handler ---
scr_load_settings_json = function() {
    var _file_name = "settings.json";
    
    if (file_exists(_file_name)) {
        var _buf = buffer_load(_file_name);
        if (_buf != -1) {
            var _json_string = buffer_read(_buf, buffer_string);
            buffer_delete(_buf);
            
            try {
                var _loaded_struct = json_parse(_json_string);
                if (is_struct(_loaded_struct)) {
                    var _keys = variable_struct_get_names(_loaded_struct);
                    for (var i = 0; i < array_length(_keys); i++) {
                        var _key_name = _keys[i];
                        variable_struct_set(global.settings, _key_name, variable_struct_get(_loaded_struct, _key_name));
                    }
                }
            } catch (_ex) {
                show_debug_message("Settings JSON parse error: " + string(_ex));
            }
        }
    }
};

// Load Saved Data
scr_load_settings_json();

// Complete Variable Backfill Guard (Prevents missing key crashes)
if (!variable_struct_exists(global.settings, "master_volume"))    global.settings.master_volume   = 1.0;
if (!variable_struct_exists(global.settings, "sfx_volume"))       global.settings.sfx_volume      = 0.8;
if (!variable_struct_exists(global.settings, "mus_volume"))       global.settings.mus_volume      = 0.8;
if (!variable_struct_exists(global.settings, "fullscreen"))       global.settings.fullscreen      = false;
if (!variable_struct_exists(global.settings, "aspect_lock"))     global.settings.aspect_lock     = true;
if (!variable_struct_exists(global.settings, "text_speed"))      global.settings.text_speed      = 1.0;
if (!variable_struct_exists(global.settings, "screen_shake"))    global.settings.screen_shake    = true;
if (!variable_struct_exists(global.settings, "flash_reduction")) global.settings.flash_reduction = false;
if (!variable_struct_exists(global.settings, "bg_audio"))         global.settings.bg_audio         = false;
if (!variable_struct_exists(global.settings, "theme_index"))      global.settings.theme_index      = 0;

// Apply initial gain
audio_master_gain(global.settings.master_volume);

// GMS LTS Safe Base Colors
color_aqua      = make_color_rgb(0, 255, 255);
color_lightgray = make_color_rgb(190, 190, 190);
color_yellow    = make_color_rgb(255, 220, 50);
color_darkbg    = make_color_rgb(12, 14, 28);
color_darkbg2   = make_color_rgb(20, 22, 40);
color_frame     = make_color_rgb(50, 70, 120);

// Play Options BGM (mus_mujuraa)
if (audio_exists(mus_mujuraa)) {
    if (!audio_is_playing(mus_mujuraa)) {
        audio_stop_all();
        audio_play_sound(mus_mujuraa, 1, true);
    }
}