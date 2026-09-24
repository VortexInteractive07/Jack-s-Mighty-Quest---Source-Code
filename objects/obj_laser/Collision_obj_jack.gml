/// @description Damage Jack on contact with the laser.

if (active && instance_exists(obj_controller)) {
    obj_controller.damage_player(100);
}
