/// @description Render Sonic-Style Level Complete & Score Toll HUD

if (activated) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    // Font Configuration
    if (asset_get_index("fnt_bitmap") != -1) {
        draw_set_font(fnt_bitmap);
    }

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Title Text Render
    draw_set_color(c_yellow);
    draw_text(_gw * 0.5, _gh * 0.3, "STAGE CLEAR!");

    // Score Toll Card Render
    draw_set_color(c_white);
    draw_text(_gw * 0.5, _gh * 0.45, "SCORE: " + string(tallied_score));
    draw_text(_gw * 0.5, _gh * 0.55, "TOTAL: " + string(tally_counter));

    // Reset Draw Alignment States
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // -----------------------------------------------------------------------------
    // POST-TALLY DELAY & FAST FADE-OUT OVERLAY
    // -----------------------------------------------------------------------------
    if (tally_finished) {
        var _delay    = variable_instance_exists(id, "fade_delay") ? fade_delay : 160;
        var _duration = variable_instance_exists(id, "fade_duration") ? fade_duration : 120;
        var _timer    = variable_instance_exists(id, "fade_timer") ? fade_timer : 0;

        // Calculate alpha strictly after the delay threshold is passed
        var _alpha = 0.0;
        if (_timer > _delay) {
            _alpha = clamp((_timer - _delay) / _duration, 0.0, 1.0);
        }

        // Draw black overlay over GUI
        if (_alpha > 0.0) {
            draw_set_alpha(_alpha);
            draw_set_color(c_black);
            draw_rectangle(0, 0, _gw, _gh, false);
            
            // Reset draw alpha state
            draw_set_alpha(1.0);
        }
    }
}