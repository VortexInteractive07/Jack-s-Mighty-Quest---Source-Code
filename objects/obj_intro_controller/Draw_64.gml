/// @description Boxless Aesthetic Rendering (426x240 Display)

var _gui_w = 426;
var _gui_h = 240;

var _current_slide = cutscenes[min(scene_index, scene_total - 1)];

// ==========================================
// 1. BACKGROUND RENDER
// ==========================================
if (_current_slide.sprite != -1 && sprite_exists(_current_slide.sprite)) {
    draw_sprite_stretched(_current_slide.sprite, 0, 0, 0, _gui_w, _gui_h);
    
    // Bottom contrast gradient overlay for artwork
    draw_set_alpha(0.70);
    draw_set_color(c_black);
    draw_rectangle(0, _gui_h - 110, _gui_w, _gui_h, false);
} else {
    draw_clear(c_black);
}

draw_set_font(fnt_bitmap);

// ==========================================
// 2. TEXT RENDER (BOXLESS RETRO STYLE)
// ==========================================
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _start_x = 32;
var _start_y = (_current_slide.sprite != -1) ? (_gui_h - 85) : 60;
var _max_wrap_width = _gui_w - 64;

// Speaker Header
if (_current_slide.speaker != "") {
    var _header_color = c_aqua;
    
    // Villains / Threat highlights in reddish-orange
    if (_current_slide.speaker == "VICTOR SCHADENFREUDE" || _current_slide.speaker == "DR. VIC SHARP" || _current_slide.speaker == "MISGUIDED VENGEANCE") {
        _header_color = make_color_rgb(255, 90, 80);
    } 
    // Key choices / themes highlighted in gold
    else if (_current_slide.speaker == "FIGHT OR FREE?" || _current_slide.speaker == "THE QUEST BEGINS") {
        _header_color = make_color_rgb(255, 215, 0);
    }

    draw_text_color(_start_x, _start_y - 20, _current_slide.speaker, _header_color, _header_color, c_white, c_white, 1);
}

// Retro Line Separator
draw_set_color(c_dkgray);
draw_line(_start_x, _start_y - 6, _gui_w - _start_x, _start_y - 6);

// Extended Body Narrative
draw_text_ext_color(
    _start_x, 
    _start_y + 6, 
    current_text, 
    13, 
    _max_wrap_width, 
    c_white, c_white, c_white, c_white, 
    1
);

// Advance Prompt Indicator (Bottom-Right)
if (text_finished && fade_state == 1) {
    draw_set_halign(fa_right);
    draw_text_color(_gui_w - 32, _gui_h - 22, "PRESS ENTER >", c_yellow, c_yellow, c_yellow, c_yellow, 0.85);
}

// Skip Option Indicator (Top-Right)
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_text_color(_gui_w - 16, 12, "ESC: SKIP", c_gray, c_gray, c_silver, c_silver, 0.5);

// Reset Draw State
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// ==========================================
// 3. FADE OVERLAY
// ==========================================
if (fade_alpha > 0) {
    draw_set_alpha(fade_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);

    draw_set_color(c_white);
    draw_set_alpha(1);
}