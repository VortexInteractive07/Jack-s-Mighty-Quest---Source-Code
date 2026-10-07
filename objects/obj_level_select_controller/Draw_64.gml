/// @description Draw the animated stage select carousel.

var _gui_w = 432;
var _gui_h = 240;
draw_clear(make_color_rgb(10, 25, 47));

if (sprite_exists(spr_vortex_logo_darkmode)) {
    var _tw = sprite_get_width(spr_vortex_logo_darkmode);
    var _th = sprite_get_height(spr_vortex_logo_darkmode);
    for (var _x = bg_x - _tw; _x < _gui_w + _tw; _x += _tw) {
        for (var _y = bg_y - _th; _y < _gui_h + _th; _y += _th) {
            draw_sprite_ext(spr_vortex_logo_darkmode, 0, _x, _y, 1, 1, 0, c_white, 0.18);
        }
    }
}

draw_set_alpha(0.88);
draw_set_color(c_black);
draw_rectangle(12, 12, _gui_w - 12, _gui_h - 12, false);
draw_set_alpha(1);
draw_set_color(c_aqua);
draw_rectangle(12, 12, _gui_w - 12, 14, false);
draw_set_color(make_color_rgb(212, 175, 55));
draw_rectangle(12, 12, _gui_w - 12, _gui_h - 12, true);

if (font_exists(fnt_bitmap)) draw_set_font(fnt_bitmap);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_yellow);
draw_text(_gui_w * 0.5, 30, "SELECT YOUR STAGE");

var _prev = (selected_index + stage_count - 1) mod stage_count;
var _next = (selected_index + 1) mod stage_count;
var _active = stages[selected_index];

// Side cards keep nearby stages visible, while the active stage stays readable.
draw_set_alpha(0.58);
draw_set_color(make_color_rgb(20, 45, 80));
draw_rectangle(30, 78, 126, 158, false);
draw_rectangle(_gui_w - 126, 78, _gui_w - 30, 158, false);
draw_set_alpha(1);
draw_set_color(make_color_rgb(212, 175, 55));
draw_rectangle(30, 78, 126, 158, true);
draw_rectangle(_gui_w - 126, 78, _gui_w - 30, 158, true);

draw_set_color(c_silver);
draw_text(78, 106, "< " + stages[_prev].name);
draw_text(78, 128, stages[_prev].act);
draw_text(_gui_w - 78, 106, stages[_next].name + " >");
draw_text(_gui_w - 78, 128, stages[_next].act);

draw_set_color(make_color_rgb(20, 45, 80));
draw_rectangle(137, 62, _gui_w - 137, 174, false);
draw_set_color(make_color_rgb(245, 222, 179));
draw_rectangle(137, 62, _gui_w - 137, 174, true);
draw_set_color(c_white);
draw_text(_gui_w * 0.5, 96, _active.name);
draw_set_color(c_yellow);
draw_text(_gui_w * 0.5, 122, _active.act);
draw_set_color(c_silver);
draw_text(_gui_w * 0.5, 148, string(selected_index + 1) + " / " + string(stage_count));

draw_set_color(c_aqua);
draw_line(24, 188, _gui_w - 24, 188);
draw_set_color(c_white);
draw_text(_gui_w * 0.5, 202, "LEFT / RIGHT: CHOOSE    ENTER: PLAY");
draw_set_color(c_gray);
draw_text(_gui_w * 0.5, 220, "ESC: TITLE SCREEN");

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
if (fade_alpha > 0) scr_draw_transition_overlay(fade_alpha, _gui_w, _gui_h);
