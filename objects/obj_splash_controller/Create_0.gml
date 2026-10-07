/// @description Initialize Splash Controller, Console Targets & Soundtrack Engine
// Intelligence Level: 10/10

// Required Assets:
// rm_title_screen
// scr_load_settings
// scr_splash_ost_playback
// scr_splash_sequence_controller
// fnt_bitmap

if (script_exists(scr_load_settings)) {
    scr_load_settings();
}

randomise();

target_room = rm_title_screen;

// ==========================================
// 1. SYSTEM TOGGLES & PLATFORM CONFIG
// ==========================================
enable_bgm      = (variable_global_exists("vol_bgm") ? global.vol_bgm > 0 : true); 
enable_lyrics   = true; 
enable_dialogue = variable_global_exists("enable_splash_dialogue") ? global.enable_splash_dialogue : true;
publisher_name  = "VORTEX Interactive";

// Platform Licensing Configuration: "pc", "ps", "switch", "xbox", "deck_machine"
console_type    = "xbox"; 

// Region config for Nintendo Switch: "AMERICA" or "JP"
switch_region   = "AMERICA"; 

// ==========================================
// 2. SOUNDTRACK PLAYLIST & MUSIC MODES
// ==========================================
playlist = (enable_bgm && script_exists(scr_splash_ost_playback)) ? scr_splash_ost_playback() : [];

audio_stop_all();

current_track_index = -1;
splash_sound_inst   = -1;
current_lyric_index = 0;
current_lyric_text  = "";
lyric_list          = [];

music_mode = 2; // 0 = ONLY ONCE, 1 = UNCOMMON, 2 = CONTINUOUS

uncommon_min_delay = 300; 
uncommon_max_delay = 900; 
track_delay_timer  = 0;

play_random_track = function() {
    if (!enable_bgm || array_length(playlist) == 0) exit;
    
    if (audio_is_playing(splash_sound_inst)) {
        audio_stop_sound(splash_sound_inst);
    }
    
    var _new_index = irandom(array_length(playlist) - 1);
    if (array_length(playlist) > 1 && _new_index == current_track_index) {
        _new_index = (_new_index + 1) % array_length(playlist);
    }
    
    current_track_index = _new_index;
    var _selected = playlist[current_track_index];
    
    current_lyric_index = 0;
    current_lyric_text  = "";
    lyric_list          = struct_exists(_selected, "lyrics") ? _selected.lyrics : [];
    
    if (struct_exists(_selected, "sound") && audio_exists(_selected.sound)) {
        var _vol = variable_global_exists("vol_bgm") ? global.vol_bgm / 100 : 1.0;
        splash_sound_inst = audio_play_sound(_selected.sound, 10, false);
        audio_sound_gain(splash_sound_inst, _vol, 0);
    }
};

if (enable_bgm) {
    play_random_track();
}

// ==========================================
// 3. MASTER SPLASH QUEUE & STATE VARS
// ==========================================
splash_list = scr_splash_sequence_controller(enable_dialogue, console_type, switch_region, publisher_name);

splash_index           = 0;           
default_hold_duration  = 255; // Increased by +15 frames (240 -> 255)         
splash_timer           = default_hold_duration;           

alpha                  = 0;           
fade_speed             = 0.03;        
fade_state             = 0;           // 0: Fade In, 1: Hold/Display, 2: Fade Out

can_skip               = true;        
is_exiting             = false;       

char_count             = 0;           
last_sound_char        = 0;        
default_char_speed     = 0.45;  
typewriter_complete    = false;

prompt_blink_timer     = 0;
prompt_visible         = true;
splash_frame           = 0;
last_splash_index      = splash_index;
