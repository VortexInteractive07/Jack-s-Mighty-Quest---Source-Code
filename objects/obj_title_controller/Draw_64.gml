/// @description Draw Title GUI, Modern Dialogue Banner, & Compact Music Toast

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

// Set default font if present
if (asset_get_index("fnt_bitmap") != -1) {
    draw_set_font(fnt_bitmap);
}

var _gold = make_color_rgb(255, 215, 0);

// ==========================================
// 2. DRAW SPLASH TEXT (WITH DROP SHADOW)
// ==========================================
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _splash_x = _gui_w * 0.50;
var _splash_y = _gui_h * 0.54;

if (splash_current_str != "") {
    var _shadow_offset = 2;

    // Drop Shadow
    draw_text_transformed_color(
        _splash_x + _shadow_offset, 
        _splash_y + _shadow_offset, 
        splash_current_str, 
        1, 1, 
        splash_angle, 
        c_black, c_black, c_black, c_black, 
        0.85
    );

    // Main Yellow/Gold Text
    draw_text_transformed_color(
        _splash_x, 
        _splash_y, 
        splash_current_str, 
        1, 1, 
        splash_angle, 
        c_yellow, c_yellow, _gold, _gold, 
        1
    );
}

// ==========================================
// 3. FLASHING "PRESS START" PROMPT (STATE 1 ONLY)
// ==========================================
if (show_start_text && fade_state == 1) {
    var _prompt_y = _gui_h * 0.74;
    var _prompt_text = "- PRESS ENTER TO START -";

    draw_text_color(_splash_x + 1, _prompt_y + 1, _prompt_text, c_black, c_black, c_black, c_black, 1);
    draw_text_color(_splash_x, _prompt_y, _prompt_text, c_white, c_white, c_white, c_white, 1);
}

// ==========================================
// 4. MODERNIZED OVERLAY DIALOGUE (STATE 2 ONLY)
// ==========================================
if (fade_state == 2 && in_dialogue && array_length(dialogue_lines) > 0) {
    var _safe_index = min(dialogue_index, array_length(dialogue_lines) - 1);
    var _banner_w = _gui_w * 0.90;
    var _banner_h = 58;
    var _banner_x1 = (_gui_w - _banner_w) / 2;
    var _banner_y1 = _gui_h - _banner_h - 14;
    var _banner_x2 = _banner_x1 + _banner_w;
    var _banner_y2 = _banner_y1 + _banner_h;

    // Sleek Background Panel
    draw_set_alpha(0.85);
    draw_set_color(c_black);
    draw_rectangle(_banner_x1, _banner_y1, _banner_x2, _banner_y2, false);

    // Minimal Modern Cyan Accent Strip (Left Side)
    draw_set_alpha(1.0);
    draw_set_color(c_aqua);
    draw_rectangle(_banner_x1, _banner_y1, _banner_x1 + 3, _banner_y2, false);

    // Subtle Outer Frame
    draw_set_alpha(0.3);
    draw_rectangle(_banner_x1, _banner_y1, _banner_x2, _banner_y2, true);

    // Speaker Tag & Text Render
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // Safety fallback for speaker variable
    var _current_line = dialogue_lines[_safe_index];
    var _speaker = struct_exists(_current_line, "speaker") ? _current_line.speaker : "";
    
    // Speaker Tag (Bold Cyan/White Highlight)
    if (_speaker != "") {
        draw_text_color(_banner_x1 + 12, _banner_y1 + 6, _speaker, c_aqua, c_aqua, c_white, c_white, 1);
    }
    
    // Line Separator & Body Text (Separation set to 13px for clean multi-line wrapping)
    var _body_y = (_speaker != "") ? (_banner_y1 + 20) : (_banner_y1 + 10);
    var _line_sep = 13;
    var _max_width = _banner_w - 24;

    draw_text_ext_color(
        _banner_x1 + 12, 
        _body_y, 
        dialogue_current_text, 
        _line_sep, 
        _max_width, 
        c_white, c_white, c_white, c_white, 
        1
    );

    // Modern Minimalist Prompt
    draw_set_halign(fa_right);
    draw_text_color(_banner_x2 - 10, _banner_y2 - 12, "[ENTER >]", c_silver, c_silver, c_gray, c_gray, 0.8);
}

// ==========================================
// 5. SLIDING MUSIC TOAST NOTIFICATION (WITH COMPOSER SUPPORT)
// ==========================================
if (array_length(ost_playlist) > 0 && toast_y > -35) {
    var _safe_track = min(current_track_index, array_length(ost_playlist) - 1);
    var _track = ost_playlist[_safe_track];
    var _track_title = _track.title;
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

    // Toast Panel
    draw_set_alpha(0.80);
    draw_set_color(c_black);
    draw_rectangle(_toast_x1, _toast_y1, _toast_x2, _toast_y2, false);

    // Left Border Accent
    draw_set_alpha(0.9);
    draw_set_color(c_aqua);
    draw_rectangle(_toast_x1, _toast_y1, _toast_x1 + 2, _toast_y2, false);

    // Render Toast Text
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_text_color(_toast_x1 + _padding_x, _toast_y1 + _padding_y, _main_str, c_yellow, c_yellow, c_white, c_white, 1);
    if (_has_composer) {
        draw_text_color(_toast_x1 + _padding_x, _toast_y1 + _padding_y + 10, _sub_str, c_gray, c_gray, c_silver, c_silver, 0.75);
    }
}

// ==========================================
// 6. VERSION NUMBER (WITH DROP SHADOW)
// ==========================================
draw_set_halign(fa_right);
draw_set_valign(fa_bottom);

var _margin = 8;
var _ver_shadow_offset = 1;

// Drop Shadow
draw_text_color(
    _gui_w - _margin + _ver_shadow_offset, 
    _gui_h - _margin + _ver_shadow_offset, 
    game_version, 
    c_black, c_black, c_black, c_black, 
    0.8
);

// Main Version Text
draw_text_color(
    _gui_w - _margin, 
    _gui_h - _margin, 
    game_version, 
    c_gray, c_gray, c_white, c_white, 
    0.8
);

// Reset Alignments
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// ==========================================
// 7. SCREEN FADE OVERLAY
// ==========================================
if (fade_alpha > 0) {
    draw_set_alpha(fade_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    
    draw_set_color(c_white);
    draw_set_alpha(1);
}