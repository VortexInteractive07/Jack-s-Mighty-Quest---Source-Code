/// @description Draw GUI Event - Arcade-Style Boss Victory HUD

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _center_x = _gui_w / 2;
var _center_y = _gui_h / 2 - 20;

// Force font assignment safely
var _font = asset_get_index("fnt_dialogue");
if (_font != -1 && font_exists(_font)) {
    draw_set_font(_font);
}

// Set text alignment
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Ensure scale variables exist
if (!variable_instance_exists(id, "banner_scale")) banner_scale = 1.0;
if (!variable_instance_exists(id, "pulse_timer")) pulse_timer = 0;
if (!variable_instance_exists(id, "text_alpha")) text_alpha = 1.0;

// -----------------------------------------------------------------
// 1. MAIN BANNER: "BOSS DEFEATED!"
// -----------------------------------------------------------------
var _title_str = "BOSS DEFEATED!";

// Shadow
draw_set_color(c_black);
draw_set_alpha(1.0);
draw_text_transformed(_center_x + 2, _center_y - 18, _title_str, banner_scale, banner_scale, 0);

// Main Yellow Text
draw_set_color(c_yellow);
draw_text_transformed(_center_x, _center_y - 20, _title_str, banner_scale, banner_scale, 0);

// -----------------------------------------------------------------
// 2. SUB-BANNER: "STAGE CLEAR" + TIME BREAKDOWN
// -----------------------------------------------------------------
if (state >= 1) {
    draw_set_alpha(text_alpha);
    
    // Stage Clear Shadow & Text
    draw_set_color(c_black);
    draw_text(_center_x + 1, _center_y + 11, "STAGE CLEAR");
    draw_set_color(c_white);
    draw_text(_center_x, _center_y + 10, "STAGE CLEAR");
    
    // Time Stats Display (Safety fallback if clear_time_sec isn't set)
    var _time_val = variable_instance_exists(id, "clear_time_sec") ? clear_time_sec : 0;
    var _min_str = string(floor(_time_val / 60));
    var _sec_val = floor(_time_val % 60);
    var _sec_str = (_sec_val < 10 ? "0" : "") + string(_sec_val);
    var _time_str = "CLEAR TIME: " + _min_str + ":" + _sec_str;
    
    draw_set_color(c_black);
    draw_text(_center_x + 1, _center_y + 31, _time_str);
    draw_set_color(c_aqua);
    draw_text(_center_x, _center_y + 30, _time_str);
    
    // Flashing Press Enter Prompt
    var _flash_alpha = (sin(pulse_timer * 4) + 1) * 0.5;
    draw_set_alpha(_flash_alpha * text_alpha);
    draw_set_color(c_lime);
    draw_text(_center_x, _center_y + 55, "PRESS ENTER TO CONTINUE");
}

// Reset draw state defaults to prevent UI pollution elsewhere
draw_set_alpha(1.0);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);