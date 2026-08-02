/// @description Render Custom Option Matrix
var _view_w = 320;
var _view_h = 240;
var _shadow = 1;

// 1. Draw Background Layer (Stretched cleanly to 320x240)
if (sprite_exists(spr_bg_menu)) {
    draw_sprite_stretched(spr_blank, 0, 0, 0, _view_w, _view_h);
} else {
    draw_clear(make_color_rgb(20, 20, 40)); // Elegant deep space fallback fill
}

// 2. Configure Header Typography
draw_set_halign(fa_center);
draw_set_valign(fa_top);
if (font_exists(fnt_bit)) draw_set_font(fnt_bit);

var _header_x = floor(_view_w / 2);
var _header_y = floor(20);

// Header Shadow + Text
draw_set_color(c_black);
draw_text(_header_x + _shadow, _header_y + _shadow, "CONFIGURATION SETUP");
draw_set_color(c_yellow);
draw_text(_header_x, _header_y, "CONFIGURATION SETUP");

// 3. Render Options Options Matrix
var _menu_start_y = 65;
var _spacing = 28;
var _label_x = 40;
var _value_x = 200;

draw_set_halign(fa_left);

for (var i = 0; i < total_options; i++) {
    var _draw_y = floor(_menu_start_y + (i * _spacing));
    
    // Pick selection highlight colors
    var _text_color = c_white;
    if (i == current_selection) {
        _text_color = c_yellow;
        
        // Draw selection cursor arrow shorthand
        draw_set_color(c_black);
        draw_text(_label_x - 16 + _shadow, _draw_y + _shadow, ">");
        draw_set_color(c_yellow);
        draw_text(_label_x - 16, _draw_y, ">");
    }
    
    // Draw the option name label
    draw_set_color(c_black);
    draw_text(_label_x + _shadow, _draw_y + _shadow, options_menu[i]);
    draw_set_color(_text_color);
    draw_text(_label_x, _draw_y, options_menu[i]);
    
    // --- Render Context Values ---
    var _val_string = "";
    var _ticks = 0; // Declared once safely outside the switch cases

    switch (i) {
        case 0: // SFX Bar Build
            _ticks = floor(global.settings.sfx_volume * 10);
            _val_string = "[" + string_repeat("|", _ticks) + string_repeat(".", 10 - _ticks) + "]";
            break;
            
        case 1: // Music Bar Build
            _ticks = floor(global.settings.mus_volume * 10);
            _val_string = "[" + string_repeat("|", _ticks) + string_repeat(".", 10 - _ticks) + "]";
            break;
            
        case 2: // Display mode text mapping
            _val_string = global.settings.fullscreen ? "FULLSCREEN" : "WINDOWED";
            break;
            
        case 3: // Speed rating values mapping
            if (global.settings.text_speed == 0.5) _val_string = "SLOW";
            if (global.settings.text_speed == 1.0) _val_string = "NORMAL";
            if (global.settings.text_speed == 1.5) _val_string = "FAST";
            if (global.settings.text_speed == 2.0) _val_string = "INSTANT";
            break;
    }
    
    // Render dynamic value parameters directly opposite labels
    if (i != 4) {
        draw_set_color(c_black);
        draw_text(_value_x + _shadow, _draw_y + _shadow, _val_string);
        draw_set_color(_text_color);
        draw_text(_value_x, _draw_y, _val_string);
    }
}