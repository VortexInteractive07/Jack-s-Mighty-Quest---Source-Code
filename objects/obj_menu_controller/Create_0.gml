/// @description Create Event: Initialize v1.0 Main Menu Controller

// Intelligence Level: 10/10

display_set_gui_size(432, 240);

settings_file_name = "settings.json";
if (script_exists(scr_load_settings)) {
    scr_load_settings();
}

sfx_dialogue_asset = sfx_dialogue;
sfx_continue_asset = sfx_dialogue_continue;
mus_menu_asset     = mus_menu;

target_room = rm_intro;

toast_text = "";
toast_timer = 0;
toast_duration = 150;
toast_alpha = 0;
target_version = "v1.0.0";

play_ui_blip = function(_sfx) {
    if (_sfx != -1 && audio_exists(_sfx)) {
        var _play = audio_play_sound(_sfx, 1, false);
        audio_sound_gain(_play, global.vol_sfx / 100, 0);
    }
};

show_toast = function(_msg) {
    toast_text = _msg;
    toast_timer = toast_duration;
    play_ui_blip(sfx_dialogue_asset);
};

current_mode = 0;

menu_music = mus_menu_asset;
current_playing_track = -1;
current_playing_asset = -1;

gp_axis_pressed_v = false;
gp_axis_pressed_h = false;
pending_exit_to_title = false;

global.game_session_active = false;
global.game_lives = 3;
global.game_score = 0;
if (!variable_global_exists("time_attack_active")) global.time_attack_active = false;
if (!variable_global_exists("time_attack_ticks")) global.time_attack_ticks = 0;
if (!variable_global_exists("time_attack_result_ticks")) global.time_attack_result_ticks = -1;
if (!variable_global_exists("active_save_slot")) global.active_save_slot = 0;
if (!variable_global_exists("player_name")) global.player_name = "JACK";
save_slots = array_create(3, undefined);
selected_save_slot = 0;
save_select_load_only = false;
name_entry_text = "";
name_entry_cursor = 0;
name_entry_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

save_settings = function() {
    return scr_save_settings();
};

refresh_save_slots = function() {
    for (var _slot = 0; _slot < 3; _slot++) {
        save_slots[_slot] = scr_game_save_slot_read(_slot + 1);
    }
    if (!is_struct(save_slots[0]) && !is_struct(save_slots[1]) && !is_struct(save_slots[2])) {
        var _legacy_autosave = scr_game_autosave_read();
        if (is_struct(_legacy_autosave)) {
            if (!variable_struct_exists(_legacy_autosave, "name")) _legacy_autosave.name = "JACK";
            if (scr_game_save_slot_write(1, _legacy_autosave.name, _legacy_autosave)) {
                file_delete("autosave.json");
                save_slots[0] = scr_game_save_slot_read(1);
            }
        }
    }
};

open_save_file_select = function(_load_only) {
    refresh_save_slots();
    selected_save_slot = 0;
    save_select_load_only = _load_only;
    current_mode = 4;
};

load_save_file = function(_slot_index) {
    var _save = save_slots[_slot_index];
    if (!is_struct(_save)) return false;
    global.active_save_slot = _slot_index + 1;
    global.player_name = _save.name;
    global.game_session_active = true;
    global.game_score = max(0, floor(_save.score));
    global.game_lives = clamp(floor(_save.lives), 1, 99);
    global.time_attack_active = _save.time_attack_active;
    global.time_attack_ticks = max(0, floor(_save.time_attack_ticks));
    global.autosave_restore_data = _save;
    global.autosave_restore_pending = true;
    io_clear();
    target_room = _save.room_id;
    fade_state = 2;
    return true;
};

start_named_game = function(_slot_index, _name) {
    global.active_save_slot = _slot_index + 1;
    global.player_name = string_copy(_name, 1, 12);
    if (global.player_name == "") global.player_name = "JACK";
    global.time_attack_active = false;
    global.time_attack_ticks = 0;
    global.autosave_restore_pending = false;
    global.game_session_active = false;
    io_clear();
    target_room = room_exists(rm_intro) ? rm_intro : rm_subway;
    fade_state = 2;
};

window_set_fullscreen(global.fullscreen);

