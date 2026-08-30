/// @description Behavior, Wall Collision & State Controller

if (!instance_exists(target)) exit;

// -------------------------------------------------------------
// 1. Movement Logic: Floating Follow with obj_wall Collision
// -------------------------------------------------------------
var target_x = target.x - (follow_distance * target.image_xscale);
var target_y = target.y - follow_height;

// Calculate desired frame displacement
var dx = (target_x - x) * lerp_speed;
var dy = (target_y - y) * lerp_speed;

// Smoothly float while sliding against solid walls
move_and_collide(dx, dy, obj_wall);

// Match target facing direction
image_xscale = target.image_xscale;

// Cooldown timer
if (plasma_cooldown > 0) plasma_cooldown--;

// -------------------------------------------------------------
// 2. Dual-System State Machine
// -------------------------------------------------------------

// CONDITION A: Emergency Assistance (Jack HP < 30% or Space press)
var needs_help = (variable_instance_exists(target, "hp") && target.hp < assistance_hp_threshold) 
                 || keyboard_check_pressed(vk_space);

// CONDITION B: Glow-Up Buff State (Shift key held)
var buff_active = keyboard_check(vk_shift);

if (needs_help && plasma_cooldown <= 0) {
    // --- PLASMA WAVE ASSISTANCE ---
    current_state = "ATTACK";
    sprite_index = spr_mark_angry_attack;
    
    var dir = image_xscale;
    var wave_sprite = (dir > 0) ? spr_pwave_right : spr_pwave_left;
    
    // Spawn Plasma Wave Projectile
    var wave = instance_create_layer(x + (12 * dir), y, "Projectiles", obj_plasma_wave);
    if (instance_exists(wave)) {
        wave.sprite_index = wave_sprite;
        wave.hspeed = 8 * dir;
    }
    
    if (audio_exists(snd_plasma_wave)) {
        audio_play_sound(snd_plasma_wave, 8, false);
    }
    
    plasma_cooldown = plasma_cooldown_max;
    
    // Reset damage multiplier during attack cast
    if (variable_instance_exists(target, "damage_multiplier")) {
        target.damage_multiplier = 1.0;
    }
} 
else if (buff_active) {
    // --- GLOW-UP BUFF MODE (No direct attack, empowers Jack) ---
    current_state = "BUFF";
    sprite_index = spr_mark_angry;
    
    // Apply 2x damage multiplier to obj_jack
    if (variable_instance_exists(target, "damage_multiplier")) {
        target.damage_multiplier = 2.0;
    }
} 
else {
    // --- STANDARD NEUTRAL & EXPRESSION SYNC ---
    current_state = "IDLE";
    
    // Reset damage multiplier
    if (variable_instance_exists(target, "damage_multiplier")) {
        target.damage_multiplier = 1.0;
    }
    
    // Map vertical movement to eye expressions
    if (variable_instance_exists(target, "vsp")) {
        if (target.vsp < -1)        sprite_index = spr_mark_looking_up;
        else if (target.vsp > 1)   sprite_index = spr_mark_looking_down;
        else                        sprite_index = spr_mark;
    } else {
        sprite_index = spr_mark;
    }
}