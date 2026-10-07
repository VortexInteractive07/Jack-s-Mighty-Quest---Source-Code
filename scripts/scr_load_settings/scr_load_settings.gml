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
    if (!variable_global_exists("cheat_godmode"))     global.cheat_godmode = false;
    if (!variable_global_exists("cheat_unlocked"))    global.cheat_unlocked = false;
    if (!variable_global_exists("cheat_debug_mode"))  global.cheat_debug_mode = false;
    if (!variable_global_exists("cheat_hitboxes"))    global.cheat_hitboxes = false;
    if (!variable_global_exists("cheat_instant_respawn")) global.cheat_instant_respawn = false;
    if (!variable_global_exists("time_attack_best_ticks")) global.time_attack_best_ticks = -1;
    if (!variable_global_exists("selected_mannequin")) global.selected_mannequin = 0;
    if (!variable_global_exists("language")) global.language = "EN";
    if (global.language != "EN" && global.language != "DE" && global.language != "ES" && global.language != "PL" && global.language != "SH" && global.language != "EG" && global.language != "JG") {
        global.language = "EN";
    }
    if (!variable_global_exists("fade_style")) global.fade_style = "SMOOTH";
    if (!variable_global_exists("fade_hold_seconds")) global.fade_hold_seconds = 1;
    global.fade_hold_seconds = clamp(global.fade_hold_seconds, 0, 5);
    if (global.fade_style != "SMOOTH" && global.fade_style != "NES" && global.fade_style != "GENESIS" && global.fade_style != "MOSAIC" && global.fade_style != "FLASH" && global.fade_style != "BLACK" && global.fade_style != "OFF") {
        global.fade_style = "SMOOTH";
    }
    if (!variable_global_exists("startup_challenge_enabled")) global.startup_challenge_enabled = false;
    if (!variable_global_exists("player_physics_mode")) global.player_physics_mode = "DEFAULT";
    if (global.player_physics_mode == "JITTERY") global.player_physics_mode = "BOOTLEG";
    if (global.player_physics_mode != "DEFAULT" && global.player_physics_mode != "BOOTLEG") global.player_physics_mode = "DEFAULT";
    if (!variable_global_exists("scrolling_mode")) global.scrolling_mode = "DEFAULT";
    if (global.scrolling_mode != "DEFAULT" && global.scrolling_mode != "JITTERY") global.scrolling_mode = "DEFAULT";
    global.language_selected = false;

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
        if (variable_struct_exists(_data, "cheat_godmode") && is_bool(_data.cheat_godmode)) {
            global.cheat_godmode = _data.cheat_godmode;
        }
        if (variable_struct_exists(_data, "cheat_unlocked") && is_bool(_data.cheat_unlocked)) {
            global.cheat_unlocked = _data.cheat_unlocked;
        }
        if (variable_struct_exists(_data, "cheat_debug_mode") && is_bool(_data.cheat_debug_mode)) {
            global.cheat_debug_mode = _data.cheat_debug_mode;
        }
        if (variable_struct_exists(_data, "cheat_hitboxes") && is_bool(_data.cheat_hitboxes)) {
            global.cheat_hitboxes = _data.cheat_hitboxes;
        }
        if (variable_struct_exists(_data, "cheat_instant_respawn") && is_bool(_data.cheat_instant_respawn)) {
            global.cheat_instant_respawn = _data.cheat_instant_respawn;
        }
        if (variable_struct_exists(_data, "selected_mannequin") && is_real(_data.selected_mannequin)) {
            global.selected_mannequin = clamp(floor(_data.selected_mannequin), 0, 2);
        }
        if (variable_struct_exists(_data, "language") && is_string(_data.language)) {
            var _language = string_upper(_data.language);
            if (_language == "EN" || _language == "DE" || _language == "ES" || _language == "PL" || _language == "SH" || _language == "EG" || _language == "JG") {
                global.language = _language;
                global.language_selected = true;
            }
        }
        if (variable_struct_exists(_data, "fade_style") && is_string(_data.fade_style)) {
            var _fade_style = string_upper(_data.fade_style);
            if (_fade_style == "SMOOTH" || _fade_style == "NES" || _fade_style == "GENESIS" || _fade_style == "MOSAIC" || _fade_style == "FLASH" || _fade_style == "BLACK" || _fade_style == "OFF") {
                global.fade_style = _fade_style;
            }
        }
        if (variable_struct_exists(_data, "fade_hold_seconds") && is_real(_data.fade_hold_seconds)) {
            global.fade_hold_seconds = clamp(_data.fade_hold_seconds, 0, 5);
        }
        if (variable_struct_exists(_data, "player_physics_mode") && is_string(_data.player_physics_mode)) {
            var _physics_mode = string_upper(_data.player_physics_mode);
            if (_physics_mode == "DEFAULT") global.player_physics_mode = "DEFAULT";
            else if (_physics_mode == "BOOTLEG" || _physics_mode == "JITTERY") global.player_physics_mode = "BOOTLEG";
        }
        if (variable_struct_exists(_data, "scrolling_mode") && is_string(_data.scrolling_mode)) {
            var _scrolling_mode = string_upper(_data.scrolling_mode);
            if (_scrolling_mode == "DEFAULT" || _scrolling_mode == "JITTERY") global.scrolling_mode = _scrolling_mode;
        }
        if (variable_struct_exists(_data, "startup_challenge_enabled") && is_bool(_data.startup_challenge_enabled)) {
            global.startup_challenge_enabled = _data.startup_challenge_enabled;
        }
        if (variable_struct_exists(_data, "time_attack_best_ticks") && is_real(_data.time_attack_best_ticks)) {
            global.time_attack_best_ticks = max(-1, floor(_data.time_attack_best_ticks));
        }
    } catch (_err) {
        show_debug_message("ERROR: could not parse '" + _settings_file_name + "' (" + string(_err.message) + ").");
    }
}
