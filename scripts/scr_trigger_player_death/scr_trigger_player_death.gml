/// @function scr_trigger_player_death()
/// @description Handles player life deduction and room transition or game over sequence
function scr_trigger_player_death() {
    with (obj_jack) {
        if (!is_dead) {
            is_dead = true;
            death_timer = death_delay_max;
            vsp = -6.0;
            hsp = -image_xscale * 2.0;
            // The project has no dedicated Jack death sprite yet.
            sprite_index = spr_player_jump;
            image_speed = 0;

            if (instance_exists(obj_controller)) {
                obj_controller.stop_level_audio();
            }

            if (audio_exists(sfx_dead)) {
                audio_play_sound(sfx_dead, 10, false);
            }
        }
    }
}