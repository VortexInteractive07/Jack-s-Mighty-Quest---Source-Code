/// @function scr_load_settings()
/// @description Loads persistent settings and applies safe defaults for every controller.
function scr_load_settings() {
    if (!variable_global_exists("vol_bgm"))           global.vol_bgm = 80;
    if (!variable_global_exists("vol_sfx"))           global.vol_sfx = 80;
    if (!variable_global_exists("fullscreen"))        global.fullscreen = false;
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
}
