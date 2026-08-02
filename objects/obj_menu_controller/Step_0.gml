/// @description Handle Inputs & Matrix Selection Loops

var _key_up       = keyboard_check_pressed(vk_up);
var _key_down     = keyboard_check_pressed(vk_down);
var _key_confirm  = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("A"));
var _key_escape   = keyboard_check_pressed(vk_escape);

// Modal UI Focus Interceptor
if (is_info_open) {
    if (_key_confirm || _key_escape || keyboard_check_pressed(vk_space)) {
        is_info_open = false; 
        if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
    }
    exit; 
}

// Navigation Triggers
if (_key_up) {
    current_menu_selection--;
    if (current_menu_selection < 0) {
        current_menu_selection = menu_total - 1;
        scroll_offset = max(0, menu_total - max_visible_items); 
    }
    if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
}

if (_key_down) {
    current_menu_selection++;
    if (current_menu_selection >= menu_total) {
        current_menu_selection = 0;
        scroll_offset = 0; 
    }
    if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
}

// --- Dynamic Viewport Scroll Locking Mechanics ---
if (current_menu_selection < scroll_offset) {
    scroll_offset = current_menu_selection;
}
if (current_menu_selection >= scroll_offset + max_visible_items) {
    scroll_offset = current_menu_selection - max_visible_items + 1;
}

// Execution Matrix
if (_key_confirm) {
    if (audio_exists(sfx_textbox_continue)) {
        audio_play_sound(sfx_textbox_continue, 1, false);
    }
    
    switch (current_menu_selection) {
        case 0: // PLAY GAME
            if (room_exists(rm_thestorysofar)) room_goto(rm_thestorysofar);
            break;
            
        case 1: // LOAD GAME
            is_info_open = true;
            info_text = "LOAD GAME FUNCTION\nCOMING SOON IN VERSION 1.1!";
            break;
            
        case 2: // TIME ATTACK
            is_info_open = true;
            info_text = "TIME ATTACK MODE\nCOMING SOON IN VERSION 1.1!";
            break;
            
        case 3: // CHEATS
            is_info_open = true;
            info_text = "CHEAT CONSOLE INTERFACE\nCOMING SOON IN VERSION 1.1!";
            break;
            
        case 4: // OPTIONS
            if (room_exists(rm_options)) room_goto(rm_options);
            break;
            
        case 5: // JUKEBOX
            if (room_exists(rm_jukebox)) room_goto(rm_jukebox);
            break;
            
        case 6: // STATISTICS
            is_info_open = true; 
            info_text = "CURRENTLY UNDER DEVELOPMENT\nDUE TO ONGOING TECHNICAL\nWORK!\n\nWE APOLOGISE FOR THE INCONVENIENCE\nCAUSED!\n--VORTEX INTERACTIVE--";
            break;
            
        case 7: // CREDITS
            if (room_exists(rm_credits)) {
                room_goto(rm_credits);
            } else {
                if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
            }
            break;
            
        case 8: // ABOUT / INFO
            is_info_open = true; 
            info_text = "This here is an internal release candidate test!\nAuthorisation and Distribution without permit is\nstrictly prohibited! Thank you for your understanding!\n\n-- Vortex Interactive --";
            break;
            
        case 9: // VOICE ACTING TEST LEVEL
            is_info_open = true;
            info_text = "VOICE ACTING TEST\nCOMING SOON IN VERSION 1.1!";
            break;  
        
        case 10: // MODE-7 SIMULATION TEST
            if (room_exists(rm_mode7)) {
                room_goto(rm_mode7);
            } else {
                if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
            }
            break;

        case 11: // PARALLAX SCROLLING TEST LEVEL
            if (room_exists(rm_parallax)) {
                room_goto(rm_parallax);
            } else {
                is_info_open = true;
                info_text = "PARALLAX TEST ROOM MISSING!";
            }
            break;
        
        case 12: // MODS
            is_info_open = true;
            info_text = "MODS SUPPORT\nCOMING SOON IN VERSION 1.1!";
            break;
            
        case 13: // TEXTURE PACKS    
            is_info_open = true;
            info_text = "TEXTURE PACK SUPPORT\nCOMING SOON IN VERSION 1.1!";
            break;
            
        case 14: // TITLE SCREEN
            if (room_exists(rm_title)) {
                room_goto(rm_title);
            } else {
                if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
            }
            break;  
        
        case 15: // CONCLUDE GAMEPLAY / QUIT
            game_end();
            break;
    }
}