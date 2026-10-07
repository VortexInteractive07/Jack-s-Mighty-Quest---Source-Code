/// @description Move the stage carousel and handle room transitions.

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _tile_w = sprite_exists(spr_vortex_logo_darkmode) ? sprite_get_width(spr_vortex_logo_darkmode) : _gui_w;
var _tile_h = sprite_exists(spr_vortex_logo_darkmode) ? sprite_get_height(spr_vortex_logo_darkmode) : _gui_h;
bg_x = (bg_x + bg_speed_x) mod max(1, _tile_w);
bg_y = (bg_y + bg_speed_y + _tile_h) mod max(1, _tile_h);

switch (fade_state) {
    case 0:
        fade_alpha = (global.fade_style == "OFF") ? 0 : max(0, fade_alpha - fade_speed);
        if (fade_alpha <= 0) fade_state = 1;
        break;

    case 1:
        var _left = keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("A")) || keyboard_check_pressed(ord("W"));
        var _right = keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("D")) || keyboard_check_pressed(ord("S"));
        var _gp_connected = gamepad_is_connected(0);
        var _axis = _gp_connected ? gamepad_axis_value(0, gp_axislh) : 0;
        var _gp_left = _gp_connected && (gamepad_button_check_pressed(0, gp_padl) || (_axis < -0.5 && !gp_axis_x_latched));
        var _gp_right = _gp_connected && (gamepad_button_check_pressed(0, gp_padr) || (_axis > 0.5 && !gp_axis_x_latched));
        gp_axis_x_latched = abs(_axis) > 0.5;

        if (_left || _gp_left) {
            selected_index = (selected_index + stage_count - 1) mod stage_count;
            play_ui_blip(sfx_dialogue);
        } else if (_right || _gp_right) {
            selected_index = (selected_index + 1) mod stage_count;
            play_ui_blip(sfx_dialogue);
        }

        var _cancel = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace)
            || (_gp_connected && gamepad_button_check_pressed(0, gp_face2));
        var _confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)
            || (_gp_connected && (gamepad_button_check_pressed(0, gp_face1) || gamepad_button_check_pressed(0, gp_start)));

        if (_cancel) {
            target_room = rm_title_screen;
            play_ui_blip(sfx_dialogue_continue);
            fade_state = 2;
        } else if (_confirm) {
            var _stage = stages[selected_index];
            if (_stage.unlocked && room_exists(_stage.room_id)) {
                target_room = _stage.room_id;
                global.time_attack_active = false;
                global.time_attack_ticks = 0;
                global.autosave_restore_pending = false;
                global.game_session_active = false;
                play_ui_blip(sfx_dialogue_continue);
                fade_state = 2;
            } else {
                play_ui_blip(sfx_menu_blip);
            }
        }
        break;

    case 2:
        fade_alpha = (global.fade_style == "OFF") ? 1 : min(1, fade_alpha + fade_speed);
        if (fade_alpha >= 1 && scr_transition_black_hold_complete(id)) {
            if (room_exists(target_room)) room_goto(target_room); else room_goto(rm_title_screen);
        }
        break;
}
