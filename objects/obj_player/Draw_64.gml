/// @description Render Debug Overlay & Cheat Indicators

if (speedrunner_mode) {
    draw_set_font(fnt_dialogue);
    
    // Master Debug Title
    draw_text_color(16, 16, "⚡ HIDDEN DEBUG MODE ACTIVE [F12]", c_lime, c_lime, c_green, c_green, 1.0);
    
    // Cheat Switches Status
    var _c_str = always_dash_mode ? "[ON]" : "[OFF]";
    var _l_str = god_infinite_hp  ? "[ON]" : "[OFF]";
    var _p_str = god_no_pit_fall  ? "[ON]" : "[OFF]";
    var _h_str = god_block_enemy  ? "[ON]" : "[OFF]";

    draw_text_color(16, 36,  "C - Always Dash: " + _c_str, always_dash_mode ? c_yellow : c_white, c_yellow, c_orange, c_orange, 1.0);
    draw_text_color(16, 52,  "L - Infinite Lives/HP: " + _l_str, god_infinite_hp ? c_lime : c_white, c_lime, c_green, c_green, 1.0);
    draw_text_color(16, 68,  "P - Prevent Pit Damage: " + _p_str, god_no_pit_fall ? c_aqua : c_white, c_aqua, c_blue, c_blue, 1.0);
    draw_text_color(16, 84,  "H - Block Enemies: " + _h_str, god_block_enemy ? c_fuchsia : c_white, c_fuchsia, c_purple, c_purple, 1.0);
}