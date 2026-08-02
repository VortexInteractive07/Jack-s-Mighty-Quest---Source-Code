/// @description Initialize Mode 7 Engine & 2560x1440 Texture Mapping

view_w = 426;
view_h = 240;

view_enabled = true;
view_visible[0] = true;

if (view_camera[0] != -1) {
    camera_set_view_target(view_camera[0], noone);
    camera_set_view_size(view_camera[0], view_w, view_h);
    camera_set_view_pos(view_camera[0], 0, 0);
}

surface_resize(application_surface, view_w, view_h);
display_set_gui_size(view_w, view_h);

// Enable texture repeating so the large map tiles correctly across the floor projection
gpu_set_texrepeat(true);

// Mode 7 World & Camera Coordinates (Centered on the 2560x1440 map)
cam_x      = 1280.0;
cam_y      = 720.0;
cam_angle  = 0.0;          // Rotation angle in degrees
cam_dist   = 80.0;         // Camera altitude / zoom height above the floor
cam_speed  = 6.0;
rot_speed  = 2.5;

// Retrieve Texture safely using asset_get_index 
ground_tex = -1;
var _spr = asset_get_index("spr_mode7_map"); // Replace "spr_mode7_map" with your exact sprite name if it's different
if (_spr != -1 && sprite_exists(_spr)) {
    ground_tex = sprite_get_texture(_spr, 0);
}