/// @description Draw Persistent Statistics List Matrix Layout
var _view_w = 320;
var _view_h = 240;
var _shadow = 1;

// 1. Draw Background Layer (Stretched cleanly to 320x240)
if (sprite_exists(spr_blank)) {
    draw_sprite_stretched(spr_blank, 0, 0, 0, _view_w, _view_h);
} else {
    draw_clear(make_color_rgb(15, 25, 15)); // Custom matrix terminal theme green fallback background fill
}

// 2. Configure Header Typography
draw_set_halign(fa_center);
draw_set_valign(fa_top);
if (font_exists(fnt_bit)) draw_set_font(fnt_bit);

// Title Header Text Render
draw_set_color(c_black);
draw_text((_view_w / 2) + _shadow, 15 + _shadow, "LIFETIME STATISTICS");
draw_set_color(c_lime);
draw_text(_view_w / 2, 15, "LIFETIME STATISTICS");

// Parse raw global seconds metric tracking counters into classic digital clean clock lines string array maps
var _total_seconds = floor(global.stats.time_played_sec);
var _hours = _total_seconds div 3600;
var _minutes = (_total_seconds div 60) % 60;
var _seconds = _total_seconds % 60;

var _time_formatted = string_replace_all(string_format(_hours, 2, 0) + ":" + string_format(_minutes, 2, 0) + ":" + string_format(_seconds, 2, 0), " ", "0");

// Define key metrics to display
var _stats_labels = [
    "TOTAL DEATHS: " + string(global.stats.total_deaths),
    "TOTAL JUMPS:  " + string(global.stats.total_jumps),
    "TIME PLAYED:  " + _time_formatted
];

// Display loop metrics parameters
draw_set_halign(fa_left);
var _start_y = 65;
var _spacing = 26;
var _draw_x = 50;

for (var i = 0; i < array_length(_stats_labels); i++) {
    var _current_y = floor(_start_y + (i * _spacing));
    
    draw_set_color(c_black);
    draw_text(_draw_x + _shadow, _current_y + _shadow, _stats_labels[i]);
    draw_set_color(c_white);
    draw_text(_draw_x, _current_y, _stats_labels[i]);
}

// --- Under Development Watermark ---
// Centered horizontally, placed dynamically right below your stats list matrix
draw_set_halign(fa_center);
var _watermark_y = 160; 

draw_set_color(c_black);
draw_text((_view_w / 2) + _shadow, _watermark_y + _shadow, "CURRENTLY UNDER DEVELOPMENT");
draw_set_color(make_color_rgb(200, 50, 50)); // Deep red/orange warning color so it stands out cleanly
draw_text(_view_w / 2, _watermark_y, "CURRENTLY UNDER DEVELOPMENT");

// Return Footer prompt rendering elements
draw_set_halign(fa_center);
var _footer_y = _view_h - 30;
draw_set_color(c_black);
draw_text((_view_w / 2) + _shadow, _footer_y + _shadow, "PRESS CONFIRM TO RETURN");
draw_set_color(c_yellow);
draw_text(_view_w / 2, _footer_y, "PRESS CONFIRM TO RETURN");