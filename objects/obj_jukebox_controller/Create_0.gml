/// @description Initialize Scrollable Jukebox Engine Core

// 1. EXECUTE GLOBAL DEFINITIONS
scr_jukebox_list();

// 2. JUKEBOX STRUCTURAL CONFIGURATION
current_tab = 0;       // 0 = OST Sounds, 1 = Songs, 2 = Sound FX, 3 = Unused Data
ost_cursor = 0;
songs_cursor = 0;
sfx_cursor = 0;
unused_cursor = 0;
playing_track = noone;
now_playing_name = "None - Silence";

// Dynamic Lyric Synchronization Trackers
current_lyric_text = "";
lyric_array_len = 0;

// 3. SCROLL MANAGER CONFIGURATION METRICS
max_visible_items = 8;  
ost_view_start = 0;     
songs_view_start = 0;   
sfx_view_start = 0;     
unused_view_start = 0;  

// --- Standard Background BGM OST Matrix Array ---
ost_list = [
    { 
        asset: mus_title_theme,      
        loop_start: 1.198, 
        loops: true,  
        title: "Title Screen Theme",
        fullname: "Title Screen Theme (Composed by " + string(global.composer_title) + ")" 
    },
    { 
        asset: mus_credits,          
        loop_start: 0,     
        loops: false, 
        title: "Credits Roll Ending",
        fullname: "Credits Roll Ending (Composed by " + string(global.composer_credits) + ")" 
    },
    { 
        asset: mus_city,              
        loop_start: 25.557, 
        loops: true,  
        title: "Streets of Celestia",
        fullname: "Streets of Celestia (Composed by " + string(global.composer_city) + ")" 
    },
    { 
        asset: mus_ending_theme,     
        loop_start: 0,     
        loops: true,  
        title: "Ending Theme",
        fullname: "Ending Theme (Composed by " + string(global.composer_ending) + ")" 
    },
    { 
        asset: mus_boss_prototype,  
        loop_start: 0,     
        loops: true,  
        title: "Boss Theme",
        fullname: "Boss - Jack's Mighty Quest (Composed by " + string(global.composer_boss) + ")" 
    },
    { 
        asset: mus_menu,  
        loop_start: 1,     
        loops: true,  
        title: "Main Menu",
        fullname: "Main Menu - Jack's Mighty Quest (Composed by " + string(global.composer_menu) + ")" 
    },
    { 
        asset: mus_requiem,  
        loop_start: 1,     
        loops: true,  
        title: "Victor Schadenfreude's Requiem",
        fullname: "Vic Sharp's Requiem - Jack's Mighty Quest (Composed by " + string(global.composer_requiem) + ")" 
    },
    { 
        asset: mus_dungeons,  
        loop_start: 1,     
        loops: true,  
        title: "Dungeons",
        fullname: "Dungeons - Jack's Mighty Quest (Composed by " + string(global.composer_dungeons) + ")" 
    },
    { 
        asset: mus_intermission,  
        loop_start: 1,     
        loops: true,  
        title: "Intermission",
        fullname: "Intermission - Jack's Mighty Quest (Composed by " + string(global.composer_wait) + ")" 
    },
    { 
        asset: mus_evil_clockwork_original,  
        loop_start: 0,     
        loops: true,  
        title: "Evil Clockwork",
        fullname: "Evil Clockwork (Composed by Kawashin)" 
    },
    { 
        asset: mus_evil_clockwork_extended_prototype,  
        loop_start: 0,     
        loops: true,  
        title: "Evil Clockwork - Ext.",
        fullname: "Evil Clockwork - Extended (Composed by Kawashin, Ext. by PixelForge07)" 
    }
];

