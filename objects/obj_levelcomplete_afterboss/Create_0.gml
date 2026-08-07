/// @description Initialize Animated Boss Victory Sequencer

state           = 0;
state_timer     = 0;
persistent      = false;

// Visual Animation Properties
banner_scale    = 0;
banner_target   = 1.0;
text_alpha      = 0;
pulse_timer     = 0;
clear_time_sec  = 0;

// Safe Room Context Extraction
if (variable_global_exists("stage_time")) {
    var _rem_frames = global.stage_time;
    clear_time_sec  = max(0, floor((12000 - _rem_frames) / 60));
}

// Stop current tracks and play boss victory music directly
audio_stop_all();

if (audio_exists(mus_boss_victory)) {
    audio_play_sound(mus_boss_victory, 100, false);
}