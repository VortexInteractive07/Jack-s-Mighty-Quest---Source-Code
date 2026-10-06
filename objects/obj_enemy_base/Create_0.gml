/// @description Shared enemy health and contact-damage behavior.

hp = 2;
max_hp = 2;
contact_damage = 20;
move_speed = 1;
facing = -1;
patrol_origin = x;
patrol_range = 48;
enemy_kind = "ground";
vertical_speed = 0;
touch_cooldown = 0;
boss_leap_cooldown = 0;
bob_origin_y = y;
bob_phase = random(2 * pi);

take_damage = function(_amount) {
    hp = max(0, hp - max(1, _amount));
    if (hp <= 0) {
        if (enemy_kind == "boss") {
            global.boss_defeated = true;
        }
        if (instance_exists(obj_controller)) {
            obj_controller.add_score(250);
        }
        instance_destroy();
    }
};