/// @description Trigger Boss Activation, Instant BGM Swap & Camera Lock

// 1. HARD EXIT IF ALREADY TRIGGERED OR BOSS IS ALREADY ACTIVE
if (triggered || (variable_global_exists("boss_active") && global.boss_active)) exit;

// Set triggered state immediately
triggered = true;
text_timer = text_duration;

// Disable collision mask so it cannot be re-triggered
mask_index = -1;

// Set Boss Active Flag
global.boss_active = true;

// 1. Wake up Boss Instance
if (instance_exists(obj_boss)) {
    obj_boss.is_active = true;
    obj_boss.state = "chase";
}

// 2. INSTANT BGM SWAP
audio_stop_all();

if (audio_exists(mus_ranga_dhun_yeh)) {
    audio_play_sound(mus_ranga_dhun_yeh, 100, true);
}

// 3. Lock Camera Viewport over Boss Area
if (instance_exists(obj_camera)) {
    var _cam = view_camera[0];
    var _cam_w = camera_get_view_width(_cam);
    var _cam_h = camera_get_view_height(_cam);
    
    var _focus_x = x;
    var _focus_y = y;
    
    if (instance_exists(obj_boss)) {
        _focus_x = obj_boss.x;
        _focus_y = obj_boss.y;
    }
    
    obj_camera.boss_lock = true;
    obj_camera.lock_x = clamp(_focus_x - (_cam_w / 2), 0, room_width - _cam_w);
    obj_camera.lock_y = clamp(_focus_y - (_cam_h / 2), 0, room_height - _cam_h);
}