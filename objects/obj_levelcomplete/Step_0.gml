/// @description Score Toll Logic & Tally Execution

if (score_tally_active && !tally_finished) {
    // Check if the victory jingle is still playing
    var _jingle_playing = false;
    if (level_audio_id != -1 && audio_exists(level_audio_id)) {
        if (audio_is_playing(level_audio_id)) {
            _jingle_playing = true;
        }
    }

    // Only progress the tally timer once the victory music has finished playing
    if (!_jingle_playing) {
        tally_timer++;

        // Delay tally start slightly after victory music ends (30 frames / 0.5 sec delay)
        if (tally_timer >= 30) {
            if (tallied_score > 0) {
                var _deduct = min(tallied_score, tally_rate);
                tallied_score -= _deduct;
                tally_counter += _deduct;

                // Play ticking sound effect for tally increment using sfx_dialogue
                if (asset_get_index("sfx_dialogue") != -1) {
                    var _snd_tick = asset_get_index("sfx_dialogue");
                    if (audio_exists(_snd_tick)) {
                        if (!audio_is_playing(_snd_tick)) {
                            snd_tally_tick_handle = audio_play_sound(_snd_tick, 5, false);
                        }
                    }
                }
            } else {
                // Tally completed
                tally_finished = true;

                // Stop tick audio if playing
                if (snd_tally_tick_handle != -1 && audio_is_playing(snd_tally_tick_handle)) {
                    audio_stop_sound(snd_tally_tick_handle);
                }

                // Play final completion chime sound using sfx_dialogue_continue
                if (asset_get_index("sfx_dialogue_continue") != -1) {
                    var _snd_cash = asset_get_index("sfx_dialogue_continue");
                    if (audio_exists(_snd_cash)) {
                        audio_play_sound(_snd_cash, 6, false);
                    }
                }

                // Add tallied points back into controller score
                if (instance_exists(obj_controller)) {
                    obj_controller.game_score = tally_counter;
                }

                // Set room transition delay (280 frames total)
                alarm[0] = 280;
                fade_timer = 0;
                fade_delay = 160;     // Wait duration in frames before fading starts
                fade_duration = 120;  // Fade duration in frames (2 seconds at 60 FPS)
            }
        }
    }
}

// Increment fade progress timer after tally completion
if (tally_finished) {
    if (variable_instance_exists(id, "fade_timer")) {
        fade_timer++;
    }
}