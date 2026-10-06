/// @description obj_jack - Create Event (Mario Wall Jump & Updated Controls)

// Health Variables
hp = 100;
max_hp = 100;
is_dead = false;
damage_multiplier = 1.0;

// Movement Speeds
move_speed   = 2.1;
run_speed    = 4.5;
sprint_speed = 7.5; 
jump_speed   = -7.2; 
grav         = 0.4;

// Step-Up Height
step_height = 4;

// Sprint Logic (120 frames = 2 seconds)
sprint_timer    = 0;
sprint_required = 120;
is_sprinting    = false;

// Physics Variables
hsp = 0;
vsp = 0;

grounded   = false;
jump_max   = 2;
jumps_left = 2;

// Coyote Time Variables
coyote_timer = 0;
coyote_max   = 8; 

// Mario Wall Jump & Slide Variables
wall_slide_speed = 1.8;
wall_jump_hsp    = 5.5;
wall_jump_vsp    = -8.0;
is_wall_sliding  = false;

// Horizontal Momentum Control (Prevents wall jump overwrite)
wall_jump_lock   = 0;
wall_jump_lock_max = 12;

shot_cooldown = 0;