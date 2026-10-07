/// @description Enemy contact with a player-fired shot.

var _shot_damage = other.damage;
var _impact_layer = layer_exists("Projectiles") ? "Projectiles" : "Instances";
instance_create_layer(other.x, other.y, _impact_layer, obj_projectile_impact);
with (other) {
    instance_destroy();
}
take_damage(_shot_damage);
