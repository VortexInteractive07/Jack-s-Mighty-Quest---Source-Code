/// @description Initialize the Melon Head Boss (Stage 2 Boss).

// Health & Stats
boss_hp = 100;
boss_hp_max = 100;
boss_hp_visual = 100;

// Battle States
enum BOSS_STATE {
    WAIT,
    CHASE,
    TELEGRAPH_CHARGE,
    CHARGING,
    LEAP,
    STUNNED,
    DEFEATED
}

state = BOSS_STATE.WAIT;
state_timer = 0;
contact_cooldown = 0;
contact_cooldown_max = game_get_speed(gamespeed_fps) * 0.6;

// Combat Timers
attack_timer = 60;
hit_flash = 0;
music_started = false;
defeated = false;
defeat_timer = 0;

// Arena Gates
gate = noone;
enter_gate = noone;

// Movement & Arena Limits
hsp = 0;
vsp = 0;
grav = 0.38;
grounded = false;
arena_left = 3380;
arena_right = 4000;
facing = -1;

image_speed = 0.2;
depth = -y;

take_damage = function(_amount) {
    if (defeated || state == BOSS_STATE.WAIT) return;
    boss_hp = max(0, boss_hp - max(0, _amount));
    hit_flash = 8;
    
    if (audio_exists(sfx_enemy_hit)) {
        var _snd = audio_play_sound(sfx_enemy_hit, 8, false);
        audio_sound_gain(_snd, global.vol_sfx / 100, 0);
    }
    
    // Knockback
    hsp = -facing * 2.5;
};
