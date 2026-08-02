/// @description Render Mode 7 Diagnostic HUD

if (font_exists(fnt_dialogue)) {
    draw_set_font(fnt_dialogue);
} else {
    draw_set_font(-1);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _padding = 8;
draw_set_color(c_black);
draw_set_alpha(0.65);
draw_rectangle(_padding - 4, _padding - 4, 310, 68, false);

draw_set_alpha(1.0);
draw_set_color(c_yellow);
draw_text(_padding, _padding, "--- MODE 7 TECH DEMO (2560x1440) ---");

draw_set_color(c_white);
draw_text(_padding, _padding + 12, "Cam X: " + string(round(cam_x)) + " | Y: " + string(round(cam_y)));
draw_text(_padding, _padding + 24, "Angle: " + string(round(cam_angle)) + "° | Altitude: " + string(round(cam_dist)));
draw_text(_padding, _padding + 36, "FPS Real: " + string(round(fps_real)));

var _bottom_y = view_h - 20;
draw_set_color(c_black);
draw_set_alpha(0.75);
draw_rectangle(0, _bottom_y - 2, view_w, view_h, false);

draw_set_alpha(1.0);
draw_set_color(c_yellow);
draw_text(6, _bottom_y, "[W/S] Move | [A/D] Rotate | [Q/E] Zoom | [ESC] Menu");