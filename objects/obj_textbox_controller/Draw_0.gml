// 1. Safety Exit: Only draw if the splash controller exists and is in the dialogue state (6)
if (instance_exists(obj_splash_controller)) {
    if (obj_splash_controller.state != 6) exit;
}

// 2. Standard empty check
if (array_length(text_array) == 0) exit;
if (current_line >= array_length(text_array)) exit; 

// --- Draw Box Canvas ---
draw_set_color(c_dkgrey);
draw_rectangle(box_x, box_y, box_x + box_w, box_y + box_h, false);
draw_set_color(c_white);
draw_rectangle(box_x, box_y, box_x + box_w, box_y + box_h, true);
draw_rectangle(box_x + 2, box_y + 2, box_x + box_w - 2, box_y + box_h - 2, true);

// --- Typography Engine ---
draw_set_font(active_font);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _current_msg = text_array[current_line];
var _visible_text = string_copy(_current_msg.text, 1, floor(char_index));
var _render_x = box_x + text_padding;
var _render_y = box_y + text_padding;
var _wrap_w = box_w - (text_padding * 2) - 4;
var _line_sep = 11;
var _shadow_offset = 1;

// --- Speaker Label ---
if (_current_msg.speaker != "" && _current_msg.speaker != "SYSTEM") {
    var _speaker_text = _current_msg.speaker + ":";
    draw_set_color(c_black);
    draw_text_ext(_render_x + _shadow_offset, _render_y + _shadow_offset, _speaker_text, _line_sep, _wrap_w);
    draw_set_color(c_yellow);
    draw_text_ext(_render_x, _render_y, _speaker_text, _line_sep, _wrap_w);
    _render_y += _line_sep + 3;
}

// --- Body Text ---
draw_set_color(c_black);
draw_text_ext(_render_x + _shadow_offset, _render_y + _shadow_offset, _visible_text, _line_sep, _wrap_w);
draw_set_color(c_white);
draw_text_ext(_render_x, _render_y, _visible_text, _line_sep, _wrap_w);

// --- Interaction Prompt ---
if (is_finished) {
    var _btn_x = box_x + box_w - 12;
    var _btn_y = box_y + box_h - 10;
    
    if (sprite_exists(button_sprite)) {
        var _subimg = (current_time * 0.001 * sprite_get_speed(button_sprite)) % sprite_get_number(button_sprite);
        draw_sprite(button_sprite, _subimg, _btn_x, _btn_y);
    } else {
        // Fallback
        draw_set_color(c_black);
        draw_text(box_x + box_w - 8 + _shadow_offset, box_y + box_h - 6 + _shadow_offset, "D");
        draw_set_color(c_yellow);
        draw_text(box_x + box_w - 8, box_y + box_h - 6, "D");
    }
}