/// @description Clean Up Allocation Resources

// CRITICAL FIX: Turn automatic surface drawing back on when obj_controller is destroyed
application_surface_draw_enable(true);

// Free pause surface memory safely to prevent leaks
if (surface_exists(pause_surface)) {
    surface_free(pause_surface);
    pause_surface = -1;
}