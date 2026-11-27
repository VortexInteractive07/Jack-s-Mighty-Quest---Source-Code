/// @function scr_addon_pack_create(_kind)
/// @description Creates an editable starter pack in the writable save directory.
function scr_addon_pack_create(_kind) {
    if (os_type != os_windows) return "This pack creator currently requires Windows.";
    if (_kind != "texture" && _kind != "behavior" && _kind != "resource") return "Choose a valid pack type.";

    var _is_texture = (_kind == "texture");
    var _save_root = scr_save_directory();
    if (!_is_texture && !directory_exists(_save_root + "addons\\")) directory_create(_save_root + "addons\\");
    var _base = _save_root + (_is_texture ? "texture_packs\\" : ("addons\\" + _kind + "_packs\\"));
    if (!directory_exists(_base)) directory_create(_base);
    if (!directory_exists(_base)) return "Could not create the Add-Ons folder.";

    var _folder = "jmq_" + string(irandom_range(100000, 999999)) + ".jmqpack";
    var _path = _base + _folder + "\\";
    var _attempts = 0;
    while (directory_exists(_path) && _attempts < 20) {
        _folder = "jmq_" + string(irandom_range(100000, 999999)) + ".jmqpack";
        _path = _base + _folder + "\\";
        _attempts++;
    }
    if (directory_exists(_path)) return "Could not create a unique pack folder.";
    directory_create(_path);
    if (!directory_exists(_path)) return "Could not create a unique pack folder.";

    var _title = (_kind == "texture") ? "New Texture Pack" : ((_kind == "behavior") ? "New Behavior Pack" : "New Resource Pack");
    var _manifest = "";
    if (_kind == "texture") {
        directory_create(_path + "textures\\");
        _manifest = "{\"format_version\":1,\"name\":\"" + _title + "\",\"textures\":[]}";
    } else {
        directory_create(_path + "data\\");
        directory_create(_path + "assets\\");
        directory_create(_path + "source\\");
        _manifest = "{\"format_version\":1,\"type\":\"" + _kind + "\",\"name\":\"" + _title + "\",\"description\":\"Edit this package manually.\",\"version\":\"1.0.0\"}";
    }

    var _manifest_file = file_text_open_write(_path + (_kind == "texture" ? "pack.json" : "addon.json"));
    if (_manifest_file == -1) return "Pack folder created, but its manifest could not be written.";
    file_text_write_string(_manifest_file, _manifest);
    file_text_close(_manifest_file);

    var _readme_file = file_text_open_write(_path + "README.txt");
    if (_readme_file != -1) {
        file_text_write_string(_readme_file,
            "Jack's Mighty Quest Add-On starter pack\r\n" +
            "Type: " + _kind + "\r\n" +
            "Edit this folder and its manifest with your own files.\r\n" +
            "The released game loads texture packs only for the approved sprite list. Behavior and resource folders are starter formats; arbitrary GML cannot be executed by a built game. To add runtime code, import it into the GameMaker project and rebuild.\r\n");
        file_text_close(_readme_file);
    }
    return "Created " + _kind + " pack folder: " + _folder;
}

/// @function scr_addon_manifest_root(_package_path, _manifest_name)
/// @description Finds a root manifest or one manifest inside a single enclosing folder.
function scr_addon_manifest_root(_package_path, _manifest_name) {
    if (file_exists(_package_path + _manifest_name)) return _package_path;
    var _found_root = "";
    var _matches = 0;
    var _entry = file_find_first(_package_path + "*", fa_directory);
    while (_entry != "") {
        if (_entry != "." && _entry != ".."
        && string_pos("/", _entry) == 0 && string_pos("\\", _entry) == 0
        && file_exists(_package_path + _entry + "\\" + _manifest_name)) {
            _found_root = _package_path + _entry + "\\";
            _matches++;
        }
        _entry = file_find_next();
    }
    file_find_close();
    return (_matches == 1) ? _found_root : "";
}

