/// @description Boss AI State Machine, Physics, Contact Damage & Defeat Sequence

// ============================================================================
// 0. FAIL-SAFE DEFEAT SEQUENCE
// ============================================================================
if (hp <= 0) {
    hp = 0;
    
    // Reset global boss active state
    global.boss_active = false;
    
    // 1. Release camera lock so the viewport returns to normal tracking
    if (instance_exists(obj_camera)) {
        obj_camera.boss_lock = false;
    }
    
    // 2. Determine spawn location near player for level completion object
    var _spawn_x = x;
    var _spawn_y = y;
    
    if (instance_exists(obj_player)) {
        var _p_facing = 1;
        if (variable_instance_exists(obj_player, "facing")) {
            _p_facing = (obj_player.facing != 0) ? obj_player.facing : 1;
        }
        _spawn_x = clamp(obj_player.x + (_p_facing * 32), 16, room_width - 16);
        _spawn_y = clamp(obj_player.y - 16, 16, room_height - 16);
    }
    
    // 3. Spawn level completion flag/banner
    instance_create_depth(_spawn_x, _spawn_y, -9999, obj_levelcomplete_afterboss);
    
    instance_destroy();
    exit;
}

// ============================================================================
// 1. WAKE-UP SENSOR
// ============================================================================
if (!is_active) {
    if (instance_exists(obj_bosstrigger_area)) {
        if (obj_bosstrigger_area.triggered) {
            is_active = true;
            state = "chase";
        }
    }
    
    if (instance_exists(obj_player)) {
        if (point_distance(x, y, obj_player.x, obj_player.y) < detection_radius) {
            is_active = true;
            state = "chase";
        }
    }
}

if (hit_flash_timer > 0) hit_flash_timer--;

// ============================================================================
// 2. AI BEHAVIOR & STATE MACHINE
// ============================================================================
if (is_active && instance_exists(obj_player)) {
    facing = sign(obj_player.x - x);
    if (facing == 0) facing = 1;
    
    var _is_enraged = (hp <= (max_hp * 0.40));
    chase_speed = _is_enraged ? 2.2 : 1.6;
    var _current_shoot_interval = _is_enraged ? 60 : shoot_interval;
    
    switch (state) {
        case "chase":
            hsp = facing * chase_speed;
            shoot_timer++;
            leap_timer++;
            
            if (shoot_timer >= _current_shoot_interval) {
                state = "shoot";
                shoot_timer = 0;
                hsp = 0;
            }
            else if (leap_timer >= leap_interval && abs(obj_player.x - x) > 80) {
                state = "leap";
                leap_timer = 0;
                vsp = -jump_speed;
                hsp = facing * (chase_speed + 1.2);
            }
            break;
            
        case "shoot":
            hsp = 0;
            shoot_timer++;
            
            if (shoot_timer == 15) {
                if (object_exists(obj_projectile_enemy)) {
                    var _proj = instance_create_layer(x, y - 8, layer, obj_projectile_enemy);
                    if (instance_exists(_proj)) {
                        _proj.direction = point_direction(x, y - 8, obj_player.x, obj_player.y);
                        _proj.speed = _is_enraged ? 5.0 : 3.8;
                    }
                }
            }
            
            if (shoot_timer >= 35) {
                shoot_timer = 0;
                state = "chase";
            }
            break;
            
        case "leap":
            if (instance_exists(obj_wall) && place_meeting(x, y + 1, obj_wall) && vsp >= 0) {
                state = "chase";
                hsp = 0;
            }
            break;
    }
} else {
    hsp = 0;
}

// ============================================================================
// 3. PHYSICS & COLLISIONS
// ============================================================================
vsp += grav;

if (instance_exists(obj_wall)) {
    if (place_meeting(x + hsp, y, obj_wall)) {
        if (is_active && place_meeting(x, y + 1, obj_wall) && state == "chase") {
            vsp = -jump_speed;
        }
        while (!place_meeting(x + sign(hsp), y, obj_wall)) {
            x += sign(hsp);
        }
        hsp = 0;
    }
    x += hsp;

    if (place_meeting(x, y + vsp, obj_wall)) {
        while (!place_meeting(x, y + sign(vsp), obj_wall)) {
            y += sign(vsp);
        }
        vsp = 0;
    }
    y += vsp;
} else {
    x += hsp;
    y += vsp;
}

// ============================================================================
// 4. CONTACT DAMAGE
// ============================================================================
if (instance_exists(obj_player)) {
    var _player_inst = instance_place(x, y, obj_player);
    
    if (_player_inst != noone) {
        if (_player_inst.invulnerable_timer <= 0 && _player_inst.state != 3) {
            _player_inst.hp -= damage_val;
            _player_inst.invulnerable_timer = _player_inst.invulnerable_max;
            
            if (audio_exists(sfx_player_hurt)) {
                audio_play_sound(sfx_player_hurt, 6, false);
            }
            
            if (_player_inst.hp <= 0) {
                _player_inst.hp = 0;
                _player_inst.state = 3; 
                
                if (instance_exists(obj_controller)) {
                    obj_controller.player_dead = true;
                    obj_controller.death_reason = "Slain by " + boss_name;
                    global.player_lives -= 1;
                    audio_stop_all();
                    
                    if (audio_exists(mus_life_lost)) {
                        audio_play_sound(mus_life_lost, 10, false);
                    }
                    
                    obj_controller.is_transitioning = true;
                    obj_controller.transition_timer = 0;
                }
            } else {
                _player_inst.state = 2;
                var _push_dir = sign(_player_inst.x - x);
                if (_push_dir == 0) _push_dir = 1; 
                _player_inst.hsp = _push_dir * knockback_speed;
                _player_inst.vsp = -3.0; 
            }
        }
    }
}