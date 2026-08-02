/// @description Bullet Impact & Destruction

// 1. Get damage from bullet (Default to 1 if not specified on the projectile)
var _damage = variable_instance_exists(other, "damage") ? other.damage : 1;

// 2. Reduce enemy health
hp -= _damage;

// 3. Destroy the bullet on impact (if it isn't piercing)
if (!variable_instance_exists(other, "is_piercing") || !other.is_piercing) {
    instance_destroy(other);
}

// 4. Execution / Death Check
if (hp <= 0) {
    // Spawn the explosion VFX on the same layer
    if (object_exists(obj_explosion)) {
        instance_create_layer(x, y, layer, obj_explosion);
    }

    // Play retro explosion sound effect if present
    if (audio_exists(sfx_explosion)) {
        audio_play_sound(sfx_explosion, 8, false);
    }

    // Destroy the enemy immediately
	if (!variable_global_exists("player_score"))     global.player_score = 0;
	global.player_score += 25;
    instance_destroy();
} else {
    // Optional: Brief hit-flash / hit-stun effect if enemy survives
    hit_stun = 5; 
}