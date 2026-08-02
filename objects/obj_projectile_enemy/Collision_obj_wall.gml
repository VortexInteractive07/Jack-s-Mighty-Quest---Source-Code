/// @description Collide with Wall

// Safe sound playback (prevents audio overload during heavy boss patterns)
if (audio_exists(sfx_explosion)) {
    if (!audio_is_playing(sfx_explosion)) {
        audio_play_sound(sfx_explosion, 5, false);
    }
}

// Spawn impact visual safely using depth
if (object_exists(obj_projectile_impact)) {
    instance_create_depth(x, y, depth - 1, obj_projectile_impact);
}

// Destroy the projectile immediately
instance_destroy();