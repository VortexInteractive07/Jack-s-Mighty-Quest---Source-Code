/// @description Render Vintage Retro Diagnostic Fatal Alert Screen
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// Draw classic MS-DOS solid blue screen backfill
draw_set_color(make_color_rgb(0, 0, 170)); 
draw_rectangle(0, 0, _gui_w, _gui_h, false);

if (asset_get_index("fnt_bit_true") != -1) {
    if (font_exists(fnt_bit_true)) draw_set_font(fnt_bit_true);
}
draw_set_alpha(1.0);
draw_set_valign(fa_top);

// --- HEADER TEXT RENDER PANEL ---
draw_set_halign(fa_center);
var _mid_x = _gui_w / 2;

draw_set_color(c_white);
draw_text(_mid_x, 12, "*** FATAL SYSTEM ARCHITECTURE FAILURE ***");
draw_text(_mid_x, 26, "AN UNHANDLED GAMEPLAY EXCEPTION HAS OCCURRED");

draw_set_color(c_yellow);
draw_line(20, 42, _gui_w - 20, 42);

// --- EXCEPTION DATA METRICS ---
draw_set_halign(fa_left);
var _text_left_x = 24;

draw_set_color(c_white);
draw_text(_text_left_x, 52,  "ERROR  : " + string(global.crash_data.message));
draw_text(_text_left_x, 68,  "MODULE : " + string(global.crash_data.script));
draw_text(_text_left_x, 82,  "LINE   : " + string(global.crash_data.line));

// --- STACK TRACE READOUT BOX ---
draw_set_color(make_color_rgb(255, 100, 100)); // Alert red font color selection
draw_text(_text_left_x, 102, "STACK DIAGNOSTICS:");

draw_set_color(c_white);
draw_text_ext(_text_left_x, 116, stack_display_text, 12, _gui_w - 48);

// --- SUBMISSION GUIDELINES ---
draw_set_color(c_yellow);
draw_line(20, 174, _gui_w - 20, 174);

draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text(_mid_x, 182, "PLEASE REPORT THIS LOG DETAILS TO VORTEX INTERACTIVE.");
draw_text(_mid_x, 196, "A DUMP HAS BEEN SAVED TO YOUR BASE WORKSPACE FOLDER.");

// --- INPUT FOOTER CONTROL STRINGS ---
draw_set_color(c_lime);
draw_text(_mid_x, 218, "[ENTER] WARM SYSTEM RESET  |  [ESC] TERMINATE ENGINE");

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);