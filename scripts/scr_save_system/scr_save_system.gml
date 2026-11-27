/// @function scr_save_directory()
/// @description Returns the writable per-game save folder, creating it on demand.
function scr_save_directory() {
    var _root = working_directory + "save_directory\\";
    if (!directory_exists(_root)) directory_create(_root);
    return _root;
}

/// @function scr_save_gem_was_collected(_room_name, _x, _y)
/// @description Checks whether this saved run already collected a gem at a location.
function scr_save_gem_was_collected(_room_name, _x, _y) {
    if (!variable_global_exists("collected_gem_positions") || !is_array(global.collected_gem_positions)) return false;
    for (var _i = 0; _i < array_length(global.collected_gem_positions); _i++) {
        var _gem = global.collected_gem_positions[_i];
        if (is_struct(_gem) && variable_struct_exists(_gem, "room") && _gem.room == _room_name
        && variable_struct_exists(_gem, "x") && is_real(_gem.x)
        && variable_struct_exists(_gem, "y") && is_real(_gem.y)
        && abs(_gem.x - _x) < 0.5 && abs(_gem.y - _y) < 0.5) return true;
    }
    return false;
}

/// @function scr_save_record_collected_gem(_room_name, _x, _y)
/// @description Adds a uniquely located gem to the active run's collected set.
function scr_save_record_collected_gem(_room_name, _x, _y) {
    if (!variable_global_exists("collected_gem_positions") || !is_array(global.collected_gem_positions)) {
        global.collected_gem_positions = [];
    }
    if (scr_save_gem_was_collected(_room_name, _x, _y)) return false;
    array_push(global.collected_gem_positions, { room: _room_name, x: _x, y: _y });
    return true;
}

/// @function scr_save_slot_path(_slot)
/// @description Returns a validated path for one of the ten save slots.
function scr_save_slot_path(_slot) {
    if (!is_real(_slot) || _slot < 0 || _slot > 9 || floor(_slot) != _slot) return "";
    return scr_save_directory() + "slot_" + string(_slot + 1) + ".json";
}

