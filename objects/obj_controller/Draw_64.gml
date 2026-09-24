/// @description Draw SMB1 Retro Pixel HUD & Pause Menu (GM LTS 2026)

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

draw_set_font(fnt_bitmap);

// ============================================================================
// 1. CLASSIC SMB1 NES HUD
// ============================================================================
if (pause_slide < 1.0 && !is_game_over) {
    var _hud_alpha = 1.0 - pause_slide;
    draw_set_alpha(_hud_alpha);
    
    // HUD Layout Columns
    var _col1_x = 16;   // JACK x03 / SCORE / ASCII HP
    var _col2_x = 128;  // COIN ICON + COUNT
    var _col3_x = 240;  // WORLD
    var _col4_x = 352;  // TIME
    
    var _row1_y = 8;    // JACK x03
    var _row2_y = 18;   // 000800
    var _row3_y = 28;   // HP [|||||||-]
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // --- COLUMN 1: JACK & LIVES & SCORE & ASCII HP ---
    
    // --- MECHANICAL FLIP-CLOCK LIVES RENDERING ---
    var _jack_header = "JACK x";
    
    // Draw Header Shadow + Text
    draw_set_color(c_black);
    draw_text(_col1_x + 1, _row1_y + 1, _jack_header);
    draw_set_color(c_white);
    draw_text(_col1_x, _row1_y, _jack_header);
    
    var _digit_x = _col1_x + string_width(_jack_header);
    
    // Check and update life counter change triggers
    if (player_lives != prev_player_lives) {
        flip_timer = flip_duration;
        
        var _old = string(prev_player_lives);
        if (string_length(_old) < 2) _old = "0" + _old;
        flip_old_str = _old;
        
        var _new = string(player_lives);
        if (string_length(_new) < 2) _new = "0" + _new;
        flip_new_str = _new;
        
        prev_player_lives = player_lives;
    }

    if (flip_timer <= 0) {
        // Static Digit Draw
        var _curr_str = string(player_lives);
        if (string_length(_curr_str) < 2) _curr_str = "0" + _curr_str;
        
        draw_set_color(c_black);
        draw_text(_digit_x + 1, _row1_y + 1, _curr_str);
        draw_set_color(c_white);
        draw_text(_digit_x, _row1_y, _curr_str);
    } else {
        // Active Flip Clock Animation Processing
        flip_timer--;
        var _progress = 1.0 - (flip_timer / flip_duration);
        var _char_w = string_width("00");
        var _char_h = string_height("0");
        var _half_h = floor(_char_h / 2);

        // 1. Mechanical Card Backing
        draw_set_color(c_black);
        draw_rectangle(_digit_x - 1, _row1_y - 1, _digit_x + _char_w + 1, _row1_y + _char_h + 1, false);

        // 2. Base Static Digit Display
        // Shows OLD digit before mid-flip, NEW digit after mid-flip
        var _base_str = (_progress < 0.5) ? flip_old_str : flip_new_str;
        draw_set_color(c_black);
        draw_text(_digit_x + 1, _row1_y + 1, _base_str);
        draw_set_color(c_white);
        draw_text(_digit_x, _row1_y, _base_str);

        // 3. Animated Flipping Flap Overlay
        var _scale_y = cos(_progress * pi);
        var _flip_str = (_progress < 0.5) ? flip_old_str : flip_new_str;
        var _draw_y = _row1_y + _half_h - (_half_h * _scale_y);

        // Shadow & Flap Text using cosine scale flip centered on the seam
        draw_set_color(c_black);
        draw_text_transformed(_digit_x + 1, _draw_y + 1, _flip_str, 1.0, _scale_y, 0);
        draw_set_color(c_white);
        draw_text_transformed(_digit_x, _draw_y, _flip_str, 1.0, _scale_y, 0);

        // 4. Mechanical Seam Separator Line
        draw_set_color(c_dkgray);
        draw_line(_digit_x - 1, _row1_y + _half_h, _digit_x + _char_w + 1, _row1_y + _half_h);
        draw_set_color(c_white);
    }

    // --- SCORE (6 DIGITS) ---
    var _score_str = string(game_score);
    while (string_length(_score_str) < 6) {
        _score_str = "0" + _score_str;
    }
    draw_set_color(c_black);
    draw_text(_col1_x + 1, _row2_y + 1, _score_str);
    draw_set_color(c_white);
    draw_text(_col1_x, _row2_y, _score_str);

    // --- RETRO ASCII HP COUNTER ---
    var _max_hp = 100;
    if (instance_exists(obj_jack) && variable_instance_exists(obj_jack, "max_hp")) {
        _max_hp = max(1, obj_jack.max_hp);
    }
    
    var _hp_ratio     = clamp(hp_visual_current / _max_hp, 0, 1);
    var _total_blocks = 8;
    var _filled_blocks = floor(_hp_ratio * _total_blocks);
    var _empty_blocks  = _total_blocks - _filled_blocks;
    
    var _hp_ascii = "HP [" + string_repeat("|", _filled_blocks) + string_repeat("-", _empty_blocks) + "]";
    
    var _hp_col = c_white;
    if (_hp_ratio <= 0.25) {
        _hp_col = ((floor(game_timer_ticks / 10) % 2 == 0) ? c_red : c_white);
    }
    
    draw_set_color(c_black);
    draw_text(_col1_x + 1, _row3_y + 1, _hp_ascii);
    draw_set_color(_hp_col);
    draw_text(_col1_x, _row3_y, _hp_ascii);

    // --- COLUMN 2: COINS ---
    var _coin_str = string(collectibles_collected);
    if (string_length(_coin_str) < 2) {
        _coin_str = "0" + _coin_str;
    }
    
    var _coin_w = sprite_get_width(spr_coin);
    var _coin_draw_x = _col2_x + sprite_get_xoffset(spr_coin);
    var _coin_draw_y = _row2_y + floor(string_height("X") / 2);
    
    // Draw Coin Drop-Shadow and Main Sprite
    draw_sprite_ext(spr_coin, 0, _coin_draw_x + 1, _coin_draw_y + 1, 1, 1, 0, c_black, _hud_alpha);
    draw_sprite_ext(spr_coin, 0, _coin_draw_x, _coin_draw_y, 1, 1, 0, c_white, _hud_alpha);
    
    draw_set_color(c_black);
    draw_text(_col2_x + _coin_w + 3, _row2_y + 1, "x" + _coin_str);
    draw_set_color(c_white);
    draw_text(_col2_x + _coin_w + 2, _row2_y, "x" + _coin_str);

    // --- COLUMN 3: WORLD ---
    var _world_str = variable_instance_exists(id, "world_text") ? world_text : "1-1";
    draw_set_color(c_black);
    draw_text(_col3_x + 1, _row1_y + 1, "WORLD");
    draw_text(_col3_x + 5, _row2_y + 1, _world_str);
    
    draw_set_color(c_white);
    draw_text(_col3_x, _row1_y, "WORLD");
    draw_text(_col3_x + 4, _row2_y, _world_str);

    // --- COLUMN 4: TIME ---
    var _remaining_seconds = max(0, max_time_seconds - floor(game_timer_ticks / game_get_speed(gamespeed_fps)));
    var _time_str = string(_remaining_seconds);
    while (string_length(_time_str) < 3) {
        _time_str = "0" + _time_str;
    }
    
    draw_set_color(c_black);
    draw_text(_col4_x + 1, _row1_y + 1, "TIME");
    draw_set_color(c_white);
    draw_text(_col4_x, _row1_y, "TIME");
    
    var _time_col = c_white;
    if (_remaining_seconds <= 60) {
        _time_col = ((floor(game_timer_ticks / 10) % 2 == 0) ? c_red : c_yellow);
    }
    
    draw_set_color(c_black);
    draw_text(_col4_x + 5, _row2_y + 1, _time_str);
    draw_set_color(_time_col);
    draw_text(_col4_x + 4, _row2_y, _time_str);

    // ARCADE CREDITS READOUT
    if (global.arcade_mode) {
        var _cred_str = "CREDIT " + string(global.arcade_credits);
        draw_set_color(c_black);
        draw_text(_col2_x + 1, _row3_y + 1, _cred_str);
        draw_set_color(c_yellow);
        draw_text(_col2_x, _row3_y, _cred_str);
    }

    draw_set_alpha(1.0);
}

