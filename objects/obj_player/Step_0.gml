/// @description Process State Machine, Inputs, Physics, Slopes & Debug Features

// ============================================================================
// --- 0. CRITICAL MASK LOCK ---
// ============================================================================
if (sprite_exists(spr_player_mask) && mask_index != spr_player_mask) {
    mask_index = spr_player_mask;
}

// ============================================================================
// --- 1. INPUT SYSTEM & F12 DEBUG CHEATS ---
// ============================================================================
var _key_left         = keyboard_check(vk_left);
var _key_right        = keyboard_check(vk_right);
var _key_jump         = keyboard_check_pressed(ord("D"));
var _key_jump_release = keyboard_check_released(ord("D"));
var _key_run          = keyboard_check(ord("S"));
var _key_massacre     = keyboard_check(ord("F"));

if (keyboard_check_pressed(vk_f12)) {
    speedrunner_mode = !speedrunner_mode;
    
    if (!speedrunner_mode) {
        always_dash_mode = false;
        god_infinite_hp  = false;
        god_no_pit_fall  = false;
        god_block_enemy  = false;
    } else {
        if (audio_exists(sfx_whoosh)) audio_play_sound(sfx_whoosh, 2, false);
    }
}

if (speedrunner_mode) {
    if (keyboard_check_pressed(ord("C"))) always_dash_mode = !always_dash_mode;
    if (keyboard_check_pressed(ord("L"))) {
        god_infinite_hp = !god_infinite_hp;
        if (god_infinite_hp) hp = hp_max;
    }
    if (keyboard_check_pressed(ord("P"))) god_no_pit_fall = !god_no_pit_fall;
    if (keyboard_check_pressed(ord("H"))) god_block_enemy = !god_block_enemy;
}

if (god_infinite_hp) hp = hp_max;

var _key_boost_combo = (!always_dash_mode) && 
                      ((keyboard_check(ord("S")) && keyboard_check_pressed(ord("C"))) || 
                       (keyboard_check(ord("C")) && keyboard_check_pressed(ord("S"))));

var _move = _key_right - _key_left;

if (speedrunner_mode) {
    walk_speed   = base_walk_speed * 1.6;
    run_speed    = base_run_speed * 1.8;
    jump_height  = base_jump_height * 1.25;
    accel        = 0.75;
} else {
    walk_speed   = base_walk_speed;
    run_speed    = base_run_speed;
    jump_height  = base_jump_height;
    accel        = base_accel;
}

// ============================================================================
// --- 2. TIMERS & BUFFERS ---
// ============================================================================
if (invulnerable_timer > 0) invulnerable_timer--;
if (jump_buffer_timer > 0)  jump_buffer_timer--;
if (boost_timer > 0)        boost_timer--;

if (_key_jump) jump_buffer_timer = jump_buffer_max;

if ((_key_boost_combo || always_dash_mode) && state == 0) {
    boost_timer = boost_duration;
    if (_key_boost_combo && audio_exists(sfx_whoosh)) audio_play_sound(sfx_whoosh, 1, false);
    if (_move == 0) hsp = facing * boost_speed;
}

var _on_ground = place_meeting(x, y + 1, obj_wall);

var _target_max_speed = (_key_run || always_dash_mode) ? run_speed : walk_speed;
if (boost_timer > 0) _target_max_speed = boost_speed;


// ============================================================================
// --- BACKWARDS LONG JUMP (BLJ) MECHANIC ---
// ============================================================================
if (_key_left && _key_right && _key_jump && _on_ground) {
    hsp = 15.0; // Shoot aggressively to the right
    facing = -1; // Face backwards (left)
    vsp = jump_height * 0.8; // Specialized trajectory 
    coyote_timer = 0;
    jump_buffer_timer = 0;
    state = 0;
    if (audio_exists(sfx_jump)) audio_play_sound(sfx_jump, 1, false);
}


