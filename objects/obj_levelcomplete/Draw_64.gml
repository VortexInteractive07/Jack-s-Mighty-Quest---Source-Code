/// @description Render Modern Acrylic Victory Panel & Typewriter Text (426x240 Widescreen)

if (triggered) {
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    var _screen_cx = _gui_w / 2;
    var _screen_cy = _gui_h / 2;

    // Dialogue Box Bounds (Tuned for 426x240 Widescreen)
    var _box_w = 250; 
    var _box_h = 48;
    var _x1 = floor(_screen_cx - (_box_w / 2));
    var _y1 = floor(_screen_cy - (_box_h / 2));
    var _x2 = floor(_screen_cx + (_box_w / 2));
    var _y2 = floor(_screen_cy + (_box_h / 2));

    // 1. Dark Acrylic Background Underlay
    draw_set_alpha(alpha * 0.85); 
    draw_set_color(make_color_rgb(10, 15, 25));
    draw_roundrect_ext(_x1, _y1, _x2, _y2, 8, 8, false);

    // 2. Cyan Frame Border Accent
    draw_set_alpha(alpha * 0.90);
    draw_set_color(make_color_rgb(0, 220, 255));
    draw_roundrect_ext(_x1, _y1, _x2, _y2, 8, 8, true); 

    // 3. Typewriter Substring Extraction
    var _visible_text = string_copy(text_msg, 1, floor(draw_char_count));

    // 4. Text Rendering Engine
    draw_set_alpha(alpha);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    if (font_exists(fnt_dialogue)) {
        draw_set_font(fnt_dialogue);
    }

    var _scale = 0.65;
    var _line_sep = 14;          
    var _max_width = (_box_w - 20) / _scale; 

    // Drop Shadow
    draw_set_color(c_black);
    draw_text_ext_transformed(_screen_cx + 1, _screen_cy + 1, _visible_text, _line_sep, _max_width, _scale, _scale, 0);

    // Primary Victory Text (Bright Arcade Lime)
    draw_set_color(make_color_rgb(50, 255, 120));
    draw_text_ext_transformed(_screen_cx, _screen_cy, _visible_text, _line_sep, _max_width, _scale, _scale, 0);
    
    // Clean Draw State Reset
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}