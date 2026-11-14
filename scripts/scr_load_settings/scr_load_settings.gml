/// @function scr_load_settings()
/// @description Loads persistent settings and applies safe defaults for every controller.
function scr_load_settings() {
    if (!variable_global_exists("vol_bgm"))           global.vol_bgm = 80;
    if (!variable_global_exists("vol_sfx"))           global.vol_sfx = 80;
    if (!variable_global_exists("fullscreen"))        global.fullscreen = false;
    if (!variable_global_exists("screen_resolution")) global.screen_resolution = "432x240";
    if (!variable_global_exists("texture_pack"))      global.texture_pack = "";
    if (!variable_global_exists("enable_dialogue"))   global.enable_dialogue = false;
    if (!variable_global_exists("enable_splash_dialogue")) global.enable_splash_dialogue = global.enable_dialogue;
    if (!variable_global_exists("enable_title_dialogue"))  global.enable_title_dialogue = global.enable_dialogue;
    if (!variable_global_exists("arcade_mode"))        global.arcade_mode = false;
    if (!variable_global_exists("experimental_weather")) global.experimental_weather = false;
    if (!variable_global_exists("weather_type"))       global.weather_type = "RAIN";
    if (!variable_global_exists("weather_intensity"))  global.weather_intensity = "MID";
    if (!variable_global_exists("weather_wind"))       global.weather_wind = false;
    if (!variable_global_exists("cheat_godmode"))     global.cheat_godmode = false;
    if (!variable_global_exists("cheat_infammo"))     global.cheat_infammo = false;
    if (!variable_global_exists("cheat_unlocked"))    global.cheat_unlocked = false;
    if (!variable_global_exists("selected_mannequin")) global.selected_mannequin = 0;

    scr_apply_resolution();
    scr_texture_pack_load(global.texture_pack);

    var _settings_file_name = "settings.json";
    if (!file_exists(_settings_file_name)) {
        return;
    }

    var _file = file_text_open_read(_settings_file_name);
    if (_file == -1) {
        show_debug_message("ERROR: could not open '" + _settings_file_name + "' for reading.");
        return;
    }

    var _json_str = "";
    while (!file_text_eof(_file)) {
        _json_str += file_text_readln(_file);
    }
    file_text_close(_file);

    try {
        var _data = json_parse(_json_str);
        if (!is_struct(_data)) {
            return;
        }

        if (variable_struct_exists(_data, "vol_bgm") && is_real(_data.vol_bgm)) {
            global.vol_bgm = clamp(_data.vol_bgm, 0, 100);
        }
        if (variable_struct_exists(_data, "vol_sfx") && is_real(_data.vol_sfx)) {
            global.vol_sfx = clamp(_data.vol_sfx, 0, 100);
        }
        if (variable_struct_exists(_data, "fullscreen") && is_bool(_data.fullscreen)) {
            global.fullscreen = _data.fullscreen;
        }
        if (variable_struct_exists(_data, "screen_resolution") && is_string(_data.screen_resolution)) {
            var _screen_resolution = _data.screen_resolution;
            if (_screen_resolution == "432x240"
            || _screen_resolution == "320x240"
            || _screen_resolution == "320x224"
            || _screen_resolution == "256x192"
            || _screen_resolution == "256x240"
            || _screen_resolution == "256x224") {
                global.screen_resolution = _screen_resolution;
            }
        }
        if (variable_struct_exists(_data, "texture_pack") && is_string(_data.texture_pack)) {
            global.texture_pack = _data.texture_pack;
        }
        if (variable_struct_exists(_data, "enable_dialogue") && is_bool(_data.enable_dialogue)) {
            global.enable_dialogue = _data.enable_dialogue;
            if (!variable_struct_exists(_data, "enable_splash_dialogue")) global.enable_splash_dialogue = _data.enable_dialogue;
            if (!variable_struct_exists(_data, "enable_title_dialogue"))  global.enable_title_dialogue = _data.enable_dialogue;
        }
        if (variable_struct_exists(_data, "enable_splash_dialogue") && is_bool(_data.enable_splash_dialogue)) {
            global.enable_splash_dialogue = _data.enable_splash_dialogue;
        }
        if (variable_struct_exists(_data, "enable_title_dialogue") && is_bool(_data.enable_title_dialogue)) {
            global.enable_title_dialogue = _data.enable_title_dialogue;
        }
        if (variable_struct_exists(_data, "arcade_mode") && is_bool(_data.arcade_mode)) {
            global.arcade_mode = _data.arcade_mode;
        }
        if (variable_struct_exists(_data, "experimental_weather") && is_bool(_data.experimental_weather)) {
            global.experimental_weather = _data.experimental_weather;
        }
        if (variable_struct_exists(_data, "weather_type") && is_string(_data.weather_type)) {
            var _weather_type = string_upper(_data.weather_type);
            if (_weather_type == "RAIN" || _weather_type == "SNOW") global.weather_type = _weather_type;
        }
        if (variable_struct_exists(_data, "weather_intensity") && is_string(_data.weather_intensity)) {
            var _weather_intensity = string_upper(_data.weather_intensity);
            if (_weather_intensity == "LOW" || _weather_intensity == "MID" || _weather_intensity == "HIGH" || _weather_intensity == "EXTREME") global.weather_intensity = _weather_intensity;
        }
        if (variable_struct_exists(_data, "weather_wind") && is_bool(_data.weather_wind)) {
            global.weather_wind = _data.weather_wind;
        }
        if (variable_struct_exists(_data, "cheat_godmode") && is_bool(_data.cheat_godmode)) {
            global.cheat_godmode = _data.cheat_godmode;
        }
        if (variable_struct_exists(_data, "cheat_infammo") && is_bool(_data.cheat_infammo)) {
            global.cheat_infammo = _data.cheat_infammo;
        }
        if (variable_struct_exists(_data, "cheat_unlocked") && is_bool(_data.cheat_unlocked)) {
            global.cheat_unlocked = _data.cheat_unlocked;
        }
        if (variable_struct_exists(_data, "selected_mannequin") && is_real(_data.selected_mannequin)) {
            global.selected_mannequin = clamp(floor(_data.selected_mannequin), 0, 2);
        }
    } catch (_err) {
        show_debug_message("ERROR: could not parse '" + _settings_file_name + "' (" + string(_err.message) + ").");
    }

    scr_apply_resolution();
    scr_texture_pack_load(global.texture_pack);
}

/// @function scr_apply_resolution()
/// @description Applies the selected native game, camera, and GUI dimensions.
function scr_apply_resolution() {
    var _width = 432;
    var _height = 240;

    switch (global.screen_resolution) {
        case "320x240": _width = 320; _height = 240; break;
        case "320x224": _width = 320; _height = 224; break;
        case "256x192": _width = 256; _height = 192; break;
        case "256x240": _width = 256; _height = 240; break;
        case "256x224": _width = 256; _height = 224; break;
    }

    global.screen_width = _width;
    global.screen_height = _height;
    display_set_gui_size(_width, _height);

    if (view_enabled && is_real(view_camera[0]) && view_camera[0] != -1) {
        camera_set_view_size(view_camera[0], _width, _height);
        view_set_xport(0, 0);
        view_set_yport(0, 0);
        view_set_wport(0, _width);
        view_set_hport(0, _height);
    }
}
