/// @description obj_camera - Create Event (Smooth Tracking & Parallax Setup)

// Target object for the camera to follow
target = obj_jack;

// Camera lerp speed (0.1 = smooth and fluid, 1.0 = instant/snappy)
cam_speed = 0.1;

// Retrieve current view width and height
cam_width  = camera_get_view_width(view_camera[0]);
cam_height = camera_get_view_height(view_camera[0]);

// Background layer IDs
layer_bg_ground = layer_get_id("bg_ground");
layer_bg_near_2 = layer_get_id("bg_near_2");
layer_bg_near_1 = layer_get_id("bg_near_1");
layer_bg_mid    = layer_get_id("bg_mid");
layer_bg_far    = layer_get_id("bg_far");
layer_bg_sky    = layer_get_id("bg_sky");

// Store initial positions set in the Room Editor
start_x_ground = layer_exists(layer_bg_ground) ? layer_get_x(layer_bg_ground) : 0;
start_y_ground = layer_exists(layer_bg_ground) ? layer_get_y(layer_bg_ground) : 0;

start_x_near_2 = layer_exists(layer_bg_near_2) ? layer_get_x(layer_bg_near_2) : 0;
start_y_near_2 = layer_exists(layer_bg_near_2) ? layer_get_y(layer_bg_near_2) : 0;

start_x_near_1 = layer_exists(layer_bg_near_1) ? layer_get_x(layer_bg_near_1) : 0;
start_y_near_1 = layer_exists(layer_bg_near_1) ? layer_get_y(layer_bg_near_1) : 0;

start_x_mid    = layer_exists(layer_bg_mid) ? layer_get_x(layer_bg_mid) : 0;
start_y_mid    = layer_exists(layer_bg_mid) ? layer_get_y(layer_bg_mid) : 0;

start_x_far    = layer_exists(layer_bg_far) ? layer_get_x(layer_bg_far) : 0;
start_y_far    = layer_exists(layer_bg_far) ? layer_get_y(layer_bg_far) : 0;

start_x_sky    = layer_exists(layer_bg_sky) ? layer_get_x(layer_bg_sky) : 0;
start_y_sky    = layer_exists(layer_bg_sky) ? layer_get_y(layer_bg_sky) : 0;