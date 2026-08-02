// Render the message if visible
if (is_visible) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Draw a dark background box for readability
    draw_set_color(c_black);
    draw_rectangle(80, 100, 240, 140, false);
    
    // Draw the text
    draw_set_color(c_white);
    if (font_exists(fnt_menu_options)) draw_set_font(fnt_menu_options);
    draw_text(160, 120, display_text);
}