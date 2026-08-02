/// @description Render Diagnostic HUD Overlay

// Use fnt_dialogue font with fallback check
if (font_exists(fnt_dialogue)) {
    draw_set_font(fnt_dialogue);
} else {
    draw_set_font(-1);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _padding = 8;
var _line_h  = 12;
var _hud_x   = _padding;
var _hud_y   = _padding;

draw_set_color(c_black);
draw_set_alpha(0.65);
draw_rectangle(_hud_x - 4, _hud_y - 4, _hud_x + 330, _hud_y + 45 + (array_length(layer_data) * _line_h), false);

draw_set_alpha(1.0);
draw_set_color(c_yellow);
draw_text(_hud_x, _hud_y, "--- PARALLAX CONTROLLER: 640x480 ---");

// Mode String Selector Logic
var _mode_string = "MANUAL";
if (jim_power_mode) {
    _mode_string = "JIM POWER 3D (Spd: " + string_format(jim_power_speed, 2, 2) + ")";
} else if (auto_scroll_enabled) {
    _mode_string = "AUTO (Spd: " + string_format(auto_scroll_speed, 2, 2) + ")";
}

draw_set_color(c_white);
draw_text(_hud_x, _hud_y + _line_h, "Cam X: " + string(round(cam_x)) + " | Mode: " + _mode_string);
draw_text(_hud_x, _hud_y + (_line_h * 2), "FPS Real: " + string(round(fps_real)) + " | BG Mult: x" + string(bg_speed_modifier));

draw_set_color(c_aqua);
draw_text(_hud_x, _hud_y + (_line_h * 3), "Configured Room Layers:");

for (var i = 0; i < array_length(layer_data); i++) {
    var _l = layer_data[i];
    draw_set_color(c_lime);
    draw_text(_hud_x, _hud_y + (_line_h * (4 + i)), _l.name + " (Factor: " + string(_l.factor) + ")");
}

var _bottom_y = view_h - 26;
draw_set_color(c_black);
draw_set_alpha(0.75);
draw_rectangle(0, _bottom_y - 2, view_w, view_h, false);

draw_set_alpha(1.0);
draw_set_color(c_yellow);
draw_text(6, _bottom_y, "[<-/->] Move | [I] Auto | [J] Jim Power 3D | [ESC] Menu");