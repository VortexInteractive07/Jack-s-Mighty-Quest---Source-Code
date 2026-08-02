/// @function scr_enemy_path_movement(path_index, speed, end_action, absolute)
/// @description Structural automation handler for AI asset path allocation
function scr_enemy_path_movement(_path, _spd, _action, _absolute) {
    
    // Safety check: verify that the entity isn't already execution-locked on a running path asset
    if (path_index == -1) {
        if (path_exists(_path)) {
            // Start following the predefined workspace path resource asset safely
            path_start(_path, _spd, _action, _absolute);
        }
    }
}