// ============================================================================
// --- 3. STATE MACHINE ---
// ============================================================================
switch (state) {
    case 0: // === NORMAL / MOVEMENT ===
        var _is_reversing = (_move != 0 && sign(_move) != sign(hsp) && abs(hsp) > 1.5);
        
        if (_is_reversing && _on_ground && boost_timer <= 0 && !always_dash_mode) {
            state = 1;
            break;
        }

        // Only process normal acceleration if not performing a BLJ sequence
        if (!(_key_left && _key_right)) {
            if (_move != 0) {
                var _acc = (boost_timer > 0) ? 0.85 : (_on_ground ? accel : air_accel);
                hsp = lerp(hsp, _move * _target_max_speed, _acc);
                facing = _move;
            } else if (boost_timer > 0) {
                hsp = lerp(hsp, facing * boost_speed, 0.20);
            } else {
                var _decel = _on_ground ? fric : air_fric;
                hsp = lerp(hsp, 0, _decel);
                if (abs(hsp) < 0.1) hsp = 0;
            }
        }

        if (!_on_ground) {
            vsp += grv;
            if (coyote_timer > 0) coyote_timer--;
        } else {
            coyote_timer = coyote_max;
        }

        if (jump_buffer_timer > 0 && coyote_timer > 0 && !(_key_left && _key_right)) {
            vsp = jump_height;
            coyote_timer = 0;
            jump_buffer_timer = 0;
            if (audio_exists(sfx_jump)) audio_play_sound(sfx_jump, 1, false);
            
            if (variable_global_exists("stats")) global.stats.total_jumps += 1;
        }

        if (_key_jump_release && vsp < -1.5) vsp *= 0.45;

        if (_key_massacre && object_exists(obj_projectile)) {
            if (audio_exists(sfx_shoot)) audio_play_sound(sfx_shoot, 1, false);
            repeat (3) {
                var _proj = instance_create_layer(x + (facing * 12), y - 8 + irandom_range(-6, 6), "Instances", obj_projectile);
                if (instance_exists(_proj)) {
                    _proj.hspeed = (facing * irandom_range(8, 14));
                    _proj.vspeed = irandom_range(-3, 3);
                }
            }
        }
        break;

    case 1: // === SKIDDING ===
        hsp = lerp(hsp, 0, skid_fric);
        if (!_on_ground) vsp += grv;

        if (abs(hsp) <= 0.8 || _move == 0 || sign(_move) == sign(hsp)) {
            state = 0;
        }
        break;

    case 2: // === HURT ===
        vsp += grv;
        hsp = lerp(hsp, 0, 0.08);

        if (_on_ground && invulnerable_timer <= invulnerable_max - 15) {
            state = 0;
        }
        break;

    case 3: // === DEATH ===
        hsp = lerp(hsp, 0, 0.15);
        if (!_on_ground) vsp += grv;
        break;
}

if (!variable_instance_exists(id, "death_recorded")) death_recorded = false;

if (state == 3) {
    if (!death_recorded) {
        if (variable_global_exists("stats")) global.stats.total_deaths += 1;
        death_recorded = true;
    }
} else {
    death_recorded = false;
}

// ============================================================================
// --- 4. PRECISE COLLISIONS, SLOPE FIXES & PIT PROTECTION ---
// ============================================================================
if (god_no_pit_fall) {
    if (y > room_height || y < 0) {
        vsp = jump_height * 1.5; 
        if (y < 0) y = 16;
    }
}

if (place_meeting(x, y, obj_wall)) {
    var _attempts = 0;
    while (place_meeting(x, y, obj_wall) && _attempts < 16) {
        y -= 1;
        _attempts++;
    }
}

var _stepped_up = false;
var _sub_h = sign(hsp);

if (place_meeting(x + hsp, y, obj_wall)) {
    var _max_slope_height = 12;
    for (var _step = 1; _step <= _max_slope_height; _step++) {
        if (!place_meeting(x + hsp, y - _step, obj_wall)) {
            y -= _step;
            _stepped_up = true;
            break;
        }
    }
    
    if (!_stepped_up) {
        while (!place_meeting(x + _sub_h, y, obj_wall)) x += _sub_h;
        hsp = 0;
    }
}
x += hsp;

if (_on_ground && !_stepped_up && vsp >= 0 && !place_meeting(x, y + 1, obj_wall)) {
    for (var _down = 1; _down <= 8; _down++) {
        if (place_meeting(x, y + _down, obj_wall)) {
            y += (_down - 1);
            break;
        }
    }
}

var _sub_v = sign(vsp);
if (place_meeting(x, y + vsp, obj_wall)) {
    while (!place_meeting(x, y + _sub_v, obj_wall)) y += _sub_v;
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
                    if (sprite_exists(spr_player_fall))            sprite_index = spr_player_fall;
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

if (sprite_exists(spr_player_mask)) mask_index = spr_player_mask;

if (_last_sprite != sprite_index) {
    image_index = 0;
    image_speed = 1.0;
}

if (sprite_index == spr_player_run) {
    image_speed = clamp(abs(hsp) / run_speed, 0.4, 2.8);
}

// ============================================================================
// --- 6. FLASH SPEED TRAIL FX ---
// ============================================================================
for (var i = array_length(trail_history) - 1; i >= 0; i--) {
    trail_history[i].alpha -= (boost_timer > 0 || speedrunner_mode) ? 0.08 : 0.12;
    if (trail_history[i].alpha <= 0) array_delete(trail_history, i, 1);
}

var _is_flash_speed = (abs(hsp) >= 9.0 || boost_timer > 0 || always_dash_mode) && state == 0;
var _current_delay  = (boost_timer > 0 || always_dash_mode) ? 1 : trail_spawn_delay;

if (_is_flash_speed) {
    trail_spawn_timer++;
    if (trail_spawn_timer >= _current_delay) {
        trail_spawn_timer = 0;
        
        var _trail_color = speedrunner_mode ? c_fuchsia : 
                          ((boost_timer > 0) ? ((array_length(trail_history) % 2 == 0) ? c_yellow : c_white) : 
                           ((array_length(trail_history) % 2 == 0) ? c_aqua : c_white));
        
        array_push(trail_history, {
            sprite:      sprite_index,
            frame:       image_index,
            x_pos:       round(x),
            y_pos:       round(y + draw_y_offset),
            facing_dir:  facing,
            color:       _trail_color,
            alpha:       0.95
        });
        
        if (array_length(trail_history) > trail_max) array_delete(trail_history, 0, 1);
    }
} else {
    trail_spawn_timer = 0;
}