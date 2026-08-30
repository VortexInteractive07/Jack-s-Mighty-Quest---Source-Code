/// @description Initialize Next-Gen Splash Controller & Script-Based Soundtrack Engine
randomise(); // Seed RNG for playlist selection

target_room = rm_title_screen;

// ==========================================
// 1. SOUNDTRACK PLAYLIST & MUSIC MODES
// ==========================================
playlist = scr_splash_ost_playback();

// Audio setup & Playback State
audio_stop_all();

current_track_index = -1;
splash_sound_inst = -1;
current_lyric_index = 0;
current_lyric_text = "";
lyric_list = [];

enable_lyrics = true; // Toggle subtitle overlay for songs with lyrics

// MUSIC PLAYBACK MODES:
// 0 = ONLY ONCE  : Plays 1 track upon load, then stays silent when finished.
// 1 = UNCOMMON   : Plays 1 track, followed by a long silence before picking the next track.
// 2 = CONTINUOUS : Plays tracks non-stop back-to-back with 0 delay.
music_mode = 2; 

// Mode 1 settings (5s to 15s wait at 60 FPS)
uncommon_min_delay = 300; 
uncommon_max_delay = 900; 
track_delay_timer = 0;

// Helper function to pick and play a random track (non-repeating)
play_random_track = function() {
    if (array_length(playlist) == 0) exit;
    
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
    current_lyric_text = "";
    lyric_list = struct_exists(_selected, "lyrics") ? _selected.lyrics : [];
    
    if (struct_exists(_selected, "sound") && audio_exists(_selected.sound)) {
        splash_sound_inst = audio_play_sound(_selected.sound, 10, false);
    }
};

// Start BGM track
play_random_track();

// ==========================================
// 2. MASTER SPLASH QUEUE (VIA CONTROLLER)
// ==========================================
splash_list = scr_splash_sequence_controller();

splash_index = 0;           
default_hold_duration = 240; 
splash_timer = default_hold_duration;           

alpha = 0;                  
fade_speed = 0.03;          
fade_state = 0;              // 0: Fade In, 1: Hold/Typewriter, 2: Fade Out

can_skip = true;            
is_exiting = false;         

// Typewriter & Audio trackers
char_count = 0;             
last_sound_char = 0;        
default_char_speed = 0.45;  
typewriter_complete = false;

prompt_blink_timer = 0;
prompt_visible = true;