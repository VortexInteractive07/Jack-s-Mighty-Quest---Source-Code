/// @description Render Main HUD, Speedometer, Music Toast, Title Card & Glitched Easter Egg

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _fnt = asset_get_index("fnt_dialogue");
if (_fnt != -1 && font_exists(_fnt)) draw_set_font(_fnt);
draw_set_alpha(1.0);
draw_set_valign(fa_top);

// =================================================================
// 1. RE-DESIGNED MAIN UI (HUD)
// =================================================================
if (!is_paused) {
    if (show_debug) {
        draw_set_halign(fa_center);
        var _mid_x = _gui_w / 2;
        var _panel_y = 8;
        
        var _p_obj = asset_get_index("obj_player");
        var _m_obj = asset_get_index("obj_mark");
        
        var _player_exists = (_p_obj != -1 && instance_exists(_p_obj));
        var _player_state   = _player_exists ? _p_obj.state : "N/A";
        var _player_hsp     = _player_exists ? string_format(_p_obj.hsp, 1, 2) : "0.00";
        var _player_vsp     = _player_exists ? string_format(_p_obj.vsp, 1, 2) : "0.00";
        var _mark_emotion   = (_m_obj != -1 && instance_exists(_m_obj)) ? _m_obj.emotion_state : "N/A";
        var _hp_val         = _player_exists ? _p_obj.hp : 0;
        var _hp_max         = _player_exists ? _p_obj.hp_max : 100;
        
        var _state_text = string(_player_state);
        if (_player_exists) {
            if (_p_obj.state == 0) _state_text += " (Normal)";
            if (_p_obj.state == 2) _state_text += " (Hurt)";
            if (_p_obj.state == 3) _state_text += " (Dead)";
        }
        
        draw_set_color(c_black);
        draw_set_alpha(0.85);
        draw_roundrect_ext(_mid_x - 120, _panel_y - 4, _mid_x + 120, _panel_y + 84, 8, 8, false);
        
        draw_set_color(make_color_rgb(0, 220, 255));
        draw_set_alpha(0.9);
        draw_roundrect_ext(_mid_x - 120, _panel_y - 4, _mid_x + 120, _panel_y + 84, 8, 8, true);
        draw_set_alpha(1.0);
        
        draw_set_color(c_black);
        draw_text_transformed(_mid_x + 1, _panel_y + 3, "--- DIAGNOSTICS ---", 0.65, 0.65, 0);
        draw_set_color(make_color_rgb(0, 220, 255));
        draw_text_transformed(_mid_x, _panel_y + 2, "--- DIAGNOSTICS ---", 0.65, 0.65, 0);

        draw_set_color(c_black);
        draw_text_transformed(_mid_x + 1, _panel_y + 17, "HEALTH: " + string(_hp_val) + " / " + string(_hp_max), 0.55, 0.55, 0);
        draw_set_color(c_white);
        draw_text_transformed(_mid_x, _panel_y + 16, "HEALTH: " + string(_hp_val) + " / " + string(_hp_max), 0.55, 0.55, 0);

        draw_set_color(c_black);
        draw_text_transformed(_mid_x + 1, _panel_y + 29, "PHYSICS: H:" + _player_hsp + " V:" + _player_vsp, 0.55, 0.55, 0);
        draw_set_color(c_white);
        draw_text_transformed(_mid_x, _panel_y + 28, "PHYSICS: H:" + _player_hsp + " V:" + _player_vsp, 0.55, 0.55, 0);

        draw_set_color(c_black);
        draw_text_transformed(_mid_x + 1, _panel_y + 41, "STATE MACHINE: " + _state_text, 0.55, 0.55, 0);
        draw_set_color(c_white);
        draw_text_transformed(_mid_x, _panel_y + 40, "STATE MACHINE: " + _state_text, 0.55, 0.55, 0);

        draw_set_color(c_black);
        draw_text_transformed(_mid_x + 1, _panel_y + 53, "MARK EMOTION: " + string(_mark_emotion), 0.55, 0.55, 0);
        draw_set_color(c_white);
        draw_text_transformed(_mid_x, _panel_y + 52, "MARK EMOTION: " + string(_mark_emotion), 0.55, 0.55, 0);

        draw_set_color(c_black);
        draw_text_transformed(_mid_x + 1, _panel_y + 67, "TIME TICKS: " + string(stage_time), 0.55, 0.55, 0);
        draw_set_color(c_lime);
        draw_text_transformed(_mid_x, _panel_y + 66, "TIME TICKS: " + string(stage_time), 0.55, 0.55, 0);
    } else {
        draw_set_halign(fa_left);
        
        var _hud_top_y = 6;
        if (toast_state != 0 && toast_slide_x > -100) {
            _hud_top_y = 44; 
        }

        // Left Panel (Player Status Box)
        draw_set_color(make_color_rgb(10, 14, 22));
        draw_set_alpha(0.80);
        draw_roundrect_ext(6, _hud_top_y, 172, _hud_top_y + 36, 6, 6, false);
        
        draw_set_color(make_color_rgb(0, 180, 240));
        draw_set_alpha(0.40);
        draw_roundrect_ext(6, _hud_top_y, 172, _hud_top_y + 36, 6, 6, true);
        draw_set_alpha(1.0);

        // Time Counter
        var _total_seconds = ceil(stage_time / 60);
        var _minutes = floor(_total_seconds / 60);
        var _seconds = _total_seconds % 60;
        var _min_str = (_minutes < 10) ? "0" + string(_minutes) : string(_minutes);
        var _sec_str = (_seconds < 10) ? "0" + string(_seconds) : string(_seconds);

        var _time_text = "TIME  " + _min_str + ":" + _sec_str;
        draw_set_color(c_black);
        draw_text_transformed(13, _hud_top_y + 5, _time_text, 0.50, 0.50, 0);
        draw_set_color(make_color_rgb(0, 220, 255));
        draw_text_transformed(12, _hud_top_y + 4, _time_text, 0.50, 0.50, 0);

        // Segmented Dynamic HP Bar
        var _p_obj  = asset_get_index("obj_player");
        var _hp_val = (_p_obj != -1 && instance_exists(_p_obj)) ? _p_obj.hp : 0;
        var _hp_max = (_p_obj != -1 && instance_exists(_p_obj)) ? _p_obj.hp_max : 100;
        
        hp_display_smooth = lerp(hp_display_smooth, _hp_val, 0.15);
        var _hp_percent = clamp(hp_display_smooth / _hp_max, 0.0, 1.0);
        
        var _bar_x1 = 32;
        var _bar_y1 = _hud_top_y + 20;
        var _bar_x2 = 164;
        var _bar_y2 = _hud_top_y + 29;
        var _bar_w  = _bar_x2 - _bar_x1;
        
        draw_set_color(c_black);
        draw_text_transformed(13, _hud_top_y + 19, "HP", 0.48, 0.48, 0);
        draw_set_color(c_white);
        draw_text_transformed(12, _hud_top_y + 18, "HP", 0.48, 0.48, 0);

        draw_set_color(make_color_rgb(18, 22, 32));
        draw_rectangle(_bar_x1, _bar_y1, _bar_x2, _bar_y2, false);
        
        var _bar_color = make_color_rgb(0, 230, 120); 
        if (_hp_percent <= 0.35) {
            var _pulse = (sin(pulse_timer * 4) + 1) * 0.5;
            _bar_color = merge_color(make_color_rgb(255, 30, 30), make_color_rgb(255, 160, 0), _pulse);
        } else if (_hp_percent <= 0.60) {
            _bar_color = make_color_rgb(255, 200, 0); 
        }

        if (_hp_percent > 0) {
            draw_set_color(_bar_color);
            draw_rectangle(_bar_x1, _bar_y1, _bar_x1 + (_bar_w * _hp_percent), _bar_y2, false);
            
            draw_set_color(c_white);
            draw_set_alpha(0.25);
            draw_rectangle(_bar_x1, _bar_y1, _bar_x1 + (_bar_w * _hp_percent), _bar_y1 + 2, false);
            draw_set_alpha(1.0);
        }
        
        draw_set_color(c_white);
        draw_set_alpha(0.25);
        draw_rectangle(_bar_x1, _bar_y1, _bar_x2, _bar_y2, true);
        draw_set_alpha(1.0);

        // Right Panel (Score & Lives Box)
        draw_set_halign(fa_right);
        var _right_margin = _gui_w - 6;

        draw_set_color(make_color_rgb(10, 14, 22));
        draw_set_alpha(0.80);
        draw_roundrect_ext(_right_margin - 132, 6, _right_margin, 42, 6, 6, false);
        
        draw_set_color(make_color_rgb(0, 180, 240));
        draw_set_alpha(0.40);
        draw_roundrect_ext(_right_margin - 132, 6, _right_margin, 42, 6, 6, true);
        draw_set_alpha(1.0);

        var _raw_score = string(global.player_score);
        while (string_length(_raw_score) < 7) _raw_score = "0" + _raw_score;
        
        draw_set_color(c_black);
        draw_text_transformed(_right_margin - 7, 11, "SCORE " + _raw_score, 0.52, 0.52, 0);
        draw_set_color(c_white);
        draw_text_transformed(_right_margin - 8, 10, "SCORE " + _raw_score, 0.52, 0.52, 0);

        var _raw_lives = string(clamp(global.player_lives, 0, 99));
        if (string_length(_raw_lives) < 2) _raw_lives = "0" + _raw_lives;
        
        draw_set_color(c_black);
        draw_text_transformed(_right_margin - 7, 25, "LIVES  " + _raw_lives, 0.52, 0.52, 0);
        draw_set_color(make_color_rgb(255, 215, 0));
        draw_text_transformed(_right_margin - 8, 24, "LIVES  " + _raw_lives, 0.52, 0.52, 0);

        // =================================================================
        // REAL-TIME SPEEDOMETER (Bottom Right HUD Element)
        // =================================================================
        var _spd_x2 = _gui_w - 6;
        var _spd_y2 = _gui_h - 6;
        var _spd_x1 = _spd_x2 - 82;
        var _spd_y1 = _spd_y2 - 22;

        draw_set_color(make_color_rgb(10, 14, 22));
        draw_set_alpha(0.80);
        draw_roundrect_ext(_spd_x1, _spd_y1, _spd_x2, _spd_y2, 5, 5, false);

        draw_set_color(make_color_rgb(0, 180, 240));
        draw_set_alpha(0.40);
        draw_roundrect_ext(_spd_x1, _spd_y1, _spd_x2, _spd_y2, 5, 5, true);
        draw_set_alpha(1.0);

        draw_set_halign(fa_right);
        var _spd_unit = use_kmh ? " KM/H" : " MPH";
        var _spd_val_str = string_format(display_speed, 3, 1);
        var _spd_full_str = _spd_val_str + _spd_unit;

        draw_set_color(c_black);
        draw_text_transformed(_spd_x2 - 5, _spd_y1 + 5, _spd_full_str, 0.48, 0.48, 0);
        draw_set_color(make_color_rgb(0, 220, 255));
        draw_text_transformed(_spd_x2 - 6, _spd_y1 + 4, _spd_full_str, 0.48, 0.48, 0);
    }
}

