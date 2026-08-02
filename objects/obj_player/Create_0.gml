/// @description Initialize Jack's Kinematics, State Machine & FX

// --- Force Permanent Physics Mask ---
// Assign dedicated 20x52 collision mask sprite
if (sprite_exists(spr_player_mask)) {
    mask_index = spr_player_mask;
}

// --- Visual Offset Tuning ---
// Push the 128x128 artwork down to match the feet of the collision mask
// Adjust this value if Jack floats or sinks relative to Mark / Ground
draw_y_offset = 48; 

// --- Health & Combat ---
hp_max = 100;
hp     = hp_max;

// --- Physics Properties ---
hsp          = 0;
vsp          = 0;
accel        = 0.45;   // Ground acceleration
fric         = 0.30;   // Ground friction
skid_fric    = 0.60;   // Sharp turn / braking friction
air_accel    = 0.25;   // Air movement control
air_fric     = 0.15;   // Air drag
grv          = 0.28;   // Gravity strength
walk_speed   = 5.6;    // Base movement speed
run_speed    = 10.0;   // Max sprint speed
boost_speed  = 15.0;   // D+C Super Boost speed
jump_height  = -6.8;   // Initial jump impulse

// --- Directional & Visual ---
facing = 1; // 1 = Right, -1 = Left

// --- Boost System Mechanics ---
boost_timer    = 0;
boost_duration = 20;   // Frames the super boost burst lasts (~1/3 second)

// --- Jump Buffers & Coyote Mechanics ---
coyote_timer      = 0;
coyote_max        = 6;
jump_buffer_timer = 0;
jump_buffer_max   = 8;

// --- Invulnerability & Knockback ---
invulnerable_timer = 0;
invulnerable_max   = 60; // 1 second flash buffer
knockback_vsp      = -3.5;

// --- State Machine ---
// 0: Normal | 1: Skidding | 2: Stunned/Hurt | 3: Dead
state = 0;

// --- Flash Trail FX Setup ---
trail_max         = 8;    // Expanded array size for super boost trails
trail_history     = [];
trail_spawn_timer = 0;
trail_spawn_delay = 1;    // Spawns every single frame during super boost

// --- Methods / Helper Functions ---
/// @function take_damage(damage, source_x)
take_damage = function(_damage, _source_x) {
    if (invulnerable_timer > 0 || state == 3) exit;
    
    hp -= _damage;
    invulnerable_timer = invulnerable_max;
    
    if (hp <= 0) {
        hp = 0;
        state = 3; // Death State
        hsp = 0;
        vsp = knockback_vsp;
        if (sprite_exists(spr_player_death)) {
            sprite_index = spr_player_death;
            image_index = 0;
        }
    } else {
        state = 2; // Hurt State
        var _dir = (x >= _source_x) ? 1 : -1;
        hsp = _dir * 4.5;
        vsp = knockback_vsp;
        if (sprite_exists(spr_player_hurt)) {
            sprite_index = spr_player_hurt;
            image_index = 0;
        }
    }
};