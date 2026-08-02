/// @description Render Real-Time Scanline Mode 7 Floor (2560x1440 Map)

// Sky / Horizon Backdrop
draw_clear(make_color_rgb(20, 10, 35));

if (ground_tex == -1) exit;

var _horizon = view_h * 0.5;
var _rad = degtorad(cam_angle);
var _cos = cos(_rad);
var _sin = sin(_rad);

var _cx = view_w * 0.5;
var _cy = _horizon;

// Scanline row-by-row projection loop from horizon down to screen bottom (using _y instead of y)
for (var _y = _horizon; _y < view_h; _y++) {
    var _p = _y - _horizon;
    if (_p <= 0) continue;
    
    // Scale distance relative to camera altitude
    var _z = (cam_dist * 120.0) / _p;
    
    // Left-side world projection coordinates
    var _fx = cam_x + (_z * _cos) - (_z * _sin * (-_cx) / 120.0);
    var _fy = cam_y - (_z * _sin) - (_z * _cos * (-_cx) / 120.0);
    
    // Horizontal step increments per screen pixel
    var _dx = (_z * _sin * (view_w / 120.0)) / view_w;
    var _dy = (_z * _cos * (view_w / 120.0)) / view_w;
    
    // Map across the 2560x1440 texture dimensions (U: 2560, V: 1440)
    var _left_u  = _fx / 2560.0;
    var _left_v  = _fy / 1440.0;
    
    var _right_u = (_fx + (_dx * view_w)) / 2560.0;
    var _right_v = (_fy + (_dy * view_w)) / 1440.0;
    
    draw_primitive_begin_texture(pr_linelist, ground_tex);
    
    draw_vertex_texture(0, _y, _left_u, _left_v);
    draw_vertex_texture(view_w, _y, _right_u, _right_v);
    
    draw_primitive_end();
}