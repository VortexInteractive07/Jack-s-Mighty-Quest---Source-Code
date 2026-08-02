/// @description Ground Physics & Surface Patrol
event_inherited();

// 1. Apply Gravity
vsp += grv;
hsp = facing * walk_speed;

// 2. Horizontal Wall Collision Check
if (place_meeting(x + hsp, y, obj_wall)) {
    while (!place_meeting(x + sign(hsp), y, obj_wall)) {
        x += sign(hsp);
    }
    hsp = 0;
    facing *= -1; // Flip direction when striking a wall
}
x += hsp;

// 3. Vertical Wall Collision Check (Grounded Surface Control)
if (place_meeting(x, y + vsp, obj_wall)) {
    while (!place_meeting(x, y + sign(vsp), obj_wall)) {
        y += sign(vsp);
    }
    vsp = 0;
}
y += vsp;

// 4. Edge Detection (Turn around before walking off a ledge)
var _is_grounded = place_meeting(x, y + 1, obj_wall);
var _ahead_ground = place_meeting(x + (facing * 12), y + 1, obj_wall);

if (_is_grounded && !_ahead_ground) {
    facing *= -1; // Flip direction at cliff edges
}

// 5. Dynamic Animation State Engine
if (abs(hsp) > 0.1) {
    sprite_index = spr_run;
} else {
    sprite_index = spr_idle;
}

// 6. Flip Sprite
image_xscale = facing;