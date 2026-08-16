/// @description Render Multi-Mode Menu GUI (426x240 Resolution)

var _gui_w = 426;
var _gui_h = 240;

// ==========================================
// 1. MAIN BACKGROUND
// ==========================================
if (sprite_exists(spr_main_menu)) {
    draw_sprite_stretched(spr_main_menu, 0, 0, 0, _gui_w, _gui_h);
} else {
    draw_clear(c_black);
}

draw_set_font(fnt_bitmap);
var _text_x = 52;

// ==========================================
// 2. RENDER MODE-SPECIFIC SUB-MENUS
// ==========================================
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

switch (current_mode) {

    // --------------------------------------
    // MODE 0: MAIN MENU
    // --------------------------------------
    case 0:
        for (var i = 0; i < menu_total; i++) {
            var _item_y = start_y + (i * line_spacing);
            var _text   = menu_options[i];

            if (i == menu_index) {
                draw_text_color(_text_x, _item_y, _text, c_yellow, c_yellow, c_yellow, c_yellow, 1);
                var _cursor_x = _text_x - 14 + cursor_offset_x;
                draw_text_color(_cursor_x, _item_y, ">", c_yellow, c_yellow, c_yellow, c_yellow, 1);
            } else {
                draw_text_color(_text_x, _item_y, _text, c_white, c_white, c_white, c_white, 1);
            }
        }
        break;

    // --------------------------------------
    // MODE 1: SETTINGS / OPTIONS SUB-MENU
    // --------------------------------------
    case 1:
        for (var i = 0; i < opt_total; i++) {
            var _item_y = start_y + (i * line_spacing);
            var _label  = opt_options[i];
            var _val_str = "";

            // Format settings values next to options
            switch (i) {
                case 0: _val_str = " < " + string(global.vol_bgm) + "% >"; break;
                case 1: _val_str = " < " + string(global.vol_sfx) + "% >"; break;
                case 2: _val_str = global.fullscreen ? " [ON]" : " [OFF]"; break;
                case 3: _val_str = ""; break;
            }

            var _full_text = _label + _val_str;

            if (i == opt_index) {
                draw_text_color(_text_x, _item_y, _full_text, c_yellow, c_yellow, c_yellow, c_yellow, 1);
                var _cursor_x = _text_x - 14 + cursor_offset_x;
                draw_text_color(_cursor_x, _item_y, ">", c_yellow, c_yellow, c_yellow, c_yellow, 1);
            } else {
                draw_text_color(_text_x, _item_y, _full_text, c_white, c_white, c_white, c_white, 1);
            }
        }
        break;

    // --------------------------------------
    // MODE 2: JUKEBOX SUB-MENU
    // --------------------------------------
    case 2:
        for (var i = 0; i < juke_total; i++) {
            var _item_y = start_y + (i * line_spacing);
            var _track_name = juke_tracks[i].title;
            var _status_str = "";

            // Add playing indicator tag
            if (i < juke_total - 1) {
                if (audio_is_playing(juke_tracks[i].asset)) {
                    _status_str = " [PLAYING]";
                }
            }

            var _full_text = _track_name + _status_str;

            if (i == juke_index) {
                draw_text_color(_text_x, _item_y, _full_text, c_yellow, c_yellow, c_yellow, c_yellow, 1);
                var _cursor_x = _text_x - 14 + cursor_offset_x;
                draw_text_color(_cursor_x, _item_y, ">", c_yellow, c_yellow, c_yellow, c_yellow, 1);
            } else {
                draw_text_color(_text_x, _item_y, _full_text, c_white, c_white, c_white, c_white, 1);
            }
        }
        break;
}

// ==========================================
// 3. FOOTER (MODE INDICATOR & VERSION)
// ==========================================
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);

var _mode_label = "MAIN MENU";
if (current_mode == 1) _mode_label = "SETTINGS";
if (current_mode == 2) _mode_label = "JUKEBOX";

draw_text_color(12, _gui_h - 10, "ALPHA v1.0 | " + _mode_label, c_white, c_white, c_white, c_white, 1);

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