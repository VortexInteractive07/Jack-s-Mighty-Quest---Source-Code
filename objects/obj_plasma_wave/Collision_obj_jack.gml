/// @description Hostile plasma waves damage Jack; Mark's waves pass through him.

if (is_hostile && instance_exists(obj_controller)) {
    obj_controller.damage_player(damage);
}
instance_destroy();
