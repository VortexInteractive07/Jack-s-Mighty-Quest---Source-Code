/// @function scr_trigger_player_death()
/// @description Handles player life deduction and room transition or game over sequence
function scr_trigger_player_death() {
    with (obj_jack) {
        if (!is_dead) {
            is_dead = true;
            hp = 0;
            
            // Arcade knockback arc
            vsp = -6.0;
            hsp = -image_xscale * 2.0;
            
            // Freeze jump frame for death animation fallback
            sprite_index = spr_player_jump;
            image_speed = 0;
            image_index = 0;
            
        }
    }
}