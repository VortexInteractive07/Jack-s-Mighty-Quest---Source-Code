/// @description Trigger Level Complete Sequence on Contact

// Only trigger once so it doesn't re-arm every frame Jack touches the trigger
if (!activated) {
    activated = true;

    // 1. Fade down existing stage music smoothly
    if (asset_get_index("mus_subway") != -1) {
        var _bgm = asset_get_index("mus_subway");
        if (audio_is_playing(_bgm)) {
            audio_sound_gain(_bgm, 0, 500); // 0.5 sec smooth fade out
        }
    }

    // 2. Play victory jingle without killing persistent music channels
    if (victory_jingle != -1 && audio_exists(victory_jingle)) {
        if (!audio_is_playing(victory_jingle)) {
            level_audio_id = audio_play_sound(victory_jingle, 10, false);
            if (level_audio_id != -1) {
                audio_sound_gain(level_audio_id, 1.0, 0);
            }
        }
    }

    // 3. Capture current score from obj_controller and start Sonic Score Toll
    if (instance_exists(obj_controller)) {
        tallied_score = obj_controller.game_score;
    } else {
        tallied_score = 0;
    }

    score_tally_active = true;
    tally_finished = false;
    tally_counter = 0;
    tally_timer = 0;

    // Set fallback alarm delay if room transition isn't executed by score completion
    alarm[0] = 360; // 6 seconds max backup safety timer
}