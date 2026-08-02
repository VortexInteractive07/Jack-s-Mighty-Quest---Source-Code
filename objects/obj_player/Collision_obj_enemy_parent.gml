/// @description Handle Damage & Knockback Collision
if (boost_timer > 0) {
    // Destroy or damage enemy if Jack rams into them during D+C boost
    with (other) {
        if (variable_instance_exists(id, "hp")) {
            hp -= 50;
        } else {
            instance_destroy();
        }
    }
} else {
    take_damage(20, other.x);
}