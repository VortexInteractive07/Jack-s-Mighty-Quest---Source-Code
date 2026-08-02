/// @description Initialize Widescreen, Modes, Audio Visualizer, Subtitles & Language Tracking

// ============================================================================
// 0. GLOBAL LANGUAGE MODE INITIALIZATION
// ============================================================================
if (!variable_global_exists("language_mode")) {
    global.language_mode = 0; // 0 = English, 1 = Romaji, 2 = Dhivehi (Latinized)
}
_prev_language_mode = global.language_mode;

// ============================================================================
// 1. DYNAMIC RESOLUTION SETTINGS (426x240 Native Widescreen)
// ============================================================================
var _gui_w = 426;
var _gui_h = 240;

surface_resize(application_surface, _gui_w, _gui_h);
display_set_gui_size(_gui_w, _gui_h);

if (view_enabled) {
    view_visible[0] = true;
    camera_set_view_size(view_camera[0], _gui_w, _gui_h);
}

// ============================================================================
// 2. PLAY MODE & SONG STYLE TOGGLES
// ============================================================================
// 0 = Video Mode ("demo_end.mp4")
// 1 = Song Mode ("No Bridge to Cross")
// 2 = Textbox Mode WITH BGM (mus_ranga_dhun_yeh)
// 3 = Textbox Mode WITHOUT Music
play_mode = 3; 

// --- Style Mode Selection for Song Mode (play_mode = 1) ---
song_style = 0; 

// Visual Toggles
show_dialogue = (play_mode != 0); 

// --- Red Music Aura & Premium Visualizer Variables (Song Mode) ---
aura_pulse = 0;
aura_color = make_color_rgb(220, 20, 40); // Deep Victor Red

// Spectrum Analyzer Arrays (Software Creations Style)
vis_bars   = 42; 
vis_levels = array_create(vis_bars, 0); 
vis_peaks  = array_create(vis_bars, 0); 

// --- Safe Audio Handles ---
end_sequence_audio = noone;
audio_played       = false;

// --- Timed Lyrics Array for Song Mode ---
lyrics_array = [
    { time: 0.00,   text: "" },
    { time: 18.01,  text: "Watch the sky turn into iron gray" },
    { time: 25.79,  text: "Shadows stretch to catch the light of day" },
    { time: 32.47,  text: "I don't need a reason, I don't need a rhyme" },
    { time: 39.55,  text: "I just need to watch you, run out of time" },
    { time: 46.17,  text: "Path of destruction is all I care" },
    { time: 53.93,  text: "The screams of horror is all that's fair" },
    { time: 60.89,  text: "Do what you want, but you cannot escape" },
    { time: 64.32,  text: "The death is near, and so as your fate" },
    { time: 68.74,  text: "..so as your fate! (your fate, your fate)" },
    { time: 73.62,  text: "The gears are turning in the dark below" },
    { time: 80.97,  text: "I'm the only harvest that the ruins grow" },
    { time: 90.01,  text: "No exit sign, no bridge for you to cross" },
    { time: 95.92,  text: "Calculatin' every second of your loss" },
    { time: 103.29, text: "" },
    { time: 118.29, text: "Path of destruction is all I care" },
    { time: 126.10, text: "The screams of horror is all that's fair" },
    { time: 132.99, text: "Do what you want, but you cannot escape" },
    { time: 136.39, text: "The death is near, and so as your fate" },
    { time: 140.89, text: "Yeah, the death is near, and so as your fate!" },
    { time: 146.80, text: "Victor Schadenfreude" },
    { time: 157.00, text: "Doomsday is here!" },
    { time: 160.97, text: "" }
];

// Assign active dialogue/lyrics data using your localized script
if (play_mode == 1) {
    text_array = lyrics_array;
} else {
    if (script_exists(get_dialogue_demoend)) {
        text_array = get_dialogue_demoend();
    } else {
        text_array = [];
    }
}

// --- Core Data & Typewriter Engine ---
current_line  = 0;        
char_index    = 0;        
print_speed   = 0.35; 
is_finished   = false;    
pause_timer   = 0;        
beep_cooldown = 0;      
prompt_sine   = 0; 

button_sprite = asset_get_index("spr_button_d"); 

// Stop previous room sounds
audio_stop_all();

// --- Mode-Specific Audio/Video Initialization ---
switch (play_mode) {
    case 0: // Video Mode
        video_open("demo_end.mp4");
        break;
        
    case 1: // Song Mode ("No Bridge to Cross")
        if (audio_exists(mus_no_bridge_to_cross)) {
            end_sequence_audio = audio_play_sound(mus_no_bridge_to_cross, 10, false);
            audio_played = true;
        }
        break;
        
    case 2: // Textbox Mode WITH BGM
        if (audio_exists(mus_ranga_dhun_yeh)) {
            end_sequence_audio = audio_play_sound(mus_ranga_dhun_yeh, 10, true); 
            audio_played = true;
        }
        break;
        
    case 3: // Textbox Mode WITHOUT Music
        break;
}