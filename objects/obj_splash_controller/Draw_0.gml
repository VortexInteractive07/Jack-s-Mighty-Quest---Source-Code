var _center_x = room_width / 2;
var _center_y = room_height / 2;

if (is_loading) {
    // Draw loading screen directly without fade
    draw_set_alpha(1.0);
    draw_sprite(spr_loading, 0, _center_x, _center_y);
} else if (current_splash_index < array_length(splash_screens)) {
    // Draw active splash screen from list with current fade alpha
    var _current_sprite = splash_screens[current_splash_index];
    
    draw_set_alpha(fade_alpha);
    draw_sprite(_current_sprite, 0, _center_x, _center_y);
    draw_set_alpha(1.0);
}