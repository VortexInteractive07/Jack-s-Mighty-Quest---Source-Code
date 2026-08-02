/// @description Safe 4:3 Engine Resolution Restoration Hook

var _base_w = 320;
var _base_h = 240;

// Shift hardware scaling frames back to base values upon script deletion
surface_resize(application_surface, _base_w, _base_h);
display_set_gui_size(_base_w, _base_h);