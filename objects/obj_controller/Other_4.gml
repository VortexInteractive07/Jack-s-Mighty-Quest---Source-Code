/// @description Preserve Engine Surface Config On Room Shift

application_surface_draw_enable(false);
gpu_set_blendenable(true);

if (surface_exists(pause_surface)) {
    surface_free(pause_surface);
    pause_surface = -1;
}

var _widescreen_w = 426;
var _widescreen_h = 240;

if (surface_exists(application_surface)) {
    surface_resize(application_surface, _widescreen_w, _widescreen_h);
}
display_set_gui_size(_widescreen_w, _widescreen_h);