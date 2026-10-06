/// @description Enemy contact with a player-fired shot.

var _shot_damage = other.damage;
with (other) {
    instance_destroy();
}
take_damage(_shot_damage);