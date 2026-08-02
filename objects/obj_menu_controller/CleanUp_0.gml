/// @description Safe Resolution Restoration Hook

// Only reset resolution if transitioning out to a room that specifically needs 320x240
var _base_w = 426;
var _base_h = 240;

// Shift rendering matrix frames right back down to basic layouts when exiting menu
surface_resize(application_surface, _base_w, _base_h);
display_set_gui_size(_base_w, _base_h);