/// @description Initialize State, Display, Subtitle System, Choices, Backlog, & FX
/// Intelligence Level: 10/10

scr_load_settings();

display_set_gui_size(432, 240);

// Room Transition Target
target = rm_subway;
target_room = (room_exists(target)) ? target : room;

// --- BACKGROUND MUSIC SYSTEM ---
bgm_inst = -1;

if (audio_is_playing(mus_no_bridge_to_cross)) {
    audio_sound_gain(mus_no_bridge_to_cross, 0, 500);
    audio_stop_sound(mus_no_bridge_to_cross);
}

if (audio_exists(mus_cutscene)) {
    if (!audio_is_playing(mus_cutscene)) {
        bgm_inst = audio_play_sound(mus_cutscene, 1, true);
        audio_sound_gain(bgm_inst, 0, 0);
        audio_sound_gain(bgm_inst, global.vol_bgm / 100, 1000);
        
        if (audio_is_playing(bgm_inst)) {
            audio_sound_loop_start(bgm_inst, 10.649);
        }
    } else {
        bgm_inst = mus_cutscene;
    }
}

// --- BULLETPROOF CUTSCENE ARRAY INITIALIZATION ---
cutscenes = [];
if (script_exists(scr_story)) {
    var _loaded_story = scr_story();
    if (is_array(_loaded_story) && array_length(_loaded_story) > 0) {
        cutscenes = _loaded_story;
    } else if (is_struct(_loaded_story)) {
        var _names = struct_get_names(_loaded_story);
        for (var _i = 0; _i < array_length(_names); _i++) {
            var _part = _loaded_story[$ _names[_i]];
            if (is_array(_part)) {
                cutscenes = array_concat(cutscenes, _part);
            }
        }
    }
}

if (!is_array(cutscenes) || array_length(cutscenes) == 0) {
    cutscenes = [
        {
            speaker: "System",
            text: "WARNING: Cutscene script data failed to load or is empty.",
            sprite: -1,
            sfx: -1
        }
    ];
}

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

// --- SPRITE TRANSITION STATE MANAGER ---
vis_sprite = -1;
prev_sprite = -1;
sprite_fade_alpha = 1.0;
sprite_fade_speed = 0.08;

// --- DIALOGUE HISTORY & BACKLOG SYSTEM ---
dialogue_history = [];
backlog_open = false;
backlog_scroll_index = 0;
max_backlog_entries = 50;

// --- INTERACTIVE BRANCHING CHOICE SYSTEM ---
choice_active = false;
choices_array = [];
choice_selected_index = 0;

// --- SCREEN SHAKE & PARTICLE ATMOSPHERE ---
shake_intensity = 0;
shake_duration = 0;
shake_timer = 0;
shake_x = 0;
shake_y = 0;

particle_list = [];
for (var _p = 0; _p < 25; _p++) {
    array_push(particle_list, {
        x: random(160),
        y: random(144),
        spd: random_range(0.2, 0.8),
        alpha: random_range(0.1, 0.5),
        size: choose(1, 2)
    });
}

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

// --- VOICE-SYNC MODE ---
enable_victor_voice_sync_mode = false;
voice_sync_active             = false;
voice_sync_group_name         = "";
voice_sync_completed_group    = "";
voice_sync_inst               = -1;
voice_sync_start_time         = 0;
voice_sync_duration           = 0;
voice_sync_timeline           = [];
voice_sync_group_start_index    = 0;
voice_sync_group_end_index      = 0;
voice_sync_music_ducked         = false;

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