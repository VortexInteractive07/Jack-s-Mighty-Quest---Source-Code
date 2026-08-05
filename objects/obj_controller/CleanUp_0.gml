/// @description Clean Up Allocation Resources

// Restore automatic surface drawing when the controller is destroyed or room ends
application_surface_draw_enable(true);

// Safely free the pause surface from VRAM to prevent memory leaks
if (surface_exists(pause_surface)) {
    surface_free(pause_surface);
    pause_surface = -1;
}