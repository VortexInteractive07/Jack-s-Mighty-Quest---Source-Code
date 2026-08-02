/// @description Minecraft Slime Hopping Logic
event_inherited();

if (!instance_exists(obj_player)) exit;

var _on_ground = place_meeting(x, y + 1, obj_wall);

// 1. LANDING RESOLUTION
if (_on_ground) {
    hsp = 0; // Stop horizontal slide upon landing
    
    if (is_jumping) {
        is_jumping = false;
        
        // Calculate distance to player to determine next jump cooldown interval
        var _dist = distance_to_object(obj_player);
        var _clamped_dist = clamp(_dist, 32, 300);
        
        // Linear interpolation: closer distance = shorter delay
        jump_cooldown = lerp(min_jump_delay, base_jump_delay, (_clamped_dist - 32) / (300 - 32));
    }
} else {
    // Apply gravity while mid-air
    vsp += grv;
}

// 2. JUMP COOLDOWN TICKER
if (_on_ground && !is_jumping) {
    if (jump_cooldown > 0) {
        jump_cooldown--;
    } else {
        // TRIGGER JUMP
        is_jumping = true;
        vsp = jump_force_y;
        
        // Face and leap toward player
        facing = sign(obj_player.x - x);
        if (facing == 0) facing = 1;
        hsp = facing * jump_force_x;
    }
}

// 3. COLLISION RESOLUTION
if (place_meeting(x + hsp, y, obj_wall)) {
    while (!place_meeting(x + sign(hsp), y, obj_wall)) x += sign(hsp);
    hsp = 0;
}
x += hsp;

if (place_meeting(x, y + vsp, obj_wall)) {
    while (!place_meeting(x + sign(vsp), y, obj_wall)) y += sign(vsp);
    vsp = 0;
}
y += vsp;

// 4. SPRITE ORIENTATION
image_xscale = facing;