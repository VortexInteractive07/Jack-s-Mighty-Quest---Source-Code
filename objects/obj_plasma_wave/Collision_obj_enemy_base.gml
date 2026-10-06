/// @description Mark's plasma wave damages the enemy it strikes.

var _wave_damage = damage;
with (other) {
    take_damage(_wave_damage);
}
instance_destroy();