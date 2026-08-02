/// @description Monitor Intersection Collisions & Apply Stun Knockback

var _player = instance_place(x, y, obj_player);

if (_player != noone) {
    // Only hurt Jack if he is alive and not currently invulnerable
    if (_player.invulnerable_timer <= 0 && _player.state != 3) {
        
        // Inflict damage
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
            
            // Calculate knockback direction away from the wall
            var _push_dir = sign(_player.x - (x + sprite_width/2));
            if (_push_dir == 0) _push_dir = -_player.facing; // Fallback opposite direction
            
            _player.hsp = _push_dir * knockback_speed;
            _player.vsp = -3.0; // Small upward lift to break ground friction locks
        }
    }
}