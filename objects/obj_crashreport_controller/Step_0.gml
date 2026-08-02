/// @description Intercept Keyboard Resets
// Retro console logic: Enter to force warm reset, Escape to terminate process execution
if (keyboard_check_pressed(ord("R"))) {
    game_restart();
}

if (keyboard_check_pressed(ord("E"))) {
    game_end();
}