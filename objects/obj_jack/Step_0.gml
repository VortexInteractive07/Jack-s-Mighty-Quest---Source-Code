/// @description obj_jack - Step Event (Bottom-Centre Collision Fix)

// --- 1. INPUT PROCESSING ---
var _move_left  = keyboard_check(ord("A")) || keyboard_check(vk_left);
var _move_right = keyboard_check(ord("D")) || keyboard_check(vk_right);
var _run_held   = keyboard_check(vk_shift);
var _jump_press = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));

var _current_speed = _run_held ? run_speed : move_speed;
var _move = _move_right - _move_left;

hsp = _move * _current_speed;
vsp += grav;

// --- 2. JUMPING ---
if (grounded && _jump_press) {
    vsp = jump_speed;
    grounded = false;
}

// --- 3. HORIZONTAL COLLISION ---
if (place_meeting(x + hsp, y, obj_wall)) {
    var _h_sign = sign(hsp);
    while (!place_meeting(x + _h_sign, y, obj_wall)) {
        x += _h_sign;
    }
    hsp = 0;
}
x += hsp;

// --- 4. VERTICAL COLLISION ---
if (place_meeting(x, y + vsp, obj_wall)) {
    var _v_sign = sign(vsp);
    while (!place_meeting(x, y + _v_sign, obj_wall)) {
        y += _v_sign;
    }
    
    if (vsp > 0) {
        grounded = true;
    } else {
        grounded = false;
    }
    vsp = 0;
} else {
    grounded = false;
}
y += vsp;

// --- 5. SPRITE FACING & ANIMATION ---
if (_move != 0) {
    image_xscale = _move;
    if (grounded) {
        sprite_index = _run_held ? spr_player_run : spr_player_walk;
    }
} else {
    if (grounded) {
        sprite_index = spr_player_idle;
    }
}

if (!grounded) {
    sprite_index = spr_player_jump;
}