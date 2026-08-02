/// @description Render Cyber Terminal GUI & CRT Overlay
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _center_x = _gui_w / 2;
var _center_y = _gui_h / 2;

// Safe Color Macros (GML Hex Format: $BBGGRR)
var _color_cyan    = $FFFF00; 
var _color_red     = $0000FF;
var _color_fuchsia = $FF00FF;
var _color_yellow  = $00FFFF;
var _color_lime    = $00FF00;
var _color_gray    = $808080;
var _color_dkgray  = $404040;
var _color_white   = $FFFFFF;
var _color_black   = $000000;

draw_set_alpha(terminal_alpha);

// --- 1. HUD Sci-Fi Frame Box ---
var _box_x1 = 24;
var _box_y1 = 16;
var _box_x2 = _gui_w - 24;
var _box_y2 = _gui_h - 16;

// Glass panel backplate
draw_set_color(_color_black);
draw_set_alpha(0.65 * terminal_alpha);
draw_rectangle(_box_x1, _box_y1, _box_x2, _box_y2, false);

// Sci-Fi Corner Brackets
draw_set_color(_color_cyan);
draw_set_alpha(0.8 * terminal_alpha);
var _corner = 12;

// Top Left / Top Right
draw_line_width(_box_x1, _box_y1, _box_x1 + _corner, _box_y1, 2);
draw_line_width(_box_x1, _box_y1, _box_x1, _box_y1 + _corner, 2);
draw_line_width(_box_x2, _box_y1, _box_x2 - _corner, _box_y1, 2);
draw_line_width(_box_x2, _box_y1, _box_x2, _box_y1 + _corner, 2);

// Bottom Left / Bottom Right
draw_line_width(_box_x1, _box_y2, _box_x1 + _corner, _box_y2, 2);
draw_line_width(_box_x1, _box_y2, _box_x1, _box_y2 - _corner, 2);
draw_line_width(_box_x2, _box_y2, _box_x2 - _corner, _box_y2, 2);
draw_line_width(_box_x2, _box_y2, _box_x2, _box_y2 - _corner, 2);


// --- 2. HEADER: SYSTEM HALTED (With RGB Glitch Shift) ---
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
if (font_exists(fnt_bit)) draw_set_font(fnt_bit);

var _hdr_y = _box_y1 + 22;
var _glitch_offset = (glitch_timer % 30 < 3) ? irandom_range(-2, 2) : 0;

// Chromatic Aberration Red/Blue Shift
draw_set_color(_color_red);
draw_text(_center_x - 1 + _glitch_offset, _hdr_y, "CRITICAL SYSTEM FAILURE");
draw_set_color(_color_cyan);
draw_text(_center_x + 1 + _glitch_offset, _hdr_y, "CRITICAL SYSTEM FAILURE");
draw_set_color(_color_white);
draw_text(_center_x, _hdr_y, "CRITICAL SYSTEM FAILURE");

// System Warning Subheader
draw_set_font(-1);
draw_set_color(_color_fuchsia);
draw_text(_center_x, _hdr_y + 14, "// NEURAL LINK DISCONNECTED //");


// --- 3. DYNAMIC DEATH DIAGNOSTIC LOG ---
var _reason_y = _hdr_y + 30;
var _reason_str = "[ CAUSE: CRITICAL DAMAGE ]";

if (instance_exists(obj_controller) && variable_instance_exists(obj_controller, "death_reason")) {
    if (obj_controller.death_reason != "") {
        _reason_str = "[ CAUSE: " + string_upper(obj_controller.death_reason) + " ]";
    }
}

draw_set_color(_color_yellow);
draw_text(_center_x, _reason_y, _reason_str);


// --- 4. RETRO ARCADE COUNTDOWN CLOCK ---
if (!continue_expired && gameover_selection == 0) {
    var _cnt_y = _center_y - 2;
    var _pulse = 1.0 + (sin(current_time * 0.01) * 0.15);
    
    draw_set_font((font_exists(fnt_bit)) ? fnt_bit : -1);
    
    // Emergency ring
    draw_set_color(_color_red);
    draw_set_alpha(0.3 * terminal_alpha);
    draw_circle(_center_x, _cnt_y, 22 * _pulse, false);
    
    draw_set_alpha(1.0 * terminal_alpha);
    draw_set_color(_color_black);
    draw_text_transformed(_center_x + 1, _cnt_y + 1, string(continue_timer), _pulse * 1.3, _pulse * 1.3, 0);
    draw_set_color(_color_lime);
    draw_text_transformed(_center_x, _cnt_y, string(continue_timer), _pulse * 1.3, _pulse * 1.3, 0);
}


// --- 5. SCI-FI SELECTION OPTIONS STACK ---
if (font_exists(fnt_bit)) draw_set_font(fnt_bit);
var _start_options_y = _center_y + 36;
var _spacing = 18;

for (var i = 0; i < gameover_total; i++) {
    var _draw_y = _start_options_y + (i * _spacing);
    var _option_string = gameover_options[i];
    var _color = _color_gray;
    
    if (i == 0 && continue_expired) {
        _color = _color_dkgray;
    }
    
    if (i == gameover_selection) {
        _color = _color_cyan;
        _option_string = ">> " + _option_string + " <<";
        
        // Active selection box
        draw_set_color(_color_cyan);
        draw_set_alpha(0.15 * terminal_alpha);
        draw_rectangle(_center_x - 110, _draw_y - 7, _center_x + 110, _draw_y + 7, false);
        draw_set_alpha(1.0 * terminal_alpha);
    }
    
    draw_set_color(_color_black);
    draw_text(_center_x + 1, _draw_y + 1, _option_string);
    draw_set_color(_color);
    draw_text(_center_x, _draw_y, _option_string);
}


// --- 6. CRT SCANLINE SIMULATOR OVERLAY ---
draw_set_color(_color_black);
draw_set_alpha(0.12 * terminal_alpha);
for (var sl = 0; sl < _gui_h; sl += 3) {
    draw_line(0, sl, _gui_w, sl);
}

// Flush states clean
draw_set_alpha(1.0);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(_color_white);