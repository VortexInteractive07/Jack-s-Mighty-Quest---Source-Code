/// @function scr_save_settings()
/// @description Persist shared player settings to settings.json.
function scr_save_settings() {
    var _data = {
        vol_bgm: global.vol_bgm,
        vol_sfx: global.vol_sfx,
        fullscreen: global.fullscreen,
        enable_dialogue: global.enable_dialogue,
        enable_splash_dialogue: global.enable_splash_dialogue,
        enable_title_dialogue: global.enable_title_dialogue,
        arcade_mode: global.arcade_mode,
        cheat_godmode: global.cheat_godmode,
        cheat_unlocked: global.cheat_unlocked,
        selected_mannequin: global.selected_mannequin,
        language: global.language,
        startup_challenge_enabled: global.startup_challenge_enabled
    };

    var _file = file_text_open_write("settings.json");
    if (_file == -1) return false;

    file_text_write_string(_file, json_stringify(_data));
    file_text_close(_file);
    return true;
}