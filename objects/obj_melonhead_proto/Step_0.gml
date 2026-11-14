/// @description Melon Head Boss AI, Phase System, Attacks & Physics.

if (hit_flash > 0) hit_flash--;
boss_hp_visual = lerp(boss_hp_visual, boss_hp, 0.15);

// --- DEFEATED STATE ---
if (defeated) {
    defeat_timer++;
    
    // Multiple explosion bursts across boss body
    if (defeat_timer mod 10 == 0 && defeat_timer < 70) {
        var _ex_x = x + random_range(-24, 24);
        var _ex_y = y + random_range(-20, 20);
        var _ex = instance_create_layer(_ex_x, _ex_y, "Instances", obj_plasma_wave);
        if (instance_exists(_ex)) {
            _ex.sprite_index = spr_explosion;
            _ex.image_speed = 0.4;
            _ex.hspeed = 0;
            _ex.life_timer = 20;
        }
        if (audio_exists(sfx_explosion)) {
            var _snd = audio_play_sound(sfx_explosion, 9, false);
            audio_sound_gain(_snd, (global.vol_sfx / 100) * 0.8, 0);
        }
    }
    
    // Fade out
    image_alpha = max(0, 1 - (defeat_timer / 80));
    
    if (defeat_timer >= 80) {
        // Spawn 5 reward gems
        for (var _g = 0; _g < 5; _g++) {
            var _gem = instance_create_layer(x - 40 + (_g * 20), y - 10, "Instances", obj_gem);
            if (instance_exists(_gem)) {
                _gem.vspeed = -3 - random(2);
                _gem.hspeed = random_range(-2, 2);
                _gem.gravity = 0.25;
            }
        }
        instance_destroy();
    }
    exit;
}

// Check if defeated
if (boss_hp <= 0 && !defeated) {
    defeated = true;
    state = BOSS_STATE.DEFEATED;
    hsp = 0;
    vsp = 0;
    
    // Destroy both arena gates to unlock the level exit
    if (instance_exists(gate)) instance_destroy(gate);
    if (instance_exists(enter_gate)) instance_destroy(enter_gate);
    
    if (instance_exists(obj_controller)) {
        var _ctrl = instance_find(obj_controller, 0);
        if (music_started) _ctrl.set_level_music(mus_city);
        if (audio_exists(mus_boss_clear)) {
            _ctrl.boss_clear_audio_id = audio_play_sound(mus_boss_clear, 10, false);
            if (_ctrl.boss_clear_audio_id != -1) {
                audio_sound_gain(_ctrl.boss_clear_audio_id, global.vol_bgm / 100, 0);
            }
        }
    }
    exit;
}

// --- TARGET ACQUISITION & ARENA ACTIVATION ---
var _player = instance_find(obj_jack, 0);
if (_player == noone || _player.is_dead) exit;

// Arena trigger when Jack enters the arena (x >= 3420)
if (!music_started && _player.x >= 3420) {
    music_started = true;
    state = BOSS_STATE.CHASE;
    attack_timer = 50;
    
    // Seal entry gate behind Jack
    if (enter_gate == noone) {
        enter_gate = instance_create_layer(3380, 0, "Instances", obj_wall);
        enter_gate.image_yscale = 15;
    }
    
    if (instance_exists(obj_controller)) {
        var _m_ctrl = instance_find(obj_controller, 0);
        _m_ctrl.set_level_music(mus_ranga_dhun_yeh);
    }
    
    if (audio_exists(sfx_victor_laugh)) {
        var _roar = audio_play_sound(sfx_victor_laugh, 9, false);
        audio_sound_gain(_roar, global.vol_sfx / 100, 0);
    }
}

if (contact_cooldown > 0) contact_cooldown--;

// Determine phase:
// Phase 1: 100 - 66 HP
// Phase 2: 65 - 31 HP (Jumping & Faster)
// Phase 3: 30 - 0 HP (Enraged Charges!)
var _phase = 1;
var _base_speed = 1.6;
if (boss_hp <= 65) { _phase = 2; _base_speed = 2.2; }
if (boss_hp <= 30) { _phase = 3; _base_speed = 2.9; }

// Face towards Jack (unless charging)
if (state != BOSS_STATE.CHARGING && state != BOSS_STATE.TELEGRAPH_CHARGE) {
    if (abs(_player.x - x) > 10) {
        facing = sign(_player.x - x);
        image_xscale = facing;
    }
}