// --- Dedicated Vocals & Lore Tracks Matrix Array ---
songs_list = [
    { 
        asset: mus_no_bridge_to_cross,  
        loop_start: 0,     
        loops: true,  
        title: "No Bridge to Cross",
        fullname: "No Bridge to Cross (Composed by PixelForge07 - Lyrics Embedded)",
        has_lyrics: true,
        lyrics: [
            { time: 0.00,  text: "" },
            { time: 18.01, text: "Watch the sky turn into iron gray" },
            { time: 25.79, text: "Shadows stretch to catch the light of day" },
            { time: 32.47, text: "I don't need a reason, I don't need a rhyme" },
            { time: 39.55, text: "I just need to watch you, run out of time" }, 
            { time: 46.17, text: "Path of destruction is all I care" },
            { time: 53.93, text: "The screams of horror is all that's fair" },
            { time: 60.89, text: "Do what you want, but you cannot escape" },
            { time: 64.32, text: "The death is near, and so as your fate" },
            { time: 68.74, text: "..so as your fate! (your fate, your fate)" },
            { time: 73.62, text: "The gears are turning in the dark below" },
            { time: 80.97, text: "I'm the only harvest that the ruins grow" },
            { time: 90.01, text: "No exit sign, no bridge for you to cross" },
            { time: 95.92, text: "Calculatin' every second of your loss" },
            { time: 103.29, text: "" }, 
            { time: 118.29, text: "Path of destruction is all I care" },
            { time: 126.10, text: "The screams of horror is all that's fair" },
            { time: 132.99, text: "Do what you want, but you cannot escape" },
            { time: 136.39, text: "The death is near, and so as your fate" },
            { time: 140.89, text: "Yeah, the death is near, and so as your fate!" },
            { time: 146.80, text: "Victor Schadenfreude" },
            { time: 157.00, text: "Doomsday is here!" },
            { time: 160.97, text: "" }
        ]
    },
    { 
        asset: mus_raalhehge_monaigaa,  
        loop_start: 0,     
        loops: true,  
        title: "Raalhehge Monaigaa",
        fullname: "Raalhahge Monaigaa - [Aetherian Lore Track] (Composed by PixelForge07)",
        has_lyrics: false
    },
    { 
        asset: mus_alhavaa,  
        loop_start: 0,     
        loops: true,  
        title: "Alhavaa Monaigaa",
        fullname: "Alhavaa Monaigaa - [Aetherian Lore Track] (Composed by PixelForge07)",
        has_lyrics: false
    },
    { 
        asset: mus_gais,  
        loop_start: 0,     
        loops: true,  
        title: "Rey Kanda Gais",
        fullname: "Rey Kanda Gais - [Aetherian Lore Track] (Composed by PixelForge07)",
        has_lyrics: false
    },
    { 
        asset: mus_reythi_aadha,  
        loop_start: 0,     
        loops: true,  
        title: "Rethi Aadha Ey",
        fullname: "Rethi Aadha Ey - [Aetherian Lore Track] (Composed by PixelForge07)",
        has_lyrics: false
    },
    { 
        asset: mus_reythi_reyge_balaalumey,  
        loop_start: 0,     
        loops: true,  
        title: "Reythi Reyge Balaalumey",
        fullname: "Reythi Reyge Balaalumey - [Aetherian Lore Track] (Composed by PixelForge07)",
        has_lyrics: false
    }
];

// --- Standard Playable SFX Matrix Array ---
sfx_list = [
    { asset: sfx_shoot,             title: "Laser Shot Pack",   fullname: "Laser Shot Pack 2020" },
    { asset: sfx_explosion,         title: "Explosion Effect",  fullname: "Red box goes boom!" },
    { asset: sfx_textbox,           title: "Dialogue Beep",     fullname: "Textbox Dialogue Blip" },
    { asset: sfx_textbox_continue,  title: "Dialogue Continue", fullname: "Textbox Continue Arrow" }
];

// --- Custom Unused/Cut Soundtracks Matrix Array ---
unused_list = [
    { 
        asset: mus_asteriskobelisk, 
        loop_start: 0, 
        loops: true,  
        title: "Asterisk Obelisk", 
        fullname: "Asterisk Obelisk (Unused/Archived Content)" 
    },
    { 
        asset: mus_death,           
        loop_start: 0, 
        loops: false, 
        title: "Game Over - FN76",  
        fullname: "Game Over Theme (Composed by FN76)" 
    },
    { 
        asset: mus_ending_theme,    
        loop_start: 0, 
        loops: true,  
        title: "Ending Variant - FN76", 
        fullname: "Ending Theme - Alternate Take (Composed by FN76)" 
    },
    { 
        asset: mus_unknown,         
        loop_start: 0, 
        loops: true,  
        title: "Unknown Track",     
        fullname: "Unknown Theme (Composed by RKK)" 
    }
];

audio_stop_all();

if (!variable_global_exists("stats")) {
    global.stats = {
        total_deaths: 0,
        total_jumps: 0,
        time_played_sec: 0
    };
}