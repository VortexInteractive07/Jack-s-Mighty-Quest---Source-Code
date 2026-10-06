/// @description Render Redesigned Cutscene HUD, Viewport, Sprites, Choices, & Backlog
/// Intelligence Level: 10/10

if (!is_array(cutscenes) || array_length(cutscenes) == 0) {
    exit;
}

var _prev_font   = draw_get_font();
var _prev_color  = draw_get_color();
var _prev_alpha  = draw_get_alpha();
var _prev_halign = draw_get_halign();
var _prev_valign = draw_get_valign();

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// --- 1. DYNAMIC ATMOSPHERIC BACKGROUND OVERLAY ---
var _bg_color = make_color_rgb(bg_r, bg_g, bg_b);
draw_set_alpha(0.75);
draw_rectangle_color(0, 0, _gui_w, _gui_h, _bg_color, _bg_color, c_black, c_black, false);
draw_set_alpha(1.0);

scene_total = array_length(cutscenes);
var _slide = cutscenes[min(scene_index, max(0, scene_total - 1))];
var _speaker_name = variable_struct_exists(_slide, "speaker") ? string_upper(_slide.speaker) : "";

// --- 2. SPRITE FADE & TRANSITION STATE MANAGER ---
var _target_sprite = variable_struct_exists(_slide, "sprite") ? _slide.sprite : -1;

if (_target_sprite != vis_sprite) {
    prev_sprite = vis_sprite;
    vis_sprite = _target_sprite;
    sprite_fade_alpha = 0.0;
}

if (sprite_fade_alpha < 1.0) {
    sprite_fade_alpha = min(1.0, sprite_fade_alpha + sprite_fade_speed);
}

// --- 3. MAIN DIALOGUE BOX GEOMETRY & FRAMING (EXPANDED HEIGHT) ---
var _margin_x = 16;
var _box_w = _gui_w - (_margin_x * 2);
var _box_h = 88;
var _box_y1 = _gui_h - _box_h - 6;
var _box_x1 = _margin_x;
var _box_x2 = _box_x1 + _box_w;
var _box_y2 = _box_y1 + _box_h;

// --- 4. 160x144 STORY SCENE VIEWPORT WINDOW (SHIFTED UP TO PREVENT OVERLAP) ---
var _scene_w = 160;
var _scene_h = 138;
var _scene_x = ((_gui_w - _scene_w) / 2) + shake_x;
var _scene_y = 6 + shake_y;

// Drop shadow & Bezel Background
draw_set_alpha(0.85);
draw_rectangle_color(_scene_x + 4, _scene_y + 4, _scene_x + _scene_w + 4, _scene_y + _scene_h + 4, c_black, c_black, c_black, c_black, false);
draw_set_alpha(1.0);
draw_rectangle_color(_scene_x - 2, _scene_y - 2, _scene_x + _scene_w + 2, _scene_y + _scene_h + 2, make_color_rgb(10, 12, 20), make_color_rgb(10, 12, 20), make_color_rgb(10, 12, 20), make_color_rgb(10, 12, 20), false);

var _get_sprite_subimg = function(_spr) {
    if (!sprite_exists(_spr)) return 0;
    var _count = sprite_get_number(_spr);
    if (_count <= 1) return 0;
    
    var _spd = sprite_get_speed(_spr);
    var _type = sprite_get_speed_type(_spr);
    var _fps = game_get_speed(gamespeed_fps);
    
    if (_type == spritespeed_framespersecond) {
        return (current_time / 1000 * _spd) % _count;
    } else {
        return (current_time / 1000 * _fps * _spd) % _count;
    }
};

if (prev_sprite != -1 && sprite_exists(prev_sprite) && sprite_fade_alpha < 1.0) {
    var _out_alpha = (1.0 - sprite_fade_alpha);
    var _subimg_prev = _get_sprite_subimg(prev_sprite);
    draw_sprite_ext(prev_sprite, _subimg_prev, _scene_x, _scene_y, 1, 1, 0, c_white, _out_alpha);
}

