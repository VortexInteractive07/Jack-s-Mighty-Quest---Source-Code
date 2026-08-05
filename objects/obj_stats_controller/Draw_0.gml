/// @description Render Stats Overlay ONLY Inside rm_stats

// Safety fallback in case viewport dimensions are uninitialized
if (!variable_instance_exists(id, "view_w")) view_w = 426;
if (!variable_instance_exists(id, "view_h")) view_h = 240;

// CRITICAL FIX: If we are not in the stats room, exit immediately so gameplay is not blocked!
if (room_get_name(room) != "rm_stats" && room != rm_stats) {
    exit; 
}

var _shadow = 1;

// 1. Draw Background Layer (Matched to 426x240)
if (sprite_exists(spr_blank)) {
    draw_sprite_stretched(spr_blank, 0, 0, 0, view_w, view_h);
} else {
    draw_clear(make_color_rgb(10, 18, 14)); 
}

// Draw subtle grid scanning lines
draw_set_color(make_color_rgb(20, 35, 25));
for (var g = 0; g < view_h; g += 8) {
    draw_line(0, g, view_w, g);
}

// 2. Configure Header Typography
draw_set_halign(fa_center);
draw_set_valign(fa_top);
if (font_exists(fnt_bit)) {
    draw_set_font(fnt_bit);
}

var _pulse = abs(sin(anim_timer)) * 50;
var _glow_color = make_color_rgb(50, 150 + _pulse, 50);

draw_set_color(c_black);
draw_text((view_w / 2) + _shadow, 15 + _shadow, "VORTEX // LIFETIME STATISTICS");
draw_set_color(_glow_color);
draw_text(view_w / 2, 15, "VORTEX // LIFETIME STATISTICS");

// Parse raw seconds into digital clock format
var _total_seconds = floor(global.stats.time_played_sec);
var _hours = _total_seconds div 3600;
var _minutes = (_total_seconds div 60) % 60;
var _seconds = _total_seconds % 60;

var _time_formatted = string_replace_all(string_format(_hours, 2, 0) + ":" + string_format(_minutes, 2, 0) + ":" + string_format(_seconds, 2, 0), " ", "0");

var _stats_labels = [
    "TOTAL DEATHS : " + string(global.stats.total_deaths),
    "TOTAL JUMPS  : " + string(global.stats.total_jumps),
    "TIME PLAYED  : " + _time_formatted
];

// Display metrics box (adjusted nicely for 426 width)
draw_set_halign(fa_left);
var _box_x = 38;
var _box_y = 50;
var _box_w = view_w - 76;
var _box_h = 100;

draw_set_color(c_black);
draw_rectangle(_box_x + _shadow, _box_y + _shadow, _box_x + _box_w + _shadow, _box_y + _box_h + _shadow, false);
draw_set_color(make_color_rgb(15, 25, 20));
draw_rectangle(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, false);
draw_set_color(c_lime);
draw_rectangle(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, true);

var _start_y = _box_y + 16;
var _spacing = 26;
var _draw_x = _box_x + 20;

for (var i = 0; i < array_length(_stats_labels); i++) {
    var _current_y = floor(_start_y + (i * _spacing));
    
    draw_set_color(c_black);
    draw_text(_draw_x + _shadow, _current_y + _shadow, _stats_labels[i]);
    draw_set_color(c_white);
    draw_text(_draw_x, _current_y, _stats_labels[i]);
}

// Watermark
draw_set_halign(fa_center);
var _watermark_y = 162; 

draw_set_color(c_black);
draw_text((view_w / 2) + _shadow, _watermark_y + _shadow, "SYSTEMS CURRENTLY UNDER DEVELOPMENT");
draw_set_color(make_color_rgb(220, 70, 70));
draw_text(view_w / 2, _watermark_y, "SYSTEMS CURRENTLY UNDER DEVELOPMENT");

// Footer
var _footer_y = view_h - 35;
var _alpha_pulse = 0.5 + (sin(anim_timer * 2) * 0.5);

draw_set_alpha(_alpha_pulse);
draw_set_color(c_black);
draw_text((view_w / 2) + _shadow, _footer_y + _shadow, "- PRESS CONFIRM TO RETURN -");
draw_set_color(c_yellow);
draw_text(view_w / 2, _footer_y, "- PRESS CONFIRM TO RETURN -");
draw_set_alpha(1.0);