/// @description Collide with Wall

// Spawn the impact visual effect safely using depth instead of layer
if (object_exists(obj_projectile_impact)) {
    instance_create_depth(x, y, depth, obj_projectile_impact);
}

// Play hit sound effect if it exists
if (audio_exists(sfx_explosion)) {
    audio_play_sound(sfx_explosion, 5, false);
}

// Destroy the projectile
instance_destroy();