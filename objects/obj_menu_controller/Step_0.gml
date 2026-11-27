/// @description Step Event: Navigation, Audio Management, Toast Timers & Action Execution

// Intelligence Level: 10/10

// Cursor subtle bobbing animation
cursor_offset_x += 0.08 * cursor_dir;
if (abs(cursor_offset_x) > 1.5) cursor_dir *= -1;

// Retro arrow animation ticker
arrow_anim_timer += 0.07;

// Show every main-menu item when the current screen height allows it.
var _main_menu_rows = max(1, floor((display_get_gui_height() - start_y - 34) / line_spacing) + 1);
menu_list_main.visible_max = min(menu_list_main.total, _main_menu_rows);
menu_list_main.scroll_offset = clamp(menu_list_main.scroll_offset, 0, max(0, menu_list_main.total - menu_list_main.visible_max));
if (menu_list_main.index < menu_list_main.scroll_offset) {
    menu_list_main.scroll_offset = menu_list_main.index;
} else if (menu_list_main.index >= menu_list_main.scroll_offset + menu_list_main.visible_max) {
    menu_list_main.scroll_offset = menu_list_main.index - menu_list_main.visible_max + 1;
}

// Toast notification decay timer logic
if (save_delete_timer > 0) save_delete_timer--;
else save_delete_armed = false;
if (toast_timer > 0) {
    toast_timer--;
    if (toast_timer > 30) {
        toast_alpha = min(toast_alpha + 0.1, 1);
    } else {
        toast_alpha = max(toast_alpha - 0.05, 0);
    }
} else {
    toast_alpha = 0;
}

// Smooth cross-fade transition for Changelog
if (changelog_fade_state == 1) {
    changelog_fade_alpha += changelog_fade_speed;
    if (changelog_fade_alpha >= 1) {
        changelog_fade_alpha = 1;
        changelog_fade_state = 0;
        current_mode = 3;
    }
} else if (changelog_fade_state == 2) {
    changelog_fade_alpha -= changelog_fade_speed;
    if (changelog_fade_alpha <= 0) {
        changelog_fade_alpha = 0;
        changelog_fade_state = 0;
        current_mode = 0;
    }
}

if (current_mode == 2) {
    if (sprite_exists(spr_vortex_logo_darkmode)) {
        var _bg_width = sprite_get_width(spr_vortex_logo_darkmode);
        var _bg_height = sprite_get_height(spr_vortex_logo_darkmode);
        if (_bg_width > 0) jukebox_bg_x = (jukebox_bg_x + jukebox_bg_speed_x) mod _bg_width;
        if (_bg_height > 0) jukebox_bg_y = (jukebox_bg_y + jukebox_bg_speed_y + _bg_height) mod _bg_height;
    }

    if (current_playing_track != -1 && audio_is_playing(current_playing_track)) {
        jukebox_playback_position = audio_sound_get_track_position(current_playing_track);
    }
}

if (jukebox_transition_state == 1) {
    fade_alpha = min(1, fade_alpha + fade_speed);
    if (current_playing_track != -1 && audio_is_playing(current_playing_track)) {
        audio_sound_gain(current_playing_track, (1 - fade_alpha) * (global.vol_bgm / 100), 0);
    }

    if (fade_alpha >= 1) {
        current_mode = jukebox_transition_target_mode;

        if (jukebox_transition_action == 1) {
            if (current_playing_track != -1) audio_stop_sound(current_playing_track);
            current_playing_track = -1;
            current_playing_asset = -1;
            jukebox_selected_index = 0;
            jukebox_scroll_offset = 0;
            jukebox_playing_index = -1;
            jukebox_is_playing = false;
            jukebox_playback_position = 0;
        } else if (jukebox_transition_action == 2) {
            if (current_playing_track != -1) audio_stop_sound(current_playing_track);
            current_playing_track = -1;
            current_playing_asset = -1;
            jukebox_playing_index = -1;
            jukebox_is_playing = false;

            if (menu_music != -1 && audio_exists(menu_music)) {
                current_playing_asset = menu_music;
                current_playing_track = audio_play_sound(menu_music, 1, true);
                audio_sound_gain(current_playing_track, 0, 0);
            }
        }

        jukebox_transition_state = 2;
    }
} else if (jukebox_transition_state == 2) {
    fade_alpha = max(0, fade_alpha - fade_speed);
    if (current_mode == 0 && current_playing_track != -1 && audio_is_playing(current_playing_track)) {
        audio_sound_gain(current_playing_track, (1 - fade_alpha) * (global.vol_bgm / 100), 0);
    }

    if (fade_alpha <= 0) {
        fade_alpha = 0;
        jukebox_transition_state = 0;
    }
}

