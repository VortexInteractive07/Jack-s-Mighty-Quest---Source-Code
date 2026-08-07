/// @description Initialize Canvas, Fade Engine & Menu Matrix

// ============================================================================
// 0. SINGLETON GUARD (NON-PERSISTENT)
// ============================================================================
if (instance_number(object_index) > 1) {
    instance_destroy();
    exit;
}

persistent = false; // Prevents object from leaking into gameplay rooms

// ============================================================================
// 1. FADE TRANSITION ENGINE
// ============================================================================
fade_alpha       = 1.0;  // Start fully opaque for room fade-in
fade_state       = -1;   // -1 = Fading In, 0 = Active Menu, 1 = Fading Out
fade_speed       = 0.05; // Fade transition rate per frame
fade_target_room = -1;
fade_action      = undefined;

trigger_transition = function(_target_room, _action = undefined) {
    fade_target_room = _target_room;
    fade_action      = _action;
    fade_state       = 1; // Begin fade-out sequence
};

// ============================================================================
// 2. DYNAMIC WIDESCREEN RESOLUTION HOOKS
// ============================================================================
canvas_w = 432;
canvas_h = 240;

view_enabled = true;
view_visible[0] = true;

surface_resize(application_surface, canvas_w, canvas_h);
display_set_gui_size(canvas_w, canvas_h);

if (view_camera[0] != -1) {
    camera_set_view_size(view_camera[0], canvas_w, canvas_h);
}

// ============================================================================
// 3. CUSTOMIZABLE PROCEDURAL BACKGROUND ENGINE
// ============================================================================
bg_mode          = 2;  // 0 = Gradient Grid, 1 = Parallax Starfield, 2 = Diagonal Stripes

col_top          = make_color_rgb(16, 20, 48);    
col_bottom       = make_color_rgb(48, 16, 64);    
col_pattern      = make_color_rgb(80, 120, 200);  
col_pattern_alt  = make_color_rgb(120, 248, 248); 

scroll_speed_x   = -0.5;
scroll_speed_y   = 0.25;
scroll_x         = 0;
scroll_y         = 0;

grid_size        = 16;
grid_thickness   = 1;
pattern_alpha    = 0.35;

star_count       = 40;
stars            = array_create(star_count);

for (var i = 0; i < star_count; i++) {
    stars[i] = {
        x: random(canvas_w),
        y: random(canvas_h),
        speed: random_range(0.2, 1.2),
        size: choose(1, 1, 2),
        color: choose(c_white, col_pattern_alt, make_color_rgb(248, 224, 56)),
        twinkle: random(pi * 2)
    };
}

depth = 1000;

// ============================================================================
// 4. TUTORIAL & WELCOME DATA ENGINE (tutorial.json)
// ============================================================================
tutorial_filename = "tutorial.json";
is_first_time     = true;
is_welcome_modal  = false;

save_tutorial_status = function() {
    var _file = file_text_open_write(tutorial_filename);
    if (_file != -1) {
        var _data = {
            completed: true,
            first_launch_timestamp: date_datetime_string(date_current_datetime())
        };
        file_text_write_string(_file, json_stringify(_data));
        file_text_close(_file);
    }
};

if (file_exists(tutorial_filename)) {
    var _file = file_text_open_read(tutorial_filename);
    var _json_string = "";
    while (!file_text_eof(_file)) {
        _json_string += file_text_readln(_file);
    }
    file_text_close(_file);

    try {
        var _t_data = json_parse(_json_string);
        if (is_struct(_t_data) && struct_exists(_t_data, "completed")) {
            is_first_time = !_t_data.completed;
        }
    } catch (_ex) {
        is_first_time = true;
    }
}

// ============================================================================
// 5. FILE CONFIGURATION & SETTINGS ENGINE (settings.json)
// ============================================================================
save_filename = "settings.json";

global.settings = {
    sfx_volume: 1.0,
    mus_volume: 1.0,
    fullscreen: false,
    text_speed: 1.0
};

save_settings = function() {
    var _file = file_text_open_write(save_filename);
    if (_file != -1) {
        file_text_write_string(_file, json_stringify(global.settings));
        file_text_close(_file);
    }
};

