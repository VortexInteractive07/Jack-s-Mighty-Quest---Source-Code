/// @description Delegate gameplay interface rendering to the HUD module.
scr_hud_draw(id);

if (global.cheat_debug_mode || show_debug_overlay_custom) {
    var _debug_text = "DEBUG MODE  F3: TOGGLE\nROOM: " + room_get_name(room)
        + "\nFPS: " + string(game_get_speed(gamespeed_fps))
        + "  ENEMIES: " + string(instance_number(obj_enemy_base));
    if (instance_exists(obj_jack)) {
        var _debug_player = instance_find(obj_jack, 0);
        _debug_text += "\nPLAYER: " + string(floor(_debug_player.x)) + "," + string(floor(_debug_player.y))
            + "  HP: " + string(_debug_player.hp)
            + "\nHSP: " + string_format(_debug_player.hsp, 1, 2)
            + "  VSP: " + string_format(_debug_player.vsp, 1, 2);
    }
    draw_set_font(fnt_bitmap);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(0.82);
    draw_set_color(c_black);
    draw_rectangle(4, 51, 236, 107, false);
    draw_set_alpha(1);
    draw_set_color(c_lime);
    draw_text(8, 54, _debug_text);
    draw_set_color(c_white);
}
