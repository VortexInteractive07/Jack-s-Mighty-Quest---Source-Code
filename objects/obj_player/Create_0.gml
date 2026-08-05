/// @description Initialize Jack's Kinematics, State Machine, FX & Debug Flags

// --- Force Permanent Physics Mask ---
if (sprite_exists(spr_player_mask)) {
    mask_index = spr_player_mask; // Explicilty fixes 128x128 bounding box snags
}

// --- Visual Offset Tuning ---
draw_y_offset = 48; 

// --- F12 Debug / Speedrunner Master Toggle ---
speedrunner_mode = false;
always_dash_mode = false;

// --- F12 Sub-Cheats (Toggled via L, P, H inside Debug Mode) ---
god_infinite_hp = false; 
god_no_pit_fall = false; 
god_block_enemy = false; 

// --- Base Physics Values ---
base_walk_speed  = 5.6;
base_run_speed   = 10.0;
base_accel       = 0.45;
base_jump_height = -6.8;

// Active Movement Physics
walk_speed   = base_walk_speed;
run_speed    = base_run_speed;
boost_speed  = 15.0;
jump_height  = base_jump_height;
accel        = base_accel;
fric         = 0.30;
skid_fric    = 0.60;
air_accel    = 0.25;
air_fric     = 0.15;
grv          = 0.28;

// --- Kinematics & States ---
hsp    = 0;
vsp    = 0;
facing = 1; 
state  = 0; // 0: Normal | 1: Skidding | 2: Stunned/Hurt | 3: Dead

// --- Health & Combat ---
hp_max = 100;
hp     = hp_max;

// --- Boost & Combo Timers ---
boost_timer    = 0;
boost_duration = 20;

// --- Jump Buffers & Coyote Mechanics ---
coyote_timer      = 0;
coyote_max        = 6;
jump_buffer_timer = 0;
jump_buffer_max   = 8;

// --- Invulnerability & Knockback ---
invulnerable_timer = 0;
invulnerable_max   = 60;
knockback_vsp      = -3.5;

// --- Flash Trail FX Setup ---
trail_max          = 12;
trail_history      = [];
trail_spawn_timer  = 0;
trail_spawn_delay  = 1;

// --- Methods / Helper Functions ---
take_damage = function(_damage, _source_x) {
    if (god_infinite_hp || invulnerable_timer > 0 || state == 3) exit;
    
    hp -= _damage;
    invulnerable_timer = invulnerable_max;
    
    if (hp <= 0) {
        hp = 0;
        
        if (state != 3 && variable_global_exists("stats")) {
            global.stats.total_deaths += 1;
        }
        
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

if (!variable_global_exists("stats")) {
    global.stats = { total_deaths: 0, total_jumps: 0, time_played_sec: 0 };
}