if (file_exists(save_filename)) {
    var _file = file_text_open_read(save_filename);
    var _json_string = "";
    while (!file_text_eof(_file)) {
        _json_string += file_text_readln(_file);
    }
    file_text_close(_file);

    try {
        var _loaded = json_parse(_json_string);
        if (is_struct(_loaded)) {
            if (struct_exists(_loaded, "sfx_volume")) global.settings.sfx_volume = _loaded.sfx_volume;
            if (struct_exists(_loaded, "mus_volume")) global.settings.mus_volume = _loaded.mus_volume;
            if (struct_exists(_loaded, "fullscreen")) global.settings.fullscreen = _loaded.fullscreen;
            if (struct_exists(_loaded, "text_speed")) global.settings.text_speed = _loaded.text_speed;
        }
    } catch (_ex) {
        save_settings();
    }
    window_set_fullscreen(global.settings.fullscreen);
} else {
    save_settings();
}

if (!variable_global_exists("stats")) {
    global.stats = {
        total_deaths: 0,
        total_jumps: 0,
        time_played_sec: 0
    };
}

// ============================================================================
// 6. STRUCT-DRIVEN MENU MATRIX SETUP & ARCADE BLINK ENGINE
// ============================================================================
menu_matrix = [
    { label: "PLAY GAME",                 type: "room",   target: asset_get_index("rm_thestorysofar") },
    { label: "LOAD GAME",                 type: "modal",  text: "LOAD GAME FUNCTION\nCOMING SOON IN VERSION 1.1!" },
    { label: "TIME ATTACK",               type: "modal",  text: "TIME ATTACK MODE\nCOMING SOON IN VERSION 1.1!" },
    { label: "CHEATS",                    type: "modal",  text: "CHEAT CONSOLE INTERFACE\nCOMING SOON IN VERSION 1.1!" },
    { label: "OPTIONS",                   type: "room",   target: asset_get_index("rm_options") },
    { label: "JUKEBOX",                   type: "room",   target: asset_get_index("rm_jukebox") },
    { label: "STATISTICS",                type: "room",   target: asset_get_index("rm_stats") },
    { label: "CREDITS",                   type: "room",   target: asset_get_index("rm_credits") },
    { label: "ABOUT",                     type: "modal",  text: "This here is an internal release candidate test!\nAuthorisation and Distribution without permit is\nstrictly prohibited!\n\n-- Vortex Interactive --" },
    { label: "VOICE ACTING TEST",         type: "modal",  text: "VOICE ACTING TEST\nCOMING SOON IN VERSION 1.1!" },
    { label: "MODE 7 TEST",               type: "room",   target: asset_get_index("rm_mode7") },
    { label: "PARALLAX SCROLLING TEST",   type: "room",   target: asset_get_index("rm_parallax") },
    { label: "MODS",                      type: "modal",  text: "MODS SUPPORT\nCOMING SOON IN VERSION 1.1!" },
    { label: "TEXTURE PACKS",             type: "modal",  text: "TEXTURE PACK SUPPORT\nCOMING SOON IN VERSION 1.1!" },
    { label: "CONCLUDE GAMEPLAY",         type: "action", action: function() { game_end(); } },
    { label: "RETURN TO SPLASH SCREEN",   type: "room",   target: asset_get_index("rm_splash") },
    { label: "RETURN TO TITLE SCREEN",    type: "room",   target: asset_get_index("rm_title") }
];

current_menu_selection = 0;
menu_total = array_length(menu_matrix);

max_visible_items = 6;
scroll_offset = 0;

is_info_open = false;
info_text = "";

if (is_first_time) {
    is_info_open = true;
    is_welcome_modal = true;
    info_text = "WELCOME NEW OPERATOR!\n\nSystem initialization complete.\nUse UP/DOWN arrows or D-PAD to navigate.\nPress ENTER / A-BUTTON to confirm selections.\n\nEnjoy the experience!";
}

// Arcade Blinking & Selection Flash Parameters
blink_timer       = 0;      // Active confirmation countdown timer
blink_speed_hover = 120;   // Selection hover pulse speed (ms)
blink_speed_press = 40;    // Rapid confirmation strobe speed (ms)

col_blue_shadow = make_color_rgb(16, 32, 96);
col_gold        = make_color_rgb(248, 224, 56);
col_cyan        = make_color_rgb(120, 248, 248);

// ============================================================================
// 7. AUDIO INITIALIZATION PIPELINE
// ============================================================================
audio_stop_all();
var _mus_menu = asset_get_index("mus_menu");
if (_mus_menu != -1 && audio_exists(_mus_menu)) {
    if (!audio_is_playing(_mus_menu)) {
        audio_play_sound(_mus_menu, 100, true);
    }
}