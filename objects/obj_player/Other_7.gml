/// @description Handle One-Shot Transitions & Freezes

switch (sprite_index) {
    case spr_player_jump:
    case spr_player_surface_fall:
        image_speed = 0;
        image_index = image_number - 1;
        break;

    case spr_player_fall:
        if (sprite_exists(spr_player_fall_loop)) {
            sprite_index = spr_player_fall_loop;
            image_index  = 0;
            image_speed  = 1.0;
        } else {
            image_speed = 0;
            image_index = image_number - 1;
        }
        break;

    case spr_player_hurt:
        image_speed = 0;
        image_index = image_number - 1;
        if (place_meeting(x, y + 1, obj_wall)) state = 0; 
        break;

    case spr_player_death:
        image_speed = 0;
        image_index = image_number - 1; 
        break;
}