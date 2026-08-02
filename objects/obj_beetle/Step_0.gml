/// @description Smooth Steering Flight Logic
event_inherited();

if (!instance_exists(obj_player)) exit;

// 1. Smooth Steering Vector toward Player
var _dir = point_direction(x, y, obj_player.x, obj_player.y - 12);
var _target_hsp = lengthdir_x(max_speed, _dir);
var _target_vsp = lengthdir_y(max_speed, _dir);

// Smoothly interpolate speed instead of instant snapping
hsp = lerp(hsp, _target_hsp, accel);
vsp = lerp(vsp, _target_vsp, accel);

// 2. Add Natural Sine Wave Bobbing
hover_timer += 0.06;
var _bob = sin(hover_timer) * 0.4;

// 3. Apply Smooth Positions
x += hsp;
y += vsp + _bob;

// 4. Orientation
if (abs(hsp) > 0.1) facing = sign(hsp);
image_xscale = facing;