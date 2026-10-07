/// @description Step Event: Input Handling, Background Scrolling, and Fade Transitions

var _tw = sprite_exists(spr_vortex_logo_darkmode) ? sprite_get_width(spr_vortex_logo_darkmode) : 64;
var _th = sprite_exists(spr_vortex_logo_darkmode) ? sprite_get_height(spr_vortex_logo_darkmode) : 64;

// Smooth Modulo Wrapping for Infinite Diagonal Background Scroll
bg_x = (bg_x + bg_speed_x) mod _tw;
bg_y = (bg_y + bg_speed_y + _th) mod _th;

if (current_playing_track != -1 && audio_is_playing(current_playing_track)) {
    playback_position = audio_sound_get_track_position(current_playing_track);
}

switch (fade_state) {
    case 0:
        if (global.fade_style == "OFF") fade_alpha = 0; else fade_alpha -= fade_speed;
        if (fade_alpha <= 0) {
            fade_alpha = 0;
            fade_state = 1;
        }
        break;

    case 1:
        var _move_up   = keyboard_check_pressed(vk_up)   || keyboard_check_pressed(ord("W"));
        var _move_down = keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S"));
        var _confirm   = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
        var _cancel    = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace);

        if (_move_up) {
            selected_index = (selected_index - 1 + playlist_total) % playlist_total;
            if (selected_index < scroll_offset) {
                scroll_offset = selected_index;
            } else if (selected_index == playlist_total - 1) {
                scroll_offset = max(0, playlist_total - visible_max);
            }
            play_ui_blip(sfx_dialogue_asset);
        }

        if (_move_down) {
            selected_index = (selected_index + 1) % playlist_total;
            if (selected_index >= scroll_offset + visible_max) {
                scroll_offset = selected_index - visible_max + 1;
            } else if (selected_index == 0) {
                scroll_offset = 0;
            }
            play_ui_blip(sfx_dialogue_asset);
        }

        if (_confirm) {
            load_and_play_track(selected_index);
        }

        if (keyboard_check_pressed(ord("P"))) {
            toggle_playback_state();
        }

        if (_cancel) {
            play_ui_blip(sfx_continue_asset);
            fade_state = 2;
        }
        break;

    case 2:
        if (global.fade_style == "OFF") fade_alpha = 1; else fade_alpha += fade_speed;
        if (current_playing_track != -1 && audio_is_playing(current_playing_track)) {
            audio_sound_gain(current_playing_track, (1 - fade_alpha) * audio_gain_val, 0);
        }
        if (fade_alpha >= 1) {
            fade_alpha = 1;
            if (!scr_transition_black_hold_complete(id)) break;
            if (current_playing_track != -1 && audio_is_playing(current_playing_track)) {
                audio_stop_sound(current_playing_track);
            }
            if (room_exists(target_room)) {
                room_goto(target_room);
            } else {
                game_restart();
            }
        }
        break;
}
