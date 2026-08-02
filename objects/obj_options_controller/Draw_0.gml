/// @description Render Widescreen Adjusted UI (Dynamic Themes)

var _center_x = floor(view_w / 2);
var _shadow   = 1;

// Dynamic Theme Palette Resolver
var _highlight_color = color_yellow;
var _accent_color    = color_aqua;

if (global.settings.theme_index == 1) { // CYBER
    _highlight_color = make_color_rgb(0, 255, 180);
    _accent_color    = make_color_rgb(255, 0, 128);
} else if (global.settings.theme_index == 2) { // GOLD
    _highlight_color = make_color_rgb(255, 200, 80);
    _accent_color    = make_color_rgb(255, 140, 0);
}

// Dark Outer Frame
draw_rectangle_color(0, 0, view_w, view_h, 
    color_darkbg, color_darkbg, 
    color_darkbg2, color_darkbg2, false);

// Ambient Dust
draw_set_color(c_white);
for (var i = 0; i < array_length(bg_particles); i++) {
    draw_set_alpha(0.25);
    draw_circle(bg_particles[i].x, bg_particles[i].y, bg_particles[i].size, false);
}
draw_set_alpha(1.0);

// Inner Frame
draw_set_color(c_black);
draw_set_alpha(0.70);
draw_roundrect_ext(8, 4, view_w - 8, view_h - 4, 6, 6, false);
draw_set_alpha(1.0);

// Frame Border Line
draw_set_color(color_frame);
draw_roundrect_ext(8, 4, view_w - 8, view_h - 4, 6, 6, true);

// Header Typography
draw_set_halign(fa_center);
draw_set_valign(fa_top);
if (font_exists(fnt_bit)) draw_set_font(fnt_bit);

var _header_y = 8;

draw_set_color(c_black);
draw_text(_center_x + _shadow, _header_y + _shadow, "SETTINGS & CONFIGURATION");
draw_set_color(_highlight_color);
draw_text(_center_x, _header_y, "SETTINGS & CONFIGURATION");

// Divider
draw_set_color(c_dkgray);
draw_line(16, _header_y + 11, view_w - 16, _header_y + 11);

// Options Matrix Grid Layout
var _menu_start_y = 24;
var _spacing      = 15;
var _label_x      = 22;
var _value_x      = view_w - 22;

for (var i = 0; i < total_options; i++) {
    var _draw_y = floor(_menu_start_y + (i * _spacing));
    var _is_selected = (i == current_selection);
    var _text_color  = c_white;

    if (_is_selected) {
        _text_color = _highlight_color;

        // Active Option Backdrop
        draw_set_color(_highlight_color);
        draw_set_alpha(0.12);
        draw_roundrect_ext(_label_x - 8, _draw_y - 1, view_w - 14, _draw_y + 12, 3, 3, false);
        draw_set_alpha(1.0);

        // Selector Arrow
        draw_set_halign(fa_left);
        draw_set_color(_highlight_color);
        draw_text(_label_x - 12 + (sin(pulse_timer) * 1.2), _draw_y, ">");
    }

    // Render Option Label
    draw_set_halign(fa_left);
    draw_set_color(c_black);
    draw_text(_label_x + _shadow, _draw_y + _shadow, options_menu[i]);
    draw_set_color(_text_color);
    draw_text(_label_x, _draw_y, options_menu[i]);

    // Build Value String
    var _val_string = "";
    var _ticks = 0;

    switch (i) {
        case 0: // MASTER
            _ticks = floor(global.settings.master_volume * 10);
            _val_string = "[" + string_repeat("|", _ticks) + string_repeat(".", 10 - _ticks) + "] " + string(round(global.settings.master_volume * 100)) + "%";
            break;

        case 1: // SFX
            _ticks = floor(global.settings.sfx_volume * 10);
            _val_string = "[" + string_repeat("|", _ticks) + string_repeat(".", 10 - _ticks) + "] " + string(round(global.settings.sfx_volume * 100)) + "%";
            break;

        case 2: // MUSIC
            _ticks = floor(global.settings.mus_volume * 10);
            _val_string = "[" + string_repeat("|", _ticks) + string_repeat(".", 10 - _ticks) + "] " + string(round(global.settings.mus_volume * 100)) + "%";
            break;

        case 3: // DISPLAY MODE
            _val_string = global.settings.fullscreen ? "< FULLSCREEN >" : "< WINDOWED >";
            break;

        case 4: // ASPECT LOCK
            _val_string = global.settings.aspect_lock ? "< LOCKED 16:9 >" : "< STRETCHED >";
            break;

        case 5: // TEXT SPEED
            if (global.settings.text_speed == 0.5) _val_string = "< SLOW >";
            if (global.settings.text_speed == 1.0) _val_string = "< NORMAL >";
            if (global.settings.text_speed == 1.5) _val_string = "< FAST >";
            if (global.settings.text_speed == 2.0) _val_string = "< INSTANT >";
            break;

        case 6: // SCREEN SHAKE
            _val_string = global.settings.screen_shake ? "< ON >" : "< OFF >";
            break;

        case 7: // FLASH REDUCTION
            _val_string = global.settings.flash_reduction ? "< REDUCED >" : "< FULL >";
            break;

        case 8: // BACKGROUND AUDIO
            _val_string = global.settings.bg_audio ? "< ALLOW >" : "< MUTE >";
            break;

        case 9: // UI COLOR SCHEME
            if (global.settings.theme_index == 0) _val_string = "< CLASSIC >";
            if (global.settings.theme_index == 1) _val_string = "< CYBER >";
            if (global.settings.theme_index == 2) _val_string = "< GOLD >";
            break;

        case 10: // RESET DEFAULT
            _val_string = "[ RESTORE ]";
            break;

        case 11: // BACK TO MENU
            _val_string = "";
            break;
    }

    // Render Right-Aligned Values
    if (_val_string != "") {
        draw_set_halign(fa_right);
        draw_set_color(c_black);
        draw_text(_value_x + _shadow, _draw_y + _shadow, _val_string);
        draw_set_color(_is_selected ? _accent_color : color_lightgray);
        draw_text(_value_x, _draw_y, _val_string);
    }
}

// Footer Controls Instructions
draw_set_halign(fa_center);
draw_set_color(c_gray);
draw_text(_center_x, view_h - 12, "[ARROWS/WASD] Move  |  [LEFT/RIGHT] Adjust  |  [ENTER] Select");