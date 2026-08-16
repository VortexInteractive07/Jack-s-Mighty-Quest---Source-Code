/// @description obj_camera - Step Event (Smooth Follow & Clamp)

// Check if the target (Jack) exists before trying to track him
if (instance_exists(target)) {
    
    // Calculate the ideal target position (Centers Jack, with a -16 pixel vertical offset to frame him better)
    var _target_x = target.x - (cam_width / 2);
    var _target_y = target.y - (cam_height / 2) - 16;
    
    // Get current camera position
    var _cur_x = camera_get_view_x(view_camera[0]);
    var _cur_y = camera_get_view_y(view_camera[0]);
    
    // Smoothly interpolate (lerp) from current position to target position
    var _new_x = lerp(_cur_x, _target_x, cam_speed);
    var _new_y = lerp(_cur_y, _target_y, cam_speed);
    
    // Clamp the camera position so it doesn't show outside the room boundaries
    _new_x = clamp(_new_x, 0, room_width - cam_width);
    _new_y = clamp(_new_y, 0, room_height - cam_height);
    
    // Apply the final coordinates to the active camera view
    camera_set_view_pos(view_camera[0], _new_x, _new_y);
}