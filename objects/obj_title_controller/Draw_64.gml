/// @description Draw Title GUI, Full-Screen Dialogue, Level Select, & Music Toast

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// ==========================================
// 1. DRAW TITLE BACKGROUND
// ==========================================
if (sprite_exists(spr_titlescreen)) {
    draw_sprite_stretched(spr_titlescreen, 0, 0, 0, _gui_w, _gui_h);
} else {
    draw_clear(c_black);
}

if (font_exists(fnt_bitmap)) {
    draw_set_font(fnt_bitmap);
}

// ==========================================
// 2. ORIGINAL LOGO SPLASH
// ==========================================
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _splash_x = _gui_w * 0.50;
var _splash_y = _gui_h * 0.57;
if (splash_current_str != "") {
    draw_text_transformed_color(
        _splash_x + 1, _splash_y + 1, splash_current_str,
        1, 1, splash_angle,
        c_black, c_black, c_black, c_black, 0.85
    );
    draw_text_transformed_color(
        _splash_x, _splash_y, splash_current_str,
        1, 1, splash_angle,
        c_yellow, c_yellow, make_color_rgb(255, 215, 0), make_color_rgb(255, 215, 0), 1
    );
}

// ==========================================
// 3. RANDOM HUMOROUS START MESSAGE AND BLINKING PROMPT
// ==========================================
if (fade_state == 1) {
    var _prompt_y = _gui_h * 0.81;
    var _prompt_label = (global.arcade_mode && global.arcade_credits <= 0)
        ? get_localized_text("insert_coins")
        : string_replace_all(press_start_message, "\\n", chr(10));

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    if (show_start_text) {
        draw_text_color(_splash_x + 1, _prompt_y + 1, _prompt_label, c_black, c_black, c_black, c_black, 1);
        draw_text_color(_splash_x, _prompt_y, _prompt_label, c_yellow, c_yellow, c_white, c_white, 1);
    }

    if (global.arcade_mode) {
        draw_set_color(c_white);
        draw_text(_splash_x, _prompt_y + 14, get_localized_text("credits") + " " + string(global.arcade_credits));
    }
}

// ==========================================
// 4. DIALOGUE SYSTEM WITH SPR_DIALOGUE (432x240 OVERLAY)
// ==========================================
if (fade_state == 2 && in_dialogue && array_length(dialogue_lines) > 0) {
    var _safe_index = clamp(dialogue_index, 0, array_length(dialogue_lines) - 1);
    var _current_line = dialogue_lines[_safe_index];
    
    var _speaker = struct_exists(_current_line, "speaker") ? _current_line.speaker : "";
    if (_speaker == "" && struct_exists(_current_line, "name")) {
        _speaker = _current_line.name;
    }
    
    var _full_text = struct_exists(_current_line, "text") ? scr_dialogue_format_text(_current_line.text) : "";
    var _font = (struct_exists(_current_line, "font") && font_exists(_current_line.font)) ? _current_line.font : fnt_bitmap;
    var _color = struct_exists(_current_line, "color") ? _current_line.color : c_white;
    var _scale = struct_exists(_current_line, "scale") ? _current_line.scale : 1.0;

    if (font_exists(_font)) {
        draw_set_font(_font);
    }

    // Full-Screen Frame Overlay
    if (sprite_exists(spr_dialogue)) {
        draw_sprite_ext(spr_dialogue, 0, 0, 0, 1.0, 1.0, 0, c_white, 1.0);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // Speaker Header
    if (_speaker != "") {
        draw_text_transformed_color(8, 168, _speaker, _scale, _scale, 0, _color, _color, _color, _color, 1.0);
    }

    // Typewriter Text
    var _displayed_text = string_copy(_full_text, 1, floor(char_count));
    draw_text_transformed_color(8, 188, _displayed_text, _scale, _scale, 0, _color, _color, _color, _color, 1.0);

    // Continue Prompt
    if (typewriter_complete) {
        if (sprite_exists(spr_dialogue_continue_btn)) {
            var _btn_spd  = sprite_get_speed(spr_dialogue_continue_btn);
            var _btn_type = sprite_get_speed_type(spr_dialogue_continue_btn);
            var _subimg   = (_btn_type == spritespeed_framespersecond)
                ? (get_timer() / 1000000) * _btn_spd
                : (get_timer() / 1000000) * (game_get_speed(gamespeed_fps) * _btn_spd);
            _subimg = _subimg % max(1, sprite_get_number(spr_dialogue_continue_btn));

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

if (font_exists(fnt_bitmap)) {
    draw_set_font(fnt_bitmap);
}

draw_set_alpha(1.0);
draw_set_color(c_white);

// ==========================================
// 6. SLIDING MUSIC TOAST NOTIFICATION
// ==========================================
if (array_length(ost_playlist) > 0 && toast_y > -35) {
    var _safe_track = clamp(current_track_index, 0, array_length(ost_playlist) - 1);
    var _track = ost_playlist[_safe_track];
    var _track_title = struct_exists(_track, "title") ? _track.title : "";
    var _track_composer = struct_exists(_track, "composer") ? _track.composer : "";
    
    var _main_str = "NOW PLAYING: " + _track_title;
    var _has_composer = (_track_composer != "");
    var _sub_str = _has_composer ? ("COMPOSER: " + _track_composer) : "";

    var _padding_x = 8;
    var _padding_y = 5;
    var _text_w = string_width(_main_str);
    if (_has_composer) {
        _text_w = max(_text_w, string_width(_sub_str));
    }
    var _toast_w = _text_w + (_padding_x * 2);
    var _toast_h = _has_composer ? 30 : 20;

    var _toast_x2 = _gui_w - 8;
    var _toast_x1 = _toast_x2 - _toast_w;
    var _toast_y1 = toast_y;
    var _toast_y2 = _toast_y1 + _toast_h;

    draw_set_alpha(0.80);
    draw_set_color(c_black);
    draw_rectangle(_toast_x1, _toast_y1, _toast_x2, _toast_y2, false);

    draw_set_alpha(0.90);
    draw_set_color(c_aqua);
    draw_rectangle(_toast_x1, _toast_y1, _toast_x1 + 2, _toast_y2, false);

    draw_set_alpha(1.0);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_text_color(_toast_x1 + _padding_x, _toast_y1 + _padding_y, _main_str, c_yellow, c_yellow, c_white, c_white, 1);
    if (_has_composer) {
        draw_text_color(_toast_x1 + _padding_x, _toast_y1 + _padding_y + 10, _sub_str, c_gray, c_gray, c_silver, c_silver, 0.75);
    }
}

// ==========================================
// 7. VERSION NUMBER (HIDDEN DURING DIALOGUE)
// ==========================================
if (!(fade_state == 2 && in_dialogue)) {
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);

    var _margin = 8;
    var _ver_shadow_offset = 1;

    draw_text_color(
        _gui_w - _margin + _ver_shadow_offset, 
        _gui_h - _margin + _ver_shadow_offset, 
        game_version, 
        c_black, c_black, c_black, c_black, 
        0.8
    );

    draw_text_color(
        _gui_w - _margin, 
        _gui_h - _margin, 
        game_version, 
        c_gray, c_gray, c_white, c_white, 
        0.8
    );
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);
if (font_exists(fnt_bitmap)) draw_set_font(fnt_bitmap);

// ==========================================
// 8. SCREEN FADE OVERLAY
// ==========================================
if (fade_alpha > 0) {
    scr_draw_transition_overlay(fade_alpha, _gui_w, _gui_h);
}
