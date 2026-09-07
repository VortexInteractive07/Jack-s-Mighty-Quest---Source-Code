/// @description Trigger Level Complete Sequence on Contact

if (!activated) {
    activated = true;

    // 1. Smoothly fade out stage BGM
    if (audio_is_playing(mus_subway)) {
        audio_sound_gain(mus_subway, 0, 500); // 0.5 sec fade out
    }

    // 2. Play victory jingle
    if (audio_exists(victory_jingle)) {
        if (!audio_is_playing(victory_jingle)) {
            level_audio_id = audio_play_sound(victory_jingle, 10, false);
            if (level_audio_id != -1) {
                audio_sound_gain(level_audio_id, global.vol_sfx / 100, 0);
            }
        }
    }

    // 3. Lock player movement if applicable
    if (instance_exists(obj_jack)) {
        obj_jack.hsp = 0;
        if (variable_instance_exists(obj_jack, "state")) {
            obj_jack.state = "idle";
        }
    }

    // 4. Capture current score from controller and initiate tally
    if (instance_exists(obj_controller)) {
        tallied_score = obj_controller.game_score;
    } else {
        tallied_score = 0;
    }

    score_tally_active = true;
    tally_finished = false;
    tally_counter = 0;
    tally_timer = 0;

    // Safety fallback transition timer (20 seconds max)
    alarm[0] = 1200;
}