/// @function scr_save_slot_read(_slot)
/// @description Loads and validates one named save slot.
function scr_save_slot_read(_slot) {
    var _path = scr_save_slot_path(_slot);
    if (_path == "") return undefined;
    if (!file_exists(_path) && file_exists(_path + ".bak")) file_rename(_path + ".bak", _path);
    if (!file_exists(_path)) return undefined;

    var _file = file_text_open_read(_path);
    if (_file == -1) return undefined;
    var _json = "";
    while (!file_text_eof(_file)) _json += file_text_readln(_file);
    file_text_close(_file);

    try {
        var _data = json_parse(_json);
        if (!is_struct(_data) || !variable_struct_exists(_data, "format_version") || _data.format_version != 2
        || !variable_struct_exists(_data, "name") || !is_string(_data.name) || string_length(_data.name) == 0
        || !variable_struct_exists(_data, "room") || !is_string(_data.room)
        || !variable_struct_exists(_data, "x") || !is_real(_data.x)
        || !variable_struct_exists(_data, "y") || !is_real(_data.y)
        || !variable_struct_exists(_data, "mark_x") || !is_real(_data.mark_x)
        || !variable_struct_exists(_data, "mark_y") || !is_real(_data.mark_y)
        || !variable_struct_exists(_data, "hp") || !is_real(_data.hp)
        || !variable_struct_exists(_data, "score") || !is_real(_data.score)
        || !variable_struct_exists(_data, "lives") || !is_real(_data.lives)) return undefined;

        var _room = asset_get_index(_data.room);
        if (_room != rm_subway && _room != rm_city && _room != rm_dungeons) return undefined;
        var _room_info = room_get_info(_room, false, false, false, false, false);
        _data.x = clamp(_data.x, 0, max(0, _room_info.width - 1));
        _data.y = clamp(_data.y, 0, max(0, _room_info.height - 1));
        _data.mark_x = clamp(_data.mark_x, 0, max(0, _room_info.width - 1));
        _data.mark_y = clamp(_data.mark_y, 0, max(0, _room_info.height - 1));
        _data.name = string_copy(_data.name, 1, 16);
        _data.hp = clamp(_data.hp, 1, 100);
        _data.score = max(0, floor(_data.score));
        _data.lives = clamp(floor(_data.lives), 1, 99);

        var _clean_inventory = [];
        if (variable_struct_exists(_data, "inventory") && is_array(_data.inventory)) {
            for (var _item_i = 0; _item_i < array_length(_data.inventory); _item_i++) {
                var _item = _data.inventory[_item_i];
                if (is_struct(_item) && variable_struct_exists(_item, "id") && is_string(_item.id)
                && variable_struct_exists(_item, "name") && is_string(_item.name)
                && variable_struct_exists(_item, "category") && is_string(_item.category)
                && variable_struct_exists(_item, "quantity") && is_real(_item.quantity)) {
                    var _clean_item = {
                        id: string_copy(_item.id, 1, 32),
                        name: string_copy(_item.name, 1, 32),
                        category: string_copy(_item.category, 1, 16),
                        quantity: clamp(floor(_item.quantity), 0, 999),
                        heal: 0
                    };
                    if (variable_struct_exists(_item, "heal") && is_real(_item.heal)) _clean_item.heal = clamp(_item.heal, 0, 100);
                    array_push(_clean_inventory, _clean_item);
                }
            }
        }
        _data.inventory = _clean_inventory;
        var _clean_collected_gems = [];
        if (variable_struct_exists(_data, "collected_gems") && is_array(_data.collected_gems)) {
            for (var _gem_i = 0; _gem_i < min(array_length(_data.collected_gems), 10000); _gem_i++) {
                var _gem = _data.collected_gems[_gem_i];
                if (is_struct(_gem) && variable_struct_exists(_gem, "room") && is_string(_gem.room)
                && variable_struct_exists(_gem, "x") && is_real(_gem.x)
                && variable_struct_exists(_gem, "y") && is_real(_gem.y)) {
                    var _gem_room = asset_get_index(_gem.room);
                    if (_gem_room == rm_subway || _gem_room == rm_city) {
                        array_push(_clean_collected_gems, { room: _gem.room, x: _gem.x, y: _gem.y });
                    }
                }
            }
        }
        _data.collected_gems = _clean_collected_gems;
        _data.room_asset = _room;
        _data.slot = _slot;
        return _data;
    } catch (_err) {
        show_debug_message("Save slot " + string(_slot + 1) + " is invalid: " + string(_err.message));
        return undefined;
    }
}

