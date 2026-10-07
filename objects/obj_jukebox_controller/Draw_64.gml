/// @description Draw GUI Event: Render Tiled Background and Jukebox UI
// Intelligence Level: 10/10

var _gui_w = 432;
var _gui_h = 240;

draw_clear(color_navy_dark);

var _spr_bg = spr_vortex_logo_darkmode;

if (sprite_exists(_spr_bg)) {
    var _tw = sprite_get_width(_spr_bg);
    var _th = sprite_get_height(_spr_bg);

    // Clean Tiled Background Loop across 432x240 canvas
    for (var _xx = bg_x - _tw; _xx < _gui_w + _tw; _xx += _tw) {
        for (var _yy = bg_y - _th; _yy < _gui_h + _th; _yy += _th) {
            draw_sprite_ext(_spr_bg, 0, _xx, _yy, 1, 1, 0, c_white, 0.25);
        }
    }
}

// Outer Gold Border Frame
draw_set_color(color_gold);
draw_rectangle(10, 10, _gui_w - 10, _gui_h - 10, true);
draw_rectangle(12, 12, _gui_w - 12, _gui_h - 12, true);

// Always-Visible Top Lyrics Banner
var _drop_x = 20;
var _drop_y = 14;
var _drop_w = _gui_w - 40;
var _drop_h = 22;

// Drop Shadow
draw_set_alpha(0.6);
draw_set_color(c_black);
draw_rectangle(_drop_x + 3, _drop_y + 3, _drop_x + _drop_w + 3, _drop_y + _drop_h + 3, false);
draw_set_alpha(1.0);

// Box Background & Border
draw_set_color(make_color_rgb(5, 12, 24));
draw_rectangle(_drop_x, _drop_y, _drop_x + _drop_w, _drop_y + _drop_h, false);
draw_set_color(color_gold);
draw_rectangle(_drop_x, _drop_y, _drop_x + _drop_w, _drop_y + _drop_h, true);

// Render Lyric String / Fallback Message
var _lyric_display = get_current_lyrics();

// Dynamic Font Selection: Detect Sinhala Unicode Range (3456..3583 / 0x0D80..0x0DFF)
var _use_sinhala = false;
var _str_len = string_length(_lyric_display);
for (var _char_pos = 1; _char_pos <= _str_len; _char_pos++) {
    var _code = ord(string_char_at(_lyric_display, _char_pos));
    if (_code >= 3456 && _code <= 3583) {
        _use_sinhala = true;
        break;
    }
}

var _top_lyric_font = fnt_bitmap;
if (_use_sinhala && font_exists(fnt_sinhala)) {
    _top_lyric_font = fnt_sinhala;
} else if (font_exists(fnt_bitmap)) {
    _top_lyric_font = fnt_bitmap;
}

if (font_exists(_top_lyric_font)) draw_set_font(_top_lyric_font);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_color(_drop_x + (_drop_w / 2), _drop_y + (_drop_h / 2), _lyric_display, color_gold_light, color_gold_light, color_platinum, color_platinum, 1);

// Header Banner Fixed Position
if (font_exists(fnt_bitmap)) draw_set_font(fnt_bitmap);
var _header_y = 40;
var _header_h = 26;
draw_set_color(color_navy_dark);
draw_rectangle(16, _header_y, _gui_w - 16, _header_y + _header_h, false);
draw_set_color(color_gold);
draw_rectangle(16, _header_y, _gui_w - 16, _header_y + _header_h, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_color(_gui_w / 2, _header_y + (_header_h / 2), "OFFICIAL PRESIDENTIAL ARCHIVE JUKEBOX", color_gold, color_gold, color_gold_light, color_gold_light, 1);

// Left Panel: Playlist Selection Fixed Position
var _list_x = 24;
var _list_y = 72;
var _list_w = 210;
var _list_h = 136;

draw_set_color(make_color_rgb(5, 12, 24));
draw_rectangle(_list_x, _list_y, _list_x + _list_w, _list_y + _list_h, false);
draw_set_color(color_gold);
draw_rectangle(_list_x, _list_y, _list_x + _list_w, _list_y + _list_h, true);

draw_set_halign(fa_left);
var _render_end = min(playlist_total, scroll_offset + visible_max);
var _item_h     = 24;

for (var i = scroll_offset; i < _render_end; i++) {
    var _display_idx     = i - scroll_offset;
    var _item_y          = _list_y + 8 + (_display_idx * _item_h);
    var _song            = playlist[i];
    var _is_selected     = (i == selected_index);
    var _is_active_play  = (i == current_playing_index && is_playing);

    if (_is_selected) {
        draw_set_color(color_navy_light);
        draw_rectangle(_list_x + 2, _item_y - 2, _list_x + _list_w - 2, _item_y + _item_h - 4, false);
        draw_set_color(color_gold);
        draw_rectangle(_list_x + 2, _item_y - 2, _list_x + _list_w - 2, _item_y + _item_h - 4, true);
    }

    var _prefix   = _is_active_play ? "> " : (_is_selected ? "* " : "  ");
    var _txt_col  = _is_selected ? color_gold_light : color_platinum;
    draw_text_color(_list_x + 8, _item_y + 8, _prefix + _song.title, _txt_col, _txt_col, _txt_col, _txt_col, 1);
}

// Right Panel: Track Details Fixed Position
var _info_x = 242;
var _info_y = _list_y;
var _info_w = 166;
var _info_h = 136;

var _active_song = playlist[selected_index];

draw_set_color(make_color_rgb(5, 12, 24));
draw_rectangle(_info_x, _info_y, _info_x + _info_w, _info_y + _info_h, false);
draw_set_color(color_gold);
draw_rectangle(_info_x, _info_y, _info_x + _info_w, _info_y + _info_h, true);

draw_set_halign(fa_left);
draw_text_color(_info_x + 8, _info_y + 10, "TRACK DETAILS", color_gold, color_gold, color_gold, color_gold, 1);

draw_set_color(color_gold);
draw_line(_info_x + 8, _info_y + 20, _info_x + _info_w - 8, _info_y + 20);

draw_text_color(_info_x + 8, _info_y + 32, "COMPOSER:", color_platinum, color_platinum, color_platinum, color_platinum, 1);
draw_text_color(_info_x + 8, _info_y + 46, _active_song.composer, color_gold_light, color_gold_light, color_gold_light, color_gold_light, 1);

draw_text_color(_info_x + 8, _info_y + 70, "CHIP ARCH:", color_platinum, color_platinum, color_platinum, color_platinum, 1);
draw_text_color(_info_x + 8, _info_y + 84, variable_struct_exists(_active_song, "chip") ? _active_song.chip : "Realtek HD Audio", color_gold_light, color_gold_light, color_gold_light, color_gold_light, 1);

// Footer Control Bar Fixed Position
var _footer_y = 214;
draw_set_color(color_navy_dark);
draw_rectangle(16, _footer_y, _gui_w - 16, _gui_h - 16, false);
draw_set_color(color_gold);
draw_rectangle(16, _footer_y, _gui_w - 16, _gui_h - 16, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var _status_text = is_playing ? "[P] PAUSE | [ENTER] PLAY | [ESC] MENU" : "[P] RESUME | [ENTER] SELECT | [ESC] MENU";
draw_text_color(_gui_w / 2, _footer_y + 11, _status_text, color_gold, color_gold, color_gold_light, color_gold_light, 1);

// Fade Transition Overlay
if (fade_alpha > 0) {
    scr_draw_transition_overlay(fade_alpha, _gui_w, _gui_h);
}

// Reset Draw State
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
