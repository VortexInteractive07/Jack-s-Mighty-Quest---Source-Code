/// @description Controller HUD, Pause Overlay, Timer Display, Screen Fade, & Debug Display

// Determine if current room is non-gameplay to suppress gameplay HUD overlays
var _is_non_gameplay_room = (room == room_first) || 
                            (string_pos("splash", string_lower(room_get_name(room))) > 0) || 
                            (string_pos("title", string_lower(room_get_name(room))) > 0) || 
                            (string_pos("menu", string_lower(room_get_name(room))) > 0) || 
                            (string_pos("intro", string_lower(room_get_name(room))) > 0);

// Store render pipeline state to restore afterwards
var _prev_font   = draw_get_font();
var _prev_color  = draw_get_color();
var _prev_alpha  = draw_get_alpha();
var _prev_halign = draw_get_halign();
var _prev_valign = draw_get_valign();

// Set target font
if (font_exists(fnt_bitmap)) {
    draw_set_font(fnt_bitmap);
}

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// -----------------------------------------------------------------------------
// 1. GAMEPLAY HUD (STATS, LIVES, & ASCENDING CLOCK)
// -----------------------------------------------------------------------------
if (!_is_non_gameplay_room && !game_paused) {
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    // Score Shadow & Text
    draw_set_color(c_black);
    draw_text(9, 9, "SCORE: " + string(game_score));
    draw_set_color(c_yellow);
    draw_text(8, 8, "SCORE: " + string(game_score));
    
    // Lives Indicator
    draw_set_color(c_black);
    draw_text(9, 21, "LIVES: " + string(player_lives));
    draw_set_color(c_white);
    draw_text(8, 20, "LIVES: " + string(player_lives));
    
    // Clock Calculations (MM:SS)
    var _total_sec = floor(game_timer_ticks / game_get_speed(gamespeed_fps));
    var _mins      = _total_sec div 60;
    var _secs      = _total_sec mod 60;
    
    var _min_str   = (_mins < 10) ? "0" + string(_mins) : string(_mins);
    var _sec_str   = (_secs < 10) ? "0" + string(_secs) : string(_secs);
    var _clock_str = "TIME: " + _min_str + ":" + _sec_str;
    
    // Draw Ascending Clock
    var _clock_color = (_total_sec >= max_time_seconds - 30) ? c_red : c_white;
    
    draw_set_color(c_black);
    draw_text(9, 33, _clock_str);
    draw_set_color(_clock_color);
    draw_text(8, 32, _clock_str);
}

// -----------------------------------------------------------------------------
// 2. PAUSE SCREEN OVERLAY
// -----------------------------------------------------------------------------
if (!_is_non_gameplay_room && game_paused) {
    // Darken Background
    draw_set_alpha(0.65);
    draw_rectangle_color(0, 0, _gw, _gh, c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1.0);
    
    // Pause Banner Framing
    var _box_w = 140;
    var _box_h = 40;
    var _bx1 = (_gw / 2) - (_box_w / 2);
    var _by1 = (_gh / 2) - (_box_h / 2);
    var _bx2 = _bx1 + _box_w;
    var _by2 = _by1 + _box_h;
    
    draw_rectangle_color(_bx1, _by1, _bx2, _by2, c_dkgray, c_black, c_black, c_dkgray, false);
    draw_rectangle_color(_bx1, _by1, _bx2, _by2, c_white, c_white, c_white, c_white, true);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    draw_set_color(c_black);
    draw_text((_gw / 2) + 1, (_gh / 2) + 1, "- PAUSED -");
    draw_set_color(c_yellow);
    draw_text(_gw / 2, _gh / 2, "- PAUSED -");
}

// -----------------------------------------------------------------------------
// 3. DEBUG OVERLAY
// -----------------------------------------------------------------------------
if (show_debug_overlay_custom) {
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
    
    var _fps_str  = "FPS: " + string(fps) + " / " + string(fps_real);
    var _room_str = "ROOM: " + room_get_name(room);
    var _inst_str = "INSTANCES: " + string(instance_count);
    
    draw_set_color(c_black);
    draw_text(_gw - 7, 7, _fps_str);
    draw_text(_gw - 7, 19, _room_str);
    draw_text(_gw - 7, 31, _inst_str);
    
    draw_set_color(c_lime);
    draw_text(_gw - 8, 6, _fps_str);
    draw_text(_gw - 8, 18, _room_str);
    draw_text(_gw - 8, 30, _inst_str);
}

// -----------------------------------------------------------------------------
// 4. SCREEN TRANSITION FADE LAYER
// -----------------------------------------------------------------------------
if (fade_alpha > 0) {
    draw_set_alpha(fade_alpha);
    draw_rectangle_color(0, 0, _gw, _gh, fade_color, fade_color, fade_color, fade_color, false);
    draw_set_alpha(1.0);
}

// Restore GPU pipeline state
draw_set_font(_prev_font);
draw_set_color(_prev_color);
draw_set_alpha(_prev_alpha);
draw_set_halign(_prev_halign);
draw_set_valign(_prev_valign);