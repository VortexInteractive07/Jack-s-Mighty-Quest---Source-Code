/// @description Universal Enemy Initialization

// --- Life Metrics ---
hp = 1;
max_hp = 1;
is_dead = false;

// --- Combat & Damage Parameters ---
damage_val = 0.05; // 5% damage per hit
knockback_speed = 5.0;

// --- Physics & Kinematics ---
hsp = 0;
vsp = 0;
grv = 0.35;
walk_speed = 1.5;
facing = 1;

// --- Stun Management ---
hit_stun = 0;