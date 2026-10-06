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

save_settings = function() {
    return scr_save_settings();
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

        var _label_text = _item.label;
        if (variable_struct_exists(_item, "localization_key")) {
            _label_text = get_localized_text(_item.localization_key);
        } else if (variable_struct_exists(_item, "get_label")) {
            _label_text = _item.get_label();
        }
        if (variable_struct_exists(_item, "get_value")) {
            _label_text += _item.get_value();
        }

        if (i == _list.index) {
            draw_text_color(_text_x, _item_y, _label_text, c_yellow, c_yellow, c_yellow, c_yellow, _alpha);
            var _cursor_x = _text_x - 14 + cursor_offset_x;
            draw_text_color(_cursor_x, _item_y, ">", c_yellow, c_yellow, c_yellow, c_yellow, _alpha);
        } else {
            draw_text_color(_text_x, _item_y, _label_text, c_white, c_white, c_white, c_white, _alpha);
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

cycle_language = function() {
    global.language = (global.language == "EN") ? "JP" : "EN";
    global.language_selected = true;
    save_settings();
};

menu_list_main = make_menu_list([
    { label: "Play Game", localization_key: "play_game", action: function() { io_clear(); target_room = room_exists(rm_intro) ? rm_intro : room_next(room); fade_state = 2; } },
    { label: "Load Recent Game", localization_key: "load_recent", action: function() { show_toast("Load Recent Game coming soon in " + target_version + "!"); } },
    { label: "Time Attack", localization_key: "time_attack", action: function() { show_toast("Time Attack coming soon in " + target_version + "!"); } },
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
        get_value: function() { return " [" + get_localized_text((global.language == "JP") ? "japanese" : "english") + "]"; },
        on_left: cycle_language,
        on_right: cycle_language,
        action: cycle_language
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
        label: "WHAT YOU SAY? (EASTER EGG)",
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
        action: function() { global.startup_challenge_enabled = !global.startup_challenge_enabled; save_settings(); }
    },
    {
        label: "BACK TO MENU",
        localization_key: "back_to_menu",
        action: function() { current_mode = 0; }
    }
], 7);

var _toggle_godmode  = function() { global.cheat_godmode  = !global.cheat_godmode;  save_settings(); };
var _toggle_unlocked = function() { global.cheat_unlocked = !global.cheat_unlocked; save_settings(); };
var _cheats_back     = function() { current_mode = 0; };

menu_list_cheats = make_menu_list([
    { label: "GOD MODE", localization_key: "god_mode", get_value: function() { return " [" + get_localized_text(global.cheat_godmode ? "enabled" : "disabled") + "]"; }, action: _toggle_godmode },
    { label: "UNLOCK ALL LEVELS", localization_key: "unlock_levels", get_value: function() { return " [" + get_localized_text(global.cheat_unlocked ? "yes" : "no") + "]"; }, action: _toggle_unlocked },
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

changelog_fade_alpha = 0;
changelog_fade_state = 0;
changelog_fade_speed = 0.08;

start_y = 52;
line_spacing = 18;

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