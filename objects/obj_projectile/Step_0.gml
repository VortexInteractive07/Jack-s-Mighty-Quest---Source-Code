/// @description Track Lifetime & Orientation

// Countdown to self-destruction
lifetime -= 1;
if (lifetime <= 0) {
    instance_destroy();
}

// Adjust visual direction based on actual movement speed
if (hspeed != 0) {
    image_xscale = sign(hspeed);
}