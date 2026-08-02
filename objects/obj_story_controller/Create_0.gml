/// @description Initialize Cinematic Widescreen & Story Prologue Systems

// ============================================================================
// 1. DYNAMIC RESIZING HOOK (Widescreen for rm_thestorysofar Only)
// ============================================================================
// Switch target resolution metrics to retro widescreen aspect ratios
var _widescreen_w = 432; // Clean multiple of 16 matching a 240p baseline perfectly
var _widescreen_h = 240;

// Reconfigure the canvas system bounds on the fly
surface_resize(application_surface, _widescreen_w, _widescreen_h);
display_set_gui_size(_widescreen_w, _widescreen_h);

// Update view ports dynamically if active inside the room
if (view_enabled) {
    view_visible[0] = true;
    camera_set_view_size(view_camera[0], _widescreen_w, _widescreen_h);
}

// ============================================================================
// 2. SCROLL SETUP & GEOMETRY
// ============================================================================
// Start text completely offscreen at the bottom of the newly scaled canvas
scroll_y      = _widescreen_h; 
scroll_speed  = 0.35; 

bg_offset_x   = 0;
bg_offset_y   = 0;

// ============================================================================
// 3. NARRATIVE TEXT DEPLOYMENT
// ============================================================================
story_text = "THE STORY SO FAR...\n\n\n\n" +
             "Celestia, a city located in the western suburbs of the Republic of Aetheria, was once a shining beacon of human spirit.\n\n\n" +
             "It was known for its blissful environment and kind community, a sanctuary where everyone was considered equal. A place where the future felt safe.\n\n\n\n" +
             "The country's ruler, Williams Smith Moore, and the First Lady, Samantha Nicolas Johnson, brought unprecedented prosperity and infrastructure to this very city.\n\n\n" +
             "Under their gentle guidance, innovation blossomed, and peace was an unbroken promise.\n\n\n\n\n" +
             "Until one fateful day.\n\n\n\n" +
             "While Jack was in his slumber, a sudden, violent shockwave shattered the tranquility. The earth trembled, and a panicked emergency news bulletin woke him instantaneously:\n\n\n" +
             "'A massive blast has hit the city center! Unknown forces are breaching our perimeter!'\n\n\n\n" +
             "Ginormous flames engulfed the city. The pristine skies turned into a suffocating canvas of crimson and ash.\n\n\n" +
             "Children, manipulated under the sinister control of Dr. Vic Sharp, filled the streets. Their innocent voices were twisted into a terrifying, synchronized chant in pure Engrish:\n\n\n" +
             "'ALL YOUR BASE ARE BELONG TO US! ENGRISH GREATNESS!'\n\n\n\n\n" +
             "Jack rushed to the president's office, the corridors echoing with the sounds of a falling republic.\n\n\n" +
             "His mother, her eyes filled with both terror and immense pride, handed him a protective blue and white hoodie woven for battle. It was heavy with the weight of destiny.\n\n\n\n" +
             "His father, battered but unbowed, implored: 'The mainframe is locked down by a massive cyber attack, son.\n\n" +
             "Use your IT intellect. Hack their network and shut this operation down from the inside.'\n\n\n\n" +
             "But before Jack could reach him, the reinforced doors blew inward.\n\n\n" +
             "Dr. Vic Sharp breached the room, a twisted smile plastered on his face, and abducted the President!\n\n\n" +
             "The room fell dead silent, save for the crackle of burning servers. Jack fell to his knees. His mission was now painfully clear: save his father, defeat the false family, and stop their notorious acts.\n\n\n\n\n" +
             "Standing up from the ashes of the fallen, Jack refused to surrender to the despair that threatened to consume him.\n\n\n" +
             "He assembled his elite tech resistance team.\n\n\n" +
             "First came Jessie, a famous acrobatic idol whose agility was matched only by her brilliance as an IT specialist.\n\n\n" +
             "Then came Mark, an assistant in robotics who calibrated a custom combat drone fleet, ready to unleash technological fury.\n\n\n\n" +
             "But the true source of Jack's unwavering resolve came from a place of profound heartbreak.\n\n\n" +
             "He was guided by his late wife, Charlotte.\n\n\n" +
             "Her physical presence was gone, a casualty of a past tragedy, but her brilliant mind remained encoded in the digital ether.\n\n\n\n" +
             "Before she passed away, she left a final saved program.\n\n\n" +
             "As Jack powered on his wrist terminal, her ethereal green text flashed onto his screen, a warm light in a cold, broken world:\n\n\n" +
             "'I am always with you in the code, Jack. I have bypassed their firewall protocols. Let's finish this mission together.'\n\n\n\n\n" +
             "A single tear fell onto Jack's console. He wasn't just fighting for Aetheria anymore; he was fighting to honor her memory.\n\n\n" +
             "These heroes embarked on a journey they knew they might not return from.\n\n\n" +
             "The once-gleaming streets of Celestia now lie fractured, patrolled by Sharp's mechanized enforcers. The neon signs that once promised a bright future now flicker with corrupted data streams.\n\n\n\n" +
             "Yet, a faint light shines through the darkness.\n\n\n" +
             "With Jessie securing the perimeter and Mark's drones scouting the perilous, smoke-filled skies, Jack tightens the strings of his blue and white hoodie.\n\n\n" +
             "Charlotte's spectral code dances across his visor, locking onto the coordinates of the heavily guarded outer gates.\n\n\n\n" +
             "He looks at his team. No words are needed. The fear is gone, replaced by a cold, unstoppable determination. They are the last line of defense against the abyss.\n\n\n\n" +
             "The false family awaits in the shadows of the capital.\n\n\n" +
             "The fate of the Republic of Aetheria rests entirely in their hands. They will not falter. They will not fail.\n\n\n\n\n\n" +
             "The mighty quest for justice begins now.\n\n\n\n\n\n\n\n\n" +
             "--- PRESS ENTER / SPACE TO SKIP ---";

// ============================================================================
// 4. AUDIO MANAGEMENT CORE
// ============================================================================
var _intro_bgm = mus_no_bridge_to_cross;

audio_stop_all();
if (audio_exists(_intro_bgm)) {
    audio_sound_gain(_intro_bgm, 1.0, 0);
    bgm_instance = audio_play_sound(_intro_bgm, 1, false);
} else {
    bgm_instance = noone;
}

if (!variable_global_exists("stats")) {
    global.stats = { total_deaths: 0, total_jumps: 0, time_played_sec: 0 };
}