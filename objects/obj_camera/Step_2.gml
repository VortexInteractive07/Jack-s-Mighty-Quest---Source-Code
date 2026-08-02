/// @description Smooth Camera Follow & Triple Layer Parallax Rendering
var _cam = view_camera[0];
var _cam_w = camera_get_view_width(_cam);
var _cam_h = camera_get_view_height(_cam);

var _new_x = camera_get_view_x(_cam);
var _new_y = camera_get_view_y(_cam);

// --- FAILSAFE: AUTO-RELEASE CAMERA LOCK IF BOSS DOES NOT EXIST ---
if (boss_lock && !instance_exists(obj_boss)) {
    boss_lock = false;
    global.boss_active = false;
}

if (boss_lock) {
    // === BOSS ARENA MODE ===
    // Freeze camera over lock coordinates
    _new_x = lock_x;
    _new_y = lock_y;
    
    camera_set_view_pos(_cam, _new_x, _new_y);
} 
else if (instance_exists(target)) {
    // === STANDARD RUNTIME TRACKING ===
    var _target_x = target.x - (_cam_w / 2);
    var _target_y = target.y - (_cam_h / 2);
    
    // Clamp inside room boundaries
    _target_x = clamp(_target_x, 0, room_width - _cam_w);
    _target_y = clamp(_target_y, 0, room_height - _cam_h);
    
    // Linear Interpolation tracking
    var _cur_x = camera_get_view_x(_cam);
    var _cur_y = camera_get_view_y(_cam);
    
    _new_x = lerp(_cur_x, _target_x, cam_speed);
    _new_y = lerp(_cur_y, _target_y, cam_speed);
    
    camera_set_view_pos(_cam, _new_x, _new_y);
}

// ============================================================================
// EXECUTE PARALLAX BACKGROUND SHIFTS
// ============================================================================
if (layer_exists(layer_bg_close)) {
    layer_x(layer_bg_close, _new_x * ratio_close);
}
if (layer_exists(layer_bg_mid)) {
    layer_x(layer_bg_mid, _new_x * ratio_mid);
}
if (layer_exists(layer_bg_far)) {
    layer_x(layer_bg_far, _new_x * ratio_far);
}