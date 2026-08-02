/// @function scr_player_movement()
/// @description Standard Arcade Platformer Physics Engine with Collision Safeguards
function scr_player_movement() {
    // 1. INPUT PROCESSING
    var _key_left  = keyboard_check(vk_left)  || keyboard_check(ord("A"));
    var _key_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
    var _key_jump  = keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("W"));

    // Freeze physics if the UI controller is presenting an intro or level complete text
    if (instance_exists(obj_controller) && obj_controller.show_title_card) exit;
    if (instance_exists(obj_levelcomplete) && obj_levelcomplete.triggered) exit;

    // 2. HORIZONTAL MOVEMENT CALCULATIONS
    var _move = _key_right - _key_left;
    hsp = _move * move_speed;

    // 3. VERTICAL MOVEMENT (GRAVITY & JUMPING)
    if (!place_meeting(x, y + 1, obj_wall)) {
        vsp += grav; // Apply gravity fall mechanics if airborne
        if (vsp > max_fall_speed) vsp = max_fall_speed;
    } else {
        vsp = 0; // Reset vertical vector when firmly grounded
        if (_key_jump) {
            vsp = -jump_force; // Apply immediate upward velocity impulse
        }
    }

    // 4. PIXEL-PERFECT HORIZONTAL COLLISION SYSTEM
    if (place_meeting(x + hsp, y, obj_wall)) {
        while (!place_meeting(x + sign(hsp), y, obj_wall)) {
            x += sign(hsp);
        }
        hsp = 0;
    }
    x += hsp;

    // 5. PIXEL-PERFECT VERTICAL COLLISION SYSTEM
    if (place_meeting(x, y + vsp, obj_wall)) {
        while (!place_meeting(x, y + sign(vsp), obj_wall)) {
            y += sign(vsp);
        }
        vsp = 0;
    }
    y += vsp;
}