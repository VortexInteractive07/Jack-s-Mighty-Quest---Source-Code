/// @description obj_mark - Create Event (State Tracking & Emotion Engine)

target = instance_find(obj_jack, 0);

follow_distance = 28;
follow_height = 16;
lerp_speed = 0.12;

plasma_cooldown = 0;
plasma_cooldown_max = game_get_speed(gamespeed_fps) * 0.4;
assistance_hp_threshold = 30;

// Shock Reaction State Timers
shock_timer = 0;
shock_timer_max = game_get_speed(gamespeed_fps) * 0.6; // 600ms shock duration

glow_alpha = 0;
current_state = "IDLE";

depth = -y;
