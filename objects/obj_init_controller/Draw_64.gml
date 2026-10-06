// ============================================================================
// DRAW GUI EVENT
// Object: obj_init_controller
// ============================================================================

var _gui_w = display_get_gui_width();  
var _gui_h = display_get_gui_height(); 

draw_clear(c_black);

if (font_exists(fnt_bitmap)) {
    draw_set_font(fnt_bitmap);
} else {
    draw_set_font(-1);
}

var _cx = _gui_w / 2;
var _cy = _gui_h / 2;

var _shadow_offset = 1;
var _blue_shadow   = make_color_rgb(0, 50, 120);
var _glass_navy    = make_color_rgb(8, 16, 28);
var _border_cyan   = make_color_rgb(0, 180, 255);

if (has_crash_log) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    
    draw_set_color(_blue_shadow);
    draw_text(_cx + _shadow_offset, 8 + _shadow_offset, "CRASH REPORT DETECTED");
    draw_set_color(make_color_rgb(255, 90, 90));
    draw_text(_cx, 8, "CRASH REPORT DETECTED");

    var _pad_x = 12;
    var _pad_y_top = 22;
    var _pad_y_bot = 22;
    var _frame_w = _gui_w - (_pad_x * 2);
    var _frame_h = _gui_h - _pad_y_top - _pad_y_bot;
    
    draw_set_color(_glass_navy);
    draw_rectangle(_pad_x, _pad_y_top, _pad_x + _frame_w, _pad_y_top + _frame_h, false);
    
    draw_set_color(c_white);
    draw_set_alpha(0.05);
    draw_rectangle(_pad_x, _pad_y_top, _pad_x + _frame_w, _pad_y_top + (_frame_h / 2), false);
    draw_set_alpha(1.0);
    
    draw_set_color(_border_cyan);
    draw_rectangle(_pad_x, _pad_y_top, _pad_x + _frame_w, _pad_y_top + _frame_h, true);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(make_color_rgb(240, 240, 240));
    
    var _text_x = _pad_x + 6;
    var _text_y = _pad_y_top + 5 - crash_log_scroll;
    var _text_w = _frame_w - 12;
    
    draw_text_ext(_text_x, _text_y, crash_log_text, 9, _text_w);

    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_yellow);
    draw_text(_cx, _gui_h - 4, "ENTER/SPACE: CONTINUE  |  C: COPY LOG");
} 
else if (language_selection_required) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);

    draw_set_color(_blue_shadow);
    draw_text(_cx + _shadow_offset, 28 + _shadow_offset, get_localized_text("language_select"));
    draw_set_color(c_white);
    draw_text(_cx, 28, get_localized_text("language_select"));

    var _choice_w = 132;
    var _choice_h = 38;
    var _choice_gap = 12;
    var _choice_y = 92;
    var _choice_0_x = _cx - _choice_w - (_choice_gap / 2);
    var _choice_1_x = _cx + (_choice_gap / 2);

    for (var _language_i = 0; _language_i < 2; _language_i++) {
        var _choice_x = (_language_i == 0) ? _choice_0_x : _choice_1_x;
        var _selected = (_language_i == language_selection_index);
        draw_set_color(_selected ? make_color_rgb(0, 50, 120) : _glass_navy);
        draw_rectangle(_choice_x, _choice_y, _choice_x + _choice_w, _choice_y + _choice_h, false);
        draw_set_color(_selected ? _border_cyan : make_color_rgb(60, 60, 60));
        draw_rectangle(_choice_x, _choice_y, _choice_x + _choice_w, _choice_y + _choice_h, true);
        draw_set_color(_selected ? c_yellow : c_white);
        draw_text(_choice_x + (_choice_w / 2), _choice_y + 12, get_localized_text((_language_i == 0) ? "english" : "japanese"));
    }

    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    draw_text(_cx, _gui_h - 12, get_localized_text("language_instruction"));
}
else if (!drm_passed) {
    var _shake_x = 0;
    if (drm_shake_timer > 0) {
        _shake_x = choose(-2, 2, -1, 1);
    }
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    
    draw_set_color(_blue_shadow);
    draw_text(_cx + _shadow_offset + _shake_x, 6 + _shadow_offset, get_localized_text("challenge_title"));
    draw_set_color(make_color_rgb(0, 235, 255));
    draw_text(_cx + _shake_x, 6, get_localized_text("challenge_title"));

    var _box_w = _gui_w - 32;
    var _box_h = 178;
    var _box_x1 = _cx - (_box_w / 2) + _shake_x;
    var _box_y1 = 22;
    var _box_x2 = _box_x1 + _box_w;
    var _box_y2 = _box_y1 + _box_h;

    draw_set_color(_glass_navy);
    draw_rectangle(_box_x1, _box_y1, _box_x2, _box_y2, false);
    
    draw_set_color(c_white);
    draw_set_alpha(0.04);
    draw_rectangle(_box_x1, _box_y1, _box_x2, _box_y1 + (_box_h / 2), false);
    draw_set_alpha(1.0);

    draw_set_color(_border_cyan);
    draw_rectangle(_box_x1, _box_y1, _box_x2, _box_y2, true);

    var _badge_y = _box_y1 + 6;
    var _b1_x = _cx - 80 + _shake_x;
    var _b2_x = _cx + 10 + _shake_x;
    var _badge_w = 70;
    var _badge_h = 13;

    draw_set_color((drm_difficulty == 0) ? make_color_rgb(0, 120, 200) : c_black);
    draw_rectangle(_b1_x, _badge_y, _b1_x + _badge_w, _badge_y + _badge_h, false);
    draw_set_color((drm_difficulty == 0) ? c_yellow : make_color_rgb(60, 60, 60));
    draw_rectangle(_b1_x, _badge_y, _b1_x + _badge_w, _badge_y + _badge_h, true);
    draw_set_color((drm_difficulty == 0) ? c_yellow : c_gray);
    draw_text(_b1_x + (_badge_w / 2), _badge_y + 1, get_localized_text("difficulty_kids"));

    draw_set_color((drm_difficulty == 1) ? make_color_rgb(0, 120, 200) : c_black);
    draw_rectangle(_b2_x, _badge_y, _b2_x + _badge_w, _badge_y + _badge_h, false);
    draw_set_color((drm_difficulty == 1) ? c_yellow : make_color_rgb(60, 60, 60));
    draw_rectangle(_b2_x, _badge_y, _b2_x + _badge_w, _badge_y + _badge_h, true);
    draw_set_color((drm_difficulty == 1) ? c_yellow : c_gray);
    draw_text(_b2_x + (_badge_w / 2), _badge_y + 1, get_localized_text("difficulty_adults"));

    draw_set_color(make_color_rgb(255, 180, 0));
    draw_text(_cx + _shake_x, _box_y1 + 22, drm_topic_title);

    draw_set_color(c_yellow);
    draw_text(_cx + _shake_x, _box_y1 + 35, get_localized_text("challenge_solve"));
    
    draw_set_color(make_color_rgb(0, 40, 80));
    draw_rectangle(_box_x1 + 20, _box_y1 + 48, _box_x2 - 20, _box_y1 + 72, false);
    draw_set_color(_border_cyan);
    draw_rectangle(_box_x1 + 20, _box_y1 + 48, _box_x2 - 20, _box_y1 + 72, true);

    draw_set_color(c_white);
    draw_text(_cx + _shake_x, _box_y1 + 55, drm_equation_str);

    var _ans_box_w = 100;
    var _ans_box_h = 18;
    var _ans_x1 = _cx - (_ans_box_w / 2) + _shake_x;
    var _ans_y1 = _box_y1 + 80;

    draw_set_color(c_black);
    draw_rectangle(_ans_x1, _ans_y1, _ans_x1 + _ans_box_w, _ans_y1 + _ans_box_h, false);
    draw_set_color(c_lime);
    draw_rectangle(_ans_x1, _ans_y1, _ans_x1 + _ans_box_w, _ans_y1 + _ans_box_h, true);

    var _display_text = drm_user_input;
    if ((current_time div 250) % 2 == 0) {
        _display_text += "_";
    }

    draw_set_color(c_lime);
    draw_set_valign(fa_middle);
    draw_text(_cx + _shake_x, _ans_y1 + (_ans_box_h / 2), _display_text);

    draw_set_valign(fa_top);
    draw_set_color((drm_shake_timer > 0) ? make_color_rgb(255, 80, 80) : c_aqua);
    draw_text(_cx + _shake_x, _box_y1 + 108, drm_status_msg);

    draw_set_valign(fa_bottom);
    draw_set_color(c_yellow);
    draw_text(_cx, _gui_h - 4, get_localized_text("challenge_controls"));
} 
else {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    draw_set_color(_blue_shadow);
    draw_text(_cx + _shadow_offset, _cy - 12 + _shadow_offset, loading_text);
    draw_set_color(c_white);
    draw_text(_cx, _cy - 12, loading_text);

    var _bar_w  = 140;
    var _bar_h  = 10;
    var _bar_x1 = _cx - (_bar_w / 2);
    var _bar_y1 = _cy + 6;
    var _bar_x2 = _bar_x1 + _bar_w;
    var _bar_y2 = _bar_y1 + _bar_h;
    
    var _pct = clamp(load_progress_smooth, 0, 1);
    var _fill_x2 = _bar_x1 + (_bar_w * _pct);

    draw_set_color(_glass_navy);
    draw_rectangle(_bar_x1, _bar_y1, _bar_x2, _bar_y2, false);

    if (_pct > 0) {
        var _c_top = make_color_rgb(0, 235, 255);
        var _c_bot = make_color_rgb(0, 100, 220);
        draw_rectangle_color(_bar_x1, _bar_y1, _fill_x2, _bar_y2, _c_top, _c_top, _c_bot, _c_bot, false);

        draw_set_color(c_white);
        draw_set_alpha(0.45);
        draw_rectangle(_bar_x1, _bar_y1, _fill_x2, _bar_y1 + (_bar_h / 2) - 1, false);

        var _strip_x = _bar_x1 + ((gloss_offset) % (_bar_w + 24)) - 12;
        if (_strip_x > _bar_x1 && _strip_x < _fill_x2) {
            draw_set_alpha(0.35);
            var _strip_w = min(10, _fill_x2 - _strip_x);
            draw_rectangle(_strip_x, _bar_y1, _strip_x + _strip_w, _bar_y2, false);
        }
        draw_set_alpha(1.0);
    }

    draw_set_color(_border_cyan);
    draw_rectangle(_bar_x1 - 1, _bar_y1 - 1, _bar_x2 + 1, _bar_y2 + 1, true);
    
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text(_cx, _bar_y2 + 4, string(floor(_pct * 100)) + "%");
}

