/// @description Render Parallax Cyber Grid & Integer-Locked Widescreen Crawl

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _screen_cx = _gui_w / 2;
var _shadow_offset = 1;

// Set Story Font
var story_font = fnt_english;

// ============================================================================
// 1. RENDER BACKGROUND MATRIX LAYERS
// ============================================================================
draw_clear(make_color_rgb(8, 8, 18));

// Ambient gradient glow simulation
draw_set_alpha(0.12);
draw_rectangle_color(0, 0, _gui_w, _gui_h, c_maroon, c_maroon, c_black, c_black, false);
draw_set_alpha(1.0);

// Retro Sci-Fi Grid Line Mesh
draw_set_color(make_color_rgb(24, 28, 48));
var _grid_size = 32;
var _start_x = floor(bg_offset_x % _grid_size);
var _start_y = floor(bg_offset_y % _grid_size);

for (var xx = _start_x; xx < _gui_w; xx += _grid_size) {
    draw_line(xx, 0, xx, _gui_h);
}
for (var yy = _start_y; yy < _gui_h; yy += _grid_size) {
    draw_line(0, yy, _gui_w, yy);
}

// ============================================================================
// 2. CONFIGURE TEXT TYPOGRAPHY ENGINE
// ============================================================================
draw_set_halign(fa_center);
draw_set_valign(fa_top);

// FIXED: Added missing closing parenthesis here
if (font_exists(story_font)) {
    draw_set_font(story_font);
}

// ============================================================================
// 3. RENDER CRAWL (Width bounded cleanly to 420px)
// ============================================================================
var _final_draw_y = floor(scroll_y);

// Drop Shadow Text Matrix Block
draw_set_color(c_black);
draw_text_ext(_screen_cx + _shadow_offset, _final_draw_y + _shadow_offset, story_text, 14, 420);

// Main Story Text Matrix Block
draw_set_color(c_white);
draw_text_ext(_screen_cx, _final_draw_y, story_text, 14, 420);

// Reset systemic color modifications
draw_set_color(c_white);