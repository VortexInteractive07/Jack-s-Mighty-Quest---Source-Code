/// @description Initialize Widescreen, 3D Vector Space & Linear Sequential Playlist Engine

// ============================================================================
// 1. DYNAMIC WIDESCREEN RESOLUTION SETTINGS (432x240 for 16:9 pixel precision)
// ============================================================================
var _widescreen_w = 432;
var _widescreen_h = 240;

surface_resize(application_surface, _widescreen_w, _widescreen_h);
display_set_gui_size(_widescreen_w, _widescreen_h);

if (view_enabled) {
    view_visible[0] = true;
    camera_set_view_size(view_camera[0], _widescreen_w, _widescreen_h);
}

// ============================================================================
// 2. SCROLL MECHANICS & DATA SETUP
// ============================================================================
scroll_y = _widescreen_h; 
scroll_speed = 0.486; 
credits_manifest = scr_credits();

// Interactive completion control variables
credits_completed = false; 
credits_skippable = true;   
prompt_alpha = 0;
prompt_timer = 0;

// ============================================================================
// 3. FULL SEQUENTIAL CREDITS PLAYLIST ENGINE
// ============================================================================
audio_stop_all();

// Call external script to set up global.title_playlist for credits
scr_credits_music_arrangement();
var _theme_pool = global.title_playlist;

credits_playlist = [];

// Filter valid sound assets to guarantee crash-proof execution
for (var i = 0; i < array_length(_theme_pool); i++) {
    if (audio_exists(_theme_pool[i])) {
        array_push(credits_playlist, _theme_pool[i]);
    }
}

playlist_index = 0;
credits_music_inst = -1;

if (array_length(credits_playlist) > 0) {
    // Start explicitly at index 0 with loop set to FALSE!
    credits_music_inst = audio_play_sound(credits_playlist[0], 1, false);
}

// Text Engine Calculations
draw_set_font(fnt_bit_true);
font_native_height = string_height("M");
line_spacing = font_native_height + 4; 
long_space   = font_native_height * 2.5; 
max_text_width = round(_widescreen_w * 0.75); 

// Pre-calculate baseline dimensions
total_credits_height = 0;
for (var i = 0; i < array_length(credits_manifest); i++) {
    var _text = credits_manifest[i];
    if (_text == "") {
        total_credits_height += long_space;
    } else if (string_char_at(_text, 1) == "=" || string_char_at(_text, 1) == "-") {
        total_credits_height += 12; // Height assigned for raw lines
    } else {
        total_credits_height += string_height_ext(_text, line_spacing, max_text_width) + 8;
    }
}

if (!variable_global_exists("stats")) {
    global.stats = { total_deaths: 0, total_jumps: 0, time_played_sec: 0 };
}

// ============================================================================
// 4. RETRO SPACE STARFIELD INITIALIZATION
// ============================================================================
star_count = 250; 
stars = array_create(star_count);
var _colors = [c_white, c_yellow, c_aqua, c_fuchsia, c_orange];

for (var i = 0; i < star_count; i++) {
    stars[i] = {
        x: random_range(-500, 500), 
        y: random_range(-500, 500), 
        z: random_range(1, 600),    
        speed: random_range(1.0, 3.0), 
        color: _colors[irandom(array_length(_colors) - 1)],
        twinkle_phase: random(100)     
    };
}

focal_length = 200; 

// Shooting Star Data Objects
shooting_star_max = 2;
shooting_stars = array_create(shooting_star_max);
for (var i = 0; i < shooting_star_max; i++) {
    shooting_stars[i] = { active: false, x1: 0, y1: 0, x2: 0, y2: 0, timer: 0, timer_max: 0, trail_length: random_range(40, 80), angle: 45 };
}

// ============================================================================
// 5. 3D VECTOR CUBE CONFIGURATION
// ============================================================================
cube_rot_x = 0;
cube_rot_y = 0;
cube_rot_z = 0;
cube_text_spin = 0; 

cube_size = 65; 
cube_z_pos = 320; 

cube_vertices = [
    {x: -cube_size, y: -cube_size, z: -cube_size},
    {x:  cube_size, y: -cube_size, z: -cube_size},
    {x:  cube_size, y:  cube_size, z: -cube_size},
    {x: -cube_size, y:  cube_size, z: -cube_size},
    {x: -cube_size, y: -cube_size, z:  cube_size},
    {x:  cube_size, y: -cube_size, z:  cube_size},
    {x:  cube_size, y:  cube_size, z:  cube_size},
    {x: -cube_size, y:  cube_size, z:  cube_size}
];

cube_edges = [
    [0, 1], [1, 2], [2, 3], [3, 0], 
    [4, 5], [5, 6], [6, 7], [7, 4], 
    [0, 4], [1, 5], [2, 6], [3, 7]  
];

// ============================================================================
// 6. TRANSITION SYSTEMS
// ============================================================================
fade_alpha = 0;        
is_fading  = false;    
fade_speed = 0.02;