if (toast_timer > 0) {
    var _toast_alpha = min(1.0, toast_timer / 15);
    var _toast_w     = 96;
    var _toast_h     = 16;
    var _toast_x1    = _cx - (_toast_w / 2);
    var _toast_y1    = _gui_h - 32;
    var _toast_x2    = _toast_x1 + _toast_w;
    var _toast_y2    = _toast_y1 + _toast_h;

    draw_set_color(_glass_navy);
    draw_set_alpha(0.9 * _toast_alpha);
    draw_rectangle(_toast_x1, _toast_y1, _toast_x2, _toast_y2, false);

    draw_set_color(c_white);
    draw_set_alpha(0.3 * _toast_alpha);
    draw_rectangle(_toast_x1, _toast_y1, _toast_x2, _toast_y1 + (_toast_h / 2) - 1, false);

    draw_set_color(_border_cyan);
    draw_set_alpha(_toast_alpha);
    draw_rectangle(_toast_x1 - 1, _toast_y1 - 1, _toast_x2 + 1, _toast_y2 + 1, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_cx, _toast_y1 + (_toast_h / 2), toast_text);
    
    draw_set_alpha(1.0);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

if (fade_alpha > 0) {
    draw_set_color(c_black);
    draw_set_alpha(fade_alpha);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1.0);
}