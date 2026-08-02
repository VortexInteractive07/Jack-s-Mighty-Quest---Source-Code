/// @description Navigation, Input Processing & Persistent Saving

pulse_timer += 0.08;

// Floating Particles Logic
for (var i = 0; i < array_length(bg_particles); i++) {
    bg_particles[i].y -= bg_particles[i].spd;
    if (bg_particles[i].y < 0) {
        bg_particles[i].y = view_h;
        bg_particles[i].x = random(view_w);
    }
}

// Input Detection
var _key_up     = keyboard_check_pressed(vk_up)    || keyboard_check_pressed(ord("W")) || gamepad_button_check_pressed(0, gp_padu);
var _key_down   = keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S")) || gamepad_button_check_pressed(0, gp_padd);
var _key_left   = keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A")) || gamepad_button_check_pressed(0, gp_padl);
var _key_right  = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D")) || gamepad_button_check_pressed(0, gp_padr);

var _key_select = keyboard_check_pressed(vk_enter)  || keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(0, gp_face1);
var _key_back   = keyboard_check_pressed(vk_escape) || gamepad_button_check_pressed(0, gp_face2);
var _mouse_click = mouse_check_button_pressed(mb_left);

// Mouse Movement Guard (Prevents static mouse softlocks)
var _mx = window_mouse_get_x();
var _my = window_mouse_get_y();

var _mouse_moved = (_mx != prev_mouse_x || _my != prev_mouse_y);
prev_mouse_x = _mx;
prev_mouse_y = _my;

var _gui_mx = (_mx / max(1, window_get_width()))  * view_w;
var _gui_my = (_my / max(1, window_get_height())) * view_h;

var _menu_start_y = 24;
var _spacing      = 15;
var _box_x1       = 16;
var _box_w        = 394;

// Update menu selection on mouse move
if (_mouse_moved) {
    for (var i = 0; i < total_options; i++) {
        var _item_y = _menu_start_y + (i * _spacing);
        if (_gui_mx >= _box_x1 && _gui_mx <= _box_x1 + _box_w && _gui_my >= _item_y && _gui_my <= _item_y + 13) {
            if (current_selection != i) {
                current_selection = i;
                if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
            }
        }
    }
}

// Keyboard / Gamepad Menu Navigation
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

current_selection = clamp(current_selection, 0, total_options - 1);

// Options Switch Execution
switch (current_selection) {
    case 0: // MASTER VOLUME
        if (_key_left && global.settings.master_volume > 0) {
            global.settings.master_volume = max(0, global.settings.master_volume - 0.1);
            audio_master_gain(global.settings.master_volume);
            scr_save_settings_json();
            if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
        }
        if (_key_right && global.settings.master_volume < 1.0) {
            global.settings.master_volume = min(1.0, global.settings.master_volume + 0.1);
            audio_master_gain(global.settings.master_volume);
            scr_save_settings_json();
            if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
        }
        break;

    case 1: // SFX VOLUME
        if (_key_left && global.settings.sfx_volume > 0) {
            global.settings.sfx_volume = max(0, global.settings.sfx_volume - 0.1);
            scr_save_settings_json();
            if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
        }
        if (_key_right && global.settings.sfx_volume < 1.0) {
            global.settings.sfx_volume = min(1.0, global.settings.sfx_volume + 0.1);
            scr_save_settings_json();
            if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
        }
        break;

    case 2: // MUSIC VOLUME
        if (_key_left && global.settings.mus_volume > 0) {
            global.settings.mus_volume = max(0, global.settings.mus_volume - 0.1);
            scr_save_settings_json();
            if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
        }
        if (_key_right && global.settings.mus_volume < 1.0) {
            global.settings.mus_volume = min(1.0, global.settings.mus_volume + 0.1);
            scr_save_settings_json();
            if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
        }
        break;

    case 3: // DISPLAY MODE
        if (_key_left || _key_right || _key_select || _mouse_click) {
            global.settings.fullscreen = !global.settings.fullscreen;
            window_set_fullscreen(global.settings.fullscreen);
            
            if (!global.settings.fullscreen) {
                window_set_size(view_w * 3, view_h * 3);
                alarm[0] = 1;
            }
            
            surface_resize(application_surface, view_w, view_h);
            display_set_gui_size(view_w, view_h);
            scr_save_settings_json();
            if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
        }
        break;

    case 4: // ASPECT LOCK
        if (_key_left || _key_right || _key_select || _mouse_click) {
            global.settings.aspect_lock = !global.settings.aspect_lock;
            window_set_showborder(global.settings.aspect_lock);
            scr_save_settings_json();
            if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
        }
        break;

    case 5: // TEXT SPEED
        if (_key_left && global.settings.text_speed > 0.5) {
            global.settings.text_speed = max(0.5, global.settings.text_speed - 0.5);
            scr_save_settings_json();
            if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
        }
        if (_key_right && global.settings.text_speed < 2.0) {
            global.settings.text_speed = min(2.0, global.settings.text_speed + 0.5);
            scr_save_settings_json();
            if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
        }
        break;

    case 6: // SCREEN SHAKE
        if (_key_left || _key_right || _key_select || _mouse_click) {
            global.settings.screen_shake = !global.settings.screen_shake;
            scr_save_settings_json();
            if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
        }
        break;

    case 7: // FLASH REDUCTION
        if (_key_left || _key_right || _key_select || _mouse_click) {
            global.settings.flash_reduction = !global.settings.flash_reduction;
            scr_save_settings_json();
            if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
        }
        break;

    case 8: // BACKGROUND AUDIO
        if (_key_left || _key_right || _key_select || _mouse_click) {
            global.settings.bg_audio = !global.settings.bg_audio;
            audio_falloff_set_model(audio_falloff_none);
            scr_save_settings_json();
            if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
        }
        break;

    case 9: // UI COLOR SCHEME
        if (_key_left) {
            global.settings.theme_index--;
            if (global.settings.theme_index < 0) global.settings.theme_index = 2;
            scr_save_settings_json();
            if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
        }
        if (_key_right || _key_select || _mouse_click) {
            global.settings.theme_index++;
            if (global.settings.theme_index > 2) global.settings.theme_index = 0;
            scr_save_settings_json();
            if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
        }
        break;

    case 10: // RESET DEFAULT
        if (_key_select || _mouse_click) {
            global.settings.master_volume   = 1.0;
            global.settings.sfx_volume      = 0.8;
            global.settings.mus_volume      = 0.8;
            global.settings.fullscreen      = false;
            global.settings.aspect_lock     = true;
            global.settings.text_speed      = 1.0;
            global.settings.screen_shake    = true;
            global.settings.flash_reduction = false;
            global.settings.bg_audio        = false;
            global.settings.theme_index     = 0;
            
            audio_master_gain(1.0);
            window_set_fullscreen(false);
            window_set_size(view_w * 3, view_h * 3);
            alarm[0] = 1;
            
            scr_save_settings_json();
            if (audio_exists(sfx_textbox_continue)) audio_play_sound(sfx_textbox_continue, 1, false);
        }
        break;

    case 11: // BACK TO MENU
        if (_key_select || _mouse_click) {
            scr_save_settings_json();
            if (audio_exists(sfx_textbox_continue)) audio_play_sound(sfx_textbox_continue, 1, false);
            room_goto(rm_main_menu);
        }
        break;
}

// Global Escape Key Exit Guard
if (_key_back) {
    scr_save_settings_json();
    if (audio_exists(sfx_textbox_continue)) audio_play_sound(sfx_textbox_continue, 1, false);
    room_goto(rm_main_menu);
}