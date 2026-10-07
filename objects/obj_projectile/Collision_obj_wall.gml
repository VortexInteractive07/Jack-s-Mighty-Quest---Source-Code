/// @description Shots stop at solid level geometry.

var _impact_layer = layer_exists("Projectiles") ? "Projectiles" : "Instances";
instance_create_layer(x, y, _impact_layer, obj_projectile_impact);
instance_destroy();
