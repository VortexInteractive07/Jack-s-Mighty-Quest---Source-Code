/// @description Initialize Modernized Widescreen Jukebox Engine Core

// 1. EXECUTE GLOBAL DEFINITIONS
scr_jukebox_list();

// 2. RESOLUTION & UI DISPLAY PARAMETERS
gui_w = 426;
gui_h = 240;

display_set_gui_size(gui_w, gui_h);

// Smooth Animation & UI Interpolation Trackers
ui_timer            = 0;
cursor_target_y     = 0;
cursor_draw_y       = 0;
tab_target_x        = 0;
tab_draw_x          = 0;
equalizer_heights   = [0, 0, 0, 0, 0, 0, 0, 0];

// 3. JUKEBOX STRUCTURAL CONFIGURATION
current_tab      = 0; // 0 = OST, 1 = Songs, 2 = SFX, 3 = Unused
ost_cursor       = 0;
songs_cursor     = 0;
sfx_cursor       = 0;
unused_cursor    = 0;

playing_track    = noone;
playing_asset    = noone;
now_playing_name = "None - Silence";

// Dynamic Lyric Synchronization Trackers
current_lyric_text = "";
lyric_array_len    = 0;

// 4. SCROLL MANAGER CONFIGURATION METRICS
max_visible_items = 7; 
ost_view_start    = 0;     
songs_view_start  = 0;   
sfx_view_start    = 0;     
unused_view_start = 0;  

// --- Assign Track Lists directly from Global Arrays ---
ost_list    = global.ost_list;
songs_list  = global.songs_list;
sfx_list    = global.sfx_list;
unused_list = global.unused_list;

audio_stop_all();

// Stats verification safety
if (!variable_global_exists("stats")) {
    global.stats = { total_deaths: 0, total_jumps: 0, time_played_sec: 0 };
}