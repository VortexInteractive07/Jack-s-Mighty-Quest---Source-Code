/// @description Procedural stage atmosphere and experimental weather.

if (stage_theme_effect != 0 && !is_game_over) {
    var _view_x = camera_get_view_x(view_camera[0]);
    var _view_y = camera_get_view_y(view_camera[0]);
    var _view_w = camera_get_view_width(view_camera[0]);
    var _view_h = camera_get_view_height(view_camera[0]);

    for (var _fx_i = 0; _fx_i < array_length(stage_effect_particles); _fx_i++) {
        var _effect = stage_effect_particles[_fx_i];
        if (stage_theme_effect == 1) {
            draw_set_color(make_color_rgb(110, 190, 220));
            draw_set_alpha(0.28);
            draw_line(_view_x + _effect.x, _view_y + _effect.y, _view_x + _effect.x - 3, _view_y + _effect.y + 8);
        } else {
            draw_set_color(make_color_rgb(255, 155, 72));
            draw_set_alpha(0.7);
            draw_circle(_view_x + _effect.x, _view_y + _effect.y, _effect.size, false);
        }
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
}

if (!weather_enabled || is_game_over) {
    exit;
}

var _view_x = camera_get_view_x(view_camera[0]);
var _view_y = camera_get_view_y(view_camera[0]);
var _view_w = camera_get_view_width(view_camera[0]);
var _view_h = camera_get_view_height(view_camera[0]);

if (stage2_storm) {
    // Gray mist is strongest in the sky and fades in pixel steps through the distant mountains.
    // The lower fade keeps the near forest, platforms, and player crisp.
    var _fog_color = make_color_rgb(142, 147, 148);
    var _fog_top = _view_y;
    var _fog_solid_end = _view_y + _view_h * 0.30;
    var _fog_fade_end = _view_y + _view_h * 0.74;
    var _fog_step = 2;

    draw_set_color(_fog_color);
    draw_set_alpha(0.58);
    draw_rectangle(_view_x, _fog_top, _view_x + _view_w, _fog_solid_end, false);

    var _fog_rows = ceil((_fog_fade_end - _fog_solid_end) / _fog_step);
    for (var _fog_row = 0; _fog_row < _fog_rows; _fog_row++) {
        var _fog_t = clamp((_fog_row * _fog_step) / max(1, _fog_fade_end - _fog_solid_end), 0, 1);
        var _fog_alpha = 0.58 * power(1 - _fog_t, 1.4);
        var _fog_y = _fog_solid_end + (_fog_row * _fog_step);
        draw_set_alpha(_fog_alpha);
        draw_rectangle(_view_x, _fog_y, _view_x + _view_w, min(_fog_y + _fog_step, _fog_fade_end), false);
    }
} else {
    draw_set_color(make_color_rgb(155, 165, 180));
    draw_set_alpha(0.24);
    draw_rectangle(_view_x, _view_y, _view_x + _view_w, _view_y + _view_h, false);
}

for (var i = 0; i < array_length(weather_drops); i++) {
    var _drop = weather_drops[i];
    var _drop_x = _view_x + _drop.x;
    var _drop_y = _view_y + _drop.y;

    draw_set_color(stage2_storm ? make_color_rgb(194, 202, 205) : make_color_rgb(185, 220, 255));
    draw_set_alpha(stage2_storm ? 0.68 : 0.55);
    var _slant = stage2_storm ? max(2, wind_speed_mph / 25) : 2;
    draw_line(_drop_x, _drop_y, _drop_x - _slant, _drop_y + _drop.length);
}

draw_set_alpha(1.0);

if (weather_flash_alpha > 0) {
    draw_set_color(stage2_storm ? make_color_rgb(215, 222, 225) : c_white);
    draw_set_alpha(weather_flash_alpha);
    draw_rectangle(_view_x, _view_y, _view_x + _view_w, _view_y + _view_h, false);
    draw_set_alpha(1.0);
}