/// @function scr_addon_pack_import(_kind)
/// @description Extracts a selected ZIP/JMQPack archive into the writable imports folder.
function scr_addon_pack_import(_kind) {
    if (os_type != os_windows) return "Archive import currently requires Windows.";
    if (_kind != "texture" && _kind != "behavior" && _kind != "resource") return "Choose a valid pack type.";
    var _archive = get_open_filename("JMQ Add-On Packages|*.zip;*.jmqpack", "");
    if (_archive == "") return "Import cancelled.";

    var _save_root = scr_save_directory();
    var _addon_root = _save_root + "addons\\";
    if (_kind != "texture" && !directory_exists(_addon_root)) directory_create(_addon_root);
    var _root = _save_root + ((_kind == "texture") ? "texture_packs\\" : ("addons\\" + _kind + "_packs\\"));
    if (!directory_exists(_root)) directory_create(_root);
    if (!directory_exists(_root)) return "Could not create the imports folder.";

    var _folder = "import_" + string(irandom_range(100000, 999999)) + ".jmqpack";
    var _target = _root + _folder + "\\";
    var _attempts = 0;
    while (directory_exists(_target) && _attempts < 20) {
        _folder = "import_" + string(irandom_range(100000, 999999)) + ".jmqpack";
        _target = _root + _folder + "\\";
        _attempts++;
    }
    if (directory_exists(_target)) return "Could not create a unique import folder.";

    // Stage the user-selected file in the game's writable storage first so
    // zip_unzip receives a path inside GameMaker's local storage area.
    var _staged_archive = _save_root + "addon_import_" + string(irandom_range(100000, 999999)) + ".zip";
    var _stage_attempts = 0;
    while (file_exists(_staged_archive) && _stage_attempts < 20) {
        _staged_archive = _save_root + "addon_import_" + string(irandom_range(100000, 999999)) + ".zip";
        _stage_attempts++;
    }
    if (file_exists(_staged_archive)) return "Could not prepare a temporary archive file.";
    file_copy(_archive, _staged_archive);
    if (!file_exists(_staged_archive)) return "Could not read the selected archive.";

    var _count = -1;
    try { _count = zip_unzip(_staged_archive, _target); }
    catch (_err) { _count = -1; }
    if (file_exists(_staged_archive)) file_delete(_staged_archive);
    if (_count <= 0) return "Could not extract this archive. Use a valid ZIP/JMQPack archive.";
    if (_kind == "texture") {
        var _texture_content_root = scr_addon_manifest_root(_target, "pack.json");
        if (_texture_content_root == "") return "Archive needs pack.json at its root or one folder below it.";
        var _texture_manifest_path = _texture_content_root + "pack.json";
        var _texture_manifest_file = file_text_open_read(_texture_manifest_path);
        if (_texture_manifest_file == -1) return "Could not read pack.json.";
        var _texture_json = "";
        while (!file_text_eof(_texture_manifest_file)) _texture_json += file_text_readln(_texture_manifest_file);
        file_text_close(_texture_manifest_file);
        try {
            var _texture_manifest = json_parse(_texture_json);
            if (!is_struct(_texture_manifest)
            || !variable_struct_exists(_texture_manifest, "format_version")
            || _texture_manifest.format_version != 1
            || !variable_struct_exists(_texture_manifest, "name")
            || !is_string(_texture_manifest.name)
            || string_length(_texture_manifest.name) <= 0
            || !variable_struct_exists(_texture_manifest, "textures")
            || !is_array(_texture_manifest.textures)) {
                return "pack.json needs format_version 1, a name, and a textures array.";
            }
            var _supported_sprites = scr_texture_pack_supported_sprites();
            for (var _texture_i = 0; _texture_i < array_length(_texture_manifest.textures); _texture_i++) {
                var _texture_name = _texture_manifest.textures[_texture_i];
                if (!is_string(_texture_name) || array_get_index(_supported_sprites, _texture_name) < 0) {
                    return "pack.json contains an unsupported sprite name.";
                }
            }
        } catch (_texture_err) {
            return "Could not parse pack.json. Check its JSON syntax.";
        }
    }
    if (_kind != "texture") {
        var _addon_content_root = scr_addon_manifest_root(_target, "addon.json");
        if (_addon_content_root == "") return "Archive needs addon.json at its root or one folder below it.";
        var _manifest_file = file_text_open_read(_addon_content_root + "addon.json");
        if (_manifest_file == -1) return "Could not read the add-on manifest.";
        var _manifest_json = "";
        while (!file_text_eof(_manifest_file)) _manifest_json += file_text_readln(_manifest_file);
        file_text_close(_manifest_file);
        try {
            var _manifest_data = json_parse(_manifest_json);
            if (!is_struct(_manifest_data)
            || !variable_struct_exists(_manifest_data, "format_version")
            || _manifest_data.format_version != 1
            || !variable_struct_exists(_manifest_data, "type")
            || _manifest_data.type != _kind
            || !variable_struct_exists(_manifest_data, "name")
            || !is_string(_manifest_data.name)
            || string_length(_manifest_data.name) <= 0) {
                return "Manifest must declare format_version 1, matching type, and a name.";
            }
        } catch (_manifest_err) {
            return "Could not parse addon.json. Check its JSON syntax.";
        }
    }
    if (_kind == "texture" && variable_global_exists("texture_pack_list_cache")) {
        variable_global_remove("texture_pack_list_cache");
    }
    return "Imported " + _folder + " (" + string(_count) + " files).";
}

/// @function scr_addon_pack_list()
/// @description Lists installed behavior and resource packages for the manager.
function scr_addon_pack_list() {
    var _items = [];
    if (os_type != os_windows) return _items;
    var _types = ["behavior", "resource"];
    for (var _type_i = 0; _type_i < array_length(_types); _type_i++) {
        var _type = _types[_type_i];
        var _root = scr_save_directory() + "addons\\" + _type + "_packs\\";
        if (!directory_exists(_root)) continue;
        var _pack_folders = [];
        var _folder = file_find_first(_root + "*.jmqpack", fa_directory);
        while (_folder != "") {
            array_push(_pack_folders, _folder);
            _folder = file_find_next();
        }
        file_find_close();
        for (var _pack_folder_i = 0; _pack_folder_i < array_length(_pack_folders); _pack_folder_i++) {
            _folder = _pack_folders[_pack_folder_i];
            if (string_pos("..", _folder) == 0 && string_pos("\\", _folder) == 0 && string_pos("/", _folder) == 0) {
                var _package_root = _root + _folder + "\\";
                var _manifest_root = scr_addon_manifest_root(_package_root, "addon.json");
                var _manifest = _manifest_root + "addon.json";
                if (_manifest_root != "" && file_exists(_manifest)) {
                    var _handle = file_text_open_read(_manifest);
                    if (_handle != -1) {
                        var _json = "";
                        while (!file_text_eof(_handle)) _json += file_text_readln(_handle);
                        file_text_close(_handle);
                        try {
                            var _data = json_parse(_json);
                            if (is_struct(_data)
                            && variable_struct_exists(_data, "format_version")
                            && _data.format_version == 1
                            && variable_struct_exists(_data, "type")
                            && _data.type == _type
                            && variable_struct_exists(_data, "name")
                            && is_string(_data.name)
                            && string_length(_data.name) > 0) {
                                array_push(_items, { name: _data.name, kind: _type, id: _folder });
                            }
                        } catch (_err) { show_debug_message("Add-On ignored: invalid manifest in " + _folder); }
                    }
                }
            }
        }
    }
    return _items;
}
