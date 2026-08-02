/// @description Initialize Level Completion Flag & Sequence Details

triggered        = false;
hold_timer       = 0;
hold_max         = 180;    // 3 seconds at 60 FPS after text finishes
alpha            = 0; 
text_msg         = ""; 
transitioning    = false;

// Typewriter Engine Settings
draw_char_count  = 0;
typewriter_speed = 0.5;
text_sound_delay = 0;