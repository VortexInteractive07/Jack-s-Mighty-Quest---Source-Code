/// @description Player Collection Check

// --- Player Collision & Collection Logic ---
var _p_obj = asset_get_index("obj_player");

if (_p_obj != -1 && instance_exists(_p_obj)) {
    if (place_meeting(x, y, _p_obj)) {
        
        // Ensure global variables exist
        if (!variable_global_exists("gems_collected")) global.gems_collected = 0;
        if (!variable_global_exists("player_score"))   global.player_score = 0;
        
        // Increment stats
        global.gems_collected += 1;
        global.player_score   += 100;
        
        // --- Sound Playback (Fixed Pitch) ---
        var _sfx = collect_sfx;
        if (_sfx == -1 && audio_exists(sfx_coin)) _sfx = sfx_coin;
        
        if (_sfx != -1) {
            // Priority 5, loops = false, gain = 1.0, offset = 0, pitch = 1.0 (fixed)
            audio_play_sound(_sfx, 5, false, 1.0, 0, 1.0);
        }
        
        // Destroy instance
        instance_destroy();
    }
}