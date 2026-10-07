var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
draw_set_alpha(1);
draw_set_color(make_color_rgb(5, 10, 22));
draw_rectangle(0, 0, _gw, _gh, false);

// Pixel stars scroll upward behind the credits.
for (var _s = 0; _s < credits_star_count; _s++) {
    draw_set_color((_s mod 4 == 0) ? make_color_rgb(140, 174, 220) : make_color_rgb(72, 100, 145));
    var _star_size = credits_star_size[_s];
    var _star_x = floor(credits_star_x[_s]);
    var _star_y = floor(credits_star_y[_s]);
    draw_rectangle(_star_x, _star_y,
        _star_x + _star_size - 1, _star_y + _star_size - 1, false);
}

draw_set_font(fnt_bitmap);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _y = credits_scroll_y;
for (var _i = 0; _i < array_length(credits_entries); _i++) {
    var _entry = credits_entries[_i];
    var _kind = _entry.kind;
    if (_kind == "gap") {
        _y += 12;
        continue;
    }

    var _height = (_kind == "title") ? 22 : ((_kind == "heading") ? 20 : 15);
    if (_y > -_height && _y < _gh + _height) {
        draw_set_color((_kind == "heading" || _kind == "title") ? make_color_rgb(235, 197, 91) : ((_kind == "small") ? make_color_rgb(150, 174, 205) : c_white));
        draw_text(216, _y, _entry.text);
    }
    _y += _height;
}

if (credits_finished) {
    draw_set_color(make_color_rgb(130, 151, 180));
    draw_text(216, 220, "PRESS ENTER TO RETURN TO TITLE");
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
