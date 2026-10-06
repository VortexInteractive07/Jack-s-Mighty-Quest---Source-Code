/// @description Move the shot and remove it after its lifetime or on level bounds.

x += shot_direction * shot_speed;
life_timer--;

if (life_timer <= 0 || x < -sprite_width || x > room_width + sprite_width) {
    instance_destroy();
}