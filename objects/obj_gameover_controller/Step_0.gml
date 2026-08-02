/// @description Handle Sci-Fi Terminal Inputs & Grid Motion

// Smooth Fade-In effect for sci-fi atmosphere
if (terminal_alpha < 1) terminal_alpha += 0.05;

// Animate Cyber Starfield & Grid Scroll
cyber_grid_offset = (cyber_grid_offset + 0.5) % 16;

for (var i = 0; i < max_stars; i++) {
    stars[i].z -= 0.04; // Faster warp-speed star travel
    if (stars[i].z <= 0) {
        stars[i].x = random_range(-250, 250);
        stars[i].y = random_range(-250, 250);
        stars[i].z = 6;
    }
}

// Glitch ticker
glitch_timer++;

// 60-Second Arcade Countdown
if (!continue_expired && gameover_selection == 0) {
    continue_frames--;
    if (continue_frames <= 0) {
        continue_frames = 60;
        continue_timer--;
        
        if (continue_timer > 0 && audio_exists(sfx_textbox)) {
            audio_play_sound(sfx_textbox, 1, false);
        }
        
        if (continue_timer <= 0) {
            continue_expired = true;
            gameover_options[0] = "[ CORE OVERHEAT - EXPIRED ]";
            gameover_selection = 1;
        }
    }
}

// Navigation Controls
var _key_up      = keyboard_check_pressed(vk_up);
var _key_down    = keyboard_check_pressed(vk_down);
var _key_confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("A"));

if (_key_up) {
    gameover_selection--;
    if (continue_expired && gameover_selection == 0) gameover_selection = gameover_total - 1;
    if (gameover_selection < 0) gameover_selection = gameover_total - 1;
    if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
}

if (_key_down) {
    gameover_selection++;
    if (gameover_selection >= gameover_total) {
        gameover_selection = (continue_expired) ? 1 : 0;
    }
    if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
}

// Selection Confirm Action
if (_key_confirm) {
    if (gameover_selection == 0 && continue_expired) exit;
    if (audio_exists(sfx_textbox_continue)) audio_play_sound(sfx_textbox_continue, 1, false);
    
    switch (gameover_selection) {
        case 0: // CONTINUE
        case 1: // RETRY
            global.player_lives = 3;
            
            // Check target_restart_room first, fallback to global.last_room if assigned, or rm_game
            var _dest_room = rm_game;
            if (variable_instance_exists(id, "target_restart_room") && room_exists(target_restart_room)) {
                _dest_room = target_restart_room;
            } else if (variable_global_exists("last_room") && room_exists(global.last_room)) {
                _dest_room = global.last_room;
            }
            
            room_goto(_dest_room);
            break;
            
        case 2: // QUIT TO MENU
            if (room_exists(rm_title)) room_goto(rm_title);
            break;
    }
}