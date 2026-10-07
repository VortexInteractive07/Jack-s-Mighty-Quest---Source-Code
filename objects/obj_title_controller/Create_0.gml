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

// Load saved cheats before checking whether level select is already unlocked.
scr_load_settings();

// --- SECRET CODE & FLOW TRACKING ---
secret_code_unlocked = global.cheat_unlocked; // Cheats may unlock Level Select immediately
secret_code_sequence = [vk_up, vk_up, vk_down, vk_down, vk_left, vk_right, vk_left, vk_right];
secret_code_index = 0;

// --- SETTINGS / JSON CONFIGURATION ---
enable_dialogue = global.enable_title_dialogue;
if (!variable_global_exists("arcade_credits")) global.arcade_credits = 0;

// Retrieve the original logo splash, random start message & game version
title_splash_text = scr_get_random_splash();
press_start_message = scr_get_random_press_start_message();
game_version = "v1.0.0-alpha";

// --- Typewriter effect for the original logo splash ---
splash_type_index = 0;
splash_type_speed = 0.35;
splash_current_str = "";
splash_angle = 0;

// --- Blinking press start prompt ---
show_start_text = true;
flash_timer = 0;
flash_interval = 20;

// --- TECH DEMO DIALOGUE SYSTEM ---
in_dialogue = false;
dialogue_lines = scr_dialogue("title_intro");
dialogue_index = 0;
dialogue_char_index = 0;
dialogue_speed = 0.22;
dialogue_current_text = "";
dialogue_arrow_timer = 0;

// Internal tracker for dialogue logic sync
char_count = 0;
typewriter_complete = false;

begin_dialogue = function(_dialogue_id) {
    var _lines = scr_dialogue(_dialogue_id);
    if (array_length(_lines) <= 0) return false;

    dialogue_lines = _lines;
    dialogue_index = 0;
    dialogue_char_index = 0;
    dialogue_current_text = "";
    dialogue_arrow_timer = 0;
    char_count = 0;
    typewriter_complete = false;
    in_dialogue = true;
    fade_state = 2;
    return true;
};

finish_dialogue = function() {
    in_dialogue = false;
    if (target_room == -1 || !room_exists(target_room)) {
        target_room = room_exists(rm_main_menu) ? rm_main_menu : room;
    }
    fade_state = 4;
};

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
    
    // Check if the initial random track is the title theme or marked to loop
    var _is_looping = false;
    if (struct_exists(_track, "is_title") && _track.is_title) {
        _is_looping = true;
    } else if (struct_exists(_track, "sound") && _track.sound == mus_title_theme) {
        _is_looping = true;
    }

    current_sound_inst = audio_play_sound(_track.sound, 10, _is_looping);
    audio_sound_gain(current_sound_inst, global.vol_bgm / 100, 0);
}

// --- STATE MACHINE ---
// 0: Fade In | 1: Title Screen | 2: Dialogue | 4: Fade Out
fade_alpha = 1;
fade_speed = 0.03;
fade_state = 0;
