/// @description Draw SMB1 Retro Pixel HUD & Pause Menu (GM LTS 2026)

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

draw_set_font(fnt_bitmap);

// ============================================================================
// 1. GAMEPLAY STATUS BAR
// ============================================================================
if (pause_slide < 1.0 && !is_game_over) {
    var _hud_alpha = 1.0 - pause_slide;
    var _panel_x = 6;
    var _panel_y = 5;
    var _panel_w = _gui_w - 12;
    var _panel_h = 38;
    var _hp = 0;
    var _max_hp = 100;
    var _world_text = variable_instance_exists(id, "world_text") ? world_text : "1-1";
    var _seconds_left = max(0, max_time_seconds - floor(game_timer_ticks / game_get_speed(gamespeed_fps)));
    var _score_display = min(999999, max(0, game_score));
    var _score_text = string(_score_display);
    var _lives_text = string(max(0, player_lives));
    var _coin_text = string(collectibles_collected);

    if (instance_exists(obj_jack)) {
        _hp = max(0, obj_jack.hp);
        _max_hp = max(1, obj_jack.max_hp);
    }
    while (string_length(_score_text) < 6) _score_text = "0" + _score_text;
    while (string_length(_lives_text) < 2) _lives_text = "0" + _lives_text;
    while (string_length(_coin_text) < 2) _coin_text = "0" + _coin_text;

    draw_set_alpha(_hud_alpha);
    draw_set_color(c_black);
    draw_rectangle(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, false);
    draw_set_color(make_color_rgb(90, 105, 130));
    draw_rectangle(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, true);
    draw_set_color(c_aqua);
    draw_line(_panel_x + 1, _panel_y + 1, _panel_x + _panel_w - 1, _panel_y + 1);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);

    draw_text(14, 8, get_localized_text("jack_label") + " x" + _lives_text);
    draw_text(14, 25, get_localized_text("hp_label"));

    var _hp_bar_x = 34;
    var _hp_bar_y = 27;
    var _hp_bar_w = 50;
    var _hp_ratio = clamp(_hp / _max_hp, 0, 1);
    draw_set_color(c_dkgray);
    draw_rectangle(_hp_bar_x, _hp_bar_y, _hp_bar_x + _hp_bar_w, _hp_bar_y + 6, false);
    draw_set_color((_hp_ratio <= 0.25) ? c_red : c_lime);
    draw_rectangle(_hp_bar_x, _hp_bar_y, _hp_bar_x + (_hp_bar_w * _hp_ratio), _hp_bar_y + 6, false);
    draw_set_color(c_white);
    draw_text(88, 25, string(_hp));

    draw_set_color(c_dkgray);
    draw_line(112, 10, 112, 38);
    draw_set_color(c_white);
    draw_text(120, 8, get_localized_text("score_label"));
    draw_text(120, 25, _score_text);

    draw_set_color(c_dkgray);
    draw_line(215, 10, 215, 38);
    draw_set_color(c_white);
    draw_text(223, 8, get_localized_text("gems_label"));
    draw_sprite_ext(spr_coin, 0, 224, 25, 1, 1, 0, c_white, _hud_alpha);
    draw_text(240, 25, "x" + _coin_text);

    draw_set_color(c_dkgray);
    draw_line(285, 10, 285, 38);
    draw_set_color(c_white);
    draw_text(293, 8, get_localized_text("world_label"));
    draw_text(293, 25, _world_text);

    draw_set_color(c_dkgray);
    draw_line(354, 10, 354, 38);
    draw_set_color(c_white);
    draw_text(362, 8, get_localized_text("time_label"));
    var _time_text = string(_seconds_left);
    while (string_length(_time_text) < 3) _time_text = "0" + _time_text;
    draw_set_color((_seconds_left <= 60) ? c_yellow : c_white);
    draw_text(362, 25, _time_text);

    if (global.arcade_mode) {
        draw_set_halign(fa_right);
        draw_set_color(c_yellow);
        draw_text(_panel_x + _panel_w - 7, _panel_y + _panel_h + 2, "CREDIT " + string(global.arcade_credits));
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
    draw_text((_gui_w / 2) + 1, (_gui_h / 2) - 9, get_localized_text("game_over"));
    draw_set_color(c_red);
    draw_text(_gui_w / 2, (_gui_h / 2) - 10, get_localized_text("game_over"));
    
    draw_set_color(c_black);
    draw_text((_gui_w / 2) + 1, (_gui_h / 2) + 17, get_localized_text("continue_start"));
    draw_set_color(c_yellow);
    draw_text(_gui_w / 2, (_gui_h / 2) + 16, get_localized_text("continue_start"));
    
    if (global.arcade_mode && global.arcade_credits <= 0) {
        draw_set_color(c_black);
        draw_text((_gui_w / 2) + 1, (_gui_h / 2) + 37, get_localized_text("no_credits"));
        draw_set_color(c_white);
        draw_text(_gui_w / 2, (_gui_h / 2) + 36, get_localized_text("no_credits"));
    }
}

if (death_notice_timer > 0 && !is_game_over) {
    var _notice_alpha = min(1, death_notice_timer / 12);
    var _notice_y = _gui_h * 0.42;
    draw_set_alpha(_notice_alpha * 0.82);
    draw_set_color(c_black);
    draw_rectangle(0, _notice_y - 18, _gui_w, _notice_y + 34, false);
    draw_set_alpha(_notice_alpha);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_red);
    draw_text(_gui_w / 2, _notice_y - 7, get_localized_text("life_lost"));
    draw_set_color(c_white);
    var _lives_message = (player_lives <= 1)
        ? get_localized_text("last_life")
        : get_localized_text("lives_left") + ": " + string(player_lives);
    draw_text(_gui_w / 2, _notice_y + 14, _lives_message);
    draw_set_alpha(1);
}

// ============================================================================
// 4. TRANSITION FADE OVERLAY
// ============================================================================
if (room == rm_boss && instance_exists(obj_boss_pumpkin)) {
    var _boss = instance_find(obj_boss_pumpkin, 0);
    var _bar_w = 180;
    var _bar_x = (_gui_w - _bar_w) / 2;
    var _bar_y = 8;
    var _boss_ratio = clamp(_boss.hp / _boss.max_hp, 0, 1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_black);
    draw_rectangle(_bar_x - 2, _bar_y - 2, _bar_x + _bar_w + 2, _bar_y + 16, false);
    draw_set_color(c_white);
    draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + 5, false);
    draw_set_color(c_red);
    draw_rectangle(_bar_x, _bar_y, _bar_x + (_bar_w * _boss_ratio), _bar_y + 5, false);
    draw_set_color(c_yellow);
    draw_text(_gui_w / 2, _bar_y + 7, "MELON HEAD");
}

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