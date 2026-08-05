/// @description Exit Secret Room and Warp Back to Stage 2

if (!triggered) {
    var _interact = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
    
    if (_interact) {
        triggered = true;
        
        // Reposition player back into the main stage layout
        other.x = target_x;
        other.y = target_y;
        
        if (room_exists(target_room)) {
            room_goto(target_room);
        }
    }
}