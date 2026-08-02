// --- Safety Execution Verification ---
audio_track_pos = 0;
narrator_audio = -1;

// Strictly verify that narrator mode is active before playing the raw master track asset
if (global.narrator_mode) {
    narrator_audio = audio_play_sound(va_intro_monaigaa, 10, false);
} else {
    // If spawned by error while disabled, destroy immediately to prevent voice leakage
    instance_destroy();
}

// Check if the stats struct doesn't exist yet before creating it
if (!variable_global_exists("stats")) {
    global.stats = {
        total_deaths: 0,
        total_jumps: 0,
        time_played_sec: 0
    };
}