// 1. Register Unhandled Exception Crash Handler
exception_unhandled_handler(function(_e) {
    var _file = file_text_open_write("crash_log.txt");
    if (_file != -1) {
        file_text_write_string(_file, "=== JACK'S MIGHTY QUEST CRASH LOG ===\n");
        file_text_write_string(_file, "TIMESTAMP: " + string(date_datetime_string(date_current_datetime())) + "\n");
        file_text_write_string(_file, "ROOM: " + room_get_name(room) + "\n");
        file_text_write_string(_file, "DETAILS:\n" + string(_e.longMessage) + "\n");
        file_text_write_string(_file, "=======================================\n");
        file_text_close(_file);
    }
    show_message_async("Jack's Mighty Quest Encountered an Error!\n\nCheck crash_log.txt for full details.");
    return 0;
});

// 2. Read Previous Crash Log Data
has_crash_log = false;
crash_log_text = "";

if (file_exists("crash_log.txt")) {
    var _file = file_text_open_read("crash_log.txt");
    if (_file != -1) {
        while (!file_text_eof(_file)) {
            crash_log_text += file_text_read_string(_file) + "\n";
            file_text_readln(_file);
        }
        file_text_close(_file);
        has_crash_log = true;
    }
}

// 3. Loading Progress & Visual Timers
load_timer = 0;
load_max = 180; // 3 seconds at 60 FPS
loading_text = "INITIALIZING SYSTEM...";
gloss_offset = 0;

// 4. Fade Sequence Controller (0: Fade In, 1: Active/Load, 2: Fade Out)
fade_state = 0;
fade_alpha = 1.0;
fade_speed = 0.03;

// 5. Toast Notification System
toast_timer = 0;
toast_max = 90; // 1.5 seconds at 60 FPS
toast_text = "Copied Text!";

// 6. Background Music:
audio_stop_all();
audio_play_sound(mus_menu, 1, true);