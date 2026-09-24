/// @description Render Sonic-Style Level Complete & Score Toll HUD

if (activated) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    // Primitive helper for slanted arcade banners
    var _draw_slanted_box = function(_x, _y, _w, _h, _skew, _color) {
        draw_primitive_begin(pr_trianglestrip);
        draw_set_color(_color);
        draw_vertex(_x + _skew, _y);
        draw_vertex(_x, _y + _h);
        draw_vertex(_x + _w + _skew, _y);
        draw_vertex(_x + _w, _y + _h);
        draw_primitive_end();
    };

    draw_set_font(fnt_bitmap);

    // Easing Slide-In Offsets
    var _slide_offset = (1.0 - card_slide) * _gw;
    
    // --- STAGE CLEAR BANNER ---
    var _banner_w = 180;
    var _banner_h = 24;
    var _banner_x = (_gw / 2) - (_banner_w / 2) + _slide_offset;
    var _banner_y = 40;

    // Banner Shadow & Plate
    _draw_slanted_box(_banner_x + 2, _banner_y + 2, _banner_w, _banner_h, banner_skew, c_black);
    _draw_slanted_box(_banner_x, _banner_y, _banner_w, _banner_h, banner_skew, make_color_rgb(255, 200, 0));

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Stage Clear Title Text
    draw_set_color(c_black);
    draw_text(_banner_x + (_banner_w / 2) + banner_skew + 1, _banner_y + (_banner_h / 2) + 1, "STAGE CLEAR!");
    draw_set_color(c_white);
    draw_text(_banner_x + (_banner_w / 2) + banner_skew, _banner_y + (_banner_h / 2), "STAGE CLEAR!");

    // --- SCORE CARD CONTAINER ---
    var _card_w = 160;
    var _card_h = 56;
    var _card_x = (_gw / 2) - (_card_w / 2) - _slide_offset;
    var _card_y = 80;

    // Card Shadow & Backplate
    _draw_slanted_box(_card_x + 2, _card_y + 2, _card_w, _card_h, banner_skew, c_black);
    _draw_slanted_box(_card_x, _card_y, _card_w, _card_h, banner_skew, make_color_rgb(16, 20, 36));

    // Pad score strings to 6 digits
    var _rem_str = string(tallied_score);
    while (string_length(_rem_str) < 6) _rem_str = "0" + _rem_str;

    var _tot_str = string(tally_counter);
    while (string_length(_tot_str) < 6) _tot_str = "0" + _tot_str;

    // Remaining Score Line
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var _line1_y = _card_y + 12;
    draw_set_color(c_black);
    draw_text(_card_x + 17, _line1_y + 1, "BONUS:");
    draw_text(_card_x + 87, _line1_y + 1, _rem_str);

    draw_set_color(make_color_rgb(180, 200, 220));
    draw_text(_card_x + 16, _line1_y, "BONUS:");
    draw_set_color(c_white);
    draw_text(_card_x + 86, _line1_y, _rem_str);

    // Total Score Line
    var _line2_y = _card_y + 32;
    draw_set_color(c_black);
    draw_text(_card_x + 17, _line2_y + 1, "TOTAL:");
    draw_text(_card_x + 87, _line2_y + 1, _tot_str);

    draw_set_color(make_color_rgb(180, 200, 220));
    draw_text(_card_x + 16, _line2_y, "TOTAL:");
    draw_set_color(make_color_rgb(255, 220, 0));
    draw_text(_card_x + 86, _line2_y, _tot_str);

    // Reset alignment defaults
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // -----------------------------------------------------------------------------
    // POST-TALLY FAST FADE-OUT OVERLAY
    // -----------------------------------------------------------------------------
    if (tally_finished) {
        var _alpha = 0.0;
        if (fade_timer > fade_delay) {
            _alpha = clamp((fade_timer - fade_delay) / fade_duration, 0.0, 1.0);
        }

        if (_alpha > 0.0) {
            draw_set_alpha(_alpha);
            draw_set_color(c_black);
            draw_rectangle(0, 0, _gw, _gh, false);
            draw_set_alpha(1.0);
        }
    }
}