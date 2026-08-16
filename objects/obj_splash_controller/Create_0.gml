/// @description Initialize Next-Gen Splash Controller
target_room = rm_title_screen;

// Audio setup
var splash_bgm = mus_vortexlogo;
audio_stop_all();
if (audio_exists(splash_bgm)) {
    audio_play_sound(splash_bgm, 10, true);
}

// Splash Queue: Mix sprite assets and dialogue structs
// Struct parameters: name, text, font, color, scale, speed, hold
splash_list = [
    spr_disclaimer,
    { name: "Jack", text: "Lorem Ipsum Dolor Sit Amet\nParagraph 2\nParagraph 3", font: fnt_bitmap, color: c_white, scale: 1, speed: 0.45, hold: 180 },
    { name: "", text: "Welcome to the adventure\nof the greatness!", font: fnt_bitmap, color: c_white, scale: 1, speed: 0.5 },
    { name: "", text: "Congraturation!", font: fnt_bitmap, color: c_white, scale: 1, speed: 0.3 },
    { name: "", text: "All your base are belong to us!", font: fnt_bitmap, color: c_white, scale: 1, speed: 0.4 },
    spr_vortex_logo_lightmode,
    spr_vortex_presents
];

splash_index = 0;           
default_hold_duration = 240; // Default hold time (in frames)
splash_timer = default_hold_duration;           

alpha = 0;                  
fade_speed = 0.03;          
fade_state = 0;             // 0: Fade In, 1: Hold/Typewriter, 2: Fade Out

can_skip = true;            
is_exiting = false;         // Prevents double-triggering room switch

// Typewriter & Audio trackers
char_count = 0;             
last_sound_char = 0;        
default_char_speed = 0.45;  
typewriter_complete = false;

// Pro Features: Blinking Prompt & Gamepad
prompt_blink_timer = 0;
prompt_visible = true;