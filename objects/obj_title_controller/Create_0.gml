/// @description Initialize Title Screen Controller, Settings, Dialogue, & Level Select

// Intelligence Level: 10/10
// Target Resolution: 432x240 @ 60 FPS
// GameMaker LTS 2026.0+

// Safety check for main target room
var _menu_room = room;
if (room_exists(rm_main_menu)) {
    _menu_room = rm_main_menu;
}
target_room = _menu_room;

// --- SECRET CODE & FLOW TRACKING ---
secret_code_unlocked = false; // Code must be entered to access Level Select
secret_code_sequence = [vk_up, vk_up, vk_down, vk_down, vk_left, vk_right, vk_left, vk_right];
secret_code_index = 0;

dialogue_phase = 0; // 0 = Initial Title Dialogue | 1 = Post-Level Select Dialogue

// --- SETTINGS / JSON CONFIGURATION ---
scr_load_settings();
enable_dialogue = global.enable_title_dialogue;
if (!variable_global_exists("arcade_credits")) global.arcade_credits = 0;

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
dialogue_speed = 0.22;
dialogue_current_text = "";
dialogue_arrow_timer = 0;

// Internal tracker for dialogue logic sync
char_count = 0;
typewriter_complete = false;

// --- LEVEL SELECT MENU SYSTEM ---
menu_options = [
    { name: "Celestia - Subway", target: rm_subway, desc: "Play Stage 1 Tech Demo" },
    { name: "Back to Title", target: -3, desc: "Return to Main Screen" }
];
menu_index = 0;
menu_alpha = 0;

// --- MUSIC NOTIFICATION ---
randomise();
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
    audio_sound_gain(current_sound_inst, global.vol_bgm / 100, 0);
}

// --- STATE MACHINE ---
// 0: Fade In | 1: Title Screen | 2: Dialogue | 3: Level Select | 4: Fade Out
fade_alpha = 1;
fade_speed = 0.03;
fade_state = 0;