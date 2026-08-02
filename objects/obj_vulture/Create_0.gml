/// @description Vulture Init
event_inherited();

hp = 1;
sprite_index = spr_vulture;

fly_state = 0; // 0: Cruise | 1: Swoop Dive | 2: Re-ascend
cruise_speed = 2.0;
swoop_speed = 4.8;
detect_range = 200;

home_y = y;
hover_timer = 0;