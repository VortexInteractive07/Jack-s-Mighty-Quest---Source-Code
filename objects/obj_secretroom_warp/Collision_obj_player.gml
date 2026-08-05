/// @description Step Event - obj_secretroom_warp

// Check if player is overlapping this warp object
var _player = instance_place(x, y, obj_player);

if (_player != noone && !triggered) {
    // Check key press
    var _interact = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
    
    if (_interact) {
        triggered = true;
        
        // Move player coordinates before changing room
        _player.x = target_x;
        _player.y = target_y;
        
        if (room_exists(target_room)) {
            room_goto(target_room);
        }
    }
}