/// @description Initialize State, Display, & Subtitle System

display_set_gui_size(426, 240);

// Room Transition Target
target_room = (room_exists(rm_subway)) ? rm_subway : room;

// --- BACKGROUND MUSIC SYSTEM ---
bgm_inst = -1;

if (audio_is_playing(mus_no_bridge_to_cross_ai)) {
    audio_sound_gain(mus_no_bridge_to_cross_ai, 0, 500);
    audio_stop_sound(mus_no_bridge_to_cross_ai);
}

if (audio_exists(mus_cutscene)) {
    if (!audio_is_playing(mus_cutscene)) {
        bgm_inst = audio_play_sound(mus_cutscene, 1, true);
        audio_sound_gain(bgm_inst, 0, 0);
        audio_sound_gain(bgm_inst, 1, 1000);
        
        if (audio_is_playing(bgm_inst)) {
            audio_sound_loop_start(bgm_inst, 10.649);
        }
    } else {
        bgm_inst = mus_cutscene;
    }
}

// Load Story Array directly
cutscenes = scr_story();
scene_index = 0;
scene_total = array_length(cutscenes);

// Typewriter Timing
char_index = 0;
char_speed = 0.18;
current_text = "";
text_finished = false;

// Smooth Background Color Tracking (RGB)
bg_r = 15;  bg_g = 20;  bg_b = 35;
target_r = 15; target_g = 20; target_b = 35;

// State Machine
fade_alpha = 1;
fade_speed = 0.02;
fade_state = 0; // 0: Fade In | 1: Playing | 2: Transition Out

// --- DIRECT SFX RESOLVER ---
resolve_sfx = function(_sfx_val, _speaker_val) {
    if (audio_exists(_sfx_val)) return _sfx_val;

    if (is_string(_speaker_val) && _speaker_val != "") {
        var _spk = string_lower(_speaker_val);
        if (string_pos("victor", _spk) > 0 || string_pos("sharp", _spk) > 0) return sfx_sharp_speak;
        if (string_pos("charlotte", _spk) > 0)      return sfx_charlotte_speak;
        if (string_pos("moore", _spk) > 0 || string_pos("president", _spk) > 0) return sfx_williams_speak;
        if (string_pos("samantha", _spk) > 0)      return sfx_samantha_speak;
        if (string_pos("jessica", _spk) > 0)       return sfx_jessica_speak;
        if (string_pos("jason", _spk) > 0)         return sfx_jason_speak;
        if (string_pos("jack", _spk) > 0)          return sfx_jack_speak;
        if (string_pos("mark", _spk) > 0)          return sfx_mark_speak;
    }

    if (audio_exists(sfx_dialogue)) return sfx_dialogue;

    return -1;
};

// --- VICTOR SCHADENFREUDE VOICE-SYNC MODE ------------------------------------
// When enabled AND the voice-over asset below is imported, Victor's opening
// "victor_monologue" beats (built in scr_story) get their captions synced to
// the real recorded voice-over timing instead of the standard typewriter, the
// automated one-shot laugh SFX is suppressed (the real VO already contains the
// laugh), background music ducks for the duration of the monologue, and once
// it concludes the music is smoothly restored WITHOUT stopping/restarting it
// (only its gain is tweened, so playback position is never interrupted).
// If the asset is missing, this entire feature safely no-ops and the
// monologue plays exactly as it did before (typewriter + automated laugh).
enable_victor_voice_sync_mode = false;

voice_sync_active               = false; // true only while a synced monologue is actively driving captions
voice_sync_group_name           = "";    // voice_sync_group currently in progress, "" if none
voice_sync_completed_group      = "";    // last voice_sync_group that finished, so it never re-triggers
voice_sync_inst                 = -1;    // audio instance id of the currently playing VO
voice_sync_start_time           = 0;     // current_time (ms) snapshot when the VO started
voice_sync_duration             = 0;     // real length (ms) of the VO, from audio_sound_length()
voice_sync_timeline             = [];    // flattened {t, txt, slide_offset} caption timeline for the active group
voice_sync_group_start_index    = 0;     // scene_index of the first slide in the active group
voice_sync_group_end_index      = 0;     // scene_index of the last slide in the active group
voice_sync_music_ducked         = false; // whether bgm_inst gain has been ducked for the active monologue

// Shared text sanitizer (same normalization the typewriter path already applies),
// exposed as a function so the voice-sync caption driver can reuse it safely.
sanitize_cutscene_text = function(_s) {
    var _r = _s;
    _r = string_replace_all(_r, "—", " - ");
    _r = string_replace_all(_r, "–", " - ");
    _r = string_replace_all(_r, "“", "\"");
    _r = string_replace_all(_r, "”", "\"");
    _r = string_replace_all(_r, "’", "'");
    _r = string_replace_all(_r, "‘", "'");
    _r = string_replace_all(_r, "…", "...");
    return _r;
};

if (enable_victor_voice_sync_mode && !audio_exists(sfx_victor_monologue_vo)) {
    show_debug_message("WARNING: enable_victor_voice_sync_mode is ON but 'sfx_victor_monologue_vo' does not exist yet. Victor's monologue will fall back to the standard typewriter + automated laugh SFX until that voice-over asset (≈48.454s, timed to match the provided LRC) is imported and named sfx_victor_monologue_vo.");
}