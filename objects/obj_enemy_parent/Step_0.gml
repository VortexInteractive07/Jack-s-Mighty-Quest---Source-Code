/// @description Universal Physics, Health, Boundary Clamp & Player Damage Logic

// 1. Health & Death Check
if (hp <= 0 && !is_dead) {
    is_dead = true;
    if (object_exists(obj_explosion)) {
        instance_create_layer(x, y, layer, obj_explosion);
    }
    if (audio_exists(sfx_explosion)) {
        audio_play_sound(sfx_explosion, 8, false);
    }
    instance_destroy();
    exit;
}

// 2. Hit Stun Recovery
if (hit_stun > 0) {
    hit_stun--;
    exit; // Skip movement/damage logic while stunned
}

// =================================================================
// 3. CEILING BOUNDARY CLAMP (Prevents enemies from going above y = 0)
// =================================================================
if (y < 0) {
    y = 0;
    if (vsp < 0) vsp = 0; // Stop upward momentum
}

// =================================================================
// 4. DAMAGE INFLICTED ON PLAYER (Jack)
// =================================================================
var _player = instance_place(x, y, obj_player);

if (_player != noone) {
    // Only hurt Jack if he is alive and not currently invulnerable
    if (_player.invulnerable_timer <= 0 && _player.state != 3) {
        
        // Inflict 5% damage (0.05)
        _player.hp -= damage_val;
        _player.invulnerable_timer = _player.invulnerable_max;
        
        // Play damage SFX
        if (audio_exists(sfx_player_hurt)) {
            audio_play_sound(sfx_player_hurt, 6, false);
        }
        
        // Check if dead (using small threshold for float math accuracy)
        if (_player.hp <= 0.001) {
            _player.hp = 0;
            _player.state = 3; // Force to Death State
            
            if (instance_exists(obj_controller)) {
                obj_controller.player_dead = true;
                obj_controller.death_reason = "hazard";
                global.player_lives -= 1;
                
                audio_stop_all();
                if (audio_exists(mus_life_lost)) {
                    audio_play_sound(mus_life_lost, 10, false);
                }
                
                obj_controller.is_transitioning = true;
                obj_controller.transition_timer = 0;
            }
        } else {
            // Apply knockback and stun state
            _player.state = 2; // HURT state
            
            // Calculate knockback direction away from the enemy
            var _push_dir = sign(_player.x - (x + sprite_width / 2));
            if (_push_dir == 0) _push_dir = -_player.facing; // Fallback opposite direction
            
            _player.hsp = _push_dir * knockback_speed;
            _player.vsp = -3.0; // Small upward lift
        }
    }
}