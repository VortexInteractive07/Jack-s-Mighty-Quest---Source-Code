/// @function scr_get_random_splash()
/// @description Returns a random splash text string for the title screen.
function scr_get_random_splash() {
    var _splashes = [
        "AN ADVENTURE LIKE NO OTHER!",
        "NOW IN 16-BIT!",
		"WHERE IS VIC SHARP? PLAY JMQ TO FIND OUT!",
		"VOCTOLY ACHIVED!",
        "PRESS ENTER TO PLAY!",
        "VORTEX POWERED!",
        "NO BUGS, ONLY FEATURES!",
        "RETRO POWER!",
        "JACK IS BACK!"
    ];
    
    // Pick a random index
    var _index = irandom(array_length(_splashes) - 1);
    return _splashes[_index];
}