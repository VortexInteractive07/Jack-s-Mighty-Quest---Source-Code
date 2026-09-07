/// @description Create Event: Initialize Main Menu Controller (432x240 Sub-Menu Architecture) - List-Modular Engine + settings.json Persistence

// Intelligence Level: 10/10

// Lock GUI canvas to exact 16:9 pixel-art display resolution (432x240)
display_set_gui_size(432, 240);

// Direct Asset Handle Initialization
sfx_dialogue_asset = sfx_dialogue;
sfx_continue_asset = sfx_dialogue_continue;
mus_menu_asset     = mus_wonk;

// --- GLOBAL DEFAULTS (Must be set before loading settings to prevent undefined errors) ---
global.vol_bgm = 100;
global.vol_sfx = 100;
global.fullscreen = false;
global.enable_dialogue = true;
global.enable_splash_dialogue = true;
global.enable_title_dialogue = true;
global.arcade_mode = false;
global.experimental_weather = false;
global.weather_type = "RAIN";
global.weather_intensity = "MID";
global.weather_wind = false;
global.cheat_godmode = false;
global.cheat_infammo = false;
global.cheat_unlocked = false;

// --- TARGET ROOM & STATE SETUP INITIALIZATION ---
target_room = rm_intro;

// --- TOAST NOTIFICATION SYSTEM ---
toast_text = "";
toast_timer = 0;
toast_duration = 150; // 2.5 seconds at 60 FPS
toast_alpha = 0;
target_version = "v1.1.0";

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

// --- NAVIGATION SUB-MODES ---
// 0 = MAIN MENU, 1 = OPTIONS, 2 = JUKEBOX, 3 = CHANGELOG, 4 = CHEATS
current_mode = 0;

// Track active playing music handle and asset ID
menu_music = mus_menu_asset;
current_playing_track = -1;
current_playing_asset = -1;

// Analog stick debounce flags
gp_axis_pressed_v = false;
gp_axis_pressed_h = false;

// Set when the player selects Exit to Title Screen, read once the fade-out completes.
pending_exit_to_title = false;

// --- SETTINGS.JSON PERSISTENCE ---
settings_file_name = "settings.json";
scr_load_settings();
global.game_session_active = false;
global.game_lives = 3;
global.game_score = 0;

save_settings = function() {
    var _data = {
        vol_bgm: global.vol_bgm,
        vol_sfx: global.vol_sfx,
        fullscreen: global.fullscreen,
        enable_dialogue: global.enable_dialogue,
        enable_splash_dialogue: global.enable_splash_dialogue,
        enable_title_dialogue: global.enable_title_dialogue,
        arcade_mode: global.arcade_mode,
        experimental_weather: global.experimental_weather,
        weather_type: global.weather_type,
        weather_intensity: global.weather_intensity,
        weather_wind: global.weather_wind,
        cheat_godmode: global.cheat_godmode,
        cheat_infammo: global.cheat_infammo,
        cheat_unlocked: global.cheat_unlocked
    };

    var _json_str = json_stringify(_data);

    var _file = file_text_open_write(settings_file_name);
    if (_file != -1) {
        file_text_write_string(_file, _json_str);
        file_text_close(_file);
    } else {
        show_debug_message("ERROR: obj_menu_controller could not open '" + settings_file_name + "' for writing.");
    }
};

window_set_fullscreen(global.fullscreen);

