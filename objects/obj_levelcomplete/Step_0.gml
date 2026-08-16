/// @description Handle Overlay Fade-in & Input Transition

// Only run fade and input checks after Jack has collided with it
if (activated) {
    // Smoothly fade the overlay screen in
    if (alpha < 1) {
        alpha += fade_speed;
    }

    // Increment pulse timer for text animation
    pulse_timer += 0.05;

    // Check for continuation input (S key, Enter, or Space)
    var _continue_pressed = keyboard_check_pressed(ord("S")) || 
                            keyboard_check_pressed(vk_enter) || 
                            keyboard_check_pressed(vk_space);

    // Only allow proceeding once the screen has fully faded in
    if (_continue_pressed && alpha >= 1) {
        audio_stop_all();
        room_goto(target_room);
    }
}