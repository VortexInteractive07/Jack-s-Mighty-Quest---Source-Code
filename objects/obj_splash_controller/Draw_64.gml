/// @description Draw Splash Screen
if (splash_index < array_length(splash_list)) {
    var _current_splash = splash_list[splash_index];
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();

    // Clear background frame
    draw_clear(c_black);

    // Draw current splash sprite centered on screen
    draw_sprite_ext(
        _current_splash, 
        0, 
        _gui_w / 2, 
        _gui_h / 2, 
        1, 1, 0, 
        c_white, 
        alpha
    );
}