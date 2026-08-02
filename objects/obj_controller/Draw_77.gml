/// @description Render Final Stretched Application Surface to Viewport

draw_clear(c_black);

gpu_set_blendenable(false);

if (surface_exists(application_surface)) {
    draw_surface_stretched(application_surface, 0, 0, window_get_width(), window_get_height());
}

gpu_set_blendenable(true);