switch (fade_state) {

    // ==========================================
    // --- STATE 0: FADE IN ---
    // ==========================================
    case 0:
        fade_alpha -= fade_speed;
        if (fade_alpha <= 0) {
            fade_alpha = 0;
            fade_state = 1;
        }
        break;

    // ==========================================
    // --- STATE 1: INTERACTIVE MENUS ---
    // ==========================================
    case 1:
        if (jukebox_transition_state != 0) break;

        if (keyboard_check_pressed(vk_f1)) {
            current_mode = (current_mode == 5) ? 0 : 5;
            play_ui_blip(sfx_continue_asset);
            break;
        }

        // Input Abstraction (Keyboard + Gamepad Support)
        var _gp_num = 0;
        var _gp_connected = gamepad_is_connected(_gp_num);
        var _gp_up = false, _gp_down = false, _gp_left = false, _gp_right = false;

        if (_gp_connected) {
            var _axis_v = gamepad_axis_value(_gp_num, gp_axislv);
            var _axis_h = gamepad_axis_value(_gp_num, gp_axislh);

            // Digital D-Pad checks
            _gp_up    = gamepad_button_check_pressed(_gp_num, gp_padu);
            _gp_down  = gamepad_button_check_pressed(_gp_num, gp_padd);
            _gp_left  = gamepad_button_check_pressed(_gp_num, gp_padl);
            _gp_right = gamepad_button_check_pressed(_gp_num, gp_padr);

            // Analog Stick Latched Debounce (Prevents 60FPS Hyper-Scrolling)
            if (abs(_axis_v) > 0.5) {
                if (!gp_axis_pressed_v) {
                    if (_axis_v < -0.5) _gp_up = true;
                    if (_axis_v > 0.5)  _gp_down = true;
                    gp_axis_pressed_v = true;
                }
            } else {
                gp_axis_pressed_v = false;
            }

            if (abs(_axis_h) > 0.5) {
                if (!gp_axis_pressed_h) {
                    if (_axis_h < -0.5) _gp_left = true;
                    if (_axis_h > 0.5)  _gp_right = true;
                    gp_axis_pressed_h = true;
                }
            } else {
                gp_axis_pressed_h = false;
            }
        }

        var _gp_conf = _gp_connected && gamepad_button_check_pressed(_gp_num, gp_face1);
        var _gp_canc = _gp_connected && gamepad_button_check_pressed(_gp_num, gp_face2);

        var _move_up    = keyboard_check_pressed(vk_up)    || keyboard_check_pressed(ord("W")) || _gp_up;
        var _move_down  = keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S")) || _gp_down;
        var _move_left  = keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A")) || _gp_left;
        var _move_right = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D")) || _gp_right;
        var _confirm    = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || _gp_conf;
        var _cancel     = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace) || _gp_canc;

        if (current_mode == 2) {
            var _playlist_total = array_length(jukebox_playlist);

            if (_move_up) {
                jukebox_selected_index = (jukebox_selected_index - 1 + _playlist_total) mod _playlist_total;
                if (jukebox_selected_index < jukebox_scroll_offset) {
                    jukebox_scroll_offset = jukebox_selected_index;
                } else if (jukebox_selected_index >= jukebox_scroll_offset + jukebox_visible_max) {
                    jukebox_scroll_offset = max(0, _playlist_total - jukebox_visible_max);
                }
                play_ui_blip(sfx_dialogue_asset);
            }

            else if (_move_down) {
                jukebox_selected_index = (jukebox_selected_index + 1) mod _playlist_total;
                if (jukebox_selected_index < jukebox_scroll_offset) {
                    jukebox_scroll_offset = 0;
                } else if (jukebox_selected_index >= jukebox_scroll_offset + jukebox_visible_max) {
                    jukebox_scroll_offset = jukebox_selected_index - jukebox_visible_max + 1;
                }
                play_ui_blip(sfx_dialogue_asset);
            }

            if (_confirm) {
                if (jukebox_playing_index == jukebox_selected_index) {
                    jukebox_toggle_playback();
                } else {
                    jukebox_play_selected(jukebox_selected_index);
                }
            }

            if (keyboard_check_pressed(ord("P"))) {
                jukebox_toggle_playback();
            }

            if (_cancel) {
                play_ui_blip(sfx_continue_asset);
                close_jukebox();
            }
        }
        // --------------------------------------
        // MANUAL, SAVE SLOT SELECTOR, AND NAME ENTRY
        // --------------------------------------
        else if (current_mode == 5) {
            if (_move_up || _move_down) guidebook_page = (guidebook_page + 1) mod 4;
            if (_confirm || _cancel) current_mode = 0;
        }
        else if (current_mode == 6) {
            if (_move_up || _move_down) {
                var _slot_step = _move_up ? -1 : 1;
                save_slot_cursor = (save_slot_cursor + _slot_step + 10) mod 10;
                save_delete_armed = false;
                play_ui_blip(sfx_dialogue_asset);
            }
            if (_cancel) {
                current_mode = 0;
                save_delete_armed = false;
            } else if (keyboard_check_pressed(vk_delete)) {
                if (is_struct(save_slots[save_slot_cursor])) {
                    if (save_delete_armed && save_delete_timer > 0) {
                        var _did_clear = scr_save_slot_clear(save_slot_cursor);
                        save_slots = scr_save_slots_read();
                        save_delete_armed = false;
                        show_toast(_did_clear ? "Save slot erased." : "Could not erase save slot.");
                    } else {
                        save_delete_armed = true;
                        save_delete_timer = game_get_speed(gamespeed_fps) * 3;
                        show_toast("Press Delete again to erase this slot.");
                    }
                }
            } else if (_confirm) {
                var _selected_save = save_slots[save_slot_cursor];
                if (is_struct(_selected_save)) {
                    global.active_save_slot = save_slot_cursor;
                    global.active_save_name = _selected_save.name;
                    global.pending_game_restore = _selected_save;
                    global.game_score = _selected_save.score;
                    global.game_lives = _selected_save.lives;
                    if (variable_struct_exists(_selected_save, "inventory") && is_array(_selected_save.inventory)) {
                        global.inventory_items = _selected_save.inventory;
                    }
                    global.collected_gem_positions = _selected_save.collected_gems;
                    global.game_session_active = true;
                    target_room = _selected_save.room_asset;
                    io_clear();
                    fade_state = 2;
                } else {
                    keyboard_string = "";
                    save_name_input = "";
                    current_mode = 7;
                }
            }
        }
        else if (current_mode == 7) {
            save_name_input = keyboard_string;
            if (string_length(save_name_input) > 16) {
                save_name_input = string_copy(save_name_input, 1, 16);
                keyboard_string = save_name_input;
            }
            if (_cancel) {
                keyboard_string = "";
                current_mode = 6;
            } else if (keyboard_check_pressed(vk_enter)) {
                var _new_name = save_name_input;
                if (string_replace_all(_new_name, " ", "") == "") _new_name = "PLAYER " + string(save_slot_cursor + 1);
                var _new_save = {
                    name: _new_name,
                    room: "rm_subway",
                    x: 48,
                    y: 224,
                    mark_x: 16,
                    mark_y: 208,
                    hp: 100,
                    score: 0,
                    lives: 10,
                    inventory: [
                        { id: "ration", name: "Trail Ration", category: "FOOD", quantity: 3, heal: 35 },
                        { id: "sidearm", name: "Service Sidearm", category: "WEAPON", quantity: 1, heal: 0 },
                        { id: "plasma_buddy", name: "Plasma Buddy", category: "GADGET", quantity: 1, heal: 0 },
                        { id: "rounds", name: "Sidearm Rounds", category: "AMMUNITION", quantity: 12, heal: 0 }
                    ]
                };
                if (scr_save_slot_write(save_slot_cursor, _new_save)) {
                    global.active_save_slot = save_slot_cursor;
                    global.active_save_name = _new_name;
                    global.pending_game_restore = undefined;
                    global.game_session_active = true;
                    global.game_lives = 10;
                    global.game_score = 0;
                    global.intro_dialogue_history = [];
                    global.collected_gem_positions = [];
                    global.inventory_items = _new_save.inventory;
                    global.inventory_index = 0;
                    target_room = rm_intro;
                    keyboard_string = "";
                    io_clear();
                    fade_state = 2;
                } else {
                    show_toast("Could not create the save slot.");
                    current_mode = 6;
                }
            }
        }
        else if (current_mode == 8) {
            if (keyboard_check_pressed(ord("N"))) {
                addon_create_type = 0;
                current_mode = 9;
            }
            if (keyboard_check_pressed(ord("I"))) {
                addon_create_type = 0;
                current_mode = 10;
            }
            var _pack_count = array_length(content_manager_packs);
            if (_pack_count > 0) {
                if (_move_up || _move_left) {
                    content_manager_page = (content_manager_page - 1 + _pack_count) mod _pack_count;
                    play_ui_blip(sfx_dialogue_asset);
                } else if (_move_down || _move_right) {
                    content_manager_page = (content_manager_page + 1) mod _pack_count;
                    play_ui_blip(sfx_dialogue_asset);
                }
                if (_confirm) {
                    var _chosen_pack = content_manager_packs[content_manager_page];
                    global.texture_pack = _chosen_pack.id;
                    save_settings();
                    show_toast("Texture pack applies next launch: " + _chosen_pack.name);
                }
            }
            if (_cancel) {
                current_mode = content_manager_return_mode;
                play_ui_blip(sfx_continue_asset);
            }
        }
        else if (current_mode == 9) {
            if (_move_up || _move_left) addon_create_type = (addon_create_type + 2) mod 3;
            if (_move_down || _move_right) addon_create_type = (addon_create_type + 1) mod 3;
            if (_confirm) {
                var _kind = (addon_create_type == 0) ? "texture" : ((addon_create_type == 1) ? "behavior" : "resource");
                show_toast(scr_addon_pack_create(_kind));
                if (variable_global_exists("texture_pack_list_cache")) variable_global_remove("texture_pack_list_cache");
                content_manager_packs = scr_texture_pack_list();
                content_manager_addons = scr_addon_pack_list();
                current_mode = 8;
            } else if (_cancel) {
                current_mode = 8;
            }
        }
        else if (current_mode == 10) {
            if (_move_up || _move_left) addon_create_type = (addon_create_type + 2) mod 3;
            if (_move_down || _move_right) addon_create_type = (addon_create_type + 1) mod 3;
            if (_confirm) {
                var _import_kind = (addon_create_type == 0) ? "texture" : ((addon_create_type == 1) ? "behavior" : "resource");
                var _import_result = scr_addon_pack_import(_import_kind);
                if (_import_result != "Import cancelled.") show_toast(_import_result);
                content_manager_packs = scr_texture_pack_list();
                content_manager_addons = scr_addon_pack_list();
                current_mode = 8;
            } else if (_cancel) {
                current_mode = 8;
            }
        }
        // --------------------------------------
        // CHANGELOG (mode 3, or mid-transition)
        // --------------------------------------
        else if (current_mode == 3 || changelog_fade_state != 0) {
            if (changelog_fade_state == 0) {
                var _max_scroll = max(0, array_length(changelog_lines) - changelog_visible_lines);

                if (_move_up && changelog_scroll > 0) {
                    changelog_scroll--;
                    play_ui_blip(sfx_dialogue_asset);
                }
                if (_move_down && changelog_scroll < _max_scroll) {
                    changelog_scroll++;
                    play_ui_blip(sfx_dialogue_asset);
                }

                if (_confirm || _cancel) {
                    play_ui_blip(sfx_continue_asset);
                    changelog_fade_state = 2;
                }
            }
        }
        // --------------------------------------
        // ALL LIST-DRIVEN MODES (0, 1, 4)
        // --------------------------------------
        else {
            var _active_list = undefined;
            var _cancel_mode = -1;

            switch (current_mode) {
                case 0: _active_list = menu_list_main;      _cancel_mode = -1; break;
                case 1: _active_list = menu_list_options;   _cancel_mode = 0;  break;
                case 4: _active_list = menu_list_cheats;    _cancel_mode = 0;  break;
            }

            if (_active_list != undefined) {
                if (_cancel && current_mode == 0) {
                    play_ui_blip(sfx_continue_asset);
                    pending_exit_to_title = true;
                    fade_state = 2;
                } else {
                    menu_navigate(_active_list, _move_up, _move_down);

                    if (_move_left)  menu_adjust_item(_active_list, -1);
                    if (_move_right) menu_adjust_item(_active_list, 1);

                    if (_confirm) {
                        menu_confirm_item(_active_list);
                    }

                    if (_cancel && _cancel_mode != -1) {
                        play_ui_blip(sfx_continue_asset);
                        current_mode = _cancel_mode;
                    }
                }
            }
        }
        break;

    // ==========================================
    // --- STATE 2: FADE OUT & ROOM TRANSITION ---
    // ==========================================
    case 2:
        fade_alpha += fade_speed;

        if (current_playing_track != -1 && audio_is_playing(current_playing_track)) {
            audio_sound_gain(current_playing_track, (1 - fade_alpha) * (global.vol_bgm / 100), 0);
        }

        if (fade_alpha >= 1) {
            fade_alpha = 1;

            if (current_playing_track != -1 && audio_is_playing(current_playing_track)) {
                audio_stop_sound(current_playing_track);
            }

            if (pending_exit_to_title) {
                if (room_exists(rm_title_screen)) {
                    room_goto(rm_title_screen);
                } else {
                    game_restart();
                }
            } else {
                if (target_room != -1 && room_exists(target_room)) {
                    room_goto(target_room);
                } else {
                    room_goto_next();
                }
            }
        }
        break;
}