// =================================================================
// 2. UPGRADED CINEMATIC TITLE CARD OVERLAY
// =================================================================
if (!is_paused && show_title_card && title_card_timer < title_card_duration) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    var _progress = title_card_timer / title_card_duration;
    var _card_alpha = 1.0;
    
    if (title_card_timer > title_card_duration - 30) {
        _card_alpha = (title_card_duration - title_card_timer) / 30.0;
    }
    
    var _expand = clamp(title_card_timer / 20.0, 0, 1);
    var _bar_h = 44 * _expand;
    
    draw_set_alpha(_card_alpha);
    
    var _box_y1 = (_gui_h / 2) - _bar_h;
    var _box_y2 = (_gui_h / 2) + _bar_h;
    
    draw_set_color(make_color_rgb(8, 10, 15));
    draw_set_alpha(_card_alpha * 0.88);
    draw_rectangle(0, _box_y1, _gui_w, _box_y2, false);
    
    draw_set_color(make_color_rgb(0, 220, 255));
    draw_set_alpha(_card_alpha);
    draw_line_width(0, _box_y1, _gui_w, _box_y1, 1);
    draw_line_width(0, _box_y2, _gui_w, _box_y2, 1);
    
    var _card_data = ["STAGE 1", "MALE' CITY HARBORSIDE", "PROTOTYPE BUILD"];
    var _scr_level = asset_get_index("scr_level_arrangement");
    if (_scr_level != -1 && script_exists(_scr_level)) {
        _card_data = scr_level_arrangement(0);
    }
    
    var _title_str = _card_data[0];
    var _sub_str   = _card_data[1];
    var _disc_str  = _card_data[2];
    
    if (_expand >= 0.8) {
        draw_set_color(c_black);
        draw_text_transformed(_gui_w/2 + 1, _gui_h/2 - 21, _title_str, 0.90, 0.90, 0);
        draw_set_color(c_white);
        draw_text_transformed(_gui_w/2, _gui_h/2 - 22, _title_str, 0.90, 0.90, 0);

        draw_set_color(c_black);
        draw_text_transformed(_gui_w/2 + 1, _gui_h/2 + 1, _sub_str, 0.62, 0.62, 0);
        draw_set_color(make_color_rgb(255, 215, 0));
        draw_text_transformed(_gui_w/2, _gui_h/2, _sub_str, 0.62, 0.62, 0);

        draw_set_color(c_black);
        draw_text_transformed(_gui_w/2 + 1, _gui_h/2 + 23, _disc_str, 0.48, 0.48, 0);
        draw_set_color(make_color_rgb(180, 195, 210));
        draw_text_transformed(_gui_w/2, _gui_h/2 + 22, _disc_str, 0.48, 0.48, 0);
    }
    
    draw_set_alpha(1.0);
}

