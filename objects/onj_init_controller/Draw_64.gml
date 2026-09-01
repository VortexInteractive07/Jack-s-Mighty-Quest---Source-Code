var _gui_w = display_get_gui_width();  // 432
var _gui_h = display_get_gui_height(); // 240

// Clear Base Canvas
draw_clear(c_black);

draw_set_font(fnt_bitmap);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _cx = _gui_w / 2;
var _cy = _gui_h / 2;

var _shadow_offset = 1;
var _blue_shadow = make_color_rgb(0, 102, 204);

if (has_crash_log) {
    // 1. Crash Screen Header (Scaled for 240p)
    draw_set_color(_blue_shadow);
    draw_text(_cx + _shadow_offset, 12 + _shadow_offset, "RECENT CRASH LOG DETECTED");
    
    draw_set_color(c_white);
    draw_text(_cx, 12, "RECENT CRASH LOG DETECTED");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    // 2. Error Window Frame
    var _pad_x = 10;
    var _pad_y_top = 24;
    var _pad_y_bot = 20;
    
    draw_set_color(_blue_shadow);
    draw_rectangle(_pad_x, _pad_y_top, _gui_w - _pad_x, _gui_h - _pad_y_bot, true);
    
    // 3. Log Output Box (Width: 400px wrapped)
    draw_set_color(c_red);
    draw_text_ext(_pad_x + 6, _pad_y_top + 5, crash_log_text, 9, _gui_w - (_pad_x * 2) - 12);

    // 4. Footer Prompt
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_yellow);
    draw_text(_cx, _gui_h - 4, "ENTER/SPACE: CONTINUE  |  C: COPY LOG");
} else {
    // 1. Loading Text
    draw_set_color(_blue_shadow);
    draw_text(_cx + _shadow_offset, _cy - 10 + _shadow_offset, loading_text);

    draw_set_color(c_white);
    draw_text(_cx, _cy - 10, loading_text);

    // 2. Proportional 432x240 Frutiger Aero Loading Bar
    var _bar_w = 120;
    var _bar_h = 8;
    var _bar_x1 = _cx - (_bar_w / 2);
    var _bar_y1 = _cy + 8;
    var _bar_x2 = _bar_x1 + _bar_w;
    var _bar_y2 = _bar_y1 + _bar_h;
    var _progress = load_timer / load_max;
    var _fill_x2 = _bar_x1 + (_bar_w * _progress);

    // Dark Glass Background Channel
    draw_set_color(make_color_rgb(10, 20, 35));
    draw_rectangle(_bar_x1, _bar_y1, _bar_x2, _bar_y2, false);

    // Aqua Base Fill Gradient
    if (_progress > 0) {
        var _c_top = make_color_rgb(0, 220, 255);
        var _c_bot = make_color_rgb(0, 110, 210);
        draw_rectangle_color(_bar_x1, _bar_y1, _fill_x2, _bar_y2, _c_top, _c_top, _c_bot, _c_bot, false);

        // Aero Top Gloss Highlight Layer
        draw_set_color(c_white);
        draw_set_alpha(0.45);
        draw_rectangle(_bar_x1, _bar_y1, _fill_x2, _bar_y1 + (_bar_h / 2) - 1, false);

        // Moving Shimmer Stripe Accent
        var _strip_x = _bar_x1 + ((gloss_offset) % (_bar_w + 20)) - 10;
        if (_strip_x > _bar_x1 && _strip_x < _fill_x2) {
            draw_set_alpha(0.35);
            var _strip_w = min(8, _fill_x2 - _strip_x);
            draw_rectangle(_strip_x, _bar_y1, _strip_x + _strip_w, _bar_y2, false);
        }
        draw_set_alpha(1.0);
    }

    // Glossy Aero Border Outline
    draw_set_color(make_color_rgb(0, 180, 255));
    draw_rectangle(_bar_x1 - 1, _bar_y1 - 1, _bar_x2 + 1, _bar_y2 + 1, true);
}

// 3. Draw Frutiger Aero Toast Notification ("Copied Text!")
if (toast_timer > 0) {
    var _toast_alpha = min(1.0, toast_timer / 15);
    var _toast_w = 90;
    var _toast_h = 16;
    var _toast_x1 = _cx - (_toast_w / 2);
    var _toast_y1 = _gui_h - 40;
    var _toast_x2 = _toast_x1 + _toast_w;
    var _toast_y2 = _toast_y1 + _toast_h;

    // Toast Dark Blue Glass Backplate
    draw_set_color(make_color_rgb(12, 35, 60));
    draw_set_alpha(0.9 * _toast_alpha);
    draw_rectangle(_toast_x1, _toast_y1, _toast_x2, _toast_y2, false);

    // Toast Top Gloss Line
    draw_set_color(c_white);
    draw_set_alpha(0.4 * _toast_alpha);
    draw_rectangle(_toast_x1, _toast_y1, _toast_x2, _toast_y1 + (_toast_h / 2) - 1, false);

    // Toast Cyan Outline
    draw_set_color(make_color_rgb(0, 200, 255));
    draw_set_alpha(_toast_alpha);
    draw_rectangle(_toast_x1 - 1, _toast_y1 - 1, _toast_x2 + 1, _toast_y2 + 1, true);

    // Toast Text
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(_cx, _toast_y1 + (_toast_h / 2), toast_text);
    
    draw_set_alpha(1.0);
}

// Reset Alignments
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// 4. Fullscreen Black Overlay for Transition Fades
if (fade_alpha > 0) {
    draw_set_color(c_black);
    draw_set_alpha(fade_alpha);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1.0);
}