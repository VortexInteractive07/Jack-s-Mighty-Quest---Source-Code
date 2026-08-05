/// @description Background Time Tracking & Stats Room Input Listener

// 1. Always track time played globally across the entire game
if (variable_global_exists("stats")) {
    var _fps_target = game_get_speed(gamespeed_fps);
    if (_fps_target > 0) {
        global.stats.time_played_sec += (1 / _fps_target);
    }
}

anim_timer += 0.05;

// 2. ONLY handle inputs and exiting if we are currently inside the stats room
if (room_get_name(room) == "rm_stats" || room == rm_stats) {
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_escape)) {
        if (audio_exists(sfx_textbox)) {
            audio_play_sound(sfx_textbox, 1, false);
        }
        
        room_goto(rm_main_menu);
    }
}