// =================================================================
// 3. PAUSE MENU OVERLAY
// =================================================================
if (is_paused) {
    if (surface_exists(pause_surface)) {
        draw_surface(pause_surface, 0, 0);
    }
    
    draw_set_color(c_black);
    draw_set_alpha(0.65); 
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    
    var _card_w = 220;
    var _card_h = 145;
    var _card_x1 = (_gui_w / 2) - (_card_w / 2);
    var _card_y1 = (_gui_h / 2) - (_card_h / 2);
    var _card_x2 = _card_x1 + _card_w;
    var _card_y2 = _card_y1 + _card_h;
    
    draw_set_color(make_color_rgb(15, 20, 30));
    draw_set_alpha(0.92);
    draw_roundrect_ext(_card_x1, _card_y1, _card_x2, _card_y2, 10, 10, false);
    
    draw_set_color(make_color_rgb(0, 220, 255)); 
    draw_set_alpha(0.6);
    draw_roundrect_ext(_card_x1, _card_y1, _card_x2, _card_y2, 10, 10, true);
    draw_set_alpha(1.0);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    var _pause_center_x = _gui_w / 2;
    var _pause_base_y   = _card_y1 + 12;
    
    draw_set_color(c_black);
    draw_text_transformed(_pause_center_x + 1, _pause_base_y + 1, "PAUSED", 0.75, 0.75, 0);
    draw_set_color(make_color_rgb(0, 220, 255));
    draw_text_transformed(_pause_center_x, _pause_base_y, "PAUSED", 0.75, 0.75, 0);
    
    var _item_spacing = 18; 
    draw_set_valign(fa_middle);
    
    for (var i = 0; i < pause_total; i++) {
        var _draw_y = _pause_base_y + 36 + (i * _item_spacing);
        var _opt_str = pause_options[i];
        
        if (i == pause_selection) {
            draw_set_color(make_color_rgb(0, 180, 240));
            draw_set_alpha(0.25);
            draw_roundrect_ext(_pause_center_x - 85, _draw_y - 7, _pause_center_x + 85, _draw_y + 7, 6, 6, false);
            draw_set_alpha(0.8);
            draw_roundrect_ext(_pause_center_x - 85, _draw_y - 7, _pause_center_x + 85, _draw_y + 7, 6, 6, true);
            draw_set_alpha(1.0);
            
            var _sel_str = ">  " + _opt_str + "  <";
            draw_set_color(c_black);
            draw_text_transformed(_pause_center_x + 1, _draw_y + 1, _sel_str, 0.58, 0.58, 0);
            draw_set_color(c_yellow);
            draw_text_transformed(_pause_center_x, _draw_y, _sel_str, 0.58, 0.58, 0);
        } else {
            draw_set_color(c_black);
            draw_text_transformed(_pause_center_x + 1, _draw_y + 1, _opt_str, 0.52, 0.52, 0);
            draw_set_color(c_white);
            draw_text_transformed(_pause_center_x, _draw_y, _opt_str, 0.52, 0.52, 0);
        }
    }
}

