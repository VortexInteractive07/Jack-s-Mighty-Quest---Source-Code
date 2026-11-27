/// @description Draw a clear retro checkpoint marker.
draw_set_color(c_black); draw_rectangle(x - 5, y - 20, x + 5, y, false);
draw_set_color(c_aqua); draw_rectangle(x - 3, y - 18, x + 3, y - 2, false);
draw_set_color(c_yellow); draw_triangle(x + 3, y - 18, x + 15, y - 14, x + 3, y - 10, false);
draw_set_color(c_white);
