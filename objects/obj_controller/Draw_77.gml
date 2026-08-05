/// @description Render Final Stretched Application Surface to Viewport

draw_clear(c_black);
gpu_set_blendenable(false);

if (surface_exists(application_surface)) {
    var _win_w = window_get_width();
    var _win_h = window_get_height();
    
    draw_surface_stretched(application_surface, 0, 0, _win_w, _win_h);
}

gpu_set_blendenable(true);