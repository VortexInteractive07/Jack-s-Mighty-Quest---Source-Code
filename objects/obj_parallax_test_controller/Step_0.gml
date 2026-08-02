/// @description Process Camera Movement, NES Auto-Scroll & Jim Power 3D Parallax Mode

var _move_left  = keyboard_check(vk_left);
var _move_right = keyboard_check(vk_right);
var _press_i    = keyboard_check_pressed(ord("I"));
var _press_j    = keyboard_check_pressed(ord("J"));

// keyboard_check allows continuous, instantaneous adjustment when holding down +/-
var _hold_plus  = keyboard_check(vk_add) || keyboard_check(187); 
var _hold_minus = keyboard_check(vk_subtract) || keyboard_check(189); 

if (_press_i) {
    auto_scroll_enabled = !auto_scroll_enabled;
    if (auto_scroll_enabled) jim_power_mode = false; // mutually exclusive
}

if (_press_j) {
    jim_power_mode = !jim_power_mode;
    if (jim_power_mode) auto_scroll_enabled = false; // override standard auto-scroll
}

// Handle Movement Speeds & Auto-Scroll Mechanics
if (jim_power_mode) {
    if (_hold_plus)  { jim_power_speed += 0.15; }
    if (_hold_minus) { jim_power_speed = max(0.5, jim_power_speed - 0.15); }
    
    cam_x += jim_power_speed;
} 
else if (auto_scroll_enabled) {
    if (_hold_plus)  { auto_scroll_speed += 0.15; }
    if (_hold_minus) { auto_scroll_speed = max(0.2, auto_scroll_speed - 0.15); }
    
    cam_x += auto_scroll_speed;
} 
else {
    if (_move_left)  { cam_x -= cam_speed; }
    if (_move_right) { cam_x += cam_speed; }
}

if (view_camera[0] != -1) {
    camera_set_view_pos(view_camera[0], 0, 0);
}

// Update layer horizontal positions with Jim Power inverted depth multipliers if active
for (var i = 0; i < array_length(layer_data); i++) {
    var _l = layer_data[i];
    
    if (jim_power_mode) {
        _l.scroll_acc += (_l.auto_spd + (_l.factor * 0.5)) * bg_speed_modifier;
        
        var _jim_factor = _l.factor;
        
        // Include Background, bg_far, and bg_mid (factor <= 0.35) to drift right
        if (_l.factor <= 0.35) {
            _jim_factor = -_l.factor * 1.5; // Far and mid/mountain layers drift right
        } else {
            _jim_factor = _l.factor * 2.2; // Near layers aggressively rush left
        }
        
        var _final_x = (-cam_x * _jim_factor) + _l.scroll_acc;
        if (_l.id != -1) layer_x(_l.id, _final_x);
        
    } else {
        _l.scroll_acc += _l.auto_spd * bg_speed_modifier;
        
        if (_l.id != -1) {
            var _final_x = (-cam_x * _l.factor) + _l.scroll_acc;
            layer_x(_l.id, _final_x);
        }
    }
}

if (keyboard_check_pressed(vk_escape)) {
    if (room_exists(rm_main_menu)) {
        room_goto(rm_main_menu);
    } else {
        game_restart();
    }
}