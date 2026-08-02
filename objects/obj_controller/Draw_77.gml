/// @description Post-Draw: Render Final Stretched Application Surface to Viewport

// Clear backbuffer to avoid ghosting artifacts
draw_clear(c_black);

// Disable alpha blending for performance when blitting full surface
gpu_set_blendenable(false);

if (surface_exists(application_surface)) {
    var _win_w = window_get_width();
    var _win_h = window_get_height();
    
    // Stretch internal low-res application surface to fill the monitor/window size
    draw_surface_stretched(application_surface, 0, 0, _win_w, _win_h);
}

// Re-enable blending for normal UI / GUI passes
gpu_set_blendenable(true);