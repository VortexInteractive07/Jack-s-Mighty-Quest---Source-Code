/// @description Move and expire the plasma projectile.

x += hspeed;
life_timer--;

if (life_timer <= 0 || x < -64 || x > room_width + 64 || y < -64 || y > room_height + 64) {
    instance_destroy();
}
