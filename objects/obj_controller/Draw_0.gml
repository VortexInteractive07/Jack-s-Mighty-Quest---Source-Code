/// @description Procedural experimental weather rendered in world space.

if (!weather_enabled || is_game_over) {
    exit;
}

var _view_x = camera_get_view_x(view_camera[0]);
var _view_y = camera_get_view_y(view_camera[0]);
var _view_w = camera_get_view_width(view_camera[0]);
var _view_h = camera_get_view_height(view_camera[0]);

// A translucent gray wash keeps the weather readable without distorting pixel colors.
draw_set_color(make_color_rgb(155, 165, 180));
draw_set_alpha(0.24);
draw_rectangle(_view_x, _view_y, _view_x + _view_w, _view_y + _view_h, false);

for (var i = 0; i < array_length(weather_drops); i++) {
    var _drop = weather_drops[i];
    var _drop_x = _view_x + _drop.x;
    var _drop_y = _view_y + _drop.y;

    draw_set_color(make_color_rgb(185, 220, 255));
    draw_set_alpha(0.55);
    draw_line(_drop_x, _drop_y, _drop_x - 2, _drop_y + _drop.length);
}

draw_set_alpha(1.0);

if (weather_flash_alpha > 0) {
    draw_set_color(c_white);
    draw_set_alpha(weather_flash_alpha);
    draw_rectangle(_view_x, _view_y, _view_x + _view_w, _view_y + _view_h, false);
    draw_set_alpha(1.0);
}
