/// @description Draw Clean Pixel-Art HUD & Pause Menu

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

draw_set_font(fnt_bitmap);

// Helper function: Clean solid slanted banner for pixel art UI
var _draw_flat_slanted_banner = function(_x, _y, _w, _h, _skew, _col) {
    draw_primitive_begin(pr_trianglestrip);
    draw_set_color(_col);
    draw_vertex(_x + _skew, _y);
    draw_vertex(_x, _y + _h);
    draw_vertex(_x + _w + _skew, _y);
    draw_vertex(_x + _w, _y + _h);
    draw_primitive_end();
};

// ============================================================================
// 1. CLEAN PIXEL-PERFECT HUD
// ============================================================================
if (pause_slide < 1.0 && !is_game_over) {
    var _hud_alpha = 1.0 - pause_slide;
    draw_set_alpha(_hud_alpha);
    
    // --- HEALTH GAUGE ---
    var _max_hp = 100;
    if (instance_exists(obj_jack) && variable_instance_exists(obj_jack, "max_hp")) {
        _max_hp = max(1, obj_jack.max_hp);
    }
    
    var _hp_tag_x  = 8;
    var _hp_tag_y  = 8;
    var _bar_x     = 30;
    var _bar_y     = 8;
    var _bar_w     = 72;
    var _bar_h     = 10;
    var _bar_skew  = 8;
    
    var _ratio_curr  = clamp(hp_visual_current / _max_hp, 0, 1);
    var _ratio_catch = clamp(hp_visual_catchup / _max_hp, 0, 1);
    
    // HP Text Badge Backplate
    _draw_flat_slanted_banner(_hp_tag_x + 1, _hp_tag_y + 1, 20, _bar_h, _bar_skew, c_black);
    _draw_flat_slanted_banner(_hp_tag_x, _hp_tag_y, 20, _bar_h, _bar_skew, make_color_rgb(0, 140, 200));
    
    // HP Text Label inside Badge
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_black);
    draw_text(_hp_tag_x + 11, _hp_tag_y + (_bar_h / 2) + 1, "HP");
    draw_set_color(c_white);
    draw_text(_hp_tag_x + 10, _hp_tag_y + (_bar_h / 2), "HP");

    // Health Bar Frame Shadow
    _draw_flat_slanted_banner(_bar_x + 1, _bar_y + 1, _bar_w, _bar_h, _bar_skew, c_black);
    // Dark Backplate
    _draw_flat_slanted_banner(_bar_x, _bar_y, _bar_w, _bar_h, _bar_skew, make_color_rgb(16, 20, 30));
    
    // Catchup Damage Trail
    if (_ratio_catch > 0) {
        _draw_flat_slanted_banner(_bar_x + 1, _bar_y + 1, max(1, (_bar_w - 2) * _ratio_catch), _bar_h - 2, _bar_skew, make_color_rgb(200, 40, 40));
    }
    
    // Primary Health Bar
    if (_ratio_curr > 0) {
        var _hp_col = _ratio_curr > 0.3 ? make_color_rgb(0, 220, 120) : make_color_rgb(240, 50, 50);
        _draw_flat_slanted_banner(_bar_x + 1, _bar_y + 1, max(1, (_bar_w - 2) * _ratio_curr), _bar_h - 2, _bar_skew, _hp_col);
    }

    // --- LIVES BADGE ---
    var _life_x = 110;
    var _life_y = 8;
    _draw_flat_slanted_banner(_life_x + 1, _life_y + 1, 28, _bar_h, 6, c_black);
    _draw_flat_slanted_banner(_life_x, _life_y, 28, _bar_h, 6, make_color_rgb(32, 40, 60));
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(255, 220, 0));
    draw_text(_life_x + 16, _life_y + (_bar_h / 2), "x" + string(player_lives));

    // --- COLLECTIBLE READOUT ---
    draw_set_color(make_color_rgb(120, 240, 255));
    draw_text(_life_x + 42, _life_y + (_bar_h / 2), "G" + string(collectibles_collected));

    if (global.arcade_mode) {
        draw_set_halign(fa_left);
        draw_set_color(make_color_rgb(255, 220, 0));
        draw_text(8, 26, "CREDITS " + string(global.arcade_credits));
    }

    // --- SCORE READOUT ---
    var _score_str = string(game_score);
    while (string_length(_score_str) < 6) _score_str = "0" + _score_str;
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    var _score_label = "SCORE ";
    var _total_score_w = string_width(_score_label) + string_width(_score_str);
    var _score_start_x = _gui_w - _total_score_w - 8;
    var _score_y = 8;
    
    // Shadow Pass
    draw_set_color(c_black);
    draw_text(_score_start_x + 1, _score_y + 1, _score_label);
    draw_text(_score_start_x + string_width(_score_label) + 1, _score_y + 1, _score_str);
    
    // Color Pass
    draw_set_color(c_white);
    draw_text(_score_start_x, _score_y, _score_label);
    draw_set_color(make_color_rgb(255, 230, 0));
    draw_text(_score_start_x + string_width(_score_label), _score_y, _score_str);

    // --- TIMER READOUT ---
    var _total_sec = game_timer_ticks / game_get_speed(gamespeed_fps);
    var _mins      = floor(_total_sec / 60);
    var _secs      = floor(_total_sec % 60);
    var _time_str  = string(_mins) + ":" + (_secs < 10 ? "0" : "") + string(_secs);
    
    var _time_col = (_total_sec > (max_time_seconds - 60)) ? ((floor(game_timer_ticks / 15) % 2 == 0) ? c_red : c_yellow) : c_white;
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_black);
    draw_text((_gui_w / 2) + 1, _score_y + 1, _time_str);
    draw_set_color(_time_col);
    draw_text(_gui_w / 2, _score_y, _time_str);

    draw_set_alpha(1.0);
}

