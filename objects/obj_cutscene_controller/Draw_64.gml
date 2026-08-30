/// @description Redesigned Cutscene HUD, Textbox, & Fade Overlay

// Save current GPU settings to restore later
var _prev_font = draw_get_font();
var _prev_color = draw_get_color();
var _prev_alpha = draw_get_alpha();
var _prev_halign = draw_get_halign();
var _prev_valign = draw_get_valign();

// Determine screen dimensions dynamically based on GUI surface
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// -----------------------------------------------------------------------------
// 1. DYNAMIC ATMOSPHERIC BACKGROUND OVERLAY
// -----------------------------------------------------------------------------
var _bg_color = make_color_rgb(bg_r, bg_g, bg_b);
draw_set_alpha(0.45);
draw_rectangle_color(0, 0, _gui_w, _gui_h, _bg_color, _bg_color, c_black, c_black, false);
draw_set_alpha(1.0);

// Fetch current slide data safely
var _slide = cutscenes[min(scene_index, max(0, scene_total - 1))];
var _speaker_name = string_upper(_slide.speaker);

// -----------------------------------------------------------------------------
// 2. MAIN DIALOGUE BOX GEOMETRY & FRAMING
// -----------------------------------------------------------------------------
var _margin_x = 16;
var _box_w = _gui_w - (_margin_x * 2);
var _box_h = 72;
var _box_x1 = _margin_x;
var _box_y1 = _gui_h - _box_h - 12;
var _box_x2 = _box_x1 + _box_w;
var _box_y2 = _box_y1 + _box_h;

// Drop Shadow Frame
draw_set_alpha(0.5);
draw_rectangle_color(_box_x1 + 3, _box_y1 + 3, _box_x2 + 3, _box_y2 + 3, c_black, c_black, c_black, c_black, false);
draw_set_alpha(1.0);

// Textbox Dark Panel Base
draw_rectangle_color(_box_x1, _box_y1, _box_x2, _box_y2, c_dkgray, c_black, c_black, c_dkgray, false);

// Outer Bright Border
draw_rectangle_color(_box_x1, _box_y1, _box_x2, _box_y2, c_white, c_white, c_white, c_white, true);

// Inner Accent Line
draw_rectangle_color(_box_x1 + 2, _box_y1 + 2, _box_x2 - 2, _box_y2 - 2, c_gray, c_gray, c_gray, c_gray, true);

// -----------------------------------------------------------------------------
// 3. SPEAKER NAME TAG BADGE
// -----------------------------------------------------------------------------
if (_speaker_name != "") {
    if (font_exists(fnt_bitmap)) {
        draw_set_font(fnt_bitmap);
    }
    
    var _tag_w = string_width(_speaker_name) + 12;
    var _tag_h = 14;
    var _tag_x1 = _box_x1 + 8;
    var _tag_y1 = _box_y1 - 10;
    var _tag_x2 = _tag_x1 + _tag_w;
    var _tag_y2 = _tag_y1 + _tag_h;

    // Speaker Badge Background
    draw_rectangle_color(_tag_x1 + 1, _tag_y1 + 1, _tag_x2 + 1, _tag_y2 + 1, c_black, c_black, c_black, c_black, false);
    draw_rectangle_color(_tag_x1, _tag_y1, _tag_x2, _tag_y2, c_navy, c_navy, c_dkgray, c_dkgray, false);
    draw_rectangle_color(_tag_x1, _tag_y1, _tag_x2, _tag_y2, c_yellow, c_yellow, c_yellow, c_yellow, true);

    // Speaker Text
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Shadow
    draw_set_color(c_black);
    draw_text(_tag_x1 + (_tag_w / 2) + 1, _tag_y1 + (_tag_h / 2) + 1, _speaker_name);
    // Primary Yellow Name
    draw_set_color(c_yellow);
    draw_text(_tag_x1 + (_tag_w / 2), _tag_y1 + (_tag_h / 2), _speaker_name);
}

// -----------------------------------------------------------------------------
// 4. DIALOGUE BODY TEXT RENDERING
// -----------------------------------------------------------------------------
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _text_padding_x = 12;
var _text_padding_y = 12;
var _text_x = _box_x1 + _text_padding_x;
var _text_y = _box_y1 + _text_padding_y;
var _max_line_w = _box_w - (_text_padding_x * 2);

// Drop Shadow for Dialogue Text
draw_set_color(c_black);
draw_text_ext(_text_x + 1, _text_y + 1, current_text, 12, _max_line_w);

// Main Dialogue White Text
draw_set_color(c_white);
draw_text_ext(_text_x, _text_y, current_text, 12, _max_line_w);

// -----------------------------------------------------------------------------
// 5. BLINKING "CONTINUE" PROMPT (WHEN TEXT FINISHES)
// -----------------------------------------------------------------------------
if (text_finished) {
    var _blink = (floor(current_time / 300) % 2 == 0);
    if (_blink) {
        var _prompt_x = _box_x2 - 12;
        var _prompt_y = _box_y2 - 12;
        
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        
        draw_set_color(c_black);
        draw_text(_prompt_x + 1, _prompt_y + 1, ">>");
        draw_set_color(c_yellow);
        draw_text(_prompt_x, _prompt_y, ">>");
    }
}

// -----------------------------------------------------------------------------
// 6. SCREEN FADE OVERLAY
// -----------------------------------------------------------------------------
if (fade_alpha > 0) {
    draw_set_alpha(fade_alpha);
    draw_rectangle_color(0, 0, _gui_w, _gui_h, c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0);
}

// Restore GPU State
draw_set_font(_prev_font);
draw_set_color(_prev_color);
draw_set_alpha(_prev_alpha);
draw_set_halign(_prev_halign);
draw_set_valign(_prev_valign);