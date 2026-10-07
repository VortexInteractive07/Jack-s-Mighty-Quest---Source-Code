/// @description Apply the player's shot damage directly to the boss.

var _shot_damage = max(1, other.damage);
var _impact_layer = layer_exists("Projectiles") ? "Projectiles" : "Instances";
instance_create_layer(other.x, other.y, _impact_layer, obj_projectile_impact);
with (other) instance_destroy();
take_damage(_shot_damage);
