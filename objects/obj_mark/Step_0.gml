/// @description obj_mark - Step Event (Emotion Sync & Jack Death Response)

if (!instance_exists(target)) exit;

depth = target.depth + 1;

// --- 1. JACK DEATH EMOTIONAL OVERRIDE ---
if (variable_instance_exists(target, "is_dead") && target.is_dead) {
    if (current_state != "SHOCKED" && current_state != "SAD") {
        current_state = "SHOCKED";
        shock_timer = shock_timer_max;
    }
    
    if (current_state == "SHOCKED") {
        sprite_index = spr_mark_shocked;
        shock_timer--;
        if (shock_timer <= 0) {
            current_state = "SAD";
        }
    } else if (current_state == "SAD") {
        sprite_index = spr_mark_sad;
    }
    
    // Float downward toward Jack's body
    var _death_x = target.x - (16 * target.image_xscale);
    var _death_y = target.y - 8;
    x = lerp(x, _death_x, 0.05);
    y = lerp(y, _death_y, 0.05);
    exit;
}

// --- 2. SMOOTH FOLLOW & WALL COLLISION ---
var target_x = target.x - (follow_distance * target.image_xscale);
var target_y = target.y - follow_height;

var dx = (target_x - x) * lerp_speed;
var dy = (target_y - y) * lerp_speed;

move_and_collide(dx, dy, obj_wall);

if (abs(target.x - x) > 4) {
    image_xscale = target.image_xscale;
}

if (plasma_cooldown > 0) plasma_cooldown--;

// --- 3. DUAL-SYSTEM STATE MACHINE ---
var needs_help = (variable_instance_exists(target, "hp") && target.hp < assistance_hp_threshold) 
                 || keyboard_check_pressed(vk_control);

var buff_active = keyboard_check(vk_shift);

if (needs_help && plasma_cooldown <= 0) {
    current_state = "ATTACK";
    sprite_index = spr_mark_angry_attack;
    
    var dir = image_xscale;
    var wave_sprite = (dir > 0) ? spr_pwave_right : spr_pwave_left;
    
    var _projectile_layer = layer_exists("Projectiles") ? "Projectiles" : "Instances";
    var wave = instance_create_layer(x + (12 * dir), y, _projectile_layer, obj_plasma_wave);
    if (instance_exists(wave)) {
        wave.sprite_index = wave_sprite;
        wave.hspeed = 8 * dir;
    }
    
    if (audio_exists(snd_plasma_wave)) {
        scr_play_sfx(snd_plasma_wave, 8, false);
    }
    
    plasma_cooldown = plasma_cooldown_max;
    
    if (variable_instance_exists(target, "damage_multiplier")) {
        target.damage_multiplier = 1.0;
    }
} 
else if (buff_active) {
    current_state = "BUFF";
    sprite_index = spr_mark_angry;
    
    if (variable_instance_exists(target, "damage_multiplier")) {
        target.damage_multiplier = 2.0;
    }
} 
else {
    current_state = "IDLE";
    
    if (variable_instance_exists(target, "damage_multiplier")) {
        target.damage_multiplier = 1.0;
    }
    
    if (variable_instance_exists(target, "vsp")) {
        if (target.vsp < -1)      sprite_index = spr_mark_looking_up;
        else if (target.vsp > 1) sprite_index = spr_mark_looking_down;
        else                     sprite_index = spr_mark;
    } else {
        sprite_index = spr_mark;
    }
}