/// @description Render Procedural Background Engine

var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);
var _w     = camera_get_view_width(view_camera[0]);
var _h     = camera_get_view_height(view_camera[0]);

// 1. BASE GRADIENT PASS
draw_rectangle_color(
    _cam_x, _cam_y, 
    _cam_x + _w, _cam_y + _h, 
    col_top, col_top, col_bottom, col_bottom, 
    false
);

// 2. PATTERN / STARFIELD PASS
switch (bg_mode) {
    case 0: // SCROLLING RETRO GRID
        draw_set_color(col_pattern);
        draw_set_alpha(pattern_alpha);

        var _start_x = _cam_x - grid_size + scroll_x;
        for (var xx = _start_x; xx <= _cam_x + _w + grid_size; xx += grid_size) {
            draw_line_width(xx, _cam_y, xx, _cam_y + _h, grid_thickness);
        }

        var _start_y = _cam_y - grid_size + scroll_y;
        for (var yy = _start_y; yy <= _cam_y + _h + grid_size; yy += grid_size) {
            draw_line_width(_cam_x, yy, _cam_x + _w, yy, grid_thickness);
        }
        break;

    case 1: // PARALLAX STARFIELD
        for (var i = 0; i < star_count; i++) {
            var _s = stars[i];
            var _alpha = (sin(_s.twinkle) + 1) * 0.5 * pattern_alpha + 0.3;
            
            draw_set_color(_s.color);
            draw_set_alpha(_alpha);
            
            if (_s.size == 1) {
                draw_point(_s.x, _s.y);
            } else {
                draw_rectangle(_s.x, _s.y, _s.x + 1, _s.y + 1, false);
            }
        }
        break;

    case 2: // DIAGONAL SCROLLING STRIPES
        draw_set_color(col_pattern);
        draw_set_alpha(pattern_alpha);

        var _total_span = _w + _h + (grid_size * 2);
        var _offset = (scroll_x + scroll_y) % (grid_size * 2);

        for (var i = -grid_size * 2; i < _total_span; i += grid_size * 2) {
            var _x1 = _cam_x + i + _offset;
            var _y1 = _cam_y;
            var _x2 = _x1 - _h;
            var _y2 = _cam_y + _h;
            
            draw_line_width(_x1, _y1, _x2, _y2, grid_size * 0.5);
        }
        break;
}

// RESET RENDER STATE
draw_set_alpha(1.0);
draw_set_color(c_white);