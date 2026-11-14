/// @function scr_texture_pack_supported_sprites()
/// @description Returns the game sprites that data-only texture packs may replace.
function scr_texture_pack_supported_sprites() {
    return [
        "spr_dialogue",
        "spr_dialogue_continue_btn",
        "spr_gem",
        "spr_main_menu",
        "spr_menu_arrow_down",
        "spr_menu_arrow_up",
        "spr_titlescreen"
    ];
}

/// @function scr_texture_pack_list()
/// @description Lists valid installed Windows texture pack folders.
function scr_texture_pack_list() {
    if (variable_global_exists("texture_pack_list_cache")) {
        return global.texture_pack_list_cache;
    }

    var _packs = [{ id: "", name: "Default" }];
    if (os_type != os_windows) {
        global.texture_pack_list_cache = _packs;
        return _packs;
    }

    var _root = save_directory + "texture_packs\\";
    if (!directory_exists(_root)) {
        directory_create(_root);
        if (!directory_exists(_root)) {
            show_debug_message("Texture pack folder could not be created at '" + _root + "'.");
            global.texture_pack_list_cache = _packs;
            return _packs;
        }
    }

    var _folder = file_find_first(_root + "*.jmqpack", fa_directory);
    while (_folder != "") {
        if (string_pos("..", _folder) == 0
        && string_pos("/", _folder) == 0
        && string_pos("\\", _folder) == 0) {
            var _manifest_path = _root + _folder + "\\pack.json";
            if (file_exists(_manifest_path)) {
                var _file = file_text_open_read(_manifest_path);
                if (_file != -1) {
                    var _json = "";
                    while (!file_text_eof(_file)) {
                        _json += file_text_readln(_file);
                    }
                    file_text_close(_file);

                    try {
                        var _data = json_parse(_json);
                        if (is_struct(_data)
                        && variable_struct_exists(_data, "format_version")
                        && is_real(_data.format_version)
                        && _data.format_version == 1
                        && variable_struct_exists(_data, "name")
                        && is_string(_data.name)
                        && string_length(_data.name) > 0
                        && variable_struct_exists(_data, "textures")
                        && is_array(_data.textures)) {
                            array_push(_packs, { id: _folder, name: string_copy(_data.name, 1, 32) });
                        } else {
                            show_debug_message("Texture pack ignored: invalid manifest in '" + _folder + "'.");
                        }
                    } catch (_err) {
                        show_debug_message("Texture pack ignored: could not parse '" + _manifest_path + "'.");
                    }
                } else {
                    show_debug_message("Texture pack ignored: could not open '" + _manifest_path + "'.");
                }
            } else {
                show_debug_message("Texture pack ignored: missing manifest in '" + _folder + "'.");
            }
        }

        _folder = file_find_next();
    }
    file_find_close();

    global.texture_pack_list_cache = _packs;
    return _packs;
}

/// @function scr_texture_pack_sprite()
/// @description Gets a loaded texture override or returns the built-in sprite.
function scr_texture_pack_sprite(_name, _fallback) {
    if (variable_global_exists("texture_pack_sprites")
    && is_struct(global.texture_pack_sprites)
    && variable_struct_exists(global.texture_pack_sprites, _name)) {
        return variable_struct_get(global.texture_pack_sprites, _name);
    }

    return _fallback;
}

