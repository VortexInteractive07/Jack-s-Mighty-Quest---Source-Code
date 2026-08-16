/// @description Initialize Level Complete Trigger & Overlay State

activated = false;          // Ensures it only triggers upon actual player contact
alpha = 0;                  // Fade-in opacity tracker for the overlay screen
fade_speed = 0.03;          // Speed of the overlay fade-in transition
target_room = rm_title_screen; // Room to return to after pressing continue

pulse_timer = 0;            // Animation timer for the glowing header text pulse
level_audio_id = noone;     // Reference tracker for the victory jingle

victory_jingle = mus_menu;