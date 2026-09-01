/// @description Render Graphics, Dialogue Layout, Standalone Text & Subtitle Overlay
if (splash_index >= array_length(splash_list)) exit;

var _current_splash = splash_list[splash_index];
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

draw_clear(c_black);

// ==========================================
// 1. STANDALONE RAW TEXT SPLASH
// ==========================================
if (is_struct(_current_splash) && struct_exists(_current_splash, "raw_text")) {
    var _font    = struct_exists(_current_splash, "font") && font_exists(_current_splash.font) ? _current_splash.font : fnt_bitmap;
    var _color   = struct_exists(_current_splash, "color") ? _current_splash.color : c_white;
    var _scale   = struct_exists(_current_splash, "scale") ? _current_splash.scale : 1;
    var _shadow  = struct_exists(_current_splash, "blue_shadow") ? _current_splash.blue_shadow : false;
    var _instant = struct_exists(_current_splash, "instant_display") ? _current_splash.instant_display : false;

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    if (font_exists(_font)) draw_set_font(_font);

    var _full_text = _current_splash.raw_text;
    var _displayed_text = _instant ? _full_text : string_copy(_full_text, 1, floor(char_count));

    if (_shadow) {
        var _shadow_color = make_color_rgb(0, 80, 180);
        draw_text_transformed_color((_gui_w / 2) + 1, (_gui_h / 2) + 1, _displayed_text, _scale, _scale, 0, _shadow_color, _shadow_color, _shadow_color, _shadow_color, alpha);
    }

    draw_text_transformed_color(_gui_w / 2, _gui_h / 2, _displayed_text, _scale, _scale, 0, _color, _color, _color, _color, alpha);
}
// ==========================================
// 2. DIALOGUE FRAME TEXT SPLASH
// ==========================================
else if (is_struct(_current_splash) && struct_exists(_current_splash, "text")) {
    if (sprite_exists(spr_dialogue)) {
        draw_sprite_ext(spr_dialogue, 0, 0, 0, 1.0, 1.0, 0, c_white, 1.0);
    }

    var _font  = struct_exists(_current_splash, "font") && font_exists(_current_splash.font) ? _current_splash.font : fnt_bitmap;
    var _color = struct_exists(_current_splash, "color") ? _current_splash.color : c_white;
    var _scale = struct_exists(_current_splash, "scale") ? _current_splash.scale : 1;

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    if (font_exists(_font)) draw_set_font(_font);

    var _name_text = struct_exists(_current_splash, "name") ? _current_splash.name : "";
    if (_name_text != "") {
        draw_text_transformed_color(8, 168, _name_text, _scale, _scale, 0, _color, _color, _color, _color, 1.0);
    }

    var _full_text = _current_splash.text;
    var _displayed_text = string_copy(_full_text, 1, floor(char_count));
    
    draw_text_transformed_color(8, 188, _displayed_text, _scale, _scale, 0, _color, _color, _color, _color, 1.0);

    if (typewriter_complete) {
        if (sprite_exists(spr_dialogue_continue_btn)) {
            var _btn_spd  = sprite_get_speed(spr_dialogue_continue_btn);
            var _btn_type = sprite_get_speed_type(spr_dialogue_continue_btn);
            var _subimg   = (_btn_type == spritespeed_framespersecond)
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
}
// ==========================================
// 3. CENTERED FULLSCREEN GRAPHIC SPRITES
// ==========================================
else if (sprite_exists(_current_splash)) {
    draw_sprite_ext(_current_splash, 0, _gui_w / 2, _gui_h / 2, 1.0, 1.0, 0, c_white, alpha);
}

// ==========================================
// 4. SONG LYRICS SUBTITLE OVERLAY
// ==========================================
if (enable_lyrics && current_lyric_text != "") {
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    if (font_exists(fnt_bitmap)) draw_set_font(fnt_bitmap);

    var _lyric_y = 12;
    var _shadow_c = c_black;
    var _text_c   = c_yellow;

    draw_text_transformed_color((_gui_w / 2) + 1, _lyric_y + 1, current_lyric_text, 1, 1, 0, _shadow_c, _shadow_c, _shadow_c, _shadow_c, 0.8);
    draw_text_transformed_color(_gui_w / 2, _lyric_y, current_lyric_text, 1, 1, 0, _text_c, _text_c, _text_c, _text_c, 1.0);
}

// Reset Draw State Properties
draw_set_alpha(1.0);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);