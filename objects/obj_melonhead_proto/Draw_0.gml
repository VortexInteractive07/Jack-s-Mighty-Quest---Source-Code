/// @description Draw Melon Head with hit flashes and polished boss HUD.

// Hit flash shader / blend
if (hit_flash > 0) {
    gpu_set_fog(true, c_white, 0, 0);
    draw_self();
    gpu_set_fog(false, c_white, 0, 0);
} else if (state == BOSS_STATE.TELEGRAPH_CHARGE) {
    // Yellow telegraph warning tint
    gpu_set_fog(true, c_yellow, 0, 0);
    draw_self();
    gpu_set_fog(false, c_white, 0, 0);
} else if (state == BOSS_STATE.STUNNED) {
    // Dizzy / blue tint when stunned
    gpu_set_fog(true, make_color_rgb(120, 180, 255), 0, 0);
    draw_self();
    gpu_set_fog(false, c_white, 0, 0);
} else {
    draw_self();
}

// Draw in-world health bar and status if engaged
if (music_started && !defeated) {
    var _bar_width = 72;
    var _bar_left = x - (_bar_width * 0.5);
    var _bar_y = bbox_top - 12;
    
    // Background frame
    draw_set_color(c_black);
    draw_set_alpha(0.85);
    draw_rectangle(_bar_left - 2, _bar_y - 2, _bar_left + _bar_width + 2, _bar_y + 6, false);
    
    // Border
    draw_set_color(c_dkgray);
    draw_rectangle(_bar_left - 2, _bar_y - 2, _bar_left + _bar_width + 2, _bar_y + 6, true);
    
    // Lagging damage bar (yellow)
    var _visual_ratio = clamp(boss_hp_visual / boss_hp_max, 0, 1);
    draw_set_color(c_yellow);
    draw_rectangle(_bar_left, _bar_y, _bar_left + (_bar_width * _visual_ratio), _bar_y + 4, false);
    
    // Current health bar (red / lime)
    var _hp_ratio = clamp(boss_hp / boss_hp_max, 0, 1);
    draw_set_color((_hp_ratio <= 0.3) ? c_red : make_color_rgb(255, 60, 60));
    draw_rectangle(_bar_left, _bar_y, _bar_left + (_bar_width * _hp_ratio), _bar_y + 4, false);
    
    // Boss Name Tag
    draw_set_font(fnt_regular);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_black);
    draw_text(x + 1, _bar_y - 3, "MELON HEAD");
    draw_set_color((boss_hp <= 30) ? c_red : c_yellow);
    draw_text(x, _bar_y - 4, (boss_hp <= 30) ? "ENRAGED MELON HEAD!" : "MELON HEAD");
    
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
