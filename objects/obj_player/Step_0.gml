/// @description Process State Machine, Inputs, Physics, Slopes & FX

// ============================================================================
// --- 0. CRITICAL MASK LOCK ---
// Force mask_index back to spr_player_mask so 128x128 visuals never expand physics
// ============================================================================
if (sprite_exists(spr_player_mask) && mask_index != spr_player_mask) {
    mask_index = spr_player_mask;
}

// ============================================================================
// --- 1. INPUT SYSTEM ---
// ============================================================================
var _key_left         = keyboard_check(vk_left);
var _key_right        = keyboard_check(vk_right);
var _key_jump         = keyboard_check_pressed(ord("D"));
var _key_jump_release = keyboard_check_released(ord("D"));
var _key_run          = keyboard_check(ord("S"));
var _key_massacre     = keyboard_check(ord("F"));

// S + C Super Boost Combination
var _key_boost_combo = (keyboard_check(ord("S")) && keyboard_check_pressed(ord("C"))) || 
                       (keyboard_check(ord("C")) && keyboard_check_pressed(ord("S")));

var _move = _key_right - _key_left;

// ============================================================================
// --- 2. TIMERS & BUFFERS ---
// ============================================================================
if (invulnerable_timer > 0) invulnerable_timer--;
if (jump_buffer_timer > 0)  jump_buffer_timer--;
if (boost_timer > 0)        boost_timer--;

if (_key_jump) {
    jump_buffer_timer = jump_buffer_max;
}

// Trigger Super Boost (S + C)
if (_key_boost_combo && state == 0) {
    boost_timer = boost_duration;
    
    if (audio_exists(sfx_whoosh)) {
        audio_play_sound(sfx_whoosh, 1, false);
    }
    
    if (_move == 0) {
        hsp = facing * boost_speed;
    }
}

// Ground check includes walls and solid entities (like Mark if applicable)
var _on_ground = place_meeting(x, y + 1, obj_wall);

// Dynamic Max Speed Selection
var _target_max_speed = _key_run ? run_speed : walk_speed;
if (boost_timer > 0) {
    _target_max_speed = boost_speed;
}

// ============================================================================
// --- 3. STATE MACHINE (KINEMATICS & BEHAVIOR) ---
// ============================================================================
switch (state) {
    case 0: // === NORMAL / MOVEMENT STATE ===
        var _is_reversing = (_move != 0 && sign(_move) != sign(hsp) && abs(hsp) > 1.5);
        
        if (_is_reversing && _on_ground && boost_timer <= 0) {
            state = 1; // Transition to Skidding
            break;
        }

        // Horizontal Movement Dynamics
        if (_move != 0) {
            var _acc = (boost_timer > 0) ? 0.80 : (_on_ground ? accel : air_accel);
            hsp = lerp(hsp, _move * _target_max_speed, _acc);
            facing = _move;
        } else if (boost_timer > 0) {
            hsp = lerp(hsp, facing * boost_speed, 0.20);
        } else {
            var _decel = _on_ground ? fric : air_fric;
            hsp = lerp(hsp, 0, _decel);
            if (abs(hsp) < 0.1) hsp = 0;
        }

        // Coyote Timer Management
        if (!_on_ground) {
            vsp += grv;
            if (coyote_timer > 0) coyote_timer--;
        } else {
            coyote_timer = coyote_max;
        }

        // Manual Jump Trigger
        if (jump_buffer_timer > 0 && coyote_timer > 0) {
            vsp = jump_height;
            coyote_timer = 0;
            jump_buffer_timer = 0;
            if (audio_exists(sfx_jump)) {
                audio_play_sound(sfx_jump, 1, false);
            }
        }

        // Variable Jump Height (Short Hop)
        if (_key_jump_release && vsp < -1.5) {
            vsp *= 0.45;
        }

        // Projectile Spray Easter Egg
        if (_key_massacre && object_exists(obj_projectile)) {
            if (audio_exists(sfx_shoot)) {
                audio_play_sound(sfx_shoot, 1, false);
            }
            repeat (3) {
                var _proj = instance_create_layer(x + (facing * 12), y - 8 + irandom_range(-6, 6), "Instances", obj_projectile);
                if (instance_exists(_proj)) {
                    _proj.hspeed = (facing * irandom_range(8, 14));
                    _proj.vspeed = irandom_range(-3, 3);
                }
            }
        }
        break;

    case 1: // === SKIDDING / QUICK TURN STATE ===
        hsp = lerp(hsp, 0, skid_fric);
        if (!_on_ground) vsp += grv;

        if (abs(hsp) <= 0.8 || _move == 0 || sign(_move) == sign(hsp)) {
            state = 0;
        }
        break;

    case 2: // === HURT / STUNNED STATE ===
        vsp += grv;
        hsp = lerp(hsp, 0, 0.08);

        if (_on_ground && invulnerable_timer <= invulnerable_max - 15) {
            state = 0;
        }
        break;

    case 3: // === DEATH STATE ===
        hsp = lerp(hsp, 0, 0.15);
        if (!_on_ground) vsp += grv;
        break;
}

