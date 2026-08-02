/// @description Handle One-Shot Transitions & Freezes

switch (sprite_index) {
    // Jump & Surface Fall freeze on their final frame until gravity updates the state
    case spr_player_jump:
    case spr_player_surface_fall:
        image_speed = 0;
        image_index = image_number - 1;
        break;

    // Transition from initial fall entry into continuous fall loop
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
        if (place_meeting(x, y + 1, obj_wall)) {
            state = 0; // Restore control upon landing
        }
        break;

    case spr_player_death:
        image_speed = 0;
        image_index = image_number - 1; // Freeze on death frame
        break;
}