/// @description obj_jack - Create Event (Arrow Keys, Controls, Coyote Time & Void Check)

move_speed = 2.1;
run_speed  = 6.0;
jump_speed = -6.4;
grav       = 0.4;

hsp = 0;
vsp = 0;

grounded   = false;
jump_max   = 2;
jumps_left = 2;

// Coyote Time Variables (Grace frames after leaving a platform)
coyote_timer = 0;
coyote_max   = 8; 

wall_slide_speed = 1.2;
wall_jump_hsp    = 4.5;
wall_jump_vsp    = -8.5;