// =================================================================
// 4. TOAST (Rendered Above Pause Layer)
// =================================================================
var _can_show_toast = global.show_music_toast;

if (is_paused && toast_title != "") {
    _can_show_toast = true;
}

if (_can_show_toast && (toast_state != 0 || is_paused)) {
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    var _t_w = 175;
    var _t_h = 34; 
    
    var _t_x = is_paused ? max(toast_slide_x, 6) : toast_slide_x;
    var _t_y = 6;

    draw_set_color(c_black);
    draw_set_alpha(0.40);
    draw_roundrect_ext(_t_x + 2, _t_y + 2, _t_x + _t_w + 2, _t_y + _t_h + 2, 4, 4, false);

    draw_set_color(make_color_rgb(18, 18, 24));
    draw_set_alpha(0.95);
    draw_roundrect_ext(_t_x, _t_y, _t_x + _t_w, _t_y + _t_h, 4, 4, false);

    draw_set_color(make_color_rgb(0, 220, 255));
    draw_set_alpha(1.0);
    draw_rectangle(_t_x, _t_y, _t_x + 3, _t_y + _t_h, false);

    draw_set_color(make_color_rgb(60, 65, 80));
    draw_roundrect_ext(_t_x, _t_y, _t_x + _t_w, _t_y + _t_h, 4, 4, true);

    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text_transformed(_t_x + 8, _t_y + 3, "NOW PLAYING", 0.38, 0.38, 0);

    draw_set_color(c_white);
    var _disp_title = string_upper(toast_title);
    if (string_width(_disp_title) * 0.42 > _t_w - 14) {
        _disp_title = string_copy(_disp_title, 1, 18) + "...";
    }
    draw_text_transformed(_t_x + 8, _t_y + 12, _disp_title, 0.42, 0.42, 0);
    
    var _artist_type = variable_struct_exists(global, "artist_type") ? global.artist_type : "composer";
    var _artist_raw  = variable_struct_exists(global, "artist_name") ? global.artist_name : "Unknown";
    var _artist_str  = "";

    if (_artist_type == "composer") {
        _artist_str = "Composed by " + _artist_raw;
    } else if (_artist_type == "artist") {
        _artist_str = "By " + _artist_raw;
    } else {
        _artist_str = _artist_raw;
    }

    if (string_width(_artist_str) * 0.36 > _t_w - 14) {
        _artist_str = string_copy(_artist_str, 1, 22) + "...";
    }

    draw_set_color(make_color_rgb(170, 185, 200));
    draw_text_transformed(_t_x + 8, _t_y + 22, _artist_str, 0.36, 0.36, 0);
    
    draw_set_alpha(1.0);
}

