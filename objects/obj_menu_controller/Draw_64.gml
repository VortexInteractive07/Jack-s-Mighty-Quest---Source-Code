/// @description Render Classic Menu GUI (Figure B Style)
var _gui_w = 426;
var _gui_h = 240;

// ==========================================
// 1. MAIN BACKGROUND (426x240)
// ==========================================
if (sprite_exists(spr_main_menu)) {
    draw_sprite_stretched(spr_main_menu, 0, 0, 0, _gui_w, _gui_h);
} else {
    draw_clear(c_black);
}

draw_set_font(fnt_bitmap);

// Position menu left-aligned to fill open screen space
var _text_x = 52;

// ==========================================
// 2. RENDER MENU OPTIONS & CURSOR
// ==========================================
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

for (var i = 0; i < menu_total; i++) {
    var _item_y = start_y + (i * line_spacing);
    var _text   = menu_options[i];

    if (i == menu_index) {
        // Selected Item: Solid Yellow
        draw_text_color(_text_x, _item_y, _text, c_yellow, c_yellow, c_yellow, c_yellow, 1);
        
        // Single Yellow Cursor '>'
        var _cursor_x = _text_x - 14 + cursor_offset_x;
        draw_text_color(_cursor_x, _item_y, ">", c_yellow, c_yellow, c_yellow, c_yellow, 1);
    } else {
        // Unselected Items: Solid White
        draw_text_color(_text_x, _item_y, _text, c_white, c_white, c_white, c_white, 1);
    }
}

// ==========================================
// 3. VERSION FOOTER (BOTTOM-LEFT)
// ==========================================
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);

draw_text_color(12, _gui_h - 10, "ALPHA v1.0", c_white, c_white, c_white, c_white, 1);

// Reset Alignments
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// ==========================================
// 4. SCREEN FADE OVERLAY
// ==========================================
if (fade_alpha > 0) {
    draw_set_alpha(fade_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);

    draw_set_color(c_white);
    draw_set_alpha(1);
}