if (vis_sprite != -1 && sprite_exists(vis_sprite)) {
    var _in_alpha = sprite_fade_alpha;
    var _subimg_vis = _get_sprite_subimg(vis_sprite);
    draw_sprite_ext(vis_sprite, _subimg_vis, _scene_x, _scene_y, 1, 1, 0, c_white, _in_alpha);
}

// Crisp Double Border Frame for Viewport
draw_rectangle_color(_scene_x, _scene_y, _scene_x + _scene_w, _scene_y + _scene_h, c_white, c_white, c_white, c_white, true);
draw_rectangle_color(_scene_x - 1, _scene_y - 1, _scene_x + _scene_w + 1, _scene_y + _scene_h + 1, make_color_rgb(70, 80, 110), make_color_rgb(70, 80, 110), make_color_rgb(70, 80, 110), make_color_rgb(70, 80, 110), true);

// --- 5. MAIN DIALOGUE BOX PANEL RENDERING ---
draw_set_alpha(0.85);
draw_rectangle_color(_box_x1 + 4, _box_y1 + 4, _box_x2 + 4, _box_y2 + 4, c_black, c_black, c_black, c_black, false);
draw_set_alpha(1.0);

draw_rectangle_color(_box_x1, _box_y1, _box_x2, _box_y2, make_color_rgb(22, 28, 48), make_color_rgb(12, 16, 28), make_color_rgb(12, 16, 28), make_color_rgb(22, 28, 48), false);
draw_rectangle_color(_box_x1, _box_y1, _box_x2, _box_y2, make_color_rgb(210, 210, 230), make_color_rgb(210, 210, 230), make_color_rgb(210, 210, 230), make_color_rgb(210, 210, 230), true);
draw_rectangle_color(_box_x1 + 2, _box_y1 + 2, _box_x2 - 2, _box_y2 - 2, make_color_rgb(60, 75, 110), make_color_rgb(60, 75, 110), make_color_rgb(60, 75, 110), make_color_rgb(60, 75, 110), true);