// --- GENERIC LIST-MENU ENGINE WITH SCOPE BINDING ---
make_menu_list = function(_items, _visible_max) {
    var _inst = self;
    var _total = array_length(_items);

    // Re-bind all struct methods to obj_menu_controller instance scope
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
    }

    return {
        items: _items,
        total: _total,
        index: 0,
        scroll_offset: 0,
        visible_max: _visible_max
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
        var _arrow_x = 396;
        var _arrow_y_center = 205;
        var _bob = round(sin(arrow_anim_timer) * 2);

        if (_list.scroll_offset > 0 && sprite_exists(spr_menu_arrow_up)) {
            draw_sprite_ext(spr_menu_arrow_up, 0, _arrow_x, _arrow_y_center - 8 + _bob, 1, 1, 0, c_white, _alpha);
        }
        if (_list.scroll_offset + _list.visible_max < _list.total && sprite_exists(spr_menu_arrow_down)) {
            draw_sprite_ext(spr_menu_arrow_down, 0, _arrow_x, _arrow_y_center + 8 - _bob, 1, 1, 0, c_white, _alpha);
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

cycle_weather_type = function() {
    global.weather_type = (global.weather_type == "RAIN") ? "SNOW" : "RAIN";
    save_settings();
};

cycle_weather_intensity = function(_direction) {
    var _levels = ["LOW", "MID", "HIGH", "EXTREME"];
    var _index = array_get_index(_levels, global.weather_intensity);
    if (_index < 0) _index = 1;
    _index = (_index + _direction + array_length(_levels)) mod array_length(_levels);
    global.weather_intensity = _levels[_index];
    save_settings();
};

toggle_weather_wind = function() {
    global.weather_wind = !global.weather_wind;
    save_settings();
};

play_jukebox_track = function(_asset) {
    if (current_playing_track != -1 && audio_is_playing(current_playing_track)) {
        audio_stop_sound(current_playing_track);
        current_playing_track = -1;
        current_playing_asset = -1;
    }

    if (_asset != -1 && audio_exists(_asset)) {
        current_playing_asset = _asset;
        current_playing_track = audio_play_sound(_asset, 1, true);
        audio_sound_gain(current_playing_track, global.vol_bgm / 100, 0);
    } else {
        current_mode = 0;
        current_playing_asset = menu_music;
        if (menu_music != -1 && audio_exists(menu_music)) {
            current_playing_track = audio_play_sound(menu_music, 1, true);
            audio_sound_gain(current_playing_track, global.vol_bgm / 100, 0);
        }
    }
};

// --- MAIN MENU LIST (mode 0) ---
menu_list_main = make_menu_list([
    { 
        label: "Play Game", 
        action: function() { 
            io_clear();
            target_room = room_exists(rm_intro) ? rm_intro : room_next(room);
            fade_state = 2;
        } 
    },
    { 
        label: "Load Recent Game", 
        action: function() { 
            show_toast("Load Recent Game coming soon in " + target_version + "!");
        } 
    },
    { 
        label: "Time Attack", 
        action: function() { 
            show_toast("Time Attack coming soon in " + target_version + "!");
        } 
    },
    { label: "Cheats",          action: function() { current_mode = 4; menu_list_cheats.index = 0; } },
    { label: "Settings",        action: function() { current_mode = 1; menu_list_options.index = 0; } },
    { label: "Changelog",       action: function() { changelog_scroll = 0; changelog_fade_state = 1; } },
    { label: "Sound Test",      action: function() { current_mode = 2; menu_list_jukebox.index = 0; menu_list_jukebox.scroll_offset = 0; } },
    { label: "Exit to Title Screen", action: function() { io_clear(); pending_exit_to_title = true; fade_state = 2; } },
    { label: "Exit Game", action: function() { game_end(); } }
], 8);

// --- SETTINGS / OPTIONS LIST (mode 1) ---
menu_list_options = make_menu_list([
    {
        label: "BGM VOLUME",
        get_value: function() { return " < " + string(global.vol_bgm) + "% >"; },
        on_left:  function() { global.vol_bgm = clamp(global.vol_bgm - 10, 0, 100); apply_bgm_volume(); save_settings(); },
        on_right: function() { global.vol_bgm = clamp(global.vol_bgm + 10, 0, 100); apply_bgm_volume(); save_settings(); }
    },
    {
        label: "SFX VOLUME",
        get_value: function() { return " < " + string(global.vol_sfx) + "% >"; },
        on_left:  function() { global.vol_sfx = clamp(global.vol_sfx - 10, 0, 100); save_settings(); },
        on_right: function() { global.vol_sfx = clamp(global.vol_sfx + 10, 0, 100); save_settings(); }
    },
    {
        label: "FULLSCREEN",
        get_value: function() { return global.fullscreen ? " [ON]" : " [OFF]"; },
        on_left: method(self, toggle_fullscreen),
        on_right: method(self, toggle_fullscreen),
        action: method(self, toggle_fullscreen),
        adjust_sfx: sfx_continue_asset,
        confirm_sfx: sfx_continue_asset
    },
    {
        label: "SPLASH DIALOGUE",
        get_value: function() { return global.enable_splash_dialogue ? " [ON]" : " [OFF]"; },
        action: function() { global.enable_splash_dialogue = !global.enable_splash_dialogue; save_settings(); },
        on_left: function() { global.enable_splash_dialogue = !global.enable_splash_dialogue; save_settings(); },
        on_right: function() { global.enable_splash_dialogue = !global.enable_splash_dialogue; save_settings(); },
        adjust_sfx: sfx_continue_asset,
        confirm_sfx: sfx_continue_asset
    },
    {
        label: "TITLE DIALOGUE (EASTER EGG)",
        get_value: function() { return global.enable_title_dialogue ? " [ON]" : " [OFF]"; },
        action: function() { global.enable_title_dialogue = !global.enable_title_dialogue; save_settings(); },
        on_left: function() { global.enable_title_dialogue = !global.enable_title_dialogue; save_settings(); },
        on_right: function() { global.enable_title_dialogue = !global.enable_title_dialogue; save_settings(); },
        adjust_sfx: sfx_continue_asset,
        confirm_sfx: sfx_continue_asset
    },
    {
        label: "ARCADE MODE",
        get_value: function() { return global.arcade_mode ? " [ON]" : " [OFF]"; },
        action: function() { global.arcade_mode = !global.arcade_mode; save_settings(); },
        on_left: function() { global.arcade_mode = !global.arcade_mode; save_settings(); },
        on_right: function() { global.arcade_mode = !global.arcade_mode; save_settings(); },
        adjust_sfx: sfx_continue_asset,
        confirm_sfx: sfx_continue_asset
    },
    {
        label: "WEATHER (EXPERIMENTAL)",
        get_value: function() { return global.experimental_weather ? " [ON]" : " [OFF]"; },
        action: function() { global.experimental_weather = !global.experimental_weather; save_settings(); },
        on_left: function() { global.experimental_weather = !global.experimental_weather; save_settings(); },
        on_right: function() { global.experimental_weather = !global.experimental_weather; save_settings(); },
        adjust_sfx: sfx_continue_asset,
        confirm_sfx: sfx_continue_asset
    },
    {
        label: "  WEATHER TYPE",
        get_value: function() { return " [" + global.weather_type + "]"; },
        on_left: cycle_weather_type,
        on_right: cycle_weather_type,
        action: cycle_weather_type,
        adjust_sfx: sfx_continue_asset,
        confirm_sfx: sfx_continue_asset
    },
    {
        label: "  WEATHER INTENSITY",
        get_value: function() { return " [" + global.weather_intensity + "]"; },
        on_left: function() { cycle_weather_intensity(-1); },
        on_right: function() { cycle_weather_intensity(1); },
        action: function() { cycle_weather_intensity(1); },
        adjust_sfx: sfx_continue_asset,
        confirm_sfx: sfx_continue_asset
    },
    {
        label: "  WEATHER WIND",
        get_value: function() { return global.weather_wind ? " [ON]" : " [OFF]"; },
        on_left: toggle_weather_wind,
        on_right: toggle_weather_wind,
        action: toggle_weather_wind,
        adjust_sfx: sfx_continue_asset,
        confirm_sfx: sfx_continue_asset
    },
    {
        label: "BACK TO MENU",
        action: function() { current_mode = 0; }
    }
], 8);

// --- JUKEBOX LIST (mode 2) ---
menu_list_jukebox = make_menu_list([
    { label: "MENU THEME",        get_value: function() { return (current_playing_asset == mus_menu_asset) ? " [PLAYING]" : ""; },            action: function() { play_jukebox_track(mus_menu_asset); } },
    { label: "MAGE MAALadivaina", get_value: function() { return (current_playing_asset == mus_mage_maaladivaina) ? " [PLAYING]" : ""; }, action: function() { play_jukebox_track(mus_mage_maaladivaina); } },
    { label: "SUBWAY STATION",    get_value: function() { return (current_playing_asset == mus_subway) ? " [PLAYING]" : ""; },            action: function() { play_jukebox_track(mus_subway); } },
    { label: "CITYSCAPE",         get_value: function() { return (current_playing_asset == mus_city) ? " [PLAYING]" : ""; },               action: function() { play_jukebox_track(mus_city); } },
    { label: "BOSS BATTLE",       get_value: function() { return (current_playing_asset == mus_boss) ? " [PLAYING]" : ""; },               action: function() { play_jukebox_track(mus_boss); } },
    { label: "BACK TO MENU",      action: function() { play_jukebox_track(-1); } }
], 8);

// --- CHEATS LIST (mode 4) ---
var _toggle_godmode  = function() { global.cheat_godmode  = !global.cheat_godmode;  save_settings(); };
var _toggle_infammo  = function() { global.cheat_infammo  = !global.cheat_infammo;  save_settings(); };
var _toggle_unlocked = function() { global.cheat_unlocked = !global.cheat_unlocked; save_settings(); };
var _cheats_back     = function() { current_mode = 0; };

menu_list_cheats = make_menu_list([
    { label: "GOD MODE",          get_value: function() { return global.cheat_godmode  ? " [ENABLED]" : " [DISABLED]"; }, action: _toggle_godmode,  on_left: _toggle_godmode,  on_right: _toggle_godmode,  adjust_sfx: sfx_continue_asset, confirm_sfx: sfx_continue_asset },
    { label: "INFINITE AMMO",     get_value: function() { return global.cheat_infammo  ? " [ENABLED]" : " [DISABLED]"; }, action: _toggle_infammo,  on_left: _toggle_infammo,  on_right: _toggle_infammo,  adjust_sfx: sfx_continue_asset, confirm_sfx: sfx_continue_asset },
    { label: "UNLOCK ALL LEVELS", get_value: function() { return global.cheat_unlocked ? " [YES]" : " [NO]"; },             action: _toggle_unlocked, on_left: _toggle_unlocked, on_right: _toggle_unlocked, adjust_sfx: sfx_continue_asset, confirm_sfx: sfx_continue_asset },
    { label: "BACK TO MENU",      action: _cheats_back, on_left: _cheats_back, on_right: _cheats_back, adjust_sfx: sfx_continue_asset, confirm_sfx: sfx_continue_asset }
], 4);

// --- CHANGELOG SUB-MENU DATA ---
changelog_lines = [];
if (script_exists(scr_changelog_details)) {
    changelog_lines = script_execute(scr_changelog_details);
} else {
    changelog_lines = [
        "[v1.0.0 CHANGELOG]",
        "+ Added multi-mode menu state engine",
        "+ Integrated Cheats sub-menu",
        "+ Fixed background audio tracking bug",
        "+ Native 432x240 pixel-perfect viewport UI"
    ];
}
changelog_scroll = 0;
changelog_line_height = 14;
changelog_visible_lines = 9;

// --- CHANGELOG FADE TRANSITION ---
changelog_fade_alpha = 0;   // 0 = Main Menu Visible, 1 = Changelog Visible
changelog_fade_state = 0;   // 0 = Idle, 1 = Fading into Changelog, 2 = Fading back to Main Menu
changelog_fade_speed = 0.08;

// --- LAYOUT & SPACING CONFIGURATION ---
start_y = 45;
line_spacing = 17;

// Cursor motion animation
cursor_offset_x = 0;
cursor_dir = 1;

// Retro arrow animation timer
arrow_anim_timer = 0;

// --- STATE MACHINE & FADE OVERLAY ---
fade_alpha = 1;
fade_speed = 0.04;
fade_state = 0; // 0 = Fade In, 1 = Active, 2 = Fade Out Transition

// --- INITIAL AUDIO SETUP ---
if (menu_music != -1 && audio_exists(menu_music)) {
    current_playing_asset = menu_music;
    current_playing_track = audio_play_sound(menu_music, 1, true);
    audio_sound_gain(current_playing_track, global.vol_bgm / 100, 0);
}