/// @function scr_save_settings()
/// @description Persist shared player settings to settings.json.
function scr_save_settings() {
    if (!variable_global_exists("time_attack_best_ticks")) global.time_attack_best_ticks = -1;
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
        cheat_debug_mode: global.cheat_debug_mode,
        cheat_hitboxes: global.cheat_hitboxes,
        cheat_instant_respawn: global.cheat_instant_respawn,
        selected_mannequin: global.selected_mannequin,
        language: global.language,
        fade_style: global.fade_style,
        fade_hold_seconds: global.fade_hold_seconds,
        player_physics_mode: global.player_physics_mode,
        scrolling_mode: global.scrolling_mode,
        startup_challenge_enabled: global.startup_challenge_enabled,
        time_attack_best_ticks: global.time_attack_best_ticks
    };

    var _file = file_text_open_write("settings.json");
    if (_file == -1) return false;

    file_text_write_string(_file, json_stringify(_data));
    file_text_close(_file);
    return true;
}

/// @function scr_game_save_room_name(_room_id)
/// @description Converts a playable room resource to a stable save-file name.
function scr_game_save_room_name(_room_id) {
    switch (_room_id) {
        case rm_subway: return "rm_subway";
        case rm_city: return "rm_city";
        case rm_dungeons: return "rm_dungeons";
        case rm_boss: return "rm_boss";
    }
    return "";
}

/// @function scr_game_save_room_id(_room_name)
/// @description Resolves a saved playable room name without trusting arbitrary file data.
function scr_game_save_room_id(_room_name) {
    switch (_room_name) {
        case "rm_subway": return rm_subway;
        case "rm_city": return rm_city;
        case "rm_dungeons": return rm_dungeons;
        case "rm_boss": return rm_boss;
    }
    return -1;
}

/// @function scr_game_autosave_write(_save_data)
/// @description Writes a versioned gameplay snapshot to autosave.json.
function scr_game_autosave_write(_save_data) {
    if (!is_struct(_save_data)) return false;
    var _room_name = scr_game_save_room_name(_save_data.room_id);
    if (_room_name == "") return false;

    var _data = {
        version: 1,
        room: _room_name,
        x: _save_data.x,
        y: _save_data.y,
        hp: _save_data.hp,
        score: _save_data.score,
        lives: _save_data.lives,
        timer_ticks: _save_data.timer_ticks,
        time_attack_active: _save_data.time_attack_active,
        time_attack_ticks: _save_data.time_attack_ticks
    };
    var _file = file_text_open_write("autosave.json");
    if (_file == -1) return false;
    file_text_write_string(_file, json_stringify(_data));
    file_text_close(_file);
    return true;
}

/// @function scr_game_autosave_read()
/// @description Reads and validates the last gameplay snapshot, or returns undefined.
function scr_game_autosave_read() {
    var _file_name = "autosave.json";
    if (!file_exists(_file_name)) return undefined;
    var _file = file_text_open_read(_file_name);
    if (_file == -1) return undefined;
    var _json = "";
    while (!file_text_eof(_file)) _json += file_text_readln(_file);
    file_text_close(_file);

    try {
        var _data = json_parse(_json);
        if (!is_struct(_data) || !variable_struct_exists(_data, "version") || _data.version != 1) return undefined;
        if (!variable_struct_exists(_data, "room") || !is_string(_data.room)) return undefined;
        var _room_id = scr_game_save_room_id(_data.room);
        if (_room_id == -1 || !room_exists(_room_id)) return undefined;
        if (!variable_struct_exists(_data, "x") || !is_real(_data.x)) return undefined;
        if (!variable_struct_exists(_data, "y") || !is_real(_data.y)) return undefined;
        if (!variable_struct_exists(_data, "hp") || !is_real(_data.hp)) return undefined;
        if (!variable_struct_exists(_data, "score") || !is_real(_data.score)) return undefined;
        if (!variable_struct_exists(_data, "lives") || !is_real(_data.lives)) return undefined;
        if (!variable_struct_exists(_data, "timer_ticks") || !is_real(_data.timer_ticks)) return undefined;
        _data.room_id = _room_id;
        if (!variable_struct_exists(_data, "time_attack_active")) _data.time_attack_active = false;
        if (!variable_struct_exists(_data, "time_attack_ticks") || !is_real(_data.time_attack_ticks)) _data.time_attack_ticks = 0;
        return _data;
    } catch (_err) {
        show_debug_message("Autosave could not be read: " + string(_err.message));
        return undefined;
    }
}

/// @function scr_game_save_slot_write(_slot, _name, _save_data)
/// @description Writes one named gameplay slot using the same snapshot fields as autosave.
function scr_game_save_slot_write(_slot, _name, _save_data) {
    if (!is_real(_slot) || _slot < 1 || _slot > 3 || !is_struct(_save_data)) return false;
    var _room_name = scr_game_save_room_name(_save_data.room_id);
    if (_room_name == "") return false;

    var _safe_name = string_copy(string(_name), 1, 12);
    if (_safe_name == "") _safe_name = "JACK";
    var _data = {
        version: 1,
        slot: _slot,
        name: _safe_name,
        room: _room_name,
        x: _save_data.x,
        y: _save_data.y,
        hp: _save_data.hp,
        score: _save_data.score,
        lives: _save_data.lives,
        timer_ticks: _save_data.timer_ticks,
        time_attack_active: _save_data.time_attack_active,
        time_attack_ticks: _save_data.time_attack_ticks
    };

    var _file = file_text_open_write("save_slot_" + string(_slot) + ".json");
    if (_file == -1) return false;
    file_text_write_string(_file, json_stringify(_data));
    file_text_close(_file);
    return true;
}

/// @function scr_game_save_slot_read(_slot)
/// @description Reads a validated named save slot, returning undefined for an empty or invalid slot.
function scr_game_save_slot_read(_slot) {
    if (!is_real(_slot) || _slot < 1 || _slot > 3) return undefined;
    var _file_name = "save_slot_" + string(_slot) + ".json";
    if (!file_exists(_file_name)) return undefined;
    var _file = file_text_open_read(_file_name);
    if (_file == -1) return undefined;
    var _json = "";
    while (!file_text_eof(_file)) _json += file_text_readln(_file);
    file_text_close(_file);

    try {
        var _data = json_parse(_json);
        if (!is_struct(_data) || !variable_struct_exists(_data, "version") || _data.version != 1) return undefined;
        if (!variable_struct_exists(_data, "name") || !is_string(_data.name)) return undefined;
        if (!variable_struct_exists(_data, "room") || !is_string(_data.room)) return undefined;
        var _room_id = scr_game_save_room_id(_data.room);
        if (_room_id == -1 || !room_exists(_room_id)) return undefined;
        var _required = ["x", "y", "hp", "score", "lives", "timer_ticks"];
        for (var _i = 0; _i < array_length(_required); _i++) {
            var _key = _required[_i];
            if (!variable_struct_exists(_data, _key) || !is_real(variable_struct_get(_data, _key))) return undefined;
        }
        if (!variable_struct_exists(_data, "time_attack_active")) _data.time_attack_active = false;
        if (!variable_struct_exists(_data, "time_attack_ticks") || !is_real(_data.time_attack_ticks)) _data.time_attack_ticks = 0;
        _data.room_id = _room_id;
        return _data;
    } catch (_err) {
        show_debug_message("Save slot could not be read: " + string(_err.message));
        return undefined;
    }
}
