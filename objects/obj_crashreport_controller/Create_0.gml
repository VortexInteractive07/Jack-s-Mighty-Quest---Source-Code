/// @description Initialize Fatal Error Diagnostic Presentation
audio_stop_all();

// Enforce standard retro resolution presentation scaling
var _widescreen_w = 432;
var _widescreen_h = 240;
surface_resize(application_surface, _widescreen_w, _widescreen_h);
display_set_gui_size(_widescreen_w, _widescreen_h);

// Verify variables initialization to bypass potential cascading exceptions
if (!variable_global_exists("crash_data") || !is_struct(global.crash_data)) {
    global.crash_data = {
        message: "Forced execution block intercept / Hardware memory bounds overflow.",
        script: "Unknown Object Class Engine Loop",
        line: "0",
        stacktrace: ["Stack context unallocated / System hardware thread reset required."]
    };
}

// Convert stack arrays into structured layout text lines
stack_display_text = "";
if (is_array(global.crash_data.stacktrace)) {
    var _len = min(array_length(global.crash_data.stacktrace), 3); 
    for (var i = 0; i < _len; i++) {
        stack_display_text += string(global.crash_data.stacktrace[i]) + "\n";
    }
} else {
    stack_display_text = string(global.crash_data.stacktrace);
}