/// @description obj_jack - Step Event (Solid Collision, Mario Wall Jump & Updated Controls)

// --- 1. INPUT PROCESSING ---
var _move_left  = keyboard_check(vk_left);
var _move_right = keyboard_check(vk_right);
var _run_hold   = keyboard_check(ord("S"));                       // S to Run / Sprint / Dash
var _jump_press = keyboard_check_pressed(ord("D"));               // D to Jump / Wall Jump

var _move = _move_right - _move_left;

// --- 2. GROUND & COYOTE EVALUATION ---
grounded = place_meeting(x, y + 1, obj_wall);

if (grounded) {
    jumps_left = jump_max;
    coyote_timer = coyote_max;
} else {
    if (coyote_timer > 0) {
        coyote_timer--;
    }
}

// --- 3. SPRINT TIMER MECHANIC ---
if (_move != 0 && _run_hold && grounded) {
    if (sprint_timer < sprint_required) {
        sprint_timer++;
    }
} else if (!grounded && _run_hold && is_sprinting) {
    sprint_timer = sprint_required;
} else {
    sprint_timer = 0;
}

is_sprinting = (sprint_timer >= sprint_required);

// Speed Calculation
var _current_speed = move_speed;
if (_run_hold) {
    _current_speed = is_sprinting ? sprint_speed : run_speed;
}

hsp = _move * _current_speed;
vsp += grav;

// --- 4. MARIO WALL SLIDE & JUMP LOGIC ---
var _wall_right = place_meeting(x + 1, y, obj_wall);
var _wall_left  = place_meeting(x - 1, y, obj_wall);

// Check if player is pushing into a wall in mid-air while falling
is_wall_sliding = false;
if (!grounded && vsp > 0) {
    if ((_wall_right && _move_right) || (_wall_left && _move_left)) {
        is_wall_sliding = true;
        vsp = min(vsp, wall_slide_speed); // Cap fall speed to slide
    }
}

// --- 5. JUMPING INPUTS ---
if (_jump_press) {
    // A. MARIO WALL JUMP
    if (is_wall_sliding || (!grounded && (_wall_right || _wall_left))) {
        var _wall_dir = _wall_right ? -1 : 1; // Kick away from the wall
        
        hsp = _wall_dir * wall_jump_hsp;
        vsp = wall_jump_vsp;
        
        image_xscale = _wall_dir;
        jumps_left = jump_max - 1; // Reset mid-air jump allowance
        coyote_timer = 0;
        
        if (instance_exists(obj_controller)) {
            obj_controller.game_score += 200;
        }
    }
    // B. STANDARD GROUND JUMP (Or Coyote Jump)
    else if (grounded || coyote_timer > 0) {
        vsp = jump_speed;
        grounded = false;
        coyote_timer = 0; 
        jumps_left = jump_max - 1;
        
        if (instance_exists(obj_controller)) {
            obj_controller.game_score += 150;
        }
    } 
    // C. DOUBLE / AIR JUMP
    else if (jumps_left > 0) {
        if (_run_hold) {
            vsp = jump_speed * 1.15; 
            var _boost_dir = (_move != 0) ? _move : image_xscale;
            hsp = _boost_dir * (_current_speed * 1.3); 
        } else {
            vsp = jump_speed * 1.1; 
        }
        jumps_left--;
        
        if (instance_exists(obj_controller)) {
            obj_controller.game_score += 250;
        }
    }
}

// --- 6. HORIZONTAL COLLISION WITH STEP-UP ---
if (place_meeting(x + hsp, y, obj_wall)) {
    var _stepped = false;
    for (var i = 1; i <= step_height; i++) {
        if (!place_meeting(x + hsp, y - i, obj_wall)) {
            y -= i;
            _stepped = true;
            break;
        }
    }
    
    if (!_stepped) {
        var _h_sign = sign(hsp);
        while (!place_meeting(x + _h_sign, y, obj_wall)) {
            x += _h_sign;
        }
        hsp = 0;
    }
}
x += hsp;

// --- 7. SOLID VERTICAL COLLISION ---
if (place_meeting(x, y + vsp, obj_wall)) {
    var _v_sign = sign(vsp);
    while (!place_meeting(x, y + _v_sign, obj_wall)) {
        y += _v_sign;
    }
    vsp = 0;
}
y += vsp;

// Re-check grounded status after movement
grounded = place_meeting(x, y + 1, obj_wall);

// --- 8. VOID DEATH CHECK ---
if (y > room_height + 64) {
    room_restart();
}

// --- 9. SPRITE FACING & ANIMATION STATE ---
if (_move != 0) {
    image_xscale = _move;
    if (grounded) {
        sprite_index = _run_hold ? spr_player_run : spr_player_walk;
        image_speed = is_sprinting ? 1.6 : 1.0;
    }
} else {
    if (grounded) {
        sprite_index = spr_player_idle;
        image_speed = 1.0;
    }
}

// All airborne states (including wall sliding) use spr_player_jump
if (!grounded) {
    sprite_index = spr_player_jump;
    image_speed = 1.0;
}