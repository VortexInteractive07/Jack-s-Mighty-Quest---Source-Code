/// @function scr_trigger_player_death()
/// @description Handles player life deduction and room transition or game over sequence
function scr_trigger_player_death() {
    with (obj_jack) {
        if (!is_dead) {
            is_dead = true;
            hp = 0;
            death_timer = death_delay_max;
            
            // Arcade knockback arc
            vsp = -6.0;
            hsp = -image_xscale * 2.0;
            
            // Freeze jump frame for death animation fallback
            sprite_index = spr_player_jump;
            image_speed = 0;
            image_index = 0;
            
            // Stop background level music
            if (instance_exists(obj_controller)) {
                if (variable_instance_exists(obj_controller, "stop_level_audio")) {
                    obj_controller.stop_level_audio();
                } else {
                    audio_stop_all();
                }
            } else {
                audio_stop_all();
            }

            // Play death sound effect safely
            var _snd_death_asset = asset_get_index("sfx_death");
            if (_snd_death_asset != -1 && audio_exists(_snd_death_asset)) {
                audio_play_sound(_snd_death_asset, 10, false);
            }
            
            // Deduct player life count
            if (instance_exists(obj_controller)) {
                if (variable_instance_exists(obj_controller, "player_lives")) {
                    obj_controller.player_lives = max(0, obj_controller.player_lives - 1);
                }
            } else if (variable_global_exists("player_lives")) {
                global.player_lives = max(0, global.player_lives - 1);
            }
        }
    }
}