// ============================================================================
// 2. PAUSE MENU OVERLAY
// ============================================================================
if (pause_slide > 0.0) {
    var _ease_slide = power(pause_slide, 0.5);
    
    draw_set_color(c_black);
    draw_set_alpha(0.75 * _ease_slide);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    
    draw_set_alpha(1.0);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    draw_set_color(c_black);
    draw_text((_gui_w / 2) + 1, 41, "PAUSED");
    draw_set_color(c_yellow);
    draw_text(_gui_w / 2, 40, "PAUSED");

    var _start_y = 80;
    var _spacing = 20;
    
    for (var i = 0; i < pause_options_count; i++) {
        var _option_y = _start_y + (i * _spacing);
        var _is_sel   = (i == pause_option);
        
        var _text_out = _is_sel ? ("> " + pause_labels[i] + " <") : pause_labels[i];
        var _color_out = _is_sel ? c_yellow : c_white;
        
        draw_set_color(c_black);
        draw_text((_gui_w / 2) + 1, _option_y + 1, _text_out);
        draw_set_color(_color_out);
        draw_text(_gui_w / 2, _option_y, _text_out);
    }
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
    
    draw_set_color(c_black);
    draw_text((_gui_w / 2) + 1, (_gui_h / 2) - 9, "GAME OVER");
    draw_set_color(c_red);
    draw_text(_gui_w / 2, (_gui_h / 2) - 10, "GAME OVER");
    
    draw_set_color(c_black);
    draw_text((_gui_w / 2) + 1, (_gui_h / 2) + 17, "PRESS START TO CONTINUE");
    draw_set_color(c_yellow);
    draw_text(_gui_w / 2, (_gui_h / 2) + 16, "PRESS START TO CONTINUE");
    
    if (global.arcade_mode && global.arcade_credits <= 0) {
        draw_set_color(c_black);
        draw_text((_gui_w / 2) + 1, (_gui_h / 2) + 37, "NO CREDITS - INSERT COIN AT TITLE");
        draw_set_color(c_white);
        draw_text(_gui_w / 2, (_gui_h / 2) + 36, "NO CREDITS - INSERT COIN AT TITLE");
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

// Reset Draw State
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);