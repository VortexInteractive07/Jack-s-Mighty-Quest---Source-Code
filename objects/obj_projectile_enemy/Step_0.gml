/// @description Track Lifetime

// Countdown to self-destruction
lifetime -= 1;

if (lifetime <= 0) {
    instance_destroy();
}