// --- Statistics System Initialization ---
if (!variable_global_exists("stats")) {
    global.stats = {
        total_deaths: 0,
        total_jumps: 0,
        time_played_sec: 0
    };
    
    // Debug message prints only when the struct is actually created for the first time
    show_debug_message("Vortex Statistics Struct: Initialization in Development!");
}