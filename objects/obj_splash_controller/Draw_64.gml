/// @description Render Graphics, Dialogue Layout, Standalone Text & Subtitle Overlay
// Intelligence Level: 10/10

// Required Assets:
// spr_dialogue
// spr_dialogue_continue_btn
// spr_gamemaker_attribution
// fnt_bitmap
// fnt_sinhala

if (splash_index >= array_length(splash_list)) exit;

var _current_splash = splash_list[splash_index];
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

draw_clear(c_black);

// ==========================================
// 1. STANDALONE RAW TEXT SPLASH
// ==========================================
if (is_struct(_current_splash) && struct_exists(_current_splash, "raw_text")) {
    var _font    = (struct_exists(_current_splash, "font") && font_exists(_current_splash.font)) ? _current_splash.font : fnt_bitmap;
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

    var _font  = (struct_exists(_current_splash, "font") && font_exists(_current_splash.font)) ? _current_splash.font : fnt_bitmap;
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

    if (variable_instance_exists(id, "typewriter_complete") && typewriter_complete) {
        if (sprite_exists(spr_dialogue_continue_btn)) {
            var _btn_spd   = sprite_get_speed(spr_dialogue_continue_btn);
            var _btn_type  = sprite_get_speed_type(spr_dialogue_continue_btn);
            var _btn_subimg = (_btn_type == spritespeed_framespersecond)
                ? (get_timer() / 1000000) * _btn_spd
                : (get_timer() / 1000000) * (game_get_speed(gamespeed_fps) * _btn_spd);

            draw_sprite_ext(
                spr_dialogue_continue_btn, 
                _btn_subimg, 
                _gui_w - 20, 
                _gui_h - 16, 
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
    var _total_frames = sprite_get_number(_current_splash);
    
    // Initialize object-level frame counter if not present
    if (!variable_instance_exists(id, "splash_frame")) {
        splash_frame = 0;
    }

    // Fetch the target speed set in the Sprite Editor
    var _target_spd = sprite_get_speed(_current_splash);
    var _spd_type   = sprite_get_speed_type(_current_splash);
    
    // Calculate precise step increment relative to 60 FPS room speed
    var _frame_increment = 0;
    if (_spd_type == spritespeed_framespersecond) {
        _frame_increment = _target_spd / game_get_speed(gamespeed_fps);
    } else {
        _frame_increment = _target_spd;
    }

    // Allow override via custom splash_anim_speed if defined on instance
    if (variable_instance_exists(id, "splash_anim_speed")) {
        _frame_increment *= splash_anim_speed;
    }

    if (_total_frames > 1) {
        splash_frame += _frame_increment;
        
        // Loop ONLY spr_gamemaker_attribution; freeze all other sprites on their final frame
        if (sprite_exists(spr_gamemaker_attribution) && _current_splash == spr_gamemaker_attribution) {
            splash_frame %= _total_frames;
        } else {
            splash_frame = min(splash_frame, _total_frames - 1);
        }
    } else {
        splash_frame = 0;
    }

    draw_sprite_ext(_current_splash, floor(splash_frame), _gui_w / 2, _gui_h / 2, 1.0, 1.0, 0, c_white, alpha);
}

// Reset frame index when moving between splash elements
if (variable_instance_exists(id, "last_splash_index") && last_splash_index != splash_index) {
    splash_frame = 0;
}
last_splash_index = splash_index;

// ==========================================
// 4. SONG LYRICS SUBTITLE OVERLAY
// ==========================================
if (variable_instance_exists(id, "enable_lyrics") && enable_lyrics && variable_instance_exists(id, "current_lyric_text") && current_lyric_text != "") {
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    
    // Dynamic Font Selection: Detect Sinhala Unicode Range (3456..3583 / 0x0D80..0x0DFF)
    var _has_sinhala_chars = false;
    var _lyric_len = string_length(current_lyric_text);
    for (var _c = 1; _c <= _lyric_len; _c++) {
        var _char_code = ord(string_char_at(current_lyric_text, _c));
        if (_char_code >= 3456 && _char_code <= 3583) {
            _has_sinhala_chars = true;
            break;
        }
    }
    
    // Determine lyric font based on language content
    var _lyric_font = fnt_bitmap;
    if (is_struct(_current_splash) && struct_exists(_current_splash, "lyric_font") && font_exists(_current_splash.lyric_font)) {
        _lyric_font = _current_splash.lyric_font;
    } else if (_has_sinhala_chars && font_exists(fnt_sinhala)) {
        _lyric_font = fnt_sinhala;
    } else if (font_exists(fnt_bitmap)) {
        _lyric_font = fnt_bitmap;
    }
    
    if (font_exists(_lyric_font)) draw_set_font(_lyric_font);

    var _lyric_y  = 12;
    var _shadow_c = c_black;
    var _text_c   = c_yellow;

    // Subtitle Shadow & Text Rendering
    draw_text_transformed_color((_gui_w / 2) + 1, _lyric_y + 1, current_lyric_text, 1, 1, 0, _shadow_c, _shadow_c, _shadow_c, _shadow_c, 0.8);
    draw_text_transformed_color(_gui_w / 2, _lyric_y, current_lyric_text, 1, 1, 0, _text_c, _text_c, _text_c, _text_c, 1.0);
}

// Reset Draw State
draw_set_alpha(1.0);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);