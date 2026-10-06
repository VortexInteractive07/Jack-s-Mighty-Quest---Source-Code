/// @description Score Toll Logic & Tally Execution

// Smooth slide-in transition for GUI presentation
if (activated) {
    card_slide = lerp(card_slide, 1.0, 0.1);
}

if (score_tally_active && !tally_finished) {
    // Check if victory jingle is still playing
    var _jingle_playing = false;
    if (level_audio_id != -1 && audio_exists(level_audio_id)) {
        if (audio_is_playing(level_audio_id)) {
            _jingle_playing = true;
        }
    }

    // Delay score counting until the victory jingle ends
    if (!_jingle_playing) {
        tally_timer++;

        // 30-frame initial delay before countdown starts
        if (tally_timer >= 30) {
            if (tallied_score > 0) {
                var _deduct = min(tallied_score, tally_rate);
                tallied_score -= _deduct;
                tally_counter += _deduct;

                // Play ticking sound effect on loop/re-trigger
                if (audio_exists(snd_tally_tick_asset)) {
                    if (!audio_is_playing(snd_tally_tick_asset)) {
                        snd_tally_tick_handle = scr_play_sfx(snd_tally_tick_asset, 5, false);
                    }
                }
            } else {
                // Tally Sequence Completed
                tally_finished = true;

                // Stop ticking audio
                if (snd_tally_tick_handle != -1 && audio_is_playing(snd_tally_tick_handle)) {
                    audio_stop_sound(snd_tally_tick_handle);
                }

                // Play completion chime
                if (audio_exists(snd_tally_done_asset)) {
                    scr_play_sfx(snd_tally_done_asset, 6, false);
                }

                // Sync final score into controller
                if (instance_exists(obj_controller)) {
                    obj_controller.game_score = tally_counter;
                    global.game_score = tally_counter;
                }

                // Schedule room transition alarm (delay + fade time)
                alarm[0] = fade_delay + fade_duration;
                fade_timer = 0;
            }
        }
    }
}

// Increment fade progress timer post-tally
if (tally_finished) {
    fade_timer++;
}