// ============================================================================
// 2. SONIC MANIA STYLE PAUSE MENU
// ============================================================================
if (pause_slide > 0.0) {
    var _ease_slide = power(pause_slide, 0.5);
    
    draw_set_color(make_color_rgb(10, 12, 28));
    draw_set_alpha(0.75 * _ease_slide);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    
    var _bg_offset = (1.0 - _ease_slide) * 200;
    _draw_flat_slanted_banner(-40 - _bg_offset, 0, 140, _gui_h, 40, make_color_rgb(0, 90, 180));
    _draw_flat_slanted_banner(80 - _bg_offset, 0, 14, _gui_h, 40, make_color_rgb(255, 200, 0));
    
    var _head_x = 20 - ((1.0 - _ease_slide) * 150);
    var _head_y = 20;
    
    _draw_flat_slanted_banner(_head_x - 1, _head_y - 1, 92, 22, 10, c_black);
    _draw_flat_slanted_banner(_head_x, _head_y, 90, 20, 10, make_color_rgb(255, 200, 0));
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(c_black);
    draw_text(_head_x + 14, _head_y + 11, "PAUSED");
    draw_set_color(c_white);
    draw_text(_head_x + 13, _head_y + 10, "PAUSED");

    var _start_y = 60;
    var _spacing = 24;
    
    for (var i = 0; i < pause_options_count; i++) {
        var _item_slide = clamp((_ease_slide * 1.5) - (i * 0.15), 0, 1);
        var _option_x   = 28 - ((1.0 - _item_slide) * 220);
        var _option_y   = _start_y + (i * _spacing);
        var _is_sel     = (i == pause_option);
        
        var _box_w = _is_sel ? 130 : 110;
        var _box_h = 18;
        var _skew  = 8;
        
        _draw_flat_slanted_banner(_option_x + 1, _option_y + 1, _box_w, _box_h, _skew, c_black);
        
        if (_is_sel) {
            var _c1 = make_color_rgb(255, 200, 0);
            _draw_flat_slanted_banner(_option_x, _option_y, _box_w, _box_h, _skew, _c1);
            
            draw_set_color(c_white);
            draw_primitive_begin(pr_trianglelist);
            draw_vertex(_option_x - 8, _option_y + 4);
            draw_vertex(_option_x - 2, _option_y + 9);
            draw_vertex(_option_x - 8, _option_y + 14);
            draw_primitive_end();
            
            draw_set_color(c_black);
            draw_text(_option_x + 12, _option_y + 9, pause_labels[i]);
        } else {
            _draw_flat_slanted_banner(_option_x, _option_y, _box_w, _box_h, _skew, make_color_rgb(18, 24, 42));
            
            draw_set_color(make_color_rgb(180, 200, 230));
            draw_text(_option_x + 10, _option_y + 9, pause_labels[i]);
        }
    }
    
    draw_set_alpha(1.0);
}

// ============================================================================
// 3. GAME OVER OVERLAY
// ============================================================================
if (is_game_over) {
    draw_set_color(c_black);
    draw_set_alpha(0.85);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    
    draw_set_alpha(1.0);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    _draw_flat_slanted_banner((_gui_w / 2) - 80, (_gui_h / 2) - 16, 160, 32, 12, make_color_rgb(160, 20, 20));
    
    draw_set_color(c_black);
    draw_text((_gui_w / 2) + 1, (_gui_h / 2) + 1, "GAME OVER");
    draw_set_color(c_white);
    draw_text(_gui_w / 2, _gui_h / 2, "GAME OVER");

    draw_set_color(c_yellow);
    draw_text(_gui_w / 2, (_gui_h / 2) + 26, "PRESS START TO CONTINUE");
    draw_set_color(c_aqua);
    draw_text(_gui_w / 2, (_gui_h / 2) + 40, "ESC: TITLE");
    if (global.arcade_mode && global.arcade_credits <= 0) {
        draw_set_color(c_red);
        draw_text(_gui_w / 2, (_gui_h / 2) + 54, "NO CREDITS - INSERT COIN AT TITLE");
    }
}

// ============================================================================
// 4. TRANSITION FADE OVERLAY
// ============================================================================
if (fade_alpha > 0.0) {
    draw_set_color(fade_color);
    draw_set_alpha(fade_alpha);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1.0);
}

// Reset Alignments
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);