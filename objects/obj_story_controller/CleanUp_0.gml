/// @description Restore Safe Retro 4:3 Resolution Baseline

var _base_w = 320;
var _base_h = 240;

// Reset the rendering application canvas straight back to standard game loops
surface_resize(application_surface, _base_w, _base_h);
display_set_gui_size(_base_w, _base_h);