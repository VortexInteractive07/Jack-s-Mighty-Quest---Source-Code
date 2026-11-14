/// @description Initialize the main menu controller, list menus, and persistent settings

// Intelligence Level: 10/10

// Direct Asset Handle Initialization
sfx_dialogue_asset = sfx_dialogue;
sfx_continue_asset = sfx_dialogue_continue;
mus_menu_asset     = mus_menu;

// --- GLOBAL DEFAULTS (Must be set before loading settings to prevent undefined errors) ---
global.vol_bgm = 100;
global.vol_sfx = 100;
global.fullscreen = false;
global.screen_resolution = "432x240";
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

jukebox_playlist = scr_jukebox_ost_playlist();
jukebox_selected_index = 0;
jukebox_scroll_offset = 0;
jukebox_visible_max = 5;
jukebox_playing_index = -1;
jukebox_is_playing = false;
jukebox_playback_position = 0;
jukebox_transition_state = 0;
jukebox_transition_target_mode = 0;
jukebox_transition_action = 0;
jukebox_bg_x = 0;
jukebox_bg_y = 0;
jukebox_bg_speed_x = 1;
jukebox_bg_speed_y = -1;
jukebox_navy_dark = make_color_rgb(10, 25, 47);
jukebox_navy_light = make_color_rgb(20, 45, 80);
jukebox_gold = make_color_rgb(212, 175, 55);
jukebox_gold_light = make_color_rgb(245, 222, 179);
jukebox_platinum = make_color_rgb(229, 228, 226);

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
        screen_resolution: global.screen_resolution,
        texture_pack: global.texture_pack,
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
        var _arrow_x = _text_x - 16;
        var _visible_rows = min(_list.visible_max, _list.total - _list.scroll_offset);
        var _arrow_y_center = min(
            _y_start + (_visible_rows * _line_spacing) + 2,
            display_get_gui_height() - 30
        );
        var _bob = round(sin(arrow_anim_timer) * 2);

        if (_list.scroll_offset > 0 && sprite_exists(spr_menu_arrow_up)) {
            var _arrow_up = scr_texture_pack_sprite("spr_menu_arrow_up", spr_menu_arrow_up);
            draw_sprite_ext(_arrow_up, 0, _arrow_x, _arrow_y_center - 8 + _bob, 1, 1, 0, c_white, _alpha);
        }
        if (_list.scroll_offset + _list.visible_max < _list.total && sprite_exists(spr_menu_arrow_down)) {
            var _arrow_down = scr_texture_pack_sprite("spr_menu_arrow_down", spr_menu_arrow_down);
            draw_sprite_ext(_arrow_down, 0, _arrow_x, _arrow_y_center + 8 - _bob, 1, 1, 0, c_white, _alpha);
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

cycle_screen_resolution = function(_direction) {
    var _resolutions = ["432x240", "320x240", "320x224", "256x192", "256x240", "256x224"];
    var _resolution_index = 0;

    for (var i = 0; i < array_length(_resolutions); i++) {
        if (_resolutions[i] == global.screen_resolution) {
            _resolution_index = i;
            break;
        }
    }

    _resolution_index = (_resolution_index + _direction + array_length(_resolutions)) mod array_length(_resolutions);
    global.screen_resolution = _resolutions[_resolution_index];
    scr_apply_resolution();
    save_settings();
};

cycle_texture_pack = function(_direction) {
    var _packs = scr_texture_pack_list();
    var _selected = 0;
    for (var i = 0; i < array_length(_packs); i++) {
        if (_packs[i].id == global.texture_pack) {
            _selected = i;
            break;
        }
    }

    _selected = (_selected + _direction + array_length(_packs)) mod array_length(_packs);
    global.texture_pack = _packs[_selected].id;
    save_settings();
    show_toast("Texture pack applies next launch: " + _packs[_selected].name);
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

jukebox_play_selected = function(_index) {
    if (current_playing_track != -1) {
        audio_stop_sound(current_playing_track);
    }

    current_playing_track = -1;
    current_playing_asset = -1;
    jukebox_playing_index = -1;
    jukebox_is_playing = false;

    var _song = jukebox_playlist[_index];
    if (audio_exists(_song.sound)) {
        current_playing_asset = _song.sound;
        current_playing_track = audio_play_sound(_song.sound, 1, true);
        audio_sound_gain(current_playing_track, global.vol_bgm / 100, 0);
        jukebox_playing_index = _index;
        jukebox_is_playing = true;
        jukebox_playback_position = 0;
        play_ui_blip(sfx_continue_asset);
    } else {
        show_debug_message("Jukebox track asset is unavailable: " + _song.title);
    }
};

jukebox_toggle_playback = function() {
    if (jukebox_is_playing) {
        if (current_playing_track != -1 && audio_is_playing(current_playing_track)) {
            audio_pause_sound(current_playing_track);
        }
        jukebox_is_playing = false;
    } else if (current_playing_track != -1 && jukebox_playing_index == jukebox_selected_index) {
        audio_resume_sound(current_playing_track);
        jukebox_is_playing = true;
    } else {
        jukebox_play_selected(jukebox_selected_index);
        return;
    }

    play_ui_blip(sfx_dialogue_asset);
};

begin_jukebox_transition = function(_target_mode, _action) {
    if (jukebox_transition_state != 0) return;

    jukebox_transition_target_mode = _target_mode;
    jukebox_transition_action = _action;
    jukebox_transition_state = 1;
};

open_jukebox = function() {
    begin_jukebox_transition(2, 1);
};

close_jukebox = function() {
    begin_jukebox_transition(0, 2);
};

jukebox_current_lyrics = function() {
    var _song = jukebox_playlist[jukebox_selected_index];
    if (!variable_struct_exists(_song, "lyrics") || !is_array(_song.lyrics) || array_length(_song.lyrics) == 0) {
        return "NO LYRICS AVAILABLE";
    }
    if (jukebox_playing_index != jukebox_selected_index) {
        return "SELECT A TRACK AND PRESS ENTER TO PLAY";
    }
    if (!jukebox_is_playing) {
        return "(PAUSED)";
    }

    var _lyrics = _song.lyrics;
    var _text = "";
    for (var i = 0; i < array_length(_lyrics); i++) {
        if (jukebox_playback_position >= _lyrics[i].time) {
            _text = _lyrics[i].text;
        } else {
            break;
        }
    }
    return (_text == "") ? "..." : _text;
};

fit_jukebox_text = function(_text, _max_width) {
    if (string_width(_text) <= _max_width) return _text;

    while (string_length(_text) > 0 && string_width(_text + "...") > _max_width) {
        _text = string_delete(_text, string_length(_text), 1);
    }
    return _text + "...";
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
    { label: "IN-GAME BROWSER", action: function() { show_toast("Embedded browser is not available in this build."); } },
    { label: "Changelog",       action: function() { changelog_scroll = 0; changelog_fade_state = 1; } },
    { label: "Sound Test",      action: function() { open_jukebox(); } },
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
        label: "RES (EXP)",
        get_value: function() {
            var _resolution_label = global.screen_resolution;
            if (global.screen_resolution == "432x240" && display_get_gui_width() > 256) _resolution_label += " (Default)";
            if (global.screen_resolution == "320x240") {
                _resolution_label += (display_get_gui_width() <= 256) ? " GENESIS" : " (SEGA Genesis)";
            }
            return " " + _resolution_label;
        },
        on_left: function() { cycle_screen_resolution(-1); },
        on_right: function() { cycle_screen_resolution(1); },
        action: function() { cycle_screen_resolution(1); },
        adjust_sfx: sfx_continue_asset,
        confirm_sfx: sfx_continue_asset
    },
    {
        label: "TEXTURES (RESTART)",
        get_value: function() {
            var _packs = scr_texture_pack_list();
            for (var i = 0; i < array_length(_packs); i++) {
                if (_packs[i].id == global.texture_pack) return " [" + _packs[i].name + "]";
            }
            return " [Default]";
        },
        on_left: function() { cycle_texture_pack(-1); },
        on_right: function() { cycle_texture_pack(1); },
        action: function() { cycle_texture_pack(1); },
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