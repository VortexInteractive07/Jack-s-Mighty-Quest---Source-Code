/// @description Initialize Title Screen Controller, Settings, & Dialogue

// Target transition room set to Main Menu (with safety fallback to current room)
var _menu_room = (asset_get_index("rm_main_menu") != -1) ? asset_get_index("rm_main_menu") : room;
target_room = _menu_room;

// --- SETTINGS / JSON CONFIGURATION ---
enable_dialogue = false; // Fallback default toggle

if (file_exists("settings.json")) {
    var _file = file_text_open_read("settings.json");
    var _json_str = "";
    while (!file_text_eof(_file)) {
        _json_str += file_text_readln(_file);
    }
    file_text_close(_file);
    
    var _data = json_parse(_json_str);
    if (is_struct(_data) && struct_exists(_data, "enable_dialogue")) {
        enable_dialogue = _data.enable_dialogue;
    }
}

// Retrieve random title splash text & game version
title_splash_text = scr_get_random_splash();
game_version = "v1.0.0-alpha";

// --- TYPEWRITER EFFECT FOR TITLE SPLASH ---
splash_type_index = 0;
splash_type_speed = 0.35;
splash_current_str = "";
splash_angle = 0;

// --- RETRO FLASHING PRESS START PROMPT ---
show_start_text = true;
flash_timer = 0;
flash_interval = 20;

// Legacy variables
text_alpha = 1;
text_pulse_speed = 0.03;
text_pulse_dir = -1;

// --- TECH DEMO DIALOGUE SYSTEM ---
in_dialogue = false;
dialogue_lines = scr_dialogue("tech_demo");
dialogue_index = 0;
dialogue_char_index = 0;
dialogue_speed = 0.22; // Slowed down for smooth readability
dialogue_current_text = "";

// --- MUSIC NOTIFICATION (COMPACT TOAST & RANDOMIZED) ---
randomise(); // Seed the random number generator
ost_playlist = scr_title_ost_playlist();
current_track_index = (array_length(ost_playlist) > 0) ? irandom(array_length(ost_playlist) - 1) : 0;
current_sound_inst = -1;

toast_timer = 360;
toast_y = -40;
toast_target_y = 8;
toast_lerp_speed = 0.15;

if (array_length(ost_playlist) > 0) {
    var _track = ost_playlist[current_track_index];
	audio_stop_all();
    current_sound_inst = audio_play_sound(_track.sound, 10, false);
}

// --- STATE MACHINE ---
fade_alpha = 1;
fade_speed = 0.03;
fade_state = 0;