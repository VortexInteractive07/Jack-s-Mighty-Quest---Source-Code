/// @description obj_jack - Step Event (Solid Collision, Mario Wall Jump & Updated Controls)

if ((variable_global_exists("inventory_open") && global.inventory_open)
|| (variable_global_exists("guidebook_open") && global.guidebook_open)) exit;

if (is_dead) {
    var _death_wind_push = 0;
    if (instance_exists(obj_controller)) {
        var _death_controller = instance_find(obj_controller, 0);
        if (_death_controller.stage2_storm) _death_wind_push = _death_controller.wind_speed_mph * 0.012;
    }
    hsp -= _death_wind_push;
    vsp = min(vsp + grav, 8);
    x += hsp;
    y += vsp;

    if (y > room_height + 32 && instance_exists(obj_controller)) {
        obj_controller.resolve_player_death();
    }
    exit;
}

if (damage_invulnerability_timer > 0) damage_invulnerability_timer--;

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

// Stage 2's westward 50 mph gust reduces forward control and pushes Jack left.
if (instance_exists(obj_controller)) {
    var _wind_controller = instance_find(obj_controller, 0);
    if (_wind_controller.stage2_storm && _wind_controller.wind_speed_mph > 0) {
        var _wind_ratio = clamp(_wind_controller.wind_speed_mph / 50, 0, 1);
        var _wind_push = _wind_controller.wind_speed_mph * 0.012;
        var _wind_drag = 0.20 * _wind_ratio;
        hsp = (hsp * (1 - _wind_drag)) - _wind_push;
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
    hp = 0;
    scr_trigger_player_death();
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

// Mario Stomp on Boss
if (instance_exists(obj_melonhead_proto)) {
    var _boss_inst = instance_place(x, y, obj_melonhead_proto);
    if (_boss_inst != noone && !_boss_inst.defeated && _boss_inst.state != BOSS_STATE.WAIT) {
        if (vsp > 0 && y < _boss_inst.y + 16) {
            _boss_inst.take_damage(max(1, round(16 * damage_multiplier)));
            vsp = -7.0; // Stomp bounce
            jumps_left = jump_max;
            coyote_timer = coyote_max;
            if (audio_exists(sfx_enemy_hit)) {
                var _hit_snd = audio_play_sound(sfx_enemy_hit, 9, false);
                audio_sound_gain(_hit_snd, global.vol_sfx / 100, 0);
            }
            if (audio_exists(sfx_jump)) {
                var _bounce_snd = audio_play_sound(sfx_jump, 7, false);
                audio_sound_gain(_bounce_snd, (global.vol_sfx / 100) * 0.7, 0);
            }
        }
    }
}

// Melee attack logic
if (attack_cooldown > 0) attack_cooldown--;
var _attack_key = keyboard_check_pressed(ord("X")) || keyboard_check_pressed(ord("K"))
    || (gamepad_is_connected(0) && (gamepad_button_check_pressed(0, gp_face3) || gamepad_button_check_pressed(0, gp_face4)));

if (_attack_key && attack_cooldown <= 0) {
    attack_cooldown = attack_cooldown_max;
    if (audio_exists(sfx_shoot)) {
        var _swing = audio_play_sound(sfx_shoot, 6, false);
        audio_sound_gain(_swing, (global.vol_sfx / 100) * 0.6, 0);
    }
    if (instance_exists(obj_melonhead_proto)) {
        var _boss = instance_find(obj_melonhead_proto, 0);
        if (point_distance(x, y, _boss.x, _boss.y) <= attack_range
        && sign(_boss.x - x) == sign(image_xscale)) {
            _boss.take_damage(max(1, round(12 * damage_multiplier)));
        }
    }
}

// Hold F for rapid, unlimited plasma fire in Jack's facing direction.
if (projectile_cooldown > 0) projectile_cooldown--;
if (keyboard_check(ord("F")) && projectile_cooldown <= 0) {
    projectile_cooldown = 9;
    var _shot_dir = (image_xscale < 0) ? -1 : 1;
    var _shot_layer = layer_exists("Projectiles") ? "Projectiles" : "Instances";
    var _shot = instance_create_layer(x + (14 * _shot_dir), y - 8, _shot_layer, obj_plasma_wave);
    if (instance_exists(_shot)) {
        _shot.sprite_index = (_shot_dir > 0) ? spr_pwave_right : spr_pwave_left;
        _shot.hspeed = 9 * _shot_dir;
        _shot.damage = 7;
    }
    if (audio_exists(sfx_shoot)) {
        var _shot_sfx = audio_play_sound(sfx_shoot, 6, false);
        audio_sound_gain(_shot_sfx, (global.vol_sfx / 100) * 0.45, 0);
    }
}

// G fires a five-lane Massacre volley; the longer cooldown keeps the burst special.
if (massacre_cooldown > 0) massacre_cooldown--;
if (keyboard_check_pressed(ord("G")) && massacre_cooldown <= 0) {
    massacre_cooldown = game_get_speed(gamespeed_fps);
    var _massacre_dir = (image_xscale < 0) ? -1 : 1;
    var _massacre_layer = layer_exists("Projectiles") ? "Projectiles" : "Instances";
    for (var _volley_i = -2; _volley_i <= 2; _volley_i++) {
        var _volley_shot = instance_create_layer(x + (14 * _massacre_dir), y - 8 + (_volley_i * 8), _massacre_layer, obj_plasma_wave);
        if (instance_exists(_volley_shot)) {
            _volley_shot.sprite_index = (_massacre_dir > 0) ? spr_pwave_right : spr_pwave_left;
            _volley_shot.hspeed = 9 * _massacre_dir;
            _volley_shot.damage = 7;
        }
    }
    if (audio_exists(sfx_explosion)) {
        var _massacre_sfx = audio_play_sound(sfx_explosion, 7, false);
        audio_sound_gain(_massacre_sfx, global.vol_sfx / 100, 0);
    }
}
