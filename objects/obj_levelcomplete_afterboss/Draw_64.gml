/// @description SNES Mode 7 Boss Victory HUD

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _center_x = _gui_w / 2;
var _center_y = _gui_h / 2 - 10;

// Force Font Assignment (SNES Dialogue Font)
draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// -----------------------------------------------------------------
// MODE 7 HELPER VARIABLES & CALCULATIONS
// -----------------------------------------------------------------
// Perspective perspective pitch factor (3D perspective scaling along Y-axis)
var _tilt_angle    = sin(pulse_timer * 1.5) * 4; // Subdued Mode 7 wave float
var _base_scale    = banner_scale;

// SNES Color Palette Definitions
var _col_gold      = make_color_rgb(248, 224, 56);
var _col_gold_dark = make_color_rgb(168, 120, 0);
var _col_cyan      = make_color_rgb(120, 248, 248);
var _col_lime      = make_color_rgb(120, 248, 120);
var _col_shadow    = make_color_rgb(16, 16, 24);

// -----------------------------------------------------------------
// 1. MAIN BANNER: "BOSS DEFEATED!" (Mode 7 Perspective Scale)
// -----------------------------------------------------------------
var _title_str = "BOSS DEFEATED!";
var _y_banner  = _center_y - 30;

// Mode 7 Pseudo-3D Layering (3-Pass Extrusion Depth)
for (var i = 4; i >= 1; i--) {
    var _ext_scale = _base_scale * (1 + (i * 0.02));
    draw_set_color(_col_shadow);
    draw_set_alpha(0.8);
    draw_text_transformed(_center_x + i + 1, _y_banner + i + 1, _title_str, _ext_scale, _ext_scale, _tilt_angle);
}

// Inner Dark Gold Shadow Base
draw_set_color(_col_gold_dark);
draw_set_alpha(1.0);
draw_text_transformed(_center_x + 1, _y_banner + 1, _title_str, _base_scale, _base_scale, _tilt_angle);

// Front Face
draw_set_color(_col_gold);
draw_text_transformed(_center_x, _y_banner, _title_str, _base_scale, _base_scale, _tilt_angle);


// -----------------------------------------------------------------
// 2. SUB-BANNER & STATS (Mode 7 Floor Perspective Fade-In)
// -----------------------------------------------------------------
if (state >= 1) {
    draw_set_alpha(text_alpha);
    
    // Perspective compression factors for lower UI elements
    var _sub_scale_top = 1.0;
    var _sub_scale_mid = 0.95; // Slightly scaled down for perspective depth
    var _sub_scale_bot = 0.90;
    
    // --- STAGE CLEAR ---
    var _y_clear = _center_y + 12;
    
    // Hard SNES Shadow (2px offset, no blur)
    draw_set_color(_col_shadow);
    draw_text_transformed(_center_x + 2, _y_clear + 2, "STAGE CLEAR", _sub_scale_top, _sub_scale_top, 0);
    draw_set_color(c_white);
    draw_text_transformed(_center_x, _y_clear, "STAGE CLEAR", _sub_scale_top, _sub_scale_top, 0);
    
    // --- TIME BREAKDOWN ---
    var _y_time   = _center_y + 32;
    var _min_str  = string(clear_time_sec div 60);
    var _sec_val  = clear_time_sec % 60;
    var _sec_str  = (_sec_val < 10 ? "0" : "") + string(_sec_val);
    var _time_str = "CLEAR TIME " + _min_str + ":" + _sec_str;
    
    draw_set_color(_col_shadow);
    draw_text_transformed(_center_x + 2, _y_time + 2, _time_str, _sub_scale_mid, _sub_scale_mid, 0);
    draw_set_color(_col_cyan);
    draw_text_transformed(_center_x, _y_time, _time_str, _sub_scale_mid, _sub_scale_mid, 0);
    
    // --- PRESS ENTER PROMPT ---
    var _y_prompt   = _center_y + 56;
    var _flash_step = floor(sin(pulse_timer * 6) * 2); // Discrete SNES-style blink step
    var _prompt_vis = (_flash_step >= 0);
    
    if (_prompt_vis) {
        draw_set_color(_col_shadow);
        draw_text_transformed(_center_x + 2, _y_prompt + 2, "PRESS ENTER TO CONTINUE", _sub_scale_bot, _sub_scale_bot, 0);
        draw_set_color(_col_lime);
        draw_text_transformed(_center_x, _y_prompt, "PRESS ENTER TO CONTINUE", _sub_scale_bot, _sub_scale_bot, 0);
    }
}

// -----------------------------------------------------------------
// RESET DRAW STATE DEFAULTS
// -----------------------------------------------------------------
draw_set_alpha(1.0);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);