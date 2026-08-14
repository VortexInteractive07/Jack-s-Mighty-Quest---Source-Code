/// @description Initialize Splash Controller
target_room = rm_title_screen; // Target room after splashes finish

// Array of splash sprites to display sequentially
splash_list = [
    spr_disclaimer,
    spr_vortex_logo_lightmode,
	spr_vortex_presents
];

splash_index = 0;           // Current splash image
splash_hold_duration = 120; // Hold duration in frames (120 frames = 2 seconds @ 60 FPS)
splash_timer = 0;           // Internal countdown timer

// Fade Properties
alpha = 0;                  // Current opacity (0 = invisible, 1 = fully visible)
fade_speed = 0.02;          // Speed of fade in/out
fade_state = 0;             // 0: Fade In | 1: Hold | 2: Fade Out

can_skip = true;            // Set to true to allow player input skip