make_menu_list = function(_items, _visible_max) {
    var _inst = self;
    var _total = array_length(_items);

    for (var i = 0; i < _total; i++) {
        var _item = _items[i];
        if (variable_struct_exists(_item, "action") && is_method(_item.action)) {
            _item.action = method(_inst, _item.action);
        }
        if (variable_struct_exists(_item, "on_left") && is_method(_item.on_left)) {
            _item.on_left = method(_inst, _item.on_left);
        }
        if (variable_struct_exists(_item, "on_right") && is_method(_item.on_right)) {
            _item.on_right = method(_inst, _item.on_right);
        }
        if (variable_struct_exists(_item, "get_value") && is_method(_item.get_value)) {
            _item.get_value = method(_inst, _item.get_value);
        }
        if (variable_struct_exists(_item, "get_label") && is_method(_item.get_label)) {
            _item.get_label = method(_inst, _item.get_label);
        }
    }

    return {
        items: _items,
        total: _total,
        index: 0,
        scroll_offset: 0,
        visible_max: min(_visible_max, _total)
    };
};

menu_navigate = function(_list, _up, _down) {
    if (_up) {
        _list.index = (_list.index - 1 + _list.total) % _list.total;
        if (_list.index < _list.scroll_offset) {
            _list.scroll_offset = _list.index;
        } else if (_list.index == _list.total - 1) {
            _list.scroll_offset = max(0, _list.total - _list.visible_max);
        }
        play_ui_blip(sfx_dialogue_asset);
    } else if (_down) {
        _list.index = (_list.index + 1) % _list.total;
        if (_list.index >= _list.scroll_offset + _list.visible_max) {
            _list.scroll_offset = _list.index - _list.visible_max + 1;
        } else if (_list.index == 0) {
            _list.scroll_offset = 0;
        }
        play_ui_blip(sfx_dialogue_asset);
    }
};

menu_adjust_item = function(_list, _dir) {
    var _item = _list.items[_list.index];
    var _fn = undefined;
    if (_dir < 0 && variable_struct_exists(_item, "on_left"))  _fn = _item.on_left;
    if (_dir > 0 && variable_struct_exists(_item, "on_right")) _fn = _item.on_right;

    if (_fn != undefined) {
        _fn();
        var _snd_asset = variable_struct_exists(_item, "adjust_sfx") ? _item.adjust_sfx : sfx_dialogue_asset;
        play_ui_blip(_snd_asset);
    }
};

menu_confirm_item = function(_list) {
    var _item = _list.items[_list.index];
    if (variable_struct_exists(_item, "action")) {
        var _snd_asset = variable_struct_exists(_item, "confirm_sfx") ? _item.confirm_sfx : sfx_continue_asset;
        play_ui_blip(_snd_asset);
        _item.action();
    }
};

draw_menu_list = function(_list, _text_x, _y_start, _line_spacing, _alpha) {
    var _render_end = min(_list.total, _list.scroll_offset + _list.visible_max);

    for (var i = _list.scroll_offset; i < _render_end; i++) {
        var _display_idx = i - _list.scroll_offset;
        var _item_y = _y_start + (_display_idx * _line_spacing);
        var _item = _list.items[i];
        var _row_left = _text_x - 22;
        var _row_right = 232;
        var _selected = (i == _list.index);

        if (_selected) {
            draw_set_alpha(0.78 * _alpha);
            draw_set_color(make_color_rgb(18, 43, 67));
            draw_rectangle(_row_left, _item_y - 8, _row_right, _item_y + 8, false);
            draw_set_alpha(_alpha);
            draw_set_color(c_aqua);
            draw_rectangle(_row_left, _item_y - 8, _row_left + 2, _item_y + 8, false);
        }

        var _label_text = _item.label;
        if (variable_struct_exists(_item, "localization_key")) {
            _label_text = get_localized_text(_item.localization_key);
        } else if (variable_struct_exists(_item, "get_label")) {
            _label_text = _item.get_label();
        }
        if (variable_struct_exists(_item, "get_value")) {
            _label_text += _item.get_value();
        }

        if (_selected) {
            draw_text_color(_text_x, _item_y, _label_text, c_white, c_white, c_aqua, c_aqua, _alpha);
            var _cursor_x = _row_left + 5 + cursor_offset_x;
            draw_text_color(_cursor_x, _item_y, ">", c_yellow, c_yellow, c_white, c_white, _alpha);
        } else {
            draw_text_color(_text_x, _item_y, _label_text, c_silver, c_silver, c_white, c_white, _alpha * 0.88);
        }
    }

    if (_list.total > _list.visible_max) {
        var _arrow_x = 230;
        var _arrow_y_center = 125;
        var _bob = round(sin(arrow_anim_timer) * 2);

        if (_list.scroll_offset > 0 && sprite_exists(spr_menu_arrow_up)) {
            draw_sprite_ext(spr_menu_arrow_up, 0, _arrow_x, _arrow_y_center - 16 + _bob, 1, 1, 0, c_white, _alpha);
        }
        if (_list.scroll_offset + _list.visible_max < _list.total && sprite_exists(spr_menu_arrow_down)) {
            draw_sprite_ext(spr_menu_arrow_down, 0, _arrow_x, _arrow_y_center + 16 - _bob, 1, 1, 0, c_white, _alpha);
        }
    }
};

