/// @description Render Graphics, Dialogue Layout & Continue Indicator Sprite
if (splash_index >= array_length(splash_list)) exit;

var _current_splash = splash_list[splash_index];
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

draw_clear(c_black);

if (is_struct(_current_splash)) {
    // 1. Draw Dialogue Frame (0, 0)
    if (sprite_exists(spr_dialogue)) {
        draw_sprite_ext(spr_dialogue, 0, 0, 0, 1.0, 1.0, 0, c_white, 1.0);
    }

    // 2. Set Up Text Properties
    var _font = struct_exists(_current_splash, "font") && font_exists(_current_splash.font) 
        ? _current_splash.font 
        : fnt_bitmap;
        
    var _color = struct_exists(_current_splash, "color") ? _current_splash.color : c_white;
    var _scale = struct_exists(_current_splash, "scale") ? _current_splash.scale : 1;

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    if (font_exists(_font)) {
        draw_set_font(_font);
    }

    // 3. Render Speaker Name (Top tab notch)
    var _name_text = struct_exists(_current_splash, "name") ? _current_splash.name : "";
    if (_name_text != "") {
        draw_text_transformed_color(8, 168, _name_text, _scale, _scale, 0, _color, _color, _color, _color, 1.0);
    }

    // 4. Render Body Dialogue Text (Below blue divider)
    var _full_text = struct_exists(_current_splash, "text") ? _current_splash.text : "";
    var _displayed_text = string_copy(_full_text, 1, floor(char_count));
    
    draw_text_transformed_color(8, 188, _displayed_text, _scale, _scale, 0, _color, _color, _color, _color, 1.0);

    // 5. Animated Continue Button Sprite (Solid display, no blinking)
    if (typewriter_complete) {
        if (sprite_exists(spr_dialogue_continue_btn)) {
            // Calculate subimage based on sprite editor speed settings
            var _btn_spd = sprite_get_speed(spr_dialogue_continue_btn);
            var _btn_type = sprite_get_speed_type(spr_dialogue_continue_btn);
            var _subimg = (_btn_type == spritespeed_framespersecond)
                ? (get_timer() / 1000000) * _btn_spd
                : (get_timer() / 1000000) * (game_get_speed(gamespeed_fps) * _btn_spd);

            var _btn_x = _gui_w - 20;
            var _btn_y = _gui_h - 16;
            
            draw_sprite_ext(
                spr_dialogue_continue_btn, 
                _subimg, 
                _btn_x, 
                _btn_y, 
                1.0, 1.0, 0, 
                c_white, 
                1.0
            );
        }
    }
} else {
    // Render Centered Fullscreen Graphic Sprites
    draw_sprite_ext(_current_splash, 0, _gui_w / 2, _gui_h / 2, 1.0, 1.0, 0, c_white, alpha);
}