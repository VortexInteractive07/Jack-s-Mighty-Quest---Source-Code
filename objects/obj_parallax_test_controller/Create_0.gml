/// @description Initialize 640x480 Parallax Controller (Pure X-Axis Parallax)

view_w = 640;
view_h = 480;

view_enabled = true;
view_visible[0] = true;

if (view_camera[0] != -1) {
    camera_set_view_target(view_camera[0], noone);
    camera_set_view_size(view_camera[0], view_w, view_h);
    camera_set_view_pos(view_camera[0], 0, 0);
}

surface_resize(application_surface, view_w, view_h);
display_set_gui_size(view_w, view_h);

var _win_w = window_get_width();
var _win_h = window_get_height();
if (_win_w > 0 && _win_h > 0) {
    var _scale = max(1, floor(_win_h / view_h));
    var _target_w = view_w * _scale;
    var _target_h = view_h * _scale;
    if (_win_w != _target_w || _win_h != _target_h) {
        window_set_size(_target_w, _target_h);
    }
}

cam_x = 0;
cam_speed = 4.0; 

auto_scroll_enabled = false;
auto_scroll_speed = 3.0;

// Jim Power: The Lost Dimension in 3D (TM) Mode Toggle State
jim_power_mode = false;
jim_power_speed = 3.5;

// Background speed modifier (1.5 = 0.5x faster than baseline for authentic NES feel)
bg_speed_modifier = 1.5; 

// ============================================================================
// NATIVE ROOM LAYER MAPPING (X-Axis Parallax Factors Only — Y is left to Room Editor)
// ============================================================================
layer_data = [
    { name: "Background",        id: layer_get_id("Background"),        factor: 0.00, auto_spd: 0.00, scroll_acc: 0 },
    { name: "bg_far",            id: layer_get_id("bg_far"),            factor: 0.15, auto_spd: 0.22, scroll_acc: 0 },
    { name: "bg_mid",            id: layer_get_id("bg_mid"),            factor: 0.35, auto_spd: 0.00, scroll_acc: 0 },
    { name: "bg_near",           id: layer_get_id("bg_near"),           factor: 0.55, auto_spd: 0.12, scroll_acc: 0 },
    { name: "bg_near_ground",    id: layer_get_id("bg_near_ground"),    factor: 0.80, auto_spd: 0.00, scroll_acc: 0 },
    { name: "bg_near_ground_2",  id: layer_get_id("bg_near_ground_2"),  factor: 1.00, auto_spd: 0.00, scroll_acc: 0 }
];

// Stats verification
if (!variable_global_exists("stats")) {
    global.stats = {
        total_deaths: 0,
        total_jumps: 0,
        time_played_sec: 0
    };
}