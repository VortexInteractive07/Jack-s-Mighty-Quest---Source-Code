/// @description Shared collision-safe patrol and gravity for regular enemies.

if (touch_cooldown > 0) {
    touch_cooldown--;
}
if (enemy_kind == "flying") {
    // Give flyers a readable patrol and a visible bob. Keep both axes out of walls.
    if (x <= patrol_origin - patrol_range) facing = 1;
    else if (x >= patrol_origin + patrol_range) facing = -1;

    var _fly_dx = facing * move_speed;
    var _fly_x_before = x;
    move_and_collide(_fly_dx, 0, obj_wall);
    if (abs((x - _fly_x_before) - _fly_dx) > 0.01) facing = -facing;

    var _bob_target_y = bob_origin_y + (sin(current_time / 450 + bob_phase) * 10);
    move_and_collide(0, _bob_target_y - y, obj_wall);
} else {
    if (x <= patrol_origin - patrol_range) facing = 1;
    else if (x >= patrol_origin + patrol_range) facing = -1;

    var _ground_dx = facing * move_speed;
    var _ground_x_before = x;
    move_and_collide(_ground_dx, 0, obj_wall);
    if (abs((x - _ground_x_before) - _ground_dx) > 0.01) facing = -facing;

    vertical_speed = min(vertical_speed + 0.35, 8);
    var _ground_y_before = y;
    move_and_collide(0, vertical_speed, obj_wall);
    if (abs((y - _ground_y_before) - vertical_speed) > 0.01) vertical_speed = 0;
}

image_xscale = (facing == 0) ? 1 : sign(facing) * abs(image_xscale);

if (touch_cooldown == 0 && place_meeting(x, y, obj_jack) && instance_exists(obj_controller)) {
    obj_controller.damage_player(contact_damage);
    touch_cooldown = 45;
}
