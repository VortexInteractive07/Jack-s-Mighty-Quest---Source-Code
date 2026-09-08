/// @description Draw GUI Event - obj_init_controller

var _gui_w = display_get_gui_width();  // Target resolution 432
var _gui_h = display_get_gui_height(); // Target resolution 240

// Clear Base Canvas
draw_clear(c_black);

draw_set_font(fnt_bitmap);

var _cx = _gui_w / 2;
var _cy = _gui_h / 2;

var _shadow_offset = 1;
var _blue_shadow   = make_color_rgb(0, 50, 120);
var _glass_navy    = make_color_rgb(8, 16, 28);
var _border_cyan   = make_color_rgb(0, 180, 255);

if (show_passcode_prompt) {
    // ------------------------------------------------------------------------
    // KEY-CODE ENTER PROMPT OVERLAY
    // ------------------------------------------------------------------------
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Background Dark Plate
    draw_set_color(_glass_navy);
    draw_rectangle(24, 24, _gui_w - 24, _gui_h - 24, false);
    
    draw_set_color(_border_cyan);
    draw_rectangle(24, 24, _gui_w - 24, _gui_h - 24, true);

    // Header Prompt
    draw_set_color(_blue_shadow);
    draw_text(_cx + _shadow_offset, _cy - 40 + _shadow_offset, "ENTER SECURITY PASSCODE");
    draw_set_color(c_white);
    draw_text(_cx, _cy - 40, "ENTER SECURITY PASSCODE");

    // Input Field Box
    var _box_w = 120;
    var _box_h = 18;
    var _bx1 = _cx - (_box_w / 2);
    var _by1 = _cy - 8;
    var _bx2 = _bx1 + _box_w;
    var _by2 = _by1 + _box_h;

    draw_set_color(c_black);
    draw_rectangle(_bx1, _by1, _bx2, _by2, false);
    draw_set_color(_border_cyan);
    draw_rectangle(_bx1, _by1, _bx2, _by2, true);

    // Render Typed Text with Blinking Cursor Effect
    var _cursor = ((current_time / 350) % 2 == 0) ? "_" : "";
    draw_set_color(c_yellow);
    draw_text(_cx, _cy + 1, user_input_code + _cursor);

    // Instructions
    draw_set_color(c_gray);
    draw_set_valign(fa_top);
    draw_text(_cx, _by2 + 10, "PRESS ENTER TO CONFIRM");
} else if (is_pirated) {
    // ------------------------------------------------------------------------
    // ANTI-PIRACY SCREEN VIEWPORT
    // ------------------------------------------------------------------------
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    draw_set_color(make_color_rgb(180, 0, 0));
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    
    draw_set_color(c_black);
    draw_rectangle(8, 8, _gui_w - 8, _gui_h - 8, false);
    
    draw_set_color(c_red);
    draw_text(_cx + _shadow_offset, _cy - 30 + _shadow_offset, "PIRACY DETECTED");
    draw_set_color(c_white);
    draw_text(_cx, _cy - 30, "PIRACY DETECTED");
    
    draw_set_color(c_yellow);
    draw_text_ext(_cx, _cy + 5, piracy_reason, 11, _gui_w - 32);
    
    draw_set_color(c_gray);
    draw_text(_cx, _gui_h - 16, "PRESS ESC TO EXIT");
} else if (has_crash_log) {
    // ------------------------------------------------------------------------
    // CRASH SCREEN VIEWPORT
    // ------------------------------------------------------------------------
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    
    // Header
    draw_set_color(_blue_shadow);
    draw_text(_cx + _shadow_offset, 8 + _shadow_offset, "CRASH REPORT DETECTED");
    draw_set_color(make_color_rgb(255, 90, 90));
    draw_text(_cx, 8, "CRASH REPORT DETECTED");

    // Terminal Frame
    var _pad_x = 12;
    var _pad_y_top = 22;
    var _pad_y_bot = 22;
    var _frame_w = _gui_w - (_pad_x * 2);
    var _frame_h = _gui_h - _pad_y_top - _pad_y_bot;
    
    // Backplate
    draw_set_color(_glass_navy);
    draw_rectangle(_pad_x, _pad_y_top, _pad_x + _frame_w, _pad_y_top + _frame_h, false);
    
    // Glass Panel
    draw_set_color(c_white);
    draw_set_alpha(0.05);
    draw_rectangle(_pad_x, _pad_y_top, _pad_x + _frame_w, _pad_y_top + (_frame_h / 2), false);
    draw_set_alpha(1.0);
    
    // Border
    draw_set_color(_border_cyan);
    draw_rectangle(_pad_x, _pad_y_top, _pad_x + _frame_w, _pad_y_top + _frame_h, true);

    // Text Log Output
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(make_color_rgb(240, 240, 240));
    
    var _text_x = _pad_x + 6;
    var _text_y = _pad_y_top + 5 - crash_log_scroll;
    var _text_w = _frame_w - 12;
    
    draw_text_ext(_text_x, _text_y, crash_log_text, 9, _text_w);

    // Footer Prompts
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_yellow);
    draw_text(_cx, _gui_h - 4, "ENTER/SPACE: CONTINUE  |  C: COPY LOG");
} else {
    // ------------------------------------------------------------------------
    // FRUTIGER AERO LOADING BAR VIEWPORT
    // ------------------------------------------------------------------------
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Status Label
    draw_set_color(_blue_shadow);
    draw_text(_cx + _shadow_offset, _cy - 12 + _shadow_offset, loading_text);
    draw_set_color(c_white);
    draw_text(_cx, _cy - 12, loading_text);

    // Dimensions
    var _bar_w  = 140;
    var _bar_h  = 10;
    var _bar_x1 = _cx - (_bar_w / 2);
    var _bar_y1 = _cy + 6;
    var _bar_x2 = _bar_x1 + _bar_w;
    var _bar_y2 = _bar_y1 + _bar_h;
    
    var _pct = clamp(load_progress_smooth, 0, 1);
    var _fill_x2 = _bar_x1 + (_bar_w * _pct);

    // Dark Glass Base
    draw_set_color(_glass_navy);
    draw_rectangle(_bar_x1, _bar_y1, _bar_x2, _bar_y2, false);

    // Dynamic Aqua Fill
    if (_pct > 0) {
        var _c_top = make_color_rgb(0, 235, 255);
        var _c_bot = make_color_rgb(0, 100, 220);
        draw_rectangle_color(_bar_x1, _bar_y1, _fill_x2, _bar_y2, _c_top, _c_top, _c_bot, _c_bot, false);

        // Top Glass Gel Reflection
        draw_set_color(c_white);
        draw_set_alpha(0.45);
        draw_rectangle(_bar_x1, _bar_y1, _fill_x2, _bar_y1 + (_bar_h / 2) - 1, false);

        // Animated Gloss Shimmer Specular Accent
        var _strip_x = _bar_x1 + ((gloss_offset) % (_bar_w + 24)) - 12;
        if (_strip_x > _bar_x1 && _strip_x < _fill_x2) {
            draw_set_alpha(0.35);
            var _strip_w = min(10, _fill_x2 - _strip_x);
            draw_rectangle(_strip_x, _bar_y1, _strip_x + _strip_w, _bar_y2, false);
        }
        draw_set_alpha(1.0);
    }

    // Outer Cyan Glass Rim
    draw_set_color(_border_cyan);
    draw_rectangle(_bar_x1 - 1, _bar_y1 - 1, _bar_x2 + 1, _bar_y2 + 1, true);
    
    // Percentage Indicator
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text(_cx, _bar_y2 + 4, string(floor(_pct * 100)) + "%");
}

