/// @description Shared patrol, gravity, and boss pursuit behavior.

if (touch_cooldown > 0) {
    touch_cooldown--;
}
if (boss_leap_cooldown > 0) {
    boss_leap_cooldown--;
}

if (enemy_kind == "flying") {
    if (x <= patrol_origin - patrol_range) facing = 1;
    if (x >= patrol_origin + patrol_range) facing = -1;
    x += facing * move_speed;
    y = bob_origin_y + (sin(current_time / 300 + bob_phase) * 0.6);
} else {
    if (enemy_kind == "boss" && instance_exists(obj_jack)) {
        facing = sign(obj_jack.x - x);
        if (facing == 0) facing = 1;
        move_speed = (obj_jack.hp < 50) ? 1.8 : 1.2;
        if (boss_leap_cooldown == 0 && place_meeting(x, y + 1, obj_wall)) {
            vertical_speed = -5.5;
            boss_leap_cooldown = 90;
        }
    } else {
        if (x <= patrol_origin - patrol_range) facing = 1;
        if (x >= patrol_origin + patrol_range) facing = -1;
    }

    var _next_x = x + (facing * move_speed);
    if (place_meeting(_next_x, y, obj_wall)) {
        facing = -facing;
    } else {
        x = _next_x;
    }

    vertical_speed = min(vertical_speed + 0.35, 8);
    if (place_meeting(x, y + vertical_speed, obj_wall)) {
        vertical_speed = 0;
    } else {
        y += vertical_speed;
    }
}

if (touch_cooldown == 0 && place_meeting(x, y, obj_jack) && instance_exists(obj_controller)) {
    obj_controller.damage_player(contact_damage);
    touch_cooldown = 45;
}