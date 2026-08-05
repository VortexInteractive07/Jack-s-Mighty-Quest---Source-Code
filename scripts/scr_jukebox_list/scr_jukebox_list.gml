/// @description Define Global Composer Track Data Profiles & Song Lists
function scr_jukebox_list() {
    
    // =================================================================
    // 1. COMPOSER CREDITS DATA
    // =================================================================
    global.composer_title    = "How2Bboss";
    global.composer_credits  = "RKK";
    global.composer_city     = "How2Bboss";
    global.composer_menu     = "PixelForge07 & RKK";
    global.composer_ending   = "FN76 (Resigned)";
    global.composer_boss     = "RKK";
    global.composer_story    = "PixelForge07";
    global.composer_requiem  = "RKK";
    global.composer_monaigaa = "PixelForge07";
    global.composer_alhavaa  = "PixelForge07";
    global.composer_gais     = "PixelForge07";
    global.composer_dungeons = "PixelForge07";
    global.composer_wait     = "PixelForge07";

    // =================================================================
    // 2. STANDARD BACKGROUND BGM OST MATRIX
    // =================================================================
    global.ost_list = [
        { asset: mus_title_theme, loop_start: 1.198, loops: true, title: "Title Screen Theme", fullname: "Title Screen Theme (Composed by " + global.composer_title + ")" },
        { asset: mus_credits, loop_start: 0, loops: false, title: "Credits Roll Ending", fullname: "Credits Roll Ending (Composed by " + global.composer_credits + ")" },
        { asset: mus_city, loop_start: 25.557, loops: true, title: "Streets of Celestia", fullname: "Streets of Celestia (Composed by " + global.composer_city + ")" },
        { asset: mus_ending_theme, loop_start: 0, loops: true, title: "Ending Theme", fullname: "Ending Theme (Composed by " + global.composer_ending + ")" },
        { asset: mus_boss_prototype, loop_start: 0, loops: true, title: "Boss Theme", fullname: "Boss - Jack's Mighty Quest (Composed by " + global.composer_boss + ")" },
        { asset: mus_menu, loop_start: 1, loops: true, title: "Main Menu", fullname: "Main Menu - Jack's Mighty Quest (Composed by " + global.composer_menu + ")" },
        { asset: mus_requiem, loop_start: 1, loops: true, title: "Victor Schadenfreude's Requiem", fullname: "Vic Sharp's Requiem - Jack's Mighty Quest (Composed by " + global.composer_requiem + ")" },
        { asset: mus_dungeons, loop_start: 1, loops: true, title: "Dungeons", fullname: "Dungeons - Jack's Mighty Quest (Composed by " + global.composer_dungeons + ")" },
        { asset: mus_intermission, loop_start: 1, loops: true, title: "Intermission", fullname: "Intermission - Jack's Mighty Quest (Composed by " + global.composer_wait + ")" },
        { asset: mus_evil_clockwork_original, loop_start: 0, loops: true, title: "Evil Clockwork", fullname: "Evil Clockwork (Composed by Kawashin)" },
        { asset: mus_evil_clockwork_extended_prototype, loop_start: 0, loops: true, title: "Evil Clockwork - Ext.", fullname: "Evil Clockwork - Extended (Composed by Kawashin, Ext. by PixelForge07)" }
    ];

    // =================================================================
    // 3. VOCALS & LORE SONGS MATRIX (UPDATED WITH TITLE PLAYLIST)
    // =================================================================
    global.songs_list = [
        // --- Original Lore & Embedded Vocals ---
        { 
            asset: mus_no_bridge_to_cross, loop_start: 0, loops: true, title: "No Bridge to Cross", fullname: "No Bridge to Cross (Composed by PixelForge07 - Lyrics Embedded)", has_lyrics: true,
            lyrics: [
                { time: 0.00,   text: "" },
                { time: 18.01,  text: "Watch the sky turn into iron gray" },
                { time: 25.79,  text: "Shadows stretch to catch the light of day" },
                { time: 32.47,  text: "I don't need a reason, I don't need a rhyme" },
                { time: 39.55,  text: "I just need to watch you, run out of time" }, 
                { time: 46.17,  text: "Path of destruction is all I care" },
                { time: 53.93,  text: "The screams of horror is all that's fair" },
                { time: 60.89,  text: "Do what you want, but you cannot escape" },
                { time: 64.32,  text: "The death is near, and so as your fate" },
                { time: 68.74,  text: "..so as your fate! (your fate, your fate)" },
                { time: 73.62,  text: "The gears are turning in the dark below" },
                { time: 80.97,  text: "I'm the only harvest that the ruins grow" },
                { time: 90.01,  text: "No exit sign, no bridge for you to cross" },
                { time: 95.92,  text: "Calculatin' every second of your loss" },
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

        // --- July 26th Independence Day Tracks ---
        { asset: mus_josheh_genaimee, loop_start: 0, loops: true, title: "Josheh Genaimee", fullname: "Josheh Genaimee - [Independence Day Exclusivity #1]", has_lyrics: false },
        { asset: mus_o_wazan, loop_start: 0, loops: true, title: "O Wazan", fullname: "O Wazan - [Independence Day Exclusivity #2]", has_lyrics: false },
        { asset: mus_gaumah_aiy_minivan_nooraanee, loop_start: 0, loops: true, title: "Gaumah Aiy Minivan Nooraanee", fullname: "Gaumah Aiy Minivan Nooraanee - [Independence Day Exclusivity #3]", has_lyrics: false },

        // --- Classics & Traditional Classics ---
        { asset: mus_mujuraa, loop_start: 0, loops: true, title: "Mujuraa", fullname: "Mujuraa (Naifaru Dhohokkobe)", has_lyrics: false },
        { asset: mus_dhaaru_ofu_maaiy, loop_start: 0, loops: true, title: "Dhaaru Ofu Maaiy", fullname: "Dhaaru Ofu Maaiy", has_lyrics: false },
        { asset: mus_naanaavee_seedhaa_loabi, loop_start: 0, loops: true, title: "Naanaavee Seedhaa Loabi", fullname: "Naanaavee Seedhaa Loabi", has_lyrics: false },
        { asset: mus_ofu_maaiy, loop_start: 0, loops: true, title: "Ofu Maaiy", fullname: "Ofu Maaiy", has_lyrics: false },
        { asset: mus_dhombey_thedhuvey, loop_start: 0, loops: true, title: "Dhombey Thedhuvey", fullname: "Dhombey Thedhuvey (Holhudhoo Abdulla)", has_lyrics: false },
        { asset: mus_dhuru_dhuru_gaavey, loop_start: 0, loops: true, title: "Dhuru Dhuru Gaavey", fullname: "Dhuru Dhuru Gaavey", has_lyrics: false },
        { asset: mus_kaaku_keenhey_kuree, loop_start: 0, loops: true, title: "Kaaku Keenhey Kuree", fullname: "Kaaku Keenhey Kuree", has_lyrics: false },
        { asset: mus_vadaigannavashey, loop_start: 0, loops: true, title: "Vadaigannavashey", fullname: "Vadaigannavashey", has_lyrics: false },

        // --- Modern / AI / Regional Selection ---
        { asset: mus_falhi_jahaa, loop_start: 0, loops: true, title: "Falhi Jahaa", fullname: "Falhi Jahaa - [AI Dhivehi Track]", has_lyrics: false },
        { asset: mus_mage_maaladivaina, loop_start: 0, loops: true, title: "Mage Maaladivaina", fullname: "Mage Maaladivaina - [Sinhala]", has_lyrics: false },
        { asset: mus_nil_diyawela, loop_start: 0, loops: true, title: "Nil Diyawela", fullname: "Nil Diyawela", has_lyrics: false },

        // --- Aetherian Lore Series ---
        { asset: mus_gais, loop_start: 0, loops: true, title: "Rey Kanda Gais", fullname: "Rey Kanda Gais - [Aetherian Lore Track] (Composed by " + global.composer_gais + ")", has_lyrics: false },
        { asset: mus_raalhehge_monaigaa, loop_start: 0, loops: true, title: "Raalhehge Monaigaa", fullname: "Raalhahge Monaigaa - [Aetherian Lore Track] (Composed by " + global.composer_monaigaa + ")", has_lyrics: false },
        { asset: mus_alhavaa, loop_start: 0, loops: true, title: "Alhavaa Monaigaa", fullname: "Alhavaa Monaigaa - [Aetherian Lore Track] (Composed by " + global.composer_alhavaa + ")", has_lyrics: false },
        { asset: mus_reythi_aadha, loop_start: 0, loops: true, title: "Rethi Aadha Ey", fullname: "Rethi Aadha Ey - [Aetherian Lore Track] (Composed by PixelForge07)", has_lyrics: false },
        { asset: mus_reythi_reyge_balaalumey, loop_start: 0, loops: true, title: "Reythi Reyge Balaalumey", fullname: "Reythi Reyge Balaalumey - [Aetherian Lore Track] (Composed by PixelForge07)", has_lyrics: false },
        { asset: mus_ranga_dhun_yeh, loop_start: 0, loops: true, title: "Ranga Dhun Yeh", fullname: "Ranga Dhun Yeh - [Aetherian Lore Track]", has_lyrics: false },
        { asset: mus_monaigaa_hithaa, loop_start: 0, loops: true, title: "Monaigaa Hithaa", fullname: "Monaigaa Hithaa - [Aetherian Lore Track]", has_lyrics: false },
        { asset: mus_moodhu_raalhahge_taalam, loop_start: 0, loops: true, title: "Moodhu Raalhahge Taalam", fullname: "Moodhu Raalhahge Taalam - [Aetherian Lore Track]", has_lyrics: false },
        { asset: mus_monaigaa_alhavaa, loop_start: 0, loops: true, title: "Monaigaa Alhavaa", fullname: "Monaigaa Alhavaa - [Aetherian Lore Track]", has_lyrics: false }
    ];

    // =================================================================
    // 4. SOUND EFFECTS MATRIX
    // =================================================================
    global.sfx_list = [
        { asset: sfx_shoot, title: "Laser Shot Pack", fullname: "Laser Shot Pack 2020" },
        { asset: sfx_explosion, title: "Explosion Effect", fullname: "Red box goes boom!" },
        { asset: sfx_textbox, title: "Dialogue Beep", fullname: "Textbox Dialogue Blip" },
        { asset: sfx_textbox_continue, title: "Dialogue Continue", fullname: "Textbox Continue Arrow" }
    ];

    // =================================================================
    // 5. UNUSED ARCHIVED CONTENT MATRIX
    // =================================================================
    global.unused_list = [
        { asset: mus_asteriskobelisk, loop_start: 0, loops: true, title: "Asterisk Obelisk", fullname: "Asterisk Obelisk (Unused/Archived Content)" },
        { asset: mus_death, loop_start: 0, loops: false, title: "Game Over - FN76", fullname: "Game Over Theme (Composed by " + global.composer_ending + ")" },
        { asset: mus_ending_theme, loop_start: 0, loops: true, title: "Ending Variant - FN76", fullname: "Ending Theme - Alternate Take (Composed by " + global.composer_ending + ")" },
        { asset: mus_unknown, loop_start: 0, loops: true, title: "Unknown Track", fullname: "Unknown Theme (Composed by RKK)" }
    ];
}