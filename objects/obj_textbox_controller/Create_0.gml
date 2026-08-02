// --- Language Initialization ---
global.language_mode = 0; 

// --- Core Data ---
text_array = [];       
current_line = 0;      
char_index = 0;        
print_speed = 0.5;     
is_finished = false;   
pause_timer = 0;       
beep_cooldown = 0;     

// --- Animated Button Properties ---
button_sprite = spr_button_d; 

// --- Layout Math ---
box_x = 12; 
box_y = 152; 
box_w = 296; 
box_h = 76; 
text_padding = 8;

// --- Language Font Assignment ---
switch(global.language_mode) {
    case 1: active_font = fnt_romaji; break; // For Japanese
    case 2: active_font = fnt_dialogue; break; // For Thaana
    default: active_font = fnt_dialogue; break; // For English, by Default
}
