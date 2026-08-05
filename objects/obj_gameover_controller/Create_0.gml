/// @description Initialize Sci-Fi Arcade Terminal & 60-Second Continue Engine

// Widescreen viewport scaling
view_w = 432;
view_h = 240;
display_set_gui_size(view_w, view_h);

// Safe level tracking fallback
if (variable_global_exists("last_room") && global.last_room != room && room_exists(global.last_room)) {
    target_restart_room = global.last_room;
} else {
    target_restart_room = rm_game;
}

// Menu Matrix
gameover_options = ["RE-INITIALIZE CORE", "RETRY SECTOR", "ABORT TO TERMINAL"];
gameover_selection = 0;
gameover_total = array_length(gameover_options);

// Arcade Countdown
continue_timer = 60;         
continue_frames = 60;       
continue_expired = false;

// Sci-Fi Aesthetic & Visual FX Matrix
glitch_timer = 0;
crt_alpha = 0.15;
cyber_grid_offset = 0;
terminal_alpha = 0; // Smooth fade-in effect on spawn

// Audio Setup
audio_stop_all();
if (audio_exists(mus_gameover)) {
    audio_play_sound(mus_gameover, 10, false);
}

// 3D Cyber Starfield Matrix
max_stars = 60;
stars = array_create(max_stars);
for (var i = 0; i < max_stars; i++) {
    stars[i] = {
        x: random_range(-250, 250),
        y: random_range(-250, 250),
        z: random_range(1, 6) 
    };
}

// Stats verification
if (!variable_global_exists("stats")) {
    global.stats = {
        total_deaths: 0,
        total_jumps: 0,
        time_played_sec: 0
    };
}