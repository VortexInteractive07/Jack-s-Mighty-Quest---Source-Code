/// @description Initialize Level Trigger Variables

activated = false;
level_audio_id = -1;
target_level = rm_splash_screen;

// Post-Tally Fade-Out Variables
fade_timer = 0;
fade_delay = 160;     // Wait duration in frames after tally finishes before fading
fade_duration = 120;  // Fade duration in frames (2 seconds at 60 FPS)

// Victory Jingle Setup with Safety Fallback
if (asset_get_index("mus_levelcomplete") != -1) {
    victory_jingle = mus_levelcomplete;
} else {
    victory_jingle = -1;
}

// -----------------------------------------------------------------------------
// SONIC-INSPIRED SCORE TOLL VARIABLES
// -----------------------------------------------------------------------------
tallied_score = 0;
score_tally_active = false;
tally_finished = false;
tally_timer = 0;
tally_counter = 0;
tally_rate = 100; // Amount added to total score per tick during tallying

// Sonic Tally Audio Asset Handles
if (asset_get_index("sfx_dialogue") != -1) {
    snd_tally_tick_asset = sfx_dialogue; // Asset for score ticking sound
} else {
    snd_tally_tick_asset = -1;
}

if (asset_get_index("sfx_dialogue_continue") != -1) {
    snd_tally_done_asset = sfx_dialogue_continue; // Asset for final score completion tally sound
} else {
    snd_tally_done_asset = -1;
}

snd_tally_tick_handle = -1;