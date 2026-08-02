/// @description Process Flight, Rotation & Altitude Zoom Controls

var _move_up    = keyboard_check(vk_up)    || keyboard_check(ord("W"));
var _move_down  = keyboard_check(vk_down)  || keyboard_check(ord("S"));
var _turn_left  = keyboard_check(vk_left)  || keyboard_check(ord("A"));
var _turn_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var _alt_up     = keyboard_check(ord("Q"));
var _alt_down   = keyboard_check(ord("E"));

// Handle Rotation
if (_turn_left)  cam_angle += rot_speed;
if (_turn_right) cam_angle -= rot_speed;

// Handle Altitude / Zoom
if (_alt_up)   cam_dist = clamp(cam_dist + 1.5, 20.0, 300.0);
if (_alt_down) cam_dist = clamp(cam_dist - 1.5, 20.0, 300.0);

// Trigonometric Movement Vector Calculations
var _rad = degtorad(cam_angle);
var _cos = cos(_rad);
var _sin = sin(_rad);

if (_move_up) {
    cam_x += _cos * cam_speed;
    cam_y -= _sin * cam_speed;
}
if (_move_down) {
    cam_x -= _cos * cam_speed;
    cam_y += _sin * cam_speed;
}

// Wrap coordinates within the 2560x1440 texture bounds for seamless looping
cam_x = (cam_x + 2560) mod 2560;
cam_y = (cam_y + 1440) mod 1440;

// Exit to Main Menu on ESC
if (keyboard_check_pressed(vk_escape)) {
    var _rm_menu = asset_get_index("rm_main_menu");
    if (_rm_menu != -1 && room_exists(_rm_menu)) {
        room_goto(_rm_menu);
    } else {
        game_restart();
    }
}