// =================================================================
// 5. SECRET EASTER EGG OVERLAY (SHIFT + S GLITCH ENGINE)
// =================================================================
if (splash_active && array_length(splash_sprites) > 0) {
    draw_set_color(c_black);
    draw_set_alpha(1.0);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);

    var _spr = splash_sprites[splash_index];
    if (_spr != -1 && sprite_exists(_spr)) {
        var _cx = (_gui_w / 2) + glitch_offset_x;
        var _cy = (_gui_h / 2) + glitch_offset_y;

        gpu_set_blendmode(bm_add);
        draw_sprite_ext(
            _spr,
            glitch_subimage,
            _cx + irandom_range(-4, 4),
            _cy + irandom_range(-4, 4),
            glitch_scale_x,
            glitch_scale_y,
            irandom_range(-5, 5),
            c_red,
            0.6
        );
        gpu_set_blendmode(bm_normal);

        draw_sprite_ext(
            _spr,
            glitch_subimage,
            _cx,
            _cy,
            glitch_scale_x,
            glitch_scale_y,
            0,
            glitch_color,
            1.0
        );
    }
    
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    
    draw_set_color(c_black);
    draw_text_transformed(_gui_w - 7, _gui_h - 5, "[DEV EASTER EGG ACTIVE]", 0.45, 0.45, 0);
    draw_set_color(c_yellow);
    draw_text_transformed(_gui_w - 8, _gui_h - 6, "[DEV EASTER EGG ACTIVE]", 0.45, 0.45, 0);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);