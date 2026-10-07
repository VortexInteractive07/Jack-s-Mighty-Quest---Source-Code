/// @description obj_camera - Step Event (Smooth Follow, Clamp & Parallax)

if (instance_exists(target)) {
    // Keep the level framing stable during Jack's death animation/fall.
    var _target_instance = instance_find(target, 0);
    if (instance_exists(_target_instance) && _target_instance.is_dead) exit;
    
    // Calculate target position (Centers target with vertical offset)
    var _target_x = target.x - (cam_width / 2);
    var _target_y = target.y - (cam_height / 2) - 16;
    
    // Get current camera position
    var _cur_x = camera_get_view_x(view_camera[0]);
    var _cur_y = camera_get_view_y(view_camera[0]);
    
    // Default follows smoothly. The optional early TMS9918A-style mode has
    // no fine scroll register, so the view advances only at 8-pixel tile steps.
    var _new_x;
    var _new_y;
    if (global.scrolling_mode == "JITTERY") {
        _new_x = floor(_target_x / 8) * 8;
        _new_y = floor(_target_y / 8) * 8;
    } else {
        _new_x = lerp(_cur_x, _target_x, cam_speed);
        _new_y = lerp(_cur_y, _target_y, cam_speed);
    }
    
    // Clamp to room boundaries
    _new_x = clamp(_new_x, 0, room_width - cam_width);
    _new_y = clamp(_new_y, 0, room_height - cam_height);
    
    // Apply final position to active view
    camera_set_view_pos(view_camera[0], _new_x, _new_y);
    
    // Apply parallax offset relative to room editor starting positions
    // The early tile-scrolling mode uses one shared world plane, so disable
    // the fractional parallax offsets that the original VDP could not provide.
    var _parallax_scale = (global.scrolling_mode == "JITTERY") ? 0 : 1;
    if (layer_exists(layer_bg_ground)) {
        layer_x(layer_bg_ground, start_x_ground + (_new_x * 0.00));
        layer_y(layer_bg_ground, start_y_ground + (_new_y * 0.00));
    }
    
    if (layer_exists(layer_bg_near_2)) {
        layer_x(layer_bg_near_2, start_x_near_2 + (_new_x * 0.20 * _parallax_scale));
        layer_y(layer_bg_near_2, start_y_near_2 + (_new_y * 0.10 * _parallax_scale));
    }
    
    if (layer_exists(layer_bg_near_1)) {
        layer_x(layer_bg_near_1, start_x_near_1 + (_new_x * 0.40 * _parallax_scale));
        layer_y(layer_bg_near_1, start_y_near_1 + (_new_y * 0.15 * _parallax_scale));
    }
    
    if (layer_exists(layer_bg_mid)) {
        layer_x(layer_bg_mid, start_x_mid + (_new_x * 0.60 * _parallax_scale));
        layer_y(layer_bg_mid, start_y_mid + (_new_y * 0.20 * _parallax_scale));
    }
    
    if (layer_exists(layer_bg_far)) {
        layer_x(layer_bg_far, start_x_far + (_new_x * 0.80 * _parallax_scale));
        layer_y(layer_bg_far, start_y_far + (_new_y * 0.25 * _parallax_scale));
    }
    
    if (layer_exists(layer_bg_sky)) {
        layer_x(layer_bg_sky, start_x_sky + (_new_x * 0.95 * _parallax_scale));
        layer_y(layer_bg_sky, start_y_sky + (_new_y * 0.30 * _parallax_scale));
    }
}
