/// @description Draw Programmatic Retro Splash Interface with Bitmap Font

// Only draw the overlay after activation has been triggered
if (activated) {
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();

    // 1. Draw a smooth dark background overlay
    draw_set_color(c_black);
    draw_set_alpha(alpha * 0.9);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);

    // Setup text alignment and custom font
    draw_set_alpha(alpha);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_bitmap);

    // 2. Draw Retro Drop-Shadow Header Text
    draw_set_color(c_navy);
    draw_text_transformed(_gui_w / 2 + 4, (_gui_h / 2) - 60 + 4, "DEMO COMPLETE", 2.5, 2.5, 0);

    // Draw Main Glowing Header with subtle organic scale pulse
    var _scale_pulse = 2.5 + (sin(pulse_timer) * 0.04);
    draw_set_color(c_yellow);
    draw_text_transformed(_gui_w / 2, (_gui_h / 2) - 60, "DEMO COMPLETE", _scale_pulse, _scale_pulse, 0);

    // 3. Subtext / Flavor Description
    draw_set_color(c_white);
    draw_text_transformed(_gui_w / 2, (_gui_h / 2) + 10, "Thank you for playing the Vortex Interactive build!", 1.1, 1.1, 0);
    draw_set_color(c_ltgray);
    draw_text_transformed(_gui_w / 2, (_gui_h / 2) + 40, "All systems operational. Stay tuned for the full release.", 0.9, 0.9, 0);

    // 4. Blinking Arcade-Style Prompt to Continue
    if ((current_time div 400) % 2 == 0) {
        draw_set_color(c_lime);
        draw_text_transformed(_gui_w / 2, (_gui_h / 2) + 110, "PRESS [ S ] OR [ ENTER ] TO RETURN", 1.0, 1.0, 0);
    }

    // Clean up draw states to avoid bleeding into other instances
    draw_set_font(-1); // Resets font to default (optional, good practice)
    draw_set_alpha(1.0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}