/// @function scr_trigger_player_death()
/// @description Handles player life deduction and room transition or game over sequence
function scr_trigger_player_death() {
    with (obj_jack) {
        if (!is_dead) {
            is_dead = true;
            death_timer = death_delay_max;
            vsp = -6.0;
            hsp = -image_xscale * 2.0;
            sprite_index = spr_die;
            
            if (audio_exists(sfx_dead)) {
                audio_play_sound(sfx_dead, 10, false);
            }
            
            if (instance_exists(obj_controller)) {
                obj_controller.player_lives--;
                
                if (obj_controller.player_lives <= 0) {
                    obj_controller.is_game_over = true;
                    obj_controller.game_over_timer = obj_controller.game_over_delay;
                    if (audio_exists(mus_gameover)) {
                        audio_play_sound(mus_gameover, 10, false);
                    }
                }
            }
        }
    }
}