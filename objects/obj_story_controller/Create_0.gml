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
// 3. NARRATIVE TEXT DEPLOYMENT (Safe Standard ASCII Characters Only)
// ============================================================================
story_text = "THE STORY SO FAR...\n\n\n\n" +
             "In the western suburbs of the Republic of Aetheria lies Celestia - once a shining beacon of human spirit and progress.\n\n\n" +
             "For decades, the nation flourished under the steady leadership of President Williams Smith Moore and First Lady Samantha Nicolas Johnson.\n\n\n" +
             "They brought unprecedented prosperity, turning Celestia into a sanctuary where innovation blossomed, peace was an unbroken promise, and every citizen had a place in the future.\n\n\n\n" +
             "Grandfather Smith Moore: 'You have built something truly lasting here, William. Your grandmother and I spent decades laying these stones, but you and Samantha gave this Republic its heart.'\n\n\n" +
             "Grandmother Sarah Johnson: 'Just look at Jack and Charlotte. They didn't need the grand stage of politics to find their purpose. That quiet dedication is the greatest legacy our family could ever leave behind.'\n\n\n\n" +
             "Their son, Jack, chose a life away from statecraft, spending his days as an IT specialist alongside his wife, Charlotte, a brilliant systems engineer.\n\n\n" +
             "Tranquility in Celestia was destined to be fleeting. A past tragedy had already claimed Charlotte's physical presence, leaving Jack to navigate a world shadowed by grief.\n\n\n" +
             "Yet, before her passing, Charlotte encoded her brilliant mind into the digital ether - leaving behind a final, secured program designed to guide Jack when he would need her most.\n\n\n\n" +
             "Jack: 'We never needed the spotlight, Charlotte. Even with you gone, working in the code... it feels like you're still sitting right beside me.'\n\n\n" +
             "Charlotte (Digital Signal): 'I am always with you in the code, Jack. Let's keep building a safer future, line by line.'\n\n\n\n" +
             "That fragile peace shattered on one fateful day.\n\n\n" +
             "While Jack slept, a sudden, violent shockwave tore through the bedrock of Celestia. The sky turned into a suffocating canvas of crimson and ash as a panicked emergency broadcast hijacked every screen across the Republic.\n\n\n" +
             "A rogue mastermind operating as Dr. Vic Sharp stepped into the signal, unleashing a wave of mind-controlled children onto the streets, their innocent voices twisted into a chilling, synchronized chant:\n\n\n" +
             "'ALL YOUR BASE ARE BELONG TO US! ENGRISH GREATNESS!'\n\n\n\n" +
             "Dr. Vic Sharp: 'Listen carefully, Jack! Your peaceful little world ends today! By the time the smoke clears, your family will fall, and you will be nothing but a memory!'\n\n\n" +
             "Jack: 'What is this?! Who breached the network security? Father! Mother!'\n\n\n\n" +
             "Rushing through the falling city, Jack reached the corridors of the government complex as alarms blared and server racks crackled with dark energy.\n\n\n" +
             "His mother met him in the smoke-filled hallway, her hands trembling as she pressed a heavy, reinforced blue and white hoodie into his chest.\n\n\n" +
             "Samantha Nicolas Johnson: 'Put this on, Jack! This hoodie was woven for the battles ahead. Stay safe, my son! Your father needs you in the main server room right now!'\n\n\n" +
             "Jack: 'I won't let you down, Mother!'\n\n\n\n" +
             "Jack burst through the blast doors just as President Moore frantically fought to lock down the city's corrupted mainframe.\n\n\n" +
             "President Williams Smith Moore: 'Jack! The mainframe is locked down by a massive cyber attack! Use your IT intellect - you have to hack their network and shut this operation down from the inside! It's the only -'\n\n\n\n" +
             "Before the President could finish, the reinforced doors blew inward with a deafening blast.\n\n\n" +
             "Dr. Vic Sharp stepped through the swirling smoke, flanked by heavy enforcers.\n\n\n" +
             "Dr. Vic Sharp: 'Too late, Mr. President! The city is already mine!'\n\n\n" +
             "President Williams Smith Moore: 'Touch him and I swear you won't leave this building alive, Schadenfreude!'\n\n\n" +
             "Dr. Vic Sharp: 'You are in no position to make demands, William. Drag him away!'\n\n\n" +
             "Jack: 'Father! No! Let him go!'\n\n\n\n" +
             "The room fell dead silent save for the crackle of burning circuits. As the smoke settled, Jack fell to his knees in the ashes of the server room.\n\n\n" +
             "But as despair threatened to consume him, his wrist terminal flickered to life. A glowing green text interface cut through the dark - Charlotte's spectral code, dancing across his visor.\n\n\n" +
             "Charlotte (Digital Signal): 'I have bypassed their firewall protocols, Jack. I am locking onto the coordinates of the outer gates. Stand up... we have a mission to finish together.'\n\n\n" +
             "Jack: 'He took my father. He corrupted our city. He turned innocent children into his army. We're putting an end to this today.'\n\n\n\n" +
             "Standing up from the ruins, Jack assembled his elite tech resistance team.\n\n\n" +
             "First came Jessie, a world-famous acrobatic idol whose blinding speed was matched only by her genius as an IT operative.\n\n\n" +
             "Next was Mark, a brilliant robotics assistant who deployed a fleet of custom tactical combat drones to scout the perilous, smoke-filled skies.\n\n\n\n" +
             "Jessie: 'Mainframe links are secure, Jack! I've got the perimeter on lock. No enforcer is getting past us!'\n\n\n" +
             "Mark AI: 'Drone fleet calibrated and hovering in sector four. Biometric scans indicate high enemy density ahead, Jack. We must proceed with absolute tactical precision.'\n\n\n\n" +
             "Guided by Charlotte's signal, the resistance unit pushed toward the heavily guarded outer gates of Celestia.\n\n\n" +
             "Standing directly across the threshold was a young boy, his eyes glowing with a faint red neural link, raising a pulse rifle with trembling, forced hands.\n\n\n" +
             "Jessie: 'Jack, look out! Wait... that's... that's just a child!'\n\n\n" +
             "Mark AI: 'Warning. Target is under active neural override. Hostile actions are non-voluntary.'\n\n\n" +
             "Jack: 'He's just a hostage forced to play soldier... a victim of Sharp's false family. I'm not striking down the innocent to win this war.'\n\n\n\n" +
             "With Jessie securing the perimeter, Mark's drones lighting the dark, and Charlotte's code charting the path through the corrupted grid, Jack tightens the strings of his blue and white hoodie.\n\n\n" +
             "Ahead lies the capital, where the false family awaits in the shadows. The fate of the Republic of Aetheria rests entirely in their hands.\n\n\n\n" +
             "Will Jack strike down those in his path to end the chaos quickly, or will he take the harder road to free the innocent citizens from Victor's grip?\n\n\n\n\n\n" +
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

// 5. Stats verification
if (!variable_global_exists("stats")) {
    global.stats = {
        total_deaths: 0,
        total_jumps: 0,
        time_played_sec: 0
    };
}