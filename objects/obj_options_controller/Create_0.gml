// --- Navigation Parameters ---
options_menu = ["SFX VOLUME", "MUSIC VOLUME", "DISPLAY", "TEXT SPEED", "BACK TO MENU"];
current_selection = 0;
total_options = array_length(options_menu);

// Tracking states for sliders
volume_steps = 10; // 0% to 100% split across 10 ticks

// Locally anchor the save method so we can push modifications safely to disk
scr_save_settings_json = function() {
    var _file_target = "settings.json";
    var _json_string = json_stringify(global.settings);
    var _file = file_text_open_write(_file_target);
    file_text_write_string(_file, _json_string);
    file_text_close(_file);
}

// Options Background Music
audio_stop_all();
audio_play_sound(mus_options, 1, true);

// Check if the stats struct doesn't exist yet before creating it
if (!variable_global_exists("stats")) {
    global.stats = {
        total_deaths: 0,
        total_jumps: 0,
        time_played_sec: 0
    };
}