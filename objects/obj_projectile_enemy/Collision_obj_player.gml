/// @description Process Hit on Player

var _player = other; // 'other' is the player in a collision event

// Only process damage if Jack is alive and NOT invulnerable
if (_player.invulnerable_timer <= 0 && _player.state != 3) {
    
    // Inflict damage using the variable from this projectile
    _player.hp -= damage_val; 
    _player.invulnerable_timer = _player.invulnerable_max;
    
    // Play damage SFX
    if (audio_exists(sfx_player_hurt)) {
        audio_play_sound(sfx_player_hurt, 6, false);
    }
    
    // Check if dead
    if (_player.hp <= 0) {
        _player.hp = 0;
        _player.state = 3; // Force to Death State
        
        if (instance_exists(obj_controller)) {
            obj_controller.player_dead = true;
            obj_controller.death_reason = "shot by bullet";
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
        
        // Calculate knockback direction away from projectile origin
        var _proj_center = x + (sprite_width / 2);
        var _push_dir = sign(_player.x - _proj_center);
        if (_push_dir == 0) _push_dir = -_player.facing; 
        
        _player.hsp = _push_dir * knockback_speed;
        _player.vsp = -3.0; 
    }
}

// ALWAYS destroy the enemy bullet upon touching the player!
instance_destroy();