/// @function scr_save_slots_read()
/// @description Returns ten entries, each either a validated save or undefined.
function scr_save_slots_read() {
    var _slots = array_create(10, undefined);
    for (var _i = 0; _i < 10; _i++) _slots[_i] = scr_save_slot_read(_i);

    // Import the previous single continue file once and keep it unless the new slot is safe.
    var _legacy_path = scr_save_directory() + "save.json";
    if (!is_struct(_slots[0]) && file_exists(_legacy_path)) {
        var _legacy_file = file_text_open_read(_legacy_path);
        if (_legacy_file != -1) {
            var _legacy_json = "";
            while (!file_text_eof(_legacy_file)) _legacy_json += file_text_readln(_legacy_file);
            file_text_close(_legacy_file);
            try {
                var _legacy = json_parse(_legacy_json);
                if (is_struct(_legacy) && variable_struct_exists(_legacy, "room") && is_string(_legacy.room)
                && variable_struct_exists(_legacy, "x") && is_real(_legacy.x)
                && variable_struct_exists(_legacy, "y") && is_real(_legacy.y)
                && variable_struct_exists(_legacy, "hp") && is_real(_legacy.hp)
                && variable_struct_exists(_legacy, "score") && is_real(_legacy.score)
                && variable_struct_exists(_legacy, "lives") && is_real(_legacy.lives)) {
                    var _legacy_room = asset_get_index(_legacy.room);
                    if (_legacy_room == rm_city || _legacy_room == rm_dungeons || _legacy_room == rm_subway) {
                        var _migrated = {
                            name: "CONTINUE",
                            room: _legacy.room,
                            x: _legacy.x,
                            y: _legacy.y,
                            mark_x: _legacy.x - 28,
                            mark_y: _legacy.y - 16,
                            hp: _legacy.hp,
                            score: _legacy.score,
                            lives: max(1, _legacy.lives),
                            inventory: [
                                { id: "ration", name: "Trail Ration", category: "FOOD", quantity: 3, heal: 35 },
                                { id: "sidearm", name: "Service Sidearm", category: "WEAPON", quantity: 1, heal: 0 },
                                { id: "plasma_buddy", name: "Plasma Buddy", category: "GADGET", quantity: 1, heal: 0 },
                                { id: "rounds", name: "Sidearm Rounds", category: "AMMUNITION", quantity: 12, heal: 0 }
                            ],
                            collected_gems: []
                        };
                        if (scr_save_slot_write(0, _migrated)) {
                            file_delete(_legacy_path);
                            _slots[0] = scr_save_slot_read(0);
                        }
                    }
                }
            } catch (_migration_err) {
                show_debug_message("Legacy continue save could not be migrated.");
            }
        }
    }
    return _slots;
}

/// @function scr_save_slot_write(_slot, _data)
/// @description Writes one named save record using a temporary file and a recoverable backup.
function scr_save_slot_write(_slot, _data) {
    var _path = scr_save_slot_path(_slot);
    if (_path == "" || !is_struct(_data)) return false;
    var _temp = _path + ".tmp";
    var _backup = _path + ".bak";
    if (file_exists(_temp)) file_delete(_temp);
    var _file = file_text_open_write(_temp);
    if (_file == -1) return false;
    _data.format_version = 2;
    _data.slot = _slot;
    file_text_write_string(_file, json_stringify(_data));
    file_text_close(_file);
    if (!file_exists(_temp)) return false;
    if (file_exists(_backup)) file_delete(_backup);
    if (file_exists(_path) && !file_rename(_path, _backup)) {
        file_delete(_temp);
        return false;
    }
    if (!file_rename(_temp, _path)) {
        if (file_exists(_backup)) file_rename(_backup, _path);
        return false;
    }
    if (file_exists(_backup)) file_delete(_backup);
    global.save_write_failed = false;
    return true;
}

/// @function scr_save_slot_write_if_changed(_slot, _data)
/// @description Avoids touching disk when the active save state has not changed.
function scr_save_slot_write_if_changed(_slot, _data) {
    _data.format_version = 2;
    _data.slot = _slot;
    var _json = json_stringify(_data);
    if (variable_global_exists("last_saved_slot") && global.last_saved_slot == _slot
    && variable_global_exists("last_saved_slot_json") && global.last_saved_slot_json == _json) return true;
    if (!scr_save_slot_write(_slot, _data)) return false;
    global.last_saved_slot = _slot;
    global.last_saved_slot_json = _json;
    return true;
}

/// @function scr_save_slot_clear(_slot)
/// @description Deletes one selected save slot and its recovery files.
function scr_save_slot_clear(_slot) {
    var _path = scr_save_slot_path(_slot);
    if (_path == "") return false;
    if (file_exists(_path)) file_delete(_path);
    if (file_exists(_path + ".tmp")) file_delete(_path + ".tmp");
    if (file_exists(_path + ".bak")) file_delete(_path + ".bak");
    var _deleted = !file_exists(_path) && !file_exists(_path + ".tmp") && !file_exists(_path + ".bak");
    if (_deleted && variable_global_exists("last_saved_slot") && global.last_saved_slot == _slot) {
        global.last_saved_slot = -1;
        if (variable_global_exists("last_saved_slot_json")) global.last_saved_slot_json = "";
    }
    return _deleted;
}

