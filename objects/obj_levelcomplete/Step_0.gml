/// @description Process Player Collision, Typewriter & Stage Transition Engine

if (!triggered) {
    // Detect player reaching the goal post / flag
    if (instance_exists(obj_player) && place_meeting(x, y, obj_player)) {
        triggered = true;
        
        // Fetch randomized victory dialogue string
        if (script_exists(scr_levelcomplete_randommessage)) {
            text_msg = scr_levelcomplete_randommessage();
        } else {
            text_msg = "STAGE CLEARED!";
        }
        
        draw_char_count = 0;
        
        // Notify game controller of stage clear
        if (instance_exists(obj_controller)) {
            obj_controller.stage_cleared = true;
        }
        
        // Freeze player movement
        with (obj_player) {
            hsp = 0;
            vsp = 0;
            if (variable_instance_exists(id, "state")) {
                state = 0; // Return to normal state
            }
        }
        
        // Stop active music & play level complete theme
        audio_stop_all();
        if (audio_exists(mus_levelcomplete)) {
            audio_play_sound(mus_levelcomplete, 1, false);
        }
        
        // ====================================================================
        // RANDOM ANNOUNCER PRAISE SFX ENGINE
        // ====================================================================
        var _praise_pool = [
            sfx_awesome,
            sfx_welldone,
            sfx_extraordinary,
            sfx_phenomenal,
			sfx_youarethebest,
			sfx_victory,
            sfx_splendid
        ];
        
        // Filter out any SFX assets that haven't been created yet to prevent crashes
        var _valid_sfx = [];
        for (var i = 0; i < array_length(_praise_pool); i++) {
            if (audio_exists(_praise_pool[i])) {
                array_push(_valid_sfx, _praise_pool[i]);
            }
        }
        
        // Play one random praise SFX from the valid list
        if (array_length(_valid_sfx) > 0) {
            var _chosen_sfx = _valid_sfx[irandom(array_length(_valid_sfx) - 1)];
            audio_play_sound(_chosen_sfx, 10, false);
        }
    }
} else if (!transitioning) {
    // Smoothly fade in overlay box
    if (alpha < 1) alpha += 0.05;
    
    // Typewriter effect & sound blip ticker
    var _text_len = string_length(text_msg);
    if (draw_char_count < _text_len) {
        draw_char_count += typewriter_speed;
        text_sound_delay++;
        
        if (text_sound_delay >= 4) {
            text_sound_delay = 0;
            if (audio_exists(sfx_menu_blip)) {
                audio_play_sound(sfx_menu_blip, 1, false);
            }
        }
    }
    
    hold_timer++;
    var _skip = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
    
    // Input Skip Handling
    if (_skip) {
        if (draw_char_count < _text_len) {
            draw_char_count = _text_len;
            hold_timer = 0; // Reset hold timer so full message stays visible
        } else {
            hold_timer = hold_max; // Skip directly to transition
        }
    }
    
    // Trigger Level Transition
    if (hold_timer >= hold_max) {
        transitioning = true;
        
        var _advanced = false;
        if (script_exists(scr_level_arrangement)) {
            _advanced = scr_level_arrangement(1);
        }
        
        // Fallback routing if level arrangement script returns false
        if (!_advanced) {
            if (room_exists(rm_credits)) {
                room_goto(rm_credits);
            } else {
                room_restart();
            }
        }
    }
}