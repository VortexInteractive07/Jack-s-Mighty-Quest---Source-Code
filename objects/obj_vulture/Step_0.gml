/// @description Natural Vulture Flight & Swoop
event_inherited();

if (!instance_exists(obj_player)) exit;

switch (fly_state) {
    case 0: // CRUISE PATROL
        hover_timer += 0.04;
        vsp = sin(hover_timer) * 0.6;
        
        // Patrol horizontally
        hsp = lerp(hsp, facing * cruise_speed, 0.05);
        
        // Turn around at room boundaries or obstacles
        if (place_meeting(x + (facing * 16), y, obj_wall) || x < 32 || x > room_width - 32) {
            facing *= -1;
        }
        
        // Spot player
        if (distance_to_object(obj_player) < detect_range) {
            fly_state = 1;
        }
        break;

    case 1: // DIVE ATTACK
        var _target_angle = point_direction(x, y, obj_player.x, obj_player.y);
        hsp = lerp(hsp, lengthdir_x(swoop_speed, _target_angle), 0.1);
        vsp = lerp(vsp, lengthdir_y(swoop_speed, _target_angle), 0.1);
        
        // Pull up if too close to player or ground
        if (distance_to_object(obj_player) < 20 || place_meeting(x, y + 16, obj_wall)) {
            fly_state = 2;
        }
        break;

    case 2: // ASCEND BACK TO ALTITUDE
        hsp = lerp(hsp, facing * cruise_speed, 0.05);
        vsp = lerp(vsp, -3.0, 0.08); // Smooth upward climb
        
        if (y <= home_y) {
            y = home_y;
            vsp = 0;
            fly_state = 0;
        }
        break;
}

// Apply Movement
x += hsp;
y += vsp;

if (abs(hsp) > 0.1) facing = sign(hsp);
image_xscale = facing;