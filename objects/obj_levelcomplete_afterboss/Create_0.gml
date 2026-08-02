/// @description Initialize Animated Boss Victory Sequencer

state            = 0;
state_timer      = 0;
persistent       = false;

// Visual Animation Properties (No Screen Fades)
banner_scale     = 0;     // Pop-in bounce scale
text_alpha       = 0;     // Text fade-in
pulse_timer      = 0;     // Text flashing ticker
clear_time_sec   = 0;     // Computed completion time

// Safe Room Context Extraction
if (variable_global_exists("stage_time")) {
    // Inverse remaining time for clear time (assuming 12000 initial frames at 60 FPS)
    var _rem_frames = global.stage_time;
    clear_time_sec  = max(0, floor((12000 - _rem_frames) / 60));
}

// Stop current track and trigger victory fanfare
audio_stop_all();

var _mus_victory = asset_get_index("mus_boss_victory");
if (_mus_victory == -1) _mus_victory = asset_get_index("mus_stage_clear");

if (_mus_victory != -1 && audio_exists(_mus_victory)) {
    audio_play_sound(_mus_victory, 100, false);
}