// --- 6. SPEAKER NAME TAG BADGE ---
if (_speaker_name != "") {
    if (font_exists(fnt_bitmap)) {
        draw_set_font(fnt_bitmap);
    }
    
    var _tag_w = string_width(_speaker_name) + 18;
    var _tag_h = 16;
    var _tag_x1 = _box_x1 + 12;
    var _tag_y1 = _box_y1 - 12;
    var _tag_x2 = _tag_x1 + _tag_w;
    var _tag_y2 = _tag_y1 + _tag_h;

    draw_rectangle_color(_tag_x1 + 1, _tag_y1 + 1, _tag_x2 + 1, _tag_y2 + 1, c_black, c_black, c_black, c_black, false);
    draw_rectangle_color(_tag_x1, _tag_y1, _tag_x2, _tag_y2, make_color_rgb(24, 40, 80), make_color_rgb(24, 40, 80), make_color_rgb(12, 20, 45), make_color_rgb(12, 20, 45), false);
    draw_rectangle_color(_tag_x1, _tag_y1, _tag_x2, _tag_y2, c_yellow, c_yellow, c_yellow, c_yellow, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    draw_set_color(c_black);
    draw_text(_tag_x1 + (_tag_w / 2) + 1, _tag_y1 + (_tag_h / 2) + 1, _speaker_name);
    draw_set_color(c_yellow);
    draw_text(_tag_x1 + (_tag_w / 2), _tag_y1 + (_tag_h / 2), _speaker_name);
}

// --- 7. DIALOGUE BODY TEXT RENDERING (OPTIMIZED LINE SPACING) ---
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _text_padding_x = 14;
var _text_padding_y = 10;
var _text_x = _box_x1 + _text_padding_x;
var _text_y = _box_y1 + _text_padding_y;
var _max_line_w = _box_w - (_text_padding_x * 2);

draw_set_color(c_black);
draw_text_ext(_text_x + 1, _text_y + 1, current_text, 13, _max_line_w);

draw_set_color(c_white);
draw_text_ext(_text_x, _text_y, current_text, 13, _max_line_w);

// --- 8. BLINKING CONTINUE PROMPT & BACKLOG HINT ---
if (text_finished && !choice_active) {
    var _blink = (floor(current_time / 300) % 2 == 0);
    if (_blink) {
        var _prompt_x = _box_x2 - 14;
        var _prompt_y = _box_y2 - 10;
        
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        
        draw_set_color(c_black);
        draw_text(_prompt_x + 1, _prompt_y + 1, "▼");
        draw_set_color(c_yellow);
        draw_text(_prompt_x, _prompt_y, "▼");
    }
}

if (font_exists(fnt_bitmap)) draw_set_font(fnt_bitmap);
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_color(make_color_rgb(180, 190, 210));
draw_text(_gui_w - 14, 4, get_localized_text("history_hint"));

// --- 9. INTERACTIVE CHOICE BOX OVERLAY ---
if (choice_active && is_array(choices_array)) {
    var _c_w = 280;
    var _c_h = 26 + (array_length(choices_array) * 24);
    var _c_x1 = (_gui_w - _c_w) / 2;
    var _c_y1 = _gui_h - _box_h - _c_h - 14;
    var _c_x2 = _c_x1 + _c_w;
    var _c_y2 = _c_y1 + _c_h;

    draw_set_alpha(0.9);
    draw_rectangle_color(_c_x1, _c_y1, _c_x2, _c_y2, c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0);
    draw_rectangle_color(_c_x1, _c_y1, _c_x2, _c_y2, make_color_rgb(30, 40, 70), make_color_rgb(15, 20, 35), make_color_rgb(15, 20, 35), make_color_rgb(30, 40, 70), false);
    draw_rectangle_color(_c_x1, _c_y1, _c_x2, _c_y2, c_yellow, c_yellow, c_yellow, c_yellow, true);

    for (var _i = 0; _i < array_length(choices_array); _i++) {
        var _choice_item = choices_array[_i];
        var _item_y = _c_y1 + 14 + (_i * 24);
        var _is_selected = (_i == choice_selected_index);

        if (_is_selected) {
            draw_set_color(make_color_rgb(24, 45, 90));
            draw_rectangle_color(_c_x1 + 6, _item_y - 2, _c_x2 - 6, _item_y + 18, make_color_rgb(35, 65, 120), make_color_rgb(35, 65, 120), make_color_rgb(20, 35, 70), make_color_rgb(20, 35, 70), false);
            draw_set_color(c_yellow);
            draw_text(_c_x1 + 16, _item_y, "▶ " + _choice_item.text);
        } else {
            draw_set_color(c_white);
            draw_text(_c_x1 + 26, _item_y, _choice_item.text);
        }
    }
}

// --- 10. DIALOGUE HISTORY BACKLOG SCREEN OVERLAY ---
if (backlog_open && is_array(dialogue_history)) {
    draw_set_alpha(0.95);
    draw_rectangle_color(0, 0, _gui_w, _gui_h, make_color_rgb(10, 12, 20), make_color_rgb(10, 12, 20), make_color_rgb(10, 12, 20), make_color_rgb(10, 12, 20), false);
    draw_set_alpha(1.0);

    draw_set_color(c_yellow);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text(_gui_w / 2, 12, "--- " + get_localized_text("history_title") + " ---");

    var _hist_y = 36;
    var _hist_start = backlog_scroll_index;
    var _hist_end = min(_hist_start + 5, array_length(dialogue_history));

    for (var _h = _hist_start; _h < _hist_end; _h++) {
        var _entry = dialogue_history[_h];
        var _h_speaker = variable_struct_exists(_entry, "speaker") ? _entry.speaker : "";
        var _h_text = variable_struct_exists(_entry, "text") ? _entry.text : "";
        
        draw_set_halign(fa_left);
        draw_set_color(c_yellow);
        draw_text(24, _hist_y, "[" + string_upper(_h_speaker) + "]");
        draw_set_color(c_white);
        draw_text_ext(24, _hist_y + 12, _h_text, 12, _gui_w - 48);
        _hist_y += 38;
    }

    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(180, 190, 210));
    draw_text(_gui_w / 2, _gui_h - 18, get_localized_text("history_close"));
}

// --- 11. SCREEN FADE OVERLAY ---
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