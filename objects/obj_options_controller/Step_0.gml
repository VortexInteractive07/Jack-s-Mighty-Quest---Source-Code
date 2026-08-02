/// @description Navigate & Adjust Options

var _key_up     = keyboard_check_pressed(vk_up);
var _key_down   = keyboard_check_pressed(vk_down);
var _key_left   = keyboard_check_pressed(vk_left);
var _key_right  = keyboard_check_pressed(vk_right);
var _key_back   = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_escape);

// Navigate Vertically
if (_key_up) {
    current_selection--;
    if (current_selection < 0) current_selection = total_options - 1;
    if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
}

if (_key_down) {
    current_selection++;
    if (current_selection >= total_options) current_selection = 0;
    if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
}

// Adjust Horizontally Based on Selection
switch (current_selection) {
    case 0: // SFX VOLUME
        if (_key_left && global.settings.sfx_volume > 0) {
            global.settings.sfx_volume = max(0, global.settings.sfx_volume - 0.1);
            if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
        }
        if (_key_right && global.settings.sfx_volume < 1.0) {
            global.settings.sfx_volume = min(1.0, global.settings.sfx_volume + 0.1);
            if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
        }
        break;
        
    case 1: // MUSIC VOLUME
        if (_key_left && global.settings.mus_volume > 0) {
            global.settings.mus_volume = max(0, global.settings.mus_volume - 0.1);
            audio_master_gain(global.settings.mus_volume); // Real-time feedback
        }
        if (_key_right && global.settings.mus_volume < 1.0) {
            global.settings.mus_volume = min(1.0, global.settings.mus_volume + 0.1);
            audio_master_gain(global.settings.mus_volume);
        }
        break;
        
    case 2: // DISPLAY MODE
        if (_key_left || _key_right) {
            global.settings.fullscreen = !global.settings.fullscreen;
            window_set_fullscreen(global.settings.fullscreen);
            if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
        }
        break;
        
    case 3: // TEXT SPEED
        if (_key_left && global.settings.text_speed > 0.5) {
            global.settings.text_speed = max(0.5, global.settings.text_speed - 0.5);
            if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
        }
        if (_key_right && global.settings.text_speed < 2.0) {
            global.settings.text_speed = min(2.0, global.settings.text_speed + 0.5);
            if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
        }
        break;
}

// Exit and Commit Changes
if (_key_back && current_selection == 4) {
    scr_save_settings_json(); // Instantly serialize changes to settings.json
    if (audio_exists(sfx_textbox_continue)) audio_play_sound(sfx_textbox_continue, 1, false);
    room_goto(rm_main_menu);
}