/// @description Initialize Mark (GM LTS 2026)

target = obj_jack;

// Follow positioning
follow_distance = 24;
follow_height = 12;
lerp_speed = 0.1;

// Combat & Cooldowns (GM LTS 2026 Timing)
plasma_cooldown = 0;
plasma_cooldown_max = game_get_speed(gamespeed_fps) * 0.4; // 400ms cooldown
assistance_hp_threshold = 30; // Auto-assist threshold (30% HP)

// Visual Effects & State Tracking
glow_alpha = 0;
current_state = "IDLE";