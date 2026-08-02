/// @description Slimus Gustus Init
event_inherited();

hp = 2;
sprite_index = spr_slimus_gustus;

// Jump Mechanics
jump_cooldown = 0;
base_jump_delay = 120; // 2 seconds between jumps when far away
min_jump_delay = 25;   // ~0.4 seconds between jumps when player is super close

jump_force_y = -6.5;
jump_force_x = 3.0;

is_jumping = false;