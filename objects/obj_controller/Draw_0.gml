/// @description Procedural experimental weather rendered in world space.

if (!weather_enabled || is_game_over) {
    exit;
}

var _cam = view_get_camera(0);
var _view_x = camera_get_view_x(_cam);
var _view_y = camera_get_view_y(_cam);
var _view_w = camera_get_view_width(_cam);
var _view_h = camera_get_view_height(_cam);

// Weather Wash Effect
draw_set_color(make_color_rgb(155, 165, 180));
draw_set_alpha(0.24);
draw_rectangle(_view_x, _view_y, _view_x + _view_w - 1, _view_y + _view_h - 1, false);

// Raindrops
var _drop_color = make_color_rgb(185, 220, 255);
draw_set_color(_drop_color);
draw_set_alpha(0.55);

var _len = array_length(weather_drops);
for (var i = 0; i < _len; i++) {
    var _drop = weather_drops[i];
    var _drop_x = _view_x + _drop.x;
    var _drop_y = _view_y + _drop.y;

    draw_line(_drop_x, _drop_y, _drop_x - 2, _drop_y + _drop.length);
}

// Flash Lightning Overlay
if (weather_flash_alpha > 0) {
    draw_set_color(c_white);
    draw_set_alpha(weather_flash_alpha);
    draw_rectangle(_view_x, _view_y, _view_x + _view_w - 1, _view_y + _view_h - 1, false);
}

// Reset Draw State
draw_set_color(c_white);
draw_set_alpha(1.0);