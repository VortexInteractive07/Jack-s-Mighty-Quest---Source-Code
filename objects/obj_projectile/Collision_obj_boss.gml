/// @description Collision with Boss

// 1. Apply damage safely
if (other != noone && variable_instance_exists(other, "hp")) {
    other.hp -= damage;
}

// 2. Play hit SFX safely (prevents audio engine overload during spray)
if (audio_exists(sfx_explosion)) {
    if (!audio_is_playing(sfx_explosion)) {
        audio_play_sound(sfx_explosion, 5, false);
    }
}

// 3. Spawn impact effect
if (object_exists(obj_projectile_impact)) {
    instance_create_depth(x, y, depth - 1, obj_projectile_impact);
}

// 4. Destroy projectile immediately
instance_destroy();