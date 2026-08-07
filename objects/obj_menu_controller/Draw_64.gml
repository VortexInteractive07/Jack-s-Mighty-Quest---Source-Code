/// @description Menu HUD, Modal Window & Global Fade Overlay Pass

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// ----------------------------------------------------------------------------
// 1. MENU HUD & MODAL OVERLAY
// ----------------------------------------------------------------------------
draw_set_font(fnt_dialogue);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _start_x = 54;
var _start_y = 38;
var _spacing = 24;

// Menu Item Render Loop (Arcade Strobe Enhanced)
for (var i = 0; i < max_visible_items; i++) {
    var _idx = scroll_offset + i;
    if (_idx >= menu_total) break;
    
    var _draw_x      = _start_x;
    var _draw_y      = _start_y + (i * _spacing);
    var _label_str   = menu_matrix[_idx].label;
    var _is_selected = (_idx == current_menu_selection);
    
    var _draw_item = true;
    var _item_color = c_white;

    if (_is_selected) {
        if (blink_timer > 0 || fade_state == 1) {
            // High-speed confirmation strobe (~40ms interval)
            _draw_item = ((current_time div blink_speed_press) % 2 == 0);
            _item_color = col_cyan;
        } else {
            // Hover pulse (~120ms interval)
            var _blink_phase = (current_time div blink_speed_hover) % 2 == 0;
            _item_color = _blink_phase ? col_gold : c_white;
        }
    }

    // Draw Shadow Pass
    draw_set_color(col_blue_shadow);
    if (_is_selected && _draw_item) {
        draw_text(_draw_x - 14 + 2, _draw_y + 2, ">");
    }
    draw_text(_draw_x + 2, _draw_y + 2, _label_str);
    
    // Draw Foreground Text Pass
    if (_draw_item) {
        if (_is_selected) {
            draw_set_color(_item_color);
            draw_text(_draw_x - 14, _draw_y, ">");
        } else {
            draw_set_color(c_white);
        }
        draw_text(_draw_x, _draw_y, _label_str);
    }
}

// Scroll Arrows
if (scroll_offset > 0) {
    draw_set_color(col_blue_shadow);
    draw_text(_start_x + 120 + 1, _start_y - 14 + 1, "^");
    draw_set_color(col_cyan);
    draw_text(_start_x + 120, _start_y - 14, "^");
}
if (scroll_offset + max_visible_items < menu_total) {
    draw_set_color(col_blue_shadow);
    draw_text(_start_x + 120 + 1, _start_y + (max_visible_items * _spacing) + 1, "v");
    draw_set_color(col_cyan);
    draw_text(_start_x + 120, _start_y + (max_visible_items * _spacing), "v");
}

// Footer
draw_set_valign(fa_bottom);
var _footer_x = 12;
var _footer_y = _gui_h - 8;

draw_set_color(col_blue_shadow);
draw_text(_footer_x + 2, _footer_y + 2, "ALPHA v1.0");
draw_set_color(c_white);
draw_text(_footer_x, _footer_y, "ALPHA v1.0");

// Modal Window
if (is_info_open) {
    draw_set_color(c_black);
    draw_set_alpha(0.88);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1.0);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    var _cen_x = floor(_gui_w / 2);
    var _msg_y = floor(_gui_h / 2 - 10);
    var _prompt_y = floor(_gui_h / 2 + 50);
    var _return_prompt = is_welcome_modal ? "PRESS ANY KEY TO START" : "PRESS ANY KEY TO RETURN";
    
    draw_set_color(col_blue_shadow);
    draw_text_ext(_cen_x + 2, _msg_y + 2, info_text, 14, _gui_w - 64);
    draw_text(_cen_x + 2, _prompt_y + 2, _return_prompt);
    
    draw_set_color(c_white);
    draw_text_ext(_cen_x, _msg_y, info_text, 14, _gui_w - 64);
    
    draw_set_color(col_gold);
    draw_text(_cen_x, _prompt_y, _return_prompt);
}

// ----------------------------------------------------------------------------
// 2. FADE-IN / FADE-OUT OVERLAY PASS
// ----------------------------------------------------------------------------
if (fade_alpha > 0) {
    draw_set_color(c_black);
    draw_set_alpha(fade_alpha);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
}

// Render State Reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);