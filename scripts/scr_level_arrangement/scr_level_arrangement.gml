/// @function scr_level_arrangement(_mode)
/// @param {real} _mode 0 for Title Card Data, 1 for Room Routing, 2 for Designated Stage Music Track
function scr_level_arrangement(_mode) {
    
    // --- MODE 0: TITLE CARD DATA STRUCTURE [Title, Subtitle, Disclaimer] ---
    if (_mode == 0) {
        switch (room) {
            case rm_game:   return ["CITY STREETS - ACT 1", "Hmm, short?", "Warning: Watch out for drop-offs!"];
            case rm_game_2: return ["CITY STREETS - ACT 2", "oh! enemies!", "Caution: Vultures overhead."];
            case rm_game_3: return ["CITY STREETS - ACT 3", "WARNING: A HUGE GROUP OF MOBS ARE APPROACHING!\nAsterix will help ypu", "Property of Vortex Interactive."];
            case rm_demoend:return ["THE END", "Thanks for playing!", "Demo Build v1.0"];
            default:        return ["LEVEL - ACT 1", "Unknown Sector", "Proceed with caution."];
        }
    }

    // --- MODE 1: ROOM ROUTING & CLEANUP ---
    if (_mode == 1) {
        if (instance_exists(obj_controller)) {
            obj_controller.stage_time = 50 * 60; 
            obj_controller.stage_cleared = false;
        }

        var _target_room = rm_demoend;

        switch (room) {
            case rm_game: 
                if (room_exists(rm_game_2)) _target_room = rm_game_2;
                break;
                
            case rm_game_2:
                if (room_exists(rm_game_3)) _target_room = rm_game_3;
                break;
                
            case rm_game_3:
                if (room_exists(rm_demoend)) _target_room = rm_demoend;
                break;
                
            default:
                if (room_exists(rm_demoend)) _target_room = rm_demoend;
                break;
        }

        if (room_exists(_target_room)) {
            room_goto(_target_room);
            return true;
        }
        
        return false; 
    }

    // --- MODE 2: DESIGNATED STAGE MUSIC LOOKUP ---
    if (_mode == 2) {
        switch (room) {
            case rm_game:   return asset_get_index("mus_asteriskobelisk");
            case rm_game_2: return asset_get_index("mus_city");
            case rm_game_3: return asset_get_index("mus_city");
            case rm_demoend: return -1; // None (Silence)
            default:        return asset_get_index("mus_asteriskobelisk");
        }
    }
}