apply_bgm_volume = function() {
    if (current_playing_track != -1 && audio_is_playing(current_playing_track)) {
        audio_sound_gain(current_playing_track, global.vol_bgm / 100, 0);
    }
};

toggle_fullscreen = function() {
    global.fullscreen = !global.fullscreen;
    window_set_fullscreen(global.fullscreen);
    save_settings();
};

supported_languages = ["EN", "DE", "ES", "PL", "SH", "EG", "JG"];

cycle_language = function(_direction) {
    var _current = 0;
    for (var _i = 0; _i < array_length(supported_languages); _i++) {
        if (supported_languages[_i] == global.language) {
            _current = _i;
            break;
        }
    }
    _current = (_current + _direction + array_length(supported_languages)) mod array_length(supported_languages);
    global.language = supported_languages[_current];
    global.language_selected = true;
    save_settings();
};

fade_style_options = ["SMOOTH", "NES", "GENESIS", "MOSAIC", "FLASH", "BLACK", "OFF"];
cycle_fade_style = function(_direction) {
    var _current = 0;
    for (var _i = 0; _i < array_length(fade_style_options); _i++) {
        if (fade_style_options[_i] == global.fade_style) {
            _current = _i;
            break;
        }
    }
    _current = (_current + _direction + array_length(fade_style_options)) mod array_length(fade_style_options);
    global.fade_style = fade_style_options[_current];
    save_settings();
};

menu_list_main = make_menu_list([
    { label: "Play Game", localization_key: "play_game", action: function() {
        open_save_file_select(false);
    } },
    { label: "Load Recent Game", localization_key: "load_recent", action: function() {
        open_save_file_select(true);
    } },
    { label: "Time Attack", localization_key: "time_attack", get_value: function() {
        if (global.time_attack_best_ticks < 0) return "";
        var _seconds = floor(global.time_attack_best_ticks / game_get_speed(gamespeed_fps));
        return "  BEST " + string(_seconds div 60) + ":" + string_format(_seconds mod 60, 2, 0);
    }, action: function() {
        global.time_attack_active = true;
        global.time_attack_ticks = 0;
        global.time_attack_result_ticks = -1;
        global.autosave_restore_pending = false;
        global.game_session_active = false;
        io_clear(); target_room = rm_subway; fade_state = 2;
    } },
    { label: "Cheats", localization_key: "cheats_option", action: function() { current_mode = 2; menu_list_cheats.index = 0; } },
    { label: "Settings", localization_key: "settings_option", action: function() { current_mode = 1; menu_list_options.index = 0; } },
    { label: "Changelog", localization_key: "changelog", action: function() { changelog_scroll = 0; changelog_fade_state = 1; } },
    { label: "Jukebox", localization_key: "jukebox", action: function() { io_clear(); target_room = room_exists(rm_jukebox) ? rm_jukebox : room_next(room); fade_state = 2; } },
    { label: "Exit to Title Screen", localization_key: "exit_title", action: function() { io_clear(); pending_exit_to_title = true; fade_state = 2; } },
    { label: "Exit Game", localization_key: "exit_game", action: function() { game_end(); } }
], 7);

