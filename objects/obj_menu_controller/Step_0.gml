/// @description Navigation, Audio Management, & Action Execution

// Cursor subtle bobbing animation
cursor_offset_x += 0.08 * cursor_dir;
if (abs(cursor_offset_x) > 1.5) cursor_dir *= -1;

switch (fade_state) {

    // --- STATE 0: FADE IN ---
    case 0:
        fade_alpha -= fade_speed;
        if (fade_alpha <= 0) {
            fade_alpha = 0;
            fade_state = 1; // Fully interactive
        }
        break;

    // --- STATE 1: INTERACTIVE MENU ---
    case 1:
        var _move_up   = keyboard_check_pressed(vk_up)   || keyboard_check_pressed(ord("W"));
        var _move_down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
        var _confirm   = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || mouse_check_button_pressed(mb_left);

        // Menu Navigation (With Wraparound)
        if (_move_up) {
            menu_index--;
            if (menu_index < 0) menu_index = menu_total - 1;
        }

        if (_move_down) {
            menu_index++;
            if (menu_index >= menu_total) menu_index = 0;
        }

        // Selection Confirmed
        if (_confirm) {
            io_clear();
            fade_state = 2; // Begin transition out
        }
        break;

    // --- STATE 2: FADE OUT & EXECUTE ACTION ---
    case 2:
        fade_alpha += fade_speed;

        if (fade_alpha >= 1) {
            fade_alpha = 1;

            switch (menu_index) {
                case 0: // PLAY GAME -> goes to rm_intro
                case 1: // LOAD GAME -> goes to rm_intro
                    if (audio_is_playing(mus_menu)) {
                        audio_stop_sound(mus_menu);
                    }
                    room_goto(target_room);
                    break;

                case 2: // TIME ATTACK
                case 3: // CHEATS
                case 4: // OPTIONS
                case 5: // JUKEBOX
                    fade_state = 0; // Placeholder loop-back
                    break;
            }
        }
        break;
}