/// @description Handle Ramming & Damage Collision

if (boost_timer > 0 || always_dash_mode || speedrunner_mode) {
    with (other) {
        if (variable_instance_exists(id, "hp")) hp -= 100;
        else instance_destroy();
    }
} else {
    take_damage(20, other.x);
}