/// @description Render Fullscreen Vector Map, Grid lines & Process Text Array

// ============================================================================
// 1. RENDER GRADIENT SPACE BACKGROUND
// ============================================================================
var _color_top = c_black;
var _color_bottom = make_color_rgb(12, 10, 40); 
draw_rectangle_color(0, 0, room_width, room_height, _color_top, _color_top, _color_bottom, _color_bottom, false);

var _screen_center_x = room_width / 2;
var _screen_center_y = room_height / 2;

// ============================================================================
// 2. RENDER STARRY BACKGROUND SPACE MAP
// ============================================================================
for (var i = 0; i < star_count; i++) {
    var _s = stars[i];
    var _px = _screen_center_x + (_s.x * focal_length) / _s.z;
    var _py = _screen_center_y + (_s.y * focal_length) / _s.z;
    var _star_size = (1.2 * focal_length) / _s.z;
    var _pulse = 0.7 + sin(_s.twinkle_phase) * 0.3;
    var _final_size = clamp(_star_size * _pulse, 0.5, 6);
    var _brightness = clamp((1 - (_s.z / 600)) * 1.2, 0.2, 1.0);
    
    if (_px >= 0 && _px <= room_width && _py >= 0 && _py <= room_height) {
        draw_set_color(_s.color);
        draw_set_alpha(_brightness);
        if (_final_size > 2.5) {
            draw_line_width(round(_px - _final_size), round(_py), round(_px + _final_size), round(_py), 1);
            draw_line_width(round(_px), round(_py - _final_size), round(_px), round(_py + _final_size), 1);
        } else {
            draw_point(round(_px), round(_py));
        }
    }
}

// ============================================================================
// 3. TRIDIMENSIONAL ROTATION TRANSFORM ENGINE
// ============================================================================
var _rad_x = degtorad(cube_rot_x);
var _rad_y = degtorad(cube_rot_y);
var _rad_z = degtorad(cube_rot_z);

var _transformed_vertices = array_create(8);

for (var i = 0; i < 8; i++) {
    var _v = cube_vertices[i];
    
    var _x1 = _v.x;
    var _y1 = _v.y * cos(_rad_x) - _v.z * sin(_rad_x);
    var _z1 = _v.y * sin(_rad_x) + _v.z * cos(_rad_x);
    
    var _x2 = _x1 * cos(_rad_y) + _z1 * sin(_rad_y);
    var _y2 = _y1;
    var _z2 = -_x1 * sin(_rad_y) + _z1 * cos(_rad_y);
    
    var _x3 = _x2 * cos(_rad_z) - _y2 * sin(_rad_z);
    var _y3 = _x2 * sin(_rad_z) + _y2 * cos(_rad_z);
    var _z3 = _z2 + cube_z_pos; 
    
    var _proj_x = _screen_center_x + (_x3 * focal_length) / _z3;
    var _proj_y = _screen_center_y + (_y3 * focal_length) / _z3;
    
    _transformed_vertices[i] = {x: round(_proj_x), y: round(_proj_y)};
}

// Draw Cube Wireframe
draw_set_color(c_aqua);
draw_set_alpha(0.25); 
for (var i = 0; i < array_length(cube_edges); i++) {
    var _e = cube_edges[i];
    var _v1 = _transformed_vertices[_e[0]];
    var _v2 = _transformed_vertices[_e[1]];
    draw_line_width(_v1.x, _v1.y, _v2.x, _v2.y, 1.5);
}

// Centering bounds setup for inner titles
var _cube_center_x = (_transformed_vertices[0].x + _transformed_vertices[6].x) / 2;
var _cube_center_y = (_transformed_vertices[0].y + _transformed_vertices[6].y) / 2;

// Draw Text inside the Cube utilizing fnt_bit_true
draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_yellow);
draw_set_alpha(0.65);
draw_text_transformed(round(_cube_center_x), round(_cube_center_y), "JACK'S MIGHTY QUEST (TM)", 1.0, 1.0, cube_text_spin);

// ============================================================================
// 4. FOREGROUND LAYER DECORATION
// ============================================================================
for (var i = 0; i < shooting_star_max; i++) {
    var _ss = shooting_stars[i];
    if (_ss.active) {
        draw_set_alpha(1 - (_ss.timer / _ss.timer_max));
        draw_line_width_colour(round(_ss.x1), round(_ss.y1), round(_ss.x2), round(_ss.y2), 1.5, c_white, c_aqua);
    }
}
draw_set_alpha(1.0);

// ============================================================================
// 5. STABLE RENDER CRUNCH-FREE CREDIT ENGINE
// ============================================================================
draw_set_halign(fa_center);  
draw_set_valign(fa_top);

var _cx = round(room_width / 2); 
var _running_y = scroll_y;

for (var i = 0; i < array_length(credits_manifest); i++) {
    var _text = credits_manifest[i];
    
    if (_text == "") {
        _running_y += long_space; 
    } 
    else if (string_char_at(_text, 1) == "=" || string_char_at(_text, 1) == "-") {
        // --- TARGET INTERCEPT: Dynamic Horizontal Line Rules ---
        if (_running_y > -16 && _running_y < room_height + 16) {
            var _draw_y = round(_running_y + 4);
            var _line_w = (string_char_at(_text, 1) == "=") ? max_text_width : max_text_width * 0.7;
            
            draw_set_alpha(0.3);
            draw_set_color(c_blue);
            draw_line_width(_cx - (_line_w / 2) + 1, _draw_y + 1, _cx + (_line_w / 2) + 1, _draw_y + 1, 1);
            
            draw_set_alpha(0.7);
            draw_set_color(c_white);
            draw_line_width(_cx - (_line_w / 2), _draw_y, _cx + (_line_w / 2), _draw_y, 1);
        }
        _running_y += 12;
    }
    else {
        var _calculated_block_height = string_height_ext(_text, line_spacing, max_text_width);

        if (_running_y > -128 && _running_y < room_height + 128) {
            var _draw_y = round(_running_y); 
            
            // --- STEP A: BLUE SHADOW LAYER ---
            draw_set_alpha(0.5);
            draw_set_color(c_blue);
            draw_text_ext(_cx + 1, _draw_y + 1, _text, line_spacing, max_text_width);
            
            // --- STEP B: FRONT WHITE LAYER ---
            draw_set_alpha(1.0);
            draw_set_color(c_white);
            draw_text_ext(_cx, _draw_y, _text, line_spacing, max_text_width);
        }
        _running_y += _calculated_block_height + 8; 
    }
}

// ============================================================================
// 6. BOTTOM PROMPT HUD RENDER (Halts infinitely on complete)
// ============================================================================
if (credits_completed) {
    prompt_timer += 0.05;
    prompt_alpha = 0.6 + sin(prompt_timer) * 0.4; // Retro blinking effect
    
    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    
    var _prompt_y = room_height - 12;
    
    draw_set_alpha(prompt_alpha * 0.5);
    draw_set_color(c_blue);
    draw_text(_cx + 1, _prompt_y + 1, "PRESS [ENTER] TO CONTINUE");
    
    draw_set_alpha(prompt_alpha);
    draw_set_color(c_yellow);
    draw_text(_cx, _prompt_y, "PRESS [ENTER] TO CONTINUE");
}

// ============================================================================
// 7. DRAW FINAL TRANSITION OVERLAY
// ============================================================================
draw_set_alpha(1.0);
if (fade_alpha > 0) {
    draw_set_alpha(fade_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1.0); 
}