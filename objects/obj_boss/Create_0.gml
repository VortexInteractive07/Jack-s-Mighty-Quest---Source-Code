/// @description Initialize Boss Core Settings, AI Engine & Profile Properties

// --- STATS & PROFILE ---
boss_name       = "Pumpkin Head";
hp              = 100;
max_hp          = 100;
damage_val      = 25;        // Contact damage to player
knockback_speed = 4.0;

// --- MOVEMENT & PHYSICS ---
move_speed      = 1.6;
chase_speed     = 1.6;
hsp             = 0;
vsp             = 0;
grav            = 0.3;
jump_speed      = 6.5;
facing          = -1;

// --- AI STATE MACHINE ---
state           = "idle";
is_active       = false;
detection_radius = 220;

// Timers & Cooldowns
shoot_timer     = 0;
shoot_interval  = 100;
leap_timer      = 0;
leap_interval   = 180;
hit_flash_timer = 0;

// Visual Interpolation
hp_smooth       = 100;