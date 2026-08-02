/// @description Render Cyberpunk Grid & Warp Starfield
var _center_x = view_w / 2;
var _center_y = view_h / 2;

draw_clear(make_color_rgb(5, 5, 12)); // Dark void background

// 1. Draw Perspective Cyber-Grid on lower half of screen
draw_set_color(make_color_rgb(15, 45, 80));
var _horizon = _center_y + 10;

for (var gy = _horizon; gy < view_h; gy += 8) {
    draw_line(0, gy, view_w, gy);
}
for (var gx = -view_w; gx < view_w * 2; gx += 24) {
    var _x1 = _center_x + (gx - _center_x) * 0.2;
    draw_line(_x1, _horizon, gx, view_h);
}

// 2. Render 3D Starfield
for (var i = 0; i < max_stars; i++) {
    var _proj_x = _center_x + (stars[i].x / stars[i].z);
    var _proj_y = _center_y + (stars[i].y / stars[i].z);
    
    var _star_size = (1.0 - (stars[i].z / 6.0)) * 2.2;
    var _brightness = floor((1.0 - (stars[i].z / 6.0)) * 255);
    
    // Sci-fi cyan tint for warp stars
    var _star_color = make_color_rgb(_brightness * 0.4, _brightness * 0.9, _brightness);
    
    if (_proj_x >= 0 && _proj_x <= view_w && _proj_y >= 0 && _proj_y <= view_h) {
        draw_set_color(_star_color);
        draw_circle(_proj_x, _proj_y, _star_size, false);
    }
}