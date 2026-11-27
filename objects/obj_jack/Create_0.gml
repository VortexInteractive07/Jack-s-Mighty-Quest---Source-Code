 /// @description obj_jack - Create Event (Mario Wall Jump & Updated Controls)

// Health Variables
hp = 100;
max_hp = 100;
is_dead = false;
damage_invulnerability_timer = 0;
death_timer = 0;
death_delay_max = round(game_get_speed(gamespeed_fps) * 0.75);
damage_multiplier = 1.0;
attack_cooldown = 0;
attack_cooldown_max = 18;
attack_range = 72;
projectile_cooldown = 0;
massacre_cooldown = 0;

// Movement Speeds
move_speed   = 2.1;
run_speed    = 4.5;   // NOTE: unused while sprint is instant (see below)
sprint_speed = 7.5; 
jump_speed   = -7.2; 
grav         = 0.4;

// Step-Up Height
step_height = 4;

// Sprint Logic
// 1 frame = instant sprint the moment the player holds S while moving on the ground.
// (Was 120 frames = 2 seconds. Set higher again for a build-up.)
sprint_timer    = 0;
sprint_required = 1;
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

// Wall-kick input lock (needed by the fixed obj_jack Step event)
wall_jump_lock     = 0;     // frames left where horizontal input is ignored
wall_jump_lock_max = 10;    // tune: longer = bigger horizontal kick
wall_jump_dir      = 0;     // direction of the kick (-1 left, 1 right)

if (variable_global_exists("pending_game_restore") && is_struct(global.pending_game_restore)
&& global.pending_game_restore.room_asset == room) {
    x = global.pending_game_restore.x;
    y = global.pending_game_restore.y;
    hp = clamp(global.pending_game_restore.hp, 1, max_hp);
    hsp = 0;
    vsp = 0;
    // Give the player time to leave a hazard when restoring the last safe position.
    damage_invulnerability_timer = game_get_speed(gamespeed_fps) * 1.5;
}
