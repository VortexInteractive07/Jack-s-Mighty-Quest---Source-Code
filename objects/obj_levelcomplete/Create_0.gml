/// @description Initialize Level Trigger Variables
scr_load_settings();

activated = false;
level_audio_id = -1;
target_level = (room == rm_boss) ? rm_credits : rm_boss;

// Post-Tally Fade-Out Variables
fade_timer = 0;
fade_delay = 120;     // Wait 2 seconds (120 frames at 60 FPS) after tally finishes before fading
fade_duration = 60;   // Fade duration (1 second at 60 FPS)

// Direct Sound & Music References
victory_jingle = mus_levelcomplete;
snd_tally_tick_asset = sfx_dialogue;
snd_tally_done_asset = sfx_dialogue_continue;
snd_tally_tick_handle = -1;

// -----------------------------------------------------------------------------
// SONIC-INSPIRED SCORE TOLL VARIABLES
// -----------------------------------------------------------------------------
tallied_score = 0;
score_tally_active = false;
tally_finished = false;
tally_timer = 0;
tally_counter = 0;
tally_rate = 100; // Amount deducted per tick during tallying

// Slide-in Animation & Visual Polish
card_slide = 0.0;     // Easing scalar for GUI entrance
banner_skew = 12;     // Slanted pixel style skew