menu_list_options = make_menu_list([
    {
        label: "BGM VOLUME",
        localization_key: "bgm_volume",
        get_value: function() { return " < " + string(global.vol_bgm) + "% >"; },
        on_left:  function() { global.vol_bgm = clamp(global.vol_bgm - 10, 0, 100); apply_bgm_volume(); save_settings(); },
        on_right: function() { global.vol_bgm = clamp(global.vol_bgm + 10, 0, 100); apply_bgm_volume(); save_settings(); }
    },
    {
        label: "SFX VOLUME",
        localization_key: "sfx_volume",
        get_value: function() { return " < " + string(global.vol_sfx) + "% >"; },
        on_left:  function() { global.vol_sfx = clamp(global.vol_sfx - 10, 0, 100); save_settings(); },
        on_right: function() { global.vol_sfx = clamp(global.vol_sfx + 10, 0, 100); save_settings(); }
    },
    {
        label: "LANGUAGE",
        get_label: function() { return get_localized_text("language_setting"); },
        get_value: function() {
            var _name_key = "english";
            switch (global.language) {
                case "DE": _name_key = "german"; break;
                case "ES": _name_key = "spanish"; break;
                case "PL": _name_key = "polish"; break;
                case "SH": _name_key = "shakespearean"; break;
                case "EG": _name_key = "engrish"; break;
                case "JG": _name_key = "japangrish"; break;
            }
            return " < " + get_localized_text(_name_key) + " >";
        },
        on_left: function() { cycle_language(-1); },
        on_right: function() { cycle_language(1); },
        action: function() { cycle_language(1); }
    },
    {
        label: "TRANSITION STYLE",
        localization_key: "transition_style",
        get_value: function() {
            var _style_key = "fade_style_smooth";
            switch (global.fade_style) {
                case "NES": _style_key = "fade_style_nes"; break;
                case "GENESIS": _style_key = "fade_style_genesis"; break;
                case "MOSAIC": _style_key = "fade_style_mosaic"; break;
                case "FLASH": _style_key = "fade_style_flash"; break;
                case "BLACK": _style_key = "fade_style_black"; break;
                case "OFF": _style_key = "fade_style_off"; break;
            }
            return " < " + get_localized_text(_style_key) + " >";
        },
        on_left: function() { cycle_fade_style(-1); },
        on_right: function() { cycle_fade_style(1); },
        action: function() { cycle_fade_style(1); }
    },
    {
        label: "BLACK HOLD TIME",
        localization_key: "black_hold_duration",
        get_value: function() { return " < " + string_format(global.fade_hold_seconds, 1, 2) + "s >"; },
        on_left: function() { global.fade_hold_seconds = max(0, global.fade_hold_seconds - 0.25); save_settings(); },
        on_right: function() { global.fade_hold_seconds = min(5, global.fade_hold_seconds + 0.25); save_settings(); }
    },
    {
        label: "PLAYER PHYSICS",
        localization_key: "player_physics",
        get_value: function() { return " < " + get_localized_text(global.player_physics_mode == "BOOTLEG" ? "physics_bootleg" : "physics_default") + " >"; },
        on_left: function() { global.player_physics_mode = (global.player_physics_mode == "DEFAULT") ? "BOOTLEG" : "DEFAULT"; save_settings(); },
        on_right: function() { global.player_physics_mode = (global.player_physics_mode == "DEFAULT") ? "BOOTLEG" : "DEFAULT"; save_settings(); },
        action: function() { global.player_physics_mode = (global.player_physics_mode == "DEFAULT") ? "BOOTLEG" : "DEFAULT"; save_settings(); }
    },
    {
        label: "SCROLLING MODE",
        localization_key: "scrolling_mode",
        get_value: function() { return " < " + get_localized_text(global.scrolling_mode == "JITTERY" ? "physics_jittery" : "physics_default") + " >"; },
        on_left: function() { global.scrolling_mode = (global.scrolling_mode == "DEFAULT") ? "JITTERY" : "DEFAULT"; save_settings(); },
        on_right: function() { global.scrolling_mode = (global.scrolling_mode == "DEFAULT") ? "JITTERY" : "DEFAULT"; save_settings(); },
        action: function() { global.scrolling_mode = (global.scrolling_mode == "DEFAULT") ? "JITTERY" : "DEFAULT"; save_settings(); }
    },
    {
        label: "FULLSCREEN",
        localization_key: "fullscreen",
        get_value: function() { return " [" + get_localized_text(global.fullscreen ? "on" : "off") + "]"; },
        on_left: toggle_fullscreen,
        on_right: toggle_fullscreen,
        action: toggle_fullscreen
    },
    {
        label: "SPLASH DIALOGUE",
        localization_key: "splash_dialogue",
        get_value: function() { return " [" + get_localized_text(global.enable_splash_dialogue ? "on" : "off") + "]"; },
        action: function() { global.enable_splash_dialogue = !global.enable_splash_dialogue; save_settings(); }
    },
    {
        label: "TITLE DIALOGUE",
        localization_key: "title_dialogue",
        get_value: function() { return " [" + get_localized_text(global.enable_title_dialogue ? "on" : "off") + "]"; },
        action: function() { global.enable_title_dialogue = !global.enable_title_dialogue; save_settings(); }
    },
    {
        label: "ARCADE MODE (BETA)",
        localization_key: "arcade_mode",
        get_value: function() { return " [" + get_localized_text(global.arcade_mode ? "on" : "off") + "]"; },
        action: function() { global.arcade_mode = !global.arcade_mode; save_settings(); }
    },
    {
        label: "OPTIONAL STARTUP CHALLENGE",
        localization_key: "startup_challenge",
        get_value: function() { return " [" + get_localized_text(global.startup_challenge_enabled ? "on" : "off") + "]"; },
        action: function() {
            global.startup_challenge_enabled = !global.startup_challenge_enabled;
            save_settings();
            show_toast("Startup challenge changes apply next launch.");
        }
    },
    {
        label: "BACK TO MENU",
        localization_key: "back_to_menu",
        action: function() { current_mode = 0; }
    }
], 7);

