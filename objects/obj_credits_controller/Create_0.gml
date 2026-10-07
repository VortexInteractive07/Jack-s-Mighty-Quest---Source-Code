/// Movie-style end credits setup.
display_set_gui_size(432, 240);

credits_entries = [
    { text: "JACK'S MIGHTY QUEST", kind: "title" },
    { text: "A RETRO ADVENTURE", kind: "subtitle" },
    { text: "", kind: "gap" },
    { text: "DIRECTOR", kind: "heading" },
    { text: "PixelForge07", kind: "name" },
    { text: "", kind: "gap" },
    { text: "STORYBOARD", kind: "heading" },
    { text: "PixelForge07", kind: "name" },
    { text: "XxInfinity_EaglexX", kind: "name" },
    { text: "Similar_Nectarine_76", kind: "name" },
    { text: "", kind: "gap" },
    { text: "MUSIC", kind: "heading" },
    { text: "How2Bboss  |  PixelForge07", kind: "name" },
    { text: "RKK  |  Shiru8bit  |  Kawashin", kind: "name" },
    { text: "Frandaman", kind: "name" },
    { text: "", kind: "gap" },
    { text: "GAME DIRECTION & DESIGN", kind: "heading" },
    { text: "Ibrahim Aayan Bin Abdulla", kind: "name" },
    { text: "", kind: "gap" },
    { text: "PROGRAMMING & DEVELOPMENT", kind: "heading" },
    { text: "Ibrahim Aayan Bin Abdulla", kind: "name" },
    { text: "", kind: "gap" },
    { text: "ART, UI & PROJECT LEAD", kind: "heading" },
    { text: "Ibrahim Aayan Bin Abdulla", kind: "name" },
    { text: "", kind: "gap" },
    { text: "SPECIAL THANKS", kind: "heading" },
    { text: "FN76  |  DobyGames", kind: "name" },
    { text: "Mathieu - Creator of FamiStudio", kind: "name" },
    { text: "My dearest mother, Shaira", kind: "name" },
    { text: "My dearest sister, Fathmath Hudha Hussain", kind: "name" },
    { text: "And you!", kind: "name" },
    { text: "", kind: "gap" },
    { text: "JMQ IS THE FIRST RETRO-STYLE INDIE GAME", kind: "message" },
    { text: "IN THE MALDIVES. THANK YOU ALL!", kind: "message" },
    { text: "", kind: "gap" },
    { text: "I appreciate all your help,", kind: "message" },
    { text: "despite the hurdles we had to", kind: "message" },
    { text: "overcome in the past.", kind: "message" },
    { text: "", kind: "gap" },
    { text: "THANK YOU FOR PLAYING", kind: "title" }
];

credits_scroll_y = 240;
credits_scroll_speed = 0.45;
credits_total_height = 0;
for (var i = 0; i < array_length(credits_entries); i++) {
    var _kind = credits_entries[i].kind;
    credits_total_height += (_kind == "gap") ? 12 : ((_kind == "title") ? 22 : ((_kind == "heading") ? 20 : 15));
}
credits_finished = false;
credits_music_handle = -1;

// Deterministic pixel star field. Each star drifts upward at its own speed.
credits_star_count = 72;
credits_star_x = array_create(credits_star_count, 0);
credits_star_y = array_create(credits_star_count, 0);
credits_star_speed = array_create(credits_star_count, 0);
credits_star_size = array_create(credits_star_count, 1);
for (var _star = 0; _star < credits_star_count; _star++) {
    credits_star_x[_star] = (_star * 97 + 23) mod 432;
    credits_star_y[_star] = (_star * 53 + 17) mod 240;
    credits_star_speed[_star] = 0.25 + ((_star mod 5) * 0.12);
    credits_star_size[_star] = (_star mod 6 == 0) ? 2 : 1;
}

if (audio_exists(mus_credits)) {
    credits_music_handle = audio_play_sound(mus_credits, 8, false);
    var _music_gain = variable_global_exists("vol_bgm") ? global.vol_bgm / 100 : 1;
    audio_sound_gain(credits_music_handle, _music_gain, 0);
}
