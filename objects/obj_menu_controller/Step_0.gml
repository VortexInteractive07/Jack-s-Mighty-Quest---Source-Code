/// @description Navigation, Audio Management, & Action Execution

// Cursor subtle bobbing animation
cursor_offset_x += 0.08 * cursor_dir;
if (abs(cursor_offset_x) > 1.5) cursor_dir *= -1;

switch (fade_state) {

    // ==========================================
    // --- STATE 0: FADE IN ---
    // ==========================================
    case 0:
        fade_alpha -= fade_speed;
        if (fade_alpha <= 0) {
            fade_alpha = 0;
            fade_state = 1; // Fully interactive
        }
        break;

    // ==========================================
    // --- STATE 1: INTERACTIVE MENUS ---
    // ==========================================
    case 1:
        var _move_up    = keyboard_check_pressed(vk_up)    || keyboard_check_pressed(ord("W"));
        var _move_down  = keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S"));
        var _move_left  = keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A"));
        var _move_right = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
        var _confirm    = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || mouse_check_button_pressed(mb_left);
        var _cancel     = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace);

        // Helper function for SFX playback respecting volume level
        var _sfx_vol = global.vol_sfx / 100;
        var _bgm_vol = global.vol_bgm / 100;

        // --------------------------------------
        // MODE 0: MAIN MENU
        // --------------------------------------
        if (current_mode == 0) {
            if (_move_up) {
                menu_index = (menu_index - 1 + menu_total) % menu_total;
                var _snd = audio_play_sound(sfx_dialogue, 1, false);
                audio_sound_gain(_snd, _sfx_vol, 0);
            }
            if (_move_down) {
                menu_index = (menu_index + 1) % menu_total;
                var _snd = audio_play_sound(sfx_dialogue, 1, false);
                audio_sound_gain(_snd, _sfx_vol, 0);
            }

            if (_confirm) {
                var _snd = audio_play_sound(sfx_dialogue_continue, 1, false);
                audio_sound_gain(_snd, _sfx_vol, 0);

                switch (menu_index) {
                    case 0: // PLAY GAME
                    case 1: // LOAD GAME
                        io_clear();
                        fade_state = 2; // Transition out to target_room
                        break;

                    case 2: // TIME ATTACK
                    case 3: // CHEATS
                        break;

                    case 4: // OPTIONS
                        current_mode = 1;
                        opt_index = 0;
                        break;

                    case 5: // JUKEBOX
                        current_mode = 2;
                        juke_index = 0;
                        break;

                    case 6: // RET TO TITLE
                        io_clear();
                        fade_state = 2; // Transition out to title room
                        break;
						
					case 7:
						io_clear();
						fade_state = 2;
						room_goto(rm_splash_screen);
						break;
                }
            }
        }

        // --------------------------------------
        // MODE 1: SETTINGS / OPTIONS SUB-MENU
        // --------------------------------------
        else if (current_mode == 1) {
            if (_move_up) {
                opt_index = (opt_index - 1 + opt_total) % opt_total;
                var _snd = audio_play_sound(sfx_dialogue, 1, false);
                audio_sound_gain(_snd, _sfx_vol, 0);
            }
            if (_move_down) {
                opt_index = (opt_index + 1) % opt_total;
                var _snd = audio_play_sound(sfx_dialogue, 1, false);
                audio_sound_gain(_snd, _sfx_vol, 0);
            }

            // Adjust settings options
            switch (opt_index) {
                case 0: // BGM Volume (0 - 100)
                    if (_move_left || _move_right) {
                        if (_move_left)  global.vol_bgm = clamp(global.vol_bgm - 10, 0, 100);
                        if (_move_right) global.vol_bgm = clamp(global.vol_bgm + 10, 0, 100);
                        
                        // Apply volume change immediately to active music
                        if (audio_is_playing(mus_menu)) {
                            audio_sound_gain(mus_menu, global.vol_bgm / 100, 0);
                        }
                        if (audio_is_playing(current_playing_track)) {
                            audio_sound_gain(current_playing_track, global.vol_bgm / 100, 0);
                        }
                        
                        var _snd = audio_play_sound(sfx_dialogue, 1, false);
                        audio_sound_gain(_snd, _sfx_vol, 0);
                    }
                    break;

                case 1: // SFX Volume (0 - 100)
                    if (_move_left || _move_right) {
                        if (_move_left)  global.vol_sfx = clamp(global.vol_sfx - 10, 0, 100);
                        if (_move_right) global.vol_sfx = clamp(global.vol_sfx + 10, 0, 100);
                        
                        var _snd = audio_play_sound(sfx_dialogue, 1, false);
                        audio_sound_gain(_snd, global.vol_sfx / 100, 0);
                    }
                    break;

                case 2: // Fullscreen Toggle
                    if (_move_left || _move_right || _confirm) {
                        global.fullscreen = !global.fullscreen;
                        window_set_fullscreen(global.fullscreen);
                        var _snd = audio_play_sound(sfx_dialogue_continue, 1, false);
                        audio_sound_gain(_snd, _sfx_vol, 0);
                    }
                    break;

                case 3: // BACK TO MENU
                    if (_confirm) {
                        var _snd = audio_play_sound(sfx_dialogue_continue, 1, false);
                        audio_sound_gain(_snd, _sfx_vol, 0);
                        current_mode = 0;
                    }
                    break;
            }

            if (_cancel) {
                var _snd = audio_play_sound(sfx_dialogue_continue, 1, false);
                audio_sound_gain(_snd, _sfx_vol, 0);
                current_mode = 0;
            }
        }

        // --------------------------------------
        // MODE 2: JUKEBOX SUB-MENU
        // --------------------------------------
        else if (current_mode == 2) {
            if (_move_up) {
                juke_index = (juke_index - 1 + juke_total) % juke_total;
                var _snd = audio_play_sound(sfx_dialogue, 1, false);
                audio_sound_gain(_snd, _sfx_vol, 0);
            }
            if (_move_down) {
                juke_index = (juke_index + 1) % juke_total;
                var _snd = audio_play_sound(sfx_dialogue, 1, false);
                audio_sound_gain(_snd, _sfx_vol, 0);
            }

            if (_confirm) {
                var _snd = audio_play_sound(sfx_dialogue_continue, 1, false);
                audio_sound_gain(_snd, _sfx_vol, 0);

                if (juke_index == juke_total - 1) {
                    // BACK TO MENU selected
                    current_mode = 0;
                    if (!audio_is_playing(mus_menu)) {
                        audio_stop_all();
                        var _mus = audio_play_sound(mus_menu, 1, true);
                        audio_sound_gain(_mus, _bgm_vol, 0);
                    }
                } else {
                    // Play selected track
                    audio_stop_all();
                    var _track_asset = juke_tracks[juke_index].asset;
                    if (_track_asset != -1) {
                        current_playing_track = audio_play_sound(_track_asset, 1, true);
                        audio_sound_gain(current_playing_track, _bgm_vol, 0);
                    }
                }
            }

            if (_cancel) {
                var _snd = audio_play_sound(sfx_dialogue_continue, 1, false);
                audio_sound_gain(_snd, _sfx_vol, 0);
                current_mode = 0;
                if (!audio_is_playing(mus_menu)) {
                    audio_stop_all();
                    var _mus = audio_play_sound(mus_menu, 1, true);
                    audio_sound_gain(_mus, _bgm_vol, 0);
                }
            }
        }
        break;

    // ==========================================
    // --- STATE 2: FADE OUT & ROOM TRANSITION ---
    // ==========================================
    case 2:
        fade_alpha += fade_speed;

        if (fade_alpha >= 1) {
            fade_alpha = 1;

            switch (menu_index) {
                case 0: // PLAY GAME
                case 1: // LOAD GAME
                    if (audio_is_playing(mus_menu)) {
                        audio_stop_sound(mus_menu);
                    }
                    room_goto(target_room);
                    break;

                case 6: // RET TO TITLE
                    if (audio_is_playing(mus_menu)) {
                        audio_stop_sound(mus_menu);
                    }
                    var _title_room = (asset_get_index("rm_title_screen") != -1) ? asset_get_index("rm_title_screen") : room;
                    room_goto(_title_room);
                    break;
            }
        }
        break;
}