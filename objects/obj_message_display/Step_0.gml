// Example: Press 'M' to trigger a message test
if (keyboard_check_pressed(ord("M"))) {
    display_text = "Hello! This is a test message.";
    is_visible = true;
    alarm[0] = game_get_speed(gamespeed_fps) * 3; // Modern, non-deprecated alternative
}