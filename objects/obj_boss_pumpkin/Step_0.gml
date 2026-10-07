/// @description Melon Head chase, leap, and ranged attack behavior.

if (hp <= 0) exit;

if (touch_cooldown > 0) touch_cooldown--;
if (boss_leap_cooldown > 0) boss_leap_cooldown--;
if (attack_cooldown > 0) attack_cooldown--;

var _player_exists = instance_exists(obj_jack);
var _player = _player_exists ? instance_find(obj_jack, 0) : noone;
var _player_alive = _player_exists && !_player.is_dead;

// Advance toward Jack while resolving movement against arena walls.
if (_player_alive) {
    var _distance_x = _player.x - x;
    var _toward_player = sign(_distance_x);
    if (_toward_player != 0) facing = _toward_player;
    move_speed = (hp <= max_hp * 0.5) ? 1.8 : 1.2;

    var _boss_dx = facing * move_speed;
    if (place_meeting(x + _boss_dx, y, obj_wall)) {
        facing = -facing;
        _boss_dx = facing * move_speed;
    }
    var _boss_x_before = x;
    move_and_collide(_boss_dx, 0, obj_wall);
    if (abs((x - _boss_x_before) - _boss_dx) > 0.01) facing = -facing;
    image_xscale = (facing == 0) ? 1 : sign(facing) * abs(image_xscale);

    if (boss_leap_cooldown <= 0 && place_meeting(x, y + 1, obj_wall) && abs(_distance_x) > 56) {
        vertical_speed = -5.5;
        boss_leap_cooldown = 90;
    }

    if (attack_cooldown <= 0 && abs(_distance_x) < 320) {
        var _projectile_layer = layer_exists("Projectiles") ? "Projectiles" : "Instances";
        var _wave_sprite = (facing > 0) ? spr_pwave_right : spr_pwave_left;
        var _wave_x = x + (facing * (sprite_width * 0.5 + sprite_get_width(_wave_sprite) * 0.5 + 4));
        var _wave_y = y - (sprite_height * 0.25);
        var _wave = instance_create_layer(_wave_x, _wave_y, _projectile_layer, obj_plasma_wave);
        if (instance_exists(_wave)) {
            _wave.is_hostile = true;
            _wave.damage = 15;
            _wave.hspeed = facing * 4.5;
            _wave.sprite_index = _wave_sprite;
        }
        attack_cooldown = (hp <= max_hp * 0.5) ? 55 : 85;
    }
}

// Resolve vertical movement against solid geometry and land cleanly.
vertical_speed = min(vertical_speed + 0.35, 8);
var _boss_y_before = y;
move_and_collide(0, vertical_speed, obj_wall);
if (abs((y - _boss_y_before) - vertical_speed) > 0.01) vertical_speed = 0;

if (_player_alive && touch_cooldown <= 0 && place_meeting(x, y, obj_jack)) {
    if (instance_exists(obj_controller)) obj_controller.damage_player(contact_damage);
    touch_cooldown = 45;
}