// ----------------------------------------------------------------------------
// TOAST NOTIFICATION OVERLAY
// ----------------------------------------------------------------------------
if (toast_timer > 0) {
    var _toast_alpha = min(1.0, toast_timer / 15);
    var _toast_w     = 96;
    var _toast_h     = 16;
    var _toast_x1    = _cx - (_toast_w / 2);
    var _toast_y1    = _gui_h - 32;
    var _toast_x2    = _toast_x1 + _toast_w;
    var _toast_y2    = _toast_y1 + _toast_h;

    // Glass Backplate
    draw_set_color(_glass_navy);
    draw_set_alpha(0.9 * _toast_alpha);
    draw_rectangle(_toast_x1, _toast_y1, _toast_x2, _toast_y2, false);

    // Top Gel Highlight
    draw_set_color(c_white);
    draw_set_alpha(0.3 * _toast_alpha);
    draw_rectangle(_toast_x1, _toast_y1, _toast_x2, _toast_y1 + (_toast_h / 2) - 1, false);

    // Cyan Border
    draw_set_color(_border_cyan);
    draw_set_alpha(_toast_alpha);
    draw_rectangle(_toast_x1 - 1, _toast_y1 - 1, _toast_x2 + 1, _toast_y2 + 1, true);

    // Label
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(_cx, _toast_y1 + (_toast_h / 2), toast_text);
    
    draw_set_alpha(1.0);
}

// Reset Alignments & Colors
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

// ----------------------------------------------------------------------------
// FULLSCREEN TRANSITION OVERLAY
// ----------------------------------------------------------------------------
if (fade_alpha > 0) {
    draw_set_color(c_black);
    draw_set_alpha(fade_alpha);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1.0);
}