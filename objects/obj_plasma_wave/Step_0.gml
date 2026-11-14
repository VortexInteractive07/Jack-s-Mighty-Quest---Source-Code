/// @description Move and expire the plasma projectile.

x += hspeed;
life_timer--;

// Collide with boss
if (instance_exists(obj_melonhead_proto)) {
    var _boss = instance_place(x, y, obj_melonhead_proto);
    if (_boss != noone && !_boss.defeated && _boss.state != BOSS_STATE.WAIT) {
        _boss.take_damage(12);
        if (audio_exists(sfx_enemy_hit)) {
            var _snd = audio_play_sound(sfx_enemy_hit, 8, false);
            audio_sound_gain(_snd, global.vol_sfx / 100, 0);
        }
        // Small hit burst
        sprite_index = spr_explosion;
        image_speed = 0.5;
        hspeed = 0;
        life_timer = 12;
    }
}

if (life_timer <= 0 || x < -64 || x > room_width + 64 || y < -64 || y > room_height + 64) {
    instance_destroy();
}
