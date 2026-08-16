/// @description obj_camera - Create Event (Smooth Tracking Setup)

// Target object for the camera to follow
target = obj_jack;

// Camera lerp speed (0.1 = smooth and fluid, 1.0 = instant/snappy snap)
cam_speed = 0.1;

// Retrieve current view width and height
cam_width  = camera_get_view_width(view_camera[0]);
cam_height = camera_get_view_height(view_camera[0]);