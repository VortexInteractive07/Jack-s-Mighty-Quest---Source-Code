/// @description obj_jack - Step Event (Controls, Physics, Coyote Time & Void Death)

// --- 0. ANTI-STUCK SAFETY ESCAPE ---
if (place_meeting(x, y, obj_wall)) {
    y -= 1;
}

// --- 1. INPUT PROCESSING ---
var _move_left  = keyboard_check(vk_left);
var _move_right = keyboard_check(vk_right);
var _speed_up   = keyboard_check(ord("A"));     // A key to speed up / run
var _jump_press = keyboard_check_pressed(ord("S")); // S key to jump

var _current_speed = _speed_up ? run_speed : move_speed;
var _move = _move_right - _move_left;

// Wall proximity checks
var _wall_right = place_meeting(x + 1, y, obj_wall);
var _wall_left  = place_meeting(x - 1, y, obj_wall);
var _is_against_wall = (_wall_right || _wall_left) && !grounded;

hsp = _move * _current_speed;
vsp += grav;

// --- 2. WALL SLIDE LOGIC ---
if (_is_against_wall && vsp > 0) {
    vsp = min(vsp, wall_slide_speed);
    jumps_left = jump_max - 1; 
    coyote_timer = 0; 
}

// --- 3. JUMPING, COYOTE TIME, HIGHER DOUBLE JUMP & ACCELERATED AIR ABILITY ---
if (_jump_press) {
    if (grounded || coyote_timer > 0) {
        // Ground Jump or Coyote Jump (S key)
        vsp = jump_speed;
        grounded = false;
        coyote_timer = 0; 
        jumps_left = jump_max - 1;
    } 
    else if (_is_against_wall) {
        // Wall Jump
        if (_wall_left)  hsp = wall_jump_hsp;
        if (_wall_right) hsp = -wall_jump_hsp;
        vsp = wall_jump_vsp;
        jumps_left = jump_max - 1;
    } 
    else if (jumps_left > 0) {
        // Airborne Jumps
        if (_speed_up) {
            // A + S while jumping: Double Jump + Accelerated Burst
            vsp = jump_speed * 1.15; 
            var _boost_dir = (_move != 0) ? _move : image_xscale;
            hsp = _boost_dir * (run_speed * 1.4); 
            jumps_left--;
        } else {
            // Double Press S: Higher Double Jump
            vsp = jump_speed * 1.1; 
            jumps_left--;
        }
    }
}

// --- 4. HORIZONTAL COLLISION ---
if (place_meeting(x + hsp, y, obj_wall)) {
    var _h_sign = sign(hsp);
    while (!place_meeting(x + _h_sign, y, obj_wall)) {
        x += _h_sign;
    }
    hsp = 0;
}
x += hsp;

// --- 5. VERTICAL COLLISION ---
if (place_meeting(x, y + vsp, obj_wall)) {
    var _v_sign = sign(vsp);
    while (!place_meeting(x, y + _v_sign, obj_wall)) {
        y += _v_sign;
    }
    
    if (_v_sign > 0) {
        grounded = true;
    } else {
        grounded = false;
    }
    vsp = 0;
} else {
    grounded = false;
}
y += vsp;

// --- 6. COYOTE TIME & JUMP REFRESH MANAGEMENT ---
if (grounded) {
    jumps_left = jump_max;
    coyote_timer = coyote_max; 
} else {
    if (coyote_timer > 0) {
        coyote_timer--;
    }
}

// --- 7. VOID DEATH CHECK ---
// Triggers if Jack falls 64 pixels below the bottom edge of the room
if (y > room_height + 64) {
    room_restart();
}

// --- 8. SPRITE FACING & ANIMATION ---
if (_move != 0) {
    image_xscale = _move;
    if (grounded) {
        sprite_index = _speed_up ? spr_player_run : spr_player_walk;
    }
} else {
    if (grounded) {
        sprite_index = spr_player_idle;
    }
}

if (!grounded) {
    sprite_index = spr_player_jump;
}