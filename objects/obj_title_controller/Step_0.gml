/// @description Inputs, Level Select Navigation, Cheat Code & Transitions

var _press_up    = keyboard_check_pressed(vk_up);
var _press_down  = keyboard_check_pressed(vk_down);
var _press_left  = keyboard_check_pressed(vk_left);
var _press_right = keyboard_check_pressed(vk_right);
var _press_a     = keyboard_check_pressed(ord("A"));
var _press_esc   = keyboard_check_pressed(vk_escape);

blink_timer++;

var _enter_handled_by_cheat = false;

// =================================================================
// CHEAT CODE DETECTOR (UP, DOWN, LEFT, RIGHT, A + ENTER)
// =================================================================
if (!level_select_unlocked && fade_state == "idle") {
    var _expected_key = cheat_sequence[cheat_index];
    
    // Check if expected key in sequence was pressed
    if (keyboard_check_pressed(_expected_key)) {
        cheat_index++;
        
        // Play small click tone on progress
        if (audio_exists(sfx_textbox)) {
            audio_play_sound(sfx_textbox, 1, false);
        }
        
        // Full sequence entered successfully!
        if (cheat_index >= array_length(cheat_sequence)) {
            level_select_unlocked = true;
            cheat_index = 0;
            
            // Hide standard start message and version string while in level select
            start_message = "";
            version_text  = "";
            
            // Consume the Enter key so it doesn't trigger instant room transition
            _enter_handled_by_cheat = true; 
            
            // Play secret unlock sound effect
            if (audio_exists(sfx_textbox_continue)) {
                audio_play_sound(sfx_textbox_continue, 10, false);
            }
        }
    } 
    // Reset sequence if wrong key pressed
    else if (keyboard_check_pressed(vk_anykey)) {
        cheat_index = 0; 
    }
}

// =================================================================
// LEVEL SELECT NAVIGATION & ESCAPE RETURN
// =================================================================
if (level_select_unlocked && fade_state == "idle" && !transition_triggered) {
    // Menu item browsing
    if (_press_up || _press_left) {
        selected_level_index--;
        if (selected_level_index < 0) selected_level_index = array_length(level_list) - 1;
        
        if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
    }
    
    if (_press_down || _press_right) {
        selected_level_index = (selected_level_index + 1) % array_length(level_list);
        
        if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
    }

    // Press ESCAPE: Cancel Level Select & Restore Title Screen
    if (_press_esc) {
        level_select_unlocked = false;
        selected_level_index  = 0;

        // Restore start text & version display
        start_message = "PRESS ENTER TO START";
        version_text  = "v1.0.0";

        // Pick a new random splash text if an array exists
        if (variable_instance_exists(id, "splash_list") && array_length(splash_list) > 0) {
            splash_text = splash_list[irandom(array_length(splash_list) - 1)];
        }
        typewriter_chars = 0;

        if (audio_exists(sfx_textbox)) {
            audio_play_sound(sfx_textbox, 1, false);
        }
    }
}

// =================================================================
// TRANSITION STATE MACHINE
// =================================================================
switch (fade_state) {
    case "in":
        fade_progress += transition_speed;
        if (fade_progress >= 1.0) {
            fade_progress = 1.0;
            fade_state = "idle";
        }
        break;
        
    case "idle":
        if (typewriter_chars < string_length(splash_text)) {
            typewriter_chars += 0.5; 
        }

        // Only process Enter press if it wasn't used as the final cheat code key!
        if (keyboard_check_pressed(vk_enter) && !_enter_handled_by_cheat && !transition_triggered) {
            if (level_select_unlocked) {
                target_room = level_list[selected_level_index].room_id;
            } else {
                target_room = rm_main_menu;
            }
            
            transition_triggered = true;
            fade_state = "out";
            fade_progress = 0.0;
            
            if (audio_exists(sfx_textbox_continue)) {
                audio_play_sound(sfx_textbox_continue, 1, false);
            }
        }
        break;
        
    case "out":
        if (typewriter_chars < string_length(splash_text)) {
            typewriter_chars += 0.5; 
        }

        fade_progress += transition_speed;
        if (fade_progress >= 1.0) {
            fade_progress = 1.0;
            room_goto(target_room);
        }
        break;
}

// =================================================================
// TITLE MUSIC PLAYLIST
// =================================================================
if (variable_global_exists("title_playlist") && array_length(global.title_playlist) > 0) {
    
    // Safety check for starting flag
    if (!variable_global_exists("title_music_started")) {
        global.title_music_started = false;
    }

    var _current_song = global.title_playlist[global.current_song_index];

    // If no song in playlist is currently playing
    if (!audio_is_playing(_current_song)) {
        
        // If music was already playing before, it means song finished -> advance to next!
        if (global.title_music_started) {
            global.current_song_index = (global.current_song_index + 1) % array_length(global.title_playlist);
            _current_song = global.title_playlist[global.current_song_index];
        }

        // Play track & mark music as active
        if (audio_exists(_current_song)) {
            audio_play_sound(_current_song, 100, false);
            global.title_music_started = true;
        }
    }
}