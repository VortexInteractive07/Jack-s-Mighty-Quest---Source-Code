/// @description Initialize Persistent Stats Controller

persistent = true;

// Explicitly declare viewport dimensions first
view_w = 426;
view_h = 240;
anim_timer = 0;

// ============================================================================
// STATISTICS STRUCT INITIALIZATION
// ============================================================================
if (!variable_global_exists("stats")) {
    global.stats = {
        total_deaths: 0,
        total_jumps: 0,
        time_played_sec: 0
    };
    
    show_debug_message("Vortex Statistics Struct: Initialized!");
}