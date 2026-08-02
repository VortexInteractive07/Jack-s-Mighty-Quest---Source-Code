/// @description Pro-Max AI: Core & Enemy Execution System

// --- Physics & Dynamic Kinematics ---
hsp = 0; 
vsp = 0;
grv = 0.35;
accel = 0.3;          
friction_val = 0.2;
walk_speed = 4.2;     
jump_height = -7.2;   

// --- State Management ---
// 0: Follow/Combat | 1: Instant Slay Ultimate | 2: PAF! Dash | 3: Respawn
state = 0; 
facing = 1;
invulnerable_timer = 0;

// --- Timers & Buffers ---
coyote_timer = 0; coyote_max = 8;
paf_timer = 0; paf_duration = 15;

// --- Shooting Logic ---
fire_cooldown = 0; 
single_fire_delay = 90; // 1.5 Seconds delay at 60 FPS
is_asterix_shooting = false;

// --- Targeting & AI Brain ---
follow_offset_x = -28; 
combat_range = 400;   

// --- PRO-MAX OVERDRIVE MECHANICS ---
pmax_charge = 0;      
pmax_max = 100;       
pmax_slay_timer = 0;