/// @function scr_save_slot_autosave()
/// @description Captures the current playable location and progress into the active slot.
function scr_save_slot_autosave() {
    if (!variable_global_exists("active_save_slot") || !is_real(global.active_save_slot)
    || global.active_save_slot < 0 || global.active_save_slot > 9) return false;

    if (room == rm_dungeons && instance_exists(objDungeon)) {
        var _dungeon = instance_find(objDungeon, 0);
        var _dungeon_data = {
            name: variable_global_exists("active_save_name") ? global.active_save_name : "PLAYER",
            room: room_get_name(room),
            x: 0,
            y: 0,
            mark_x: 0,
            mark_y: 0,
            hp: max(1, _dungeon.dungeon_battle_hp),
            score: variable_global_exists("game_score") ? global.game_score : 0,
            lives: max(1, variable_global_exists("game_lives") ? global.game_lives : 10),
            inventory: variable_global_exists("inventory_items") ? global.inventory_items : [],
            collected_gems: variable_global_exists("collected_gem_positions") ? global.collected_gem_positions : [],
            dungeon_id: _dungeon.currDung,
            dungeon_level: _dungeon.currLvl,
            dungeon_x: _dungeon.locX,
            dungeon_y: _dungeon.locY,
            dungeon_facing: _dungeon.state[mPREV],
            dungeon_mp: _dungeon.dungeon_battle_mp,
            dungeon_keys: variable_global_exists("dungeon_keys") ? global.dungeon_keys : 0,
            dungeon_currency: variable_global_exists("dungeon_currency") ? global.dungeon_currency : 0
        };
        var _dungeon_saved = scr_save_slot_write_if_changed(global.active_save_slot, _dungeon_data);
        if (!_dungeon_saved && (!variable_global_exists("save_write_failed") || !global.save_write_failed)) {
            show_debug_message("Autosave failed for slot " + string(global.active_save_slot + 1) + ".");
        }
        global.save_write_failed = !_dungeon_saved;
        return _dungeon_saved;
    }

    if (!instance_exists(obj_jack)) return false;
    var _jack = instance_find(obj_jack, 0);
    var _mark = instance_exists(obj_mark) ? instance_find(obj_mark, 0) : noone;
    var _controller = instance_exists(obj_controller) ? instance_find(obj_controller, 0) : noone;
    var _restore = (variable_global_exists("pending_game_restore") && is_struct(global.pending_game_restore)
        && global.pending_game_restore.room_asset == room) ? global.pending_game_restore : undefined;
    var _data = {
        name: variable_global_exists("active_save_name") ? global.active_save_name : "PLAYER",
        room: room_get_name(room),
        x: is_struct(_restore) ? _restore.x : _jack.x,
        y: is_struct(_restore) ? _restore.y : _jack.y,
        mark_x: is_struct(_restore) ? _restore.mark_x : ((_mark != noone) ? _mark.x : _jack.x - 28),
        mark_y: is_struct(_restore) ? _restore.mark_y : ((_mark != noone) ? _mark.y : _jack.y - 16),
        hp: is_struct(_restore) ? max(1, _restore.hp) : max(1, _jack.hp),
        score: (_controller != noone) ? _controller.game_score : (variable_global_exists("game_score") ? global.game_score : 0),
        lives: max(1, (_controller != noone) ? _controller.player_lives : (variable_global_exists("game_lives") ? global.game_lives : 10)),
        inventory: variable_global_exists("inventory_items") ? global.inventory_items : [],
        collected_gems: variable_global_exists("collected_gem_positions") ? global.collected_gem_positions : []
    };
    var _saved = scr_save_slot_write_if_changed(global.active_save_slot, _data);
    if (!_saved && (!variable_global_exists("save_write_failed") || !global.save_write_failed)) {
        show_debug_message("Autosave failed for slot " + string(global.active_save_slot + 1) + ".");
    }
    global.save_write_failed = !_saved;
    return _saved;
}
