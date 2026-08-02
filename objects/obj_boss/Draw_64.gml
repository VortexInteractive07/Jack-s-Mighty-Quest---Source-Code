/// @description Render Modern Boss Health Bar HUD (426x240 Widescreen)

if (!is_active) exit;

var _gui_w = display_get_gui_width();

var _fnt = asset_get_index("fnt_dialogue");
if (_fnt != -1 && font_exists(_fnt)) {
    draw_set_font(_fnt);
}

hp_smooth = lerp(hp_smooth, hp, 0.15);
var _hp_pct = clamp(hp_smooth / max_hp, 0.0, 1.0);

var _bar_w  = 180;
var _bar_h  = 8;
var _bar_x1 = (_gui_w / 2) - (_bar_w / 2);
var _bar_y1 = 18;
var _bar_x2 = _bar_x1 + _bar_w;
var _bar_y2 = _bar_y1 + _bar_h;

// 1. Dark Glass Panel Backdrop
draw_set_color(c_black);
draw_set_alpha(0.75);
draw_roundrect_ext(_bar_x1 - 12, _bar_y1 - 14, _bar_x2 + 12, _bar_y2 + 6, 6, 6, false);

// 2. Boss Nameplate Text
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_color(c_black);
draw_text_transformed((_gui_w / 2) + 1, _bar_y1 - 2, boss_name, 0.55, 0.55, 0);
draw_set_color(make_color_rgb(255, 200, 50));
draw_text_transformed(_gui_w / 2, _bar_y1 - 3, boss_name, 0.55, 0.55, 0);

// 3. Health Trough Background
draw_set_color(make_color_rgb(25, 20, 30));
draw_set_alpha(1.0);
draw_rectangle(_bar_x1, _bar_y1, _bar_x2, _bar_y2, false);

// 4. Dynamic Fill Color
var _fill_color = (hp <= (max_hp * 0.40)) ? make_color_rgb(255, 50, 50) : make_color_rgb(255, 140, 0);
if (_hp_pct > 0) {
    draw_set_color(_fill_color);
    draw_rectangle(_bar_x1, _bar_y1, _bar_x1 + (_bar_w * _hp_pct), _bar_y2, false);
}

// 5. Outer Frame Accent
draw_set_color(c_white);
draw_set_alpha(0.4);
draw_rectangle(_bar_x1, _bar_y1, _bar_x2, _bar_y2, true);

// Reset Draw Settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);