/// @function scr_texture_pack_load()
/// @description Loads matching-size, data-only texture overrides from an installed pack.
function scr_texture_pack_load(_pack_id) {
    if (!variable_global_exists("texture_pack_sprites")) global.texture_pack_sprites = {};
    if (!variable_global_exists("texture_pack_applied")) global.texture_pack_applied = "";
    if (global.texture_pack_applied == _pack_id) return;
    if (os_type != os_windows) {
        global.texture_pack_applied = _pack_id;
        return;
    }

    global.texture_pack_sprites = {};
    global.texture_pack_applied = _pack_id;
    if (_pack_id == "") return;
    if (string_pos("..", _pack_id) > 0
    || string_pos("/", _pack_id) > 0
    || string_pos("\\", _pack_id) > 0
    || string_length(_pack_id) < 8
    || string_copy(_pack_id, string_length(_pack_id) - 7, 8) != ".jmqpack") {
        show_debug_message("Texture pack ignored: invalid folder name.");
        return;
    }

    var _installed_packs = scr_texture_pack_list();
    var _is_installed = false;
    for (var i = 1; i < array_length(_installed_packs); i++) {
        if (_installed_packs[i].id == _pack_id) {
            _is_installed = true;
            break;
        }
    }
    if (!_is_installed) {
        show_debug_message("Texture pack ignored: '" + _pack_id + "' is not an installed pack.");
        return;
    }

    var _root = save_directory + "texture_packs\\" + _pack_id + "\\";
    var _manifest_path = _root + "pack.json";
    if (!file_exists(_manifest_path)) {
        show_debug_message("Texture pack ignored: missing '" + _manifest_path + "'.");
        return;
    }

    var _file = file_text_open_read(_manifest_path);
    if (_file == -1) {
        show_debug_message("Texture pack ignored: could not open '" + _manifest_path + "'.");
        return;
    }

    var _json = "";
    while (!file_text_eof(_file)) {
        _json += file_text_readln(_file);
    }
    file_text_close(_file);

    try {
        var _data = json_parse(_json);
        if (!is_struct(_data)
        || !variable_struct_exists(_data, "format_version")
        || !is_real(_data.format_version)
        || _data.format_version != 1
        || !variable_struct_exists(_data, "textures")
        || !is_array(_data.textures)) {
            show_debug_message("Texture pack ignored: invalid manifest in '" + _pack_id + "'.");
            return;
        }

        var _supported = scr_texture_pack_supported_sprites();
        if (array_length(_data.textures) > array_length(_supported)) {
            show_debug_message("Texture pack ignored: manifest contains too many texture entries.");
            return;
        }

        for (var i = 0; i < array_length(_data.textures); i++) {
            var _name = _data.textures[i];
            if (!is_string(_name) || array_get_index(_supported, _name) < 0) {
                show_debug_message("Texture pack entry ignored: unsupported sprite name.");
                continue;
            }
            if (variable_struct_exists(global.texture_pack_sprites, _name)) continue;

            var _sprite = asset_get_index(_name);
            if (_sprite < 0 || !sprite_exists(_sprite)) {
                show_debug_message("Texture pack entry ignored: sprite '" + _name + "' was not found.");
                continue;
            }

            var _image_path = _root + "textures\\" + _name + ".png";
            if (!file_exists(_image_path)) {
                show_debug_message("Texture pack entry ignored: missing '" + _image_path + "'.");
                continue;
            }

            var _frames = sprite_get_number(_sprite);
            var _replacement = -1;
            try {
                _replacement = sprite_add(
                    _image_path,
                    _frames,
                    false,
                    false,
                    sprite_get_xoffset(_sprite),
                    sprite_get_yoffset(_sprite)
                );
            } catch (_sprite_err) {
                show_debug_message("Texture pack entry ignored: could not load '" + _image_path + "'.");
            }

            if (_replacement >= 0) {
                if (sprite_get_number(_replacement) == _frames
                && sprite_get_width(_replacement) == sprite_get_width(_sprite)
                && sprite_get_height(_replacement) == sprite_get_height(_sprite)) {
                    sprite_set_speed(_replacement, sprite_get_speed(_sprite), sprite_get_speed_type(_sprite));
                    variable_struct_set(global.texture_pack_sprites, _name, _replacement);
                } else {
                    sprite_delete(_replacement);
                    show_debug_message("Texture pack entry ignored: '" + _name + "' must match the original frame count and dimensions.");
                }
            } else {
                show_debug_message("Texture pack entry ignored: could not create sprite from '" + _image_path + "'.");
            }
        }

        global.texture_pack_applied = _pack_id;
    } catch (_err) {
        global.texture_pack_sprites = {};
        show_debug_message("Texture pack ignored: could not parse '" + _manifest_path + "'.");
    }
}