var _toggle_godmode  = function() { global.cheat_godmode  = !global.cheat_godmode;  save_settings(); };
var _toggle_unlocked = function() { global.cheat_unlocked = !global.cheat_unlocked; save_settings(); };
var _toggle_debug = function() { global.cheat_debug_mode = !global.cheat_debug_mode; save_settings(); };
var _toggle_hitboxes = function() { global.cheat_hitboxes = !global.cheat_hitboxes; save_settings(); };
var _toggle_instant_respawn = function() { global.cheat_instant_respawn = !global.cheat_instant_respawn; save_settings(); };
var _cheats_back     = function() { current_mode = 0; };

menu_list_cheats = make_menu_list([
    { label: "GOD MODE", localization_key: "god_mode", get_value: function() { return " [" + get_localized_text(global.cheat_godmode ? "enabled" : "disabled") + "]"; }, action: _toggle_godmode },
    { label: "UNLOCK ALL LEVELS", localization_key: "unlock_levels", get_value: function() { return " [" + get_localized_text(global.cheat_unlocked ? "yes" : "no") + "]"; }, action: _toggle_unlocked },
    { label: "DEBUG OVERLAY", get_value: function() { return " [" + get_localized_text(global.cheat_debug_mode ? "enabled" : "disabled") + "]"; }, action: _toggle_debug },
    { label: "SHOW HITBOXES", get_value: function() { return " [" + get_localized_text(global.cheat_hitboxes ? "enabled" : "disabled") + "]"; }, action: _toggle_hitboxes },
    { label: "INSTANT RESPAWN", get_value: function() { return " [" + get_localized_text(global.cheat_instant_respawn ? "enabled" : "disabled") + "]"; }, action: _toggle_instant_respawn },
    { label: "BACK TO MENU", localization_key: "back_to_menu", action: _cheats_back }
], 7);

changelog_lines = script_exists(scr_changelog_details) ? script_execute(scr_changelog_details) : [
    "[v1.0.0 CHANGELOG]",
    "+ Integrated complete OST playlist",
    "+ Redesigned menu architecture to v1.0",
    "+ Native 432x240 pixel-perfect scaling"
];
changelog_scroll = 0;
changelog_line_height = 14;
changelog_visible_lines = 10;

show_toast(get_localized_text("autosave_notice"));

changelog_fade_alpha = 0;
changelog_fade_state = 0;
changelog_fade_speed = 0.08;

start_y = 61;
line_spacing = 19;

cursor_offset_x = 0;
cursor_dir = 1;
arrow_anim_timer = 0;

fade_alpha = 1;
fade_speed = 0.04;
fade_state = 0;

if (menu_music != -1 && audio_exists(menu_music)) {
    current_playing_asset = menu_music;
    current_playing_track = audio_play_sound(menu_music, 1, true);
    audio_sound_gain(current_playing_track, global.vol_bgm / 100, 0);
}
