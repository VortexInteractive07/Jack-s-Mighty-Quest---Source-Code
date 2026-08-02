/// @description Exit routing listener loops
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_escape)) {
    if (audio_exists(sfx_textbox)) audio_play_sound(sfx_textbox, 1, false);
    room_goto(rm_main_menu);
}