// ============================================================================
// --- 4. PRECISE COLLISIONS & SLOPE CLIMBING ---
// ============================================================================

// --- 4A. EMERGENCY UNSTUCK CHECK ---
if (place_meeting(x, y, obj_wall)) {
    var _unstuck_attempts = 0;
    while (place_meeting(x, y, obj_wall) && _unstuck_attempts < 16) {
        y -= 1;
        _unstuck_attempts++;
    }
}

// --- 4B. HORIZONTAL COLLISIONS & SLOPE STEP-UP ---
var _stepped_up = false;

if (place_meeting(x + hsp, y, obj_wall)) {
    var _max_slope_height = 8;
    
    // Check climbable slope or step
    for (var _step = 1; _step <= _max_slope_height; _step++) {
        if (!place_meeting(x + hsp, y - _step, obj_wall)) {
            y -= _step;
            _stepped_up = true;
            break;
        }
    }
    
    // Solid wall collision
    if (!_stepped_up) {
        while (!place_meeting(x + sign(hsp), y, obj_wall)) {
            x += sign(hsp);
        }
        hsp = 0;
    }
}
x += hsp;

// --- 4C. DOWNWARD SLOPE SNAPPING ---
if (_on_ground && !_stepped_up && vsp >= 0 && !place_meeting(x, y + 1, obj_wall)) {
    for (var _down = 1; _down <= 8; _down++) {
        if (place_meeting(x, y + _down, obj_wall)) {
            y += (_down - 1);
            break;
        }
    }
}

// --- 4D. VERTICAL COLLISIONS ---
if (place_meeting(x, y + vsp, obj_wall)) {
    while (!place_meeting(x, y + sign(vsp), obj_wall)) {
        y += sign(vsp);
    }
    vsp = 0;
}
y += vsp;

// ============================================================================
// --- 5. ANIMATION STATE MACHINE ---
// ============================================================================
var _last_sprite = sprite_index;

switch (state) {
    case 0:
    case 1:
        if (!_on_ground) {
            if (vsp < -1.0) {
                if (sprite_exists(spr_player_jump)) sprite_index = spr_player_jump;
            } else if (vsp >= -1.0 && vsp <= 1.0) {
                if (sprite_exists(spr_player_surface_fall)) sprite_index = spr_player_surface_fall;
                else if (sprite_exists(spr_player_fall))         sprite_index = spr_player_fall;
            } else {
                if (sprite_index != spr_player_fall && sprite_index != spr_player_fall_loop) {
                    if (sprite_exists(spr_player_fall))           sprite_index = spr_player_fall;
                    else if (sprite_exists(spr_player_fall_loop)) sprite_index = spr_player_fall_loop;
                }
            }
        } else {
            if (abs(hsp) > 0.5) {
                if (sprite_exists(spr_player_run)) sprite_index = spr_player_run;
            } else {
                if (sprite_exists(spr_player_idle)) sprite_index = spr_player_idle;
            }
        }
        break;

    case 2:
        if (sprite_exists(spr_player_hurt)) sprite_index = spr_player_hurt;
        break;

    case 3:
        if (sprite_exists(spr_player_death)) sprite_index = spr_player_death;
        break;
}

// Re-enforce mask lock post-animation assignment
if (sprite_exists(spr_player_mask)) {
    mask_index = spr_player_mask;
}

if (_last_sprite != sprite_index) {
    image_index = 0;
    image_speed = 1.0;
}

if (sprite_index == spr_player_run) {
    image_speed = clamp(abs(hsp) / run_speed, 0.4, 2.5);
}

// ============================================================================
// --- 6. FLASH SPEED TRAIL FX MANAGEMENT ---
// ============================================================================
for (var i = array_length(trail_history) - 1; i >= 0; i--) {
    trail_history[i].alpha -= (boost_timer > 0) ? 0.07 : 0.10;
    if (trail_history[i].alpha <= 0) {
        array_delete(trail_history, i, 1);
    }
}

var _is_flash_speed = (abs(hsp) >= 9.0 || boost_timer > 0) && state == 0;
var _current_delay  = (boost_timer > 0) ? 1 : trail_spawn_delay;

if (_is_flash_speed) {
    trail_spawn_timer++;
    
    if (trail_spawn_timer >= _current_delay) {
        trail_spawn_timer = 0;
        
        var _trail_color = (boost_timer > 0) ? 
            ((array_length(trail_history) % 2 == 0) ? c_yellow : c_white) : 
            ((array_length(trail_history) % 2 == 0) ? c_aqua : c_white);
        
        array_push(trail_history, {
            sprite:     sprite_index,
            frame:      image_index,
            x_pos:      round(x),
            y_pos:      round(y + draw_y_offset),
            facing_dir: facing,
            color:      _trail_color,
            alpha:      0.90
        });
        
        if (array_length(trail_history) > trail_max) {
            array_delete(trail_history, 0, 1);
        }
    }
} else {
    trail_spawn_timer = 0;
}