// --- STATE MACHINE ---
switch (state) {
    case BOSS_STATE.WAIT:
        hsp = 0;
        break;
        
    case BOSS_STATE.CHASE:
        hsp = facing * _base_speed;
        image_speed = 0.2 + (_phase * 0.08);
        
        attack_timer--;
        if (attack_timer <= 0) {
            // Select attack based on distance and phase
            if (_phase >= 2 && irandom(2) == 0 && abs(_player.x - x) > 60) {
                // Leap attack
                state = BOSS_STATE.LEAP;
                vsp = -7.2;
                hsp = facing * 3.2;
                if (audio_exists(sfx_whoosh)) {
                    var _ws = audio_play_sound(sfx_whoosh, 7, false);
                    audio_sound_gain(_ws, global.vol_sfx / 100, 0);
                }
            } else {
                // Telegraph charge dash
                state = BOSS_STATE.TELEGRAPH_CHARGE;
                state_timer = 28 - (_phase * 4);
                hsp = 0;
                if (audio_exists(sfx_emp_charge)) {
                    var _emp = audio_play_sound(sfx_emp_charge, 8, false);
                    audio_sound_gain(_emp, global.vol_sfx / 100, 0);
                }
            }
        }
        break;
        
    case BOSS_STATE.TELEGRAPH_CHARGE:
        hsp = 0;
        state_timer--;
        // Shiver / shake telegraph
        x += random_range(-1.5, 1.5);
        if (state_timer <= 0) {
            state = BOSS_STATE.CHARGING;
            state_timer = 50;
            hsp = facing * (4.5 + (_phase * 0.6));
            if (audio_exists(sfx_shoot)) {
                var _snd_dash = audio_play_sound(sfx_shoot, 8, false);
                audio_sound_gain(_snd_dash, global.vol_sfx / 100, 0);
            }
        }
        break;
        
    case BOSS_STATE.CHARGING:
        state_timer--;
        // If hitting arena boundary or wall, slam and get stunned!
        var _hit_wall = place_meeting(x + hsp, y, obj_wall) || (x + hsp < arena_left + 16) || (x + hsp > arena_right - 16);
        if (_hit_wall || state_timer <= 0) {
            if (_hit_wall && audio_exists(sfx_smash)) {
                var _smash = audio_play_sound(sfx_smash, 9, false);
                audio_sound_gain(_smash, global.vol_sfx / 100, 0);
            }
            state = BOSS_STATE.STUNNED;
            state_timer = 40;
            hsp = -facing * 1.5;
        }
        break;
        
    case BOSS_STATE.LEAP:
        // Airborne leap
        if (place_meeting(x, y + 1, obj_wall) && vsp >= 0) {
            // Landed!
            hsp = 0;
            if (audio_exists(sfx_smash)) {
                var _land = audio_play_sound(sfx_smash, 8, false);
                audio_sound_gain(_land, (global.vol_sfx / 100) * 0.7, 0);
            }
            state = BOSS_STATE.CHASE;
            attack_timer = 45;
        }
        break;
        
    case BOSS_STATE.STUNNED:
        hsp = lerp(hsp, 0, 0.1);
        state_timer--;
        image_speed = 0.05;
        if (state_timer <= 0) {
            state = BOSS_STATE.CHASE;
            attack_timer = 40;
            image_speed = 0.2;
        }
        break;
}

// --- PHYSICS & COLLISION ---
vsp += grav;
grounded = place_meeting(x, y + 1, obj_wall);

// Horizontal collision
if (place_meeting(x + hsp, y, obj_wall)) {
    while (!place_meeting(x + sign(hsp), y, obj_wall)) {
        x += sign(hsp);
    }
    hsp = 0;
}
x += hsp;

// Clamp within arena
x = clamp(x, arena_left + 16, arena_right - 16);

// Vertical collision
if (place_meeting(x, y + vsp, obj_wall)) {
    while (!place_meeting(x, y + sign(vsp), obj_wall)) {
        y += sign(vsp);
    }
    vsp = 0;
}
y += vsp;

// --- CONTACT DAMAGE TO JACK ---
if (contact_cooldown <= 0 && state != BOSS_STATE.STUNNED && state != BOSS_STATE.WAIT) {
    if (point_distance(x, y, _player.x, _player.y) <= 56) {
        var _dmg = (state == BOSS_STATE.CHARGING) ? 22 : 14;
        if (instance_exists(obj_controller)) {
            var _dmg_ctrl = instance_find(obj_controller, 0);
            _dmg_ctrl.damage_player(_dmg);
            contact_cooldown = contact_cooldown_max;
        }
    }
}

depth = -y;
