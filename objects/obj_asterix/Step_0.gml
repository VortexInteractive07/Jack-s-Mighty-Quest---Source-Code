/// @description Pro-Max AI: Manual Input & Clean Follow Physics

var _player = obj_player;
if (!instance_exists(_player)) exit;

// Reset shooting flag each frame
is_asterix_shooting = false;

// Decrement fire cooldown timer
if (fire_cooldown > 0) fire_cooldown--;

// =================================================================
// 1. STATE MACHINE & INPUT HANDLING
// =================================================================
switch (state) {
    case 0: // NORMAL / FOLLOW MODE
        // --- MANUAL ATTACK TRIGGERS ---
        // Press 'T' to launch PAF! Attack
        if (keyboard_check_pressed(ord("T"))) { 
            state = 2; 
            paf_timer = paf_duration; 
        }

        // --- NAVIGATION LOGIC (STAYS WITH PLAYER) ---
        var _p_facing = variable_instance_exists(_player, "facing") ? _player.facing : 1;
        var _dest_x = _player.x + (follow_offset_x * _p_facing);
        
        // Horizontal Movement
        var _target_hsp = sign(_dest_x - x) * walk_speed;
        if (abs(_dest_x - x) < 16) _target_hsp = 0; // Stop smoothly near target
        hsp = lerp(hsp, _target_hsp, accel);
        if (hsp != 0) facing = sign(hsp);

        // =========================================================
        // MANUAL SHOOTING INPUT LOGIC
        // =========================================================
        var _press_massacre = keyboard_check(ord("F"));
        var _press_single   = keyboard_check_pressed(ord("G")) || keyboard_check_pressed(vk_space);

        // --- A. MASSACRE MODE (F Key) ---
        if (_press_massacre) {
            is_asterix_shooting = true;
            if (fire_cooldown <= 0) {
                var _p = instance_create_depth(x + (16 * facing), y - 8, depth - 10, obj_projectile);
                if (instance_exists(_p)) { 
                    _p.hspeed = facing * 16; 
                    _p.asterix_processed = true; 
                }
                fire_cooldown = 6; // Rapid-fire speed
            }
        }
        // --- B. REGULAR SINGLE BULLET (G Key or Spacebar) ---
        else if (_press_single) {
            is_asterix_shooting = true;
            if (fire_cooldown <= 0) {
                var _p = instance_create_depth(x + (16 * facing), y - 8, depth - 10, obj_projectile);
                if (instance_exists(_p)) { 
                    _p.hspeed = facing * 14; 
                    _p.asterix_processed = true; 
                }
                fire_cooldown = single_fire_delay; // 1.5-second delay (90 frames)
            }
        }

        // --- INTENTIONAL JUMP LOGIC ONLY ---
        var _on_ground = place_meeting(x, y + 1, obj_wall);
        if (_on_ground) coyote_timer = coyote_max;
        else coyote_timer = max(0, coyote_timer - 1);

        // Jump ONLY if player jumps OR an obstacle is directly blocking the path
        var _wall_ahead = place_meeting(x + (facing * 16), y, obj_wall);
        var _player_jumping = (_player.vsp < -1);

        if (coyote_timer > 0 && (_player_jumping || _wall_ahead)) {
            vsp = jump_height;
        }
        break;

    case 2: // PAF! ATTACK / INSTANT SLAY DASH
        hsp = facing * 12; 
        vsp = 0;
        
        // Slay enemies directly in dash path
        var _e = collision_rectangle(x, y - 16, x + (80 * facing), y + 16, obj_enemy_parent, false, true);
        if (_e != noone) {
            with (_e) instance_destroy();
        }

        paf_timer--;
        if (paf_timer <= 0) state = 0;
        break;

    case 3: // RESPAWN RECOVERY
        var _spawn_x = _player.x + (48 * _player.facing);
        if (place_meeting(_spawn_x, _player.y, obj_wall)) _spawn_x = _player.x - (48 * _player.facing);
        x = _spawn_x; 
        y = _player.y;
        hsp = 0; vsp = 0; 
        invulnerable_timer = 120; 
        state = 0;
        break;
}

// =================================================================
// 2. UNIVERSAL PHYSICS & COLLISION
// =================================================================
if (y > room_height + 64) state = 3; 
if (state != 2) vsp += grv; 

// Horizontal Collision
if (place_meeting(x + hsp, y, obj_wall)) {
    while (!place_meeting(x + sign(hsp), y, obj_wall)) x += sign(hsp);
    hsp = 0;
}
x += hsp;

// Vertical Collision
if (place_meeting(x, y + vsp, obj_wall)) {
    while (!place_meeting(x + sign(vsp), y, obj_wall)) y += sign(vsp);
    vsp = 0;
}
y += vsp;

// =================================================================
// 3. ANIMATION CONTROLLER
// =================================================================
var _is_grounded = place_meeting(x, y + 1, obj_wall);

if (state == 2 || is_asterix_shooting) {
    sprite_index = spr_asterix_paf;
} 
else if (!_is_grounded) {
    sprite_index = spr_asterix_jump;
} 
else if (abs(hsp) > 0.2) {
    sprite_index = spr_asterix_run;
} 
else {
    sprite_index = spr_asterix_idle;
}