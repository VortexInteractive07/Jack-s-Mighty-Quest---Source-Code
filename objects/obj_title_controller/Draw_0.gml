/// @description Render Title Screen, Level Select UI & Transitions

var _view_w = 426;
var _view_h = 240;
var version_text = "GITHUB DEMO v1.0"; 

// Safety check for customizable blink speed variable (default to 30 if not defined in Create Event)
var _speed = variable_instance_exists(id, "blink_speed") ? max(1, blink_speed) : 30;

// =================================================================
// 1. DRAW FULL-SCREEN BACKGROUND (DEV_MODE SWITCH)
// =================================================================
var _bg_sprite = dev_mode ? spr_titlescreen_development : spr_titlescreen;

if (sprite_exists(_bg_sprite)) {
    draw_sprite_stretched(_bg_sprite, 0, 0, 0, room_width, room_height);
} else if (sprite_exists(spr_titlescreen)) {
    // Fallback to standard title screen if dev sprite is missing
    draw_sprite_stretched(spr_titlescreen, 0, 0, 0, room_width, room_height);
} else {
    draw_clear(make_color_rgb(0, 0, 255)); 
}

// =================================================================
// 2. SUBTITLE SPLASH TEXT (Only draws AFTER transition finishes)
// =================================================================
if (fade_state != "in") {
    var _splash_y = 131;   // Adjusted to sit perfectly below the title logo
    var _max_width = 360;  
    var _shadow_offset = 1; 

    draw_set_valign(fa_middle);
    draw_set_halign(fa_left); 

    if (font_exists(fnt_dialogue)) {
        draw_set_font(fnt_dialogue);
    } else {
        draw_set_font(-1);
    }

    var _raw_text = splash_text;

    // --- Clean Width Calculation Helper ---
    var _get_clean_width = function(_str) {
        var _clean = "";
        var _len = string_length(_str);
        for (var c = 1; c <= _len; c++) {
            if (string_char_at(_str, c) == "§") {
                c++; 
            } else {
                _clean += string_char_at(_str, c);
            }
        }
        return string_width(_clean);
    };

    // --- Word Wrapping ---
    var _tokens = [];
    var _tok = "";
    var _raw_len = string_length(_raw_text);

    for (var i = 1; i <= _raw_len; i++) {
        var _char = string_char_at(_raw_text, i);
        if (_char == " ") {
            if (_tok != "") { array_push(_tokens, _tok); _tok = ""; }
            array_push(_tokens, " ");
        } else {
            _tok += _char;
        }
    }
    if (_tok != "") array_push(_tokens, _tok);

    var _lines = [];
    var _current_line = "";

    for (var k = 0; k < array_length(_tokens); k++) {
        var _t = _tokens[k];
        var _test_line = _current_line + _t;
        
        if (_get_clean_width(_test_line) > _max_width && _current_line != "") {
            array_push(_lines, _current_line);
            _current_line = (_t == " ") ? "" : _t;
        } else {
            _current_line = _test_line;
        }
    }
    if (_current_line != "") array_push(_lines, _current_line);

    // --- Layout & Render ---
    var _line_height = font_exists(fnt_bitmap) ? (string_height("M") + 3) : 12;
    var _total_lines = array_length(_lines);
    var _start_y = floor(_splash_y - ((_total_lines - 1) * _line_height) / 2);

    var _visible_limit = floor(typewriter_chars);
    var _chars_drawn = 0;
    var _active_color = c_yellow; 

    for (var l = 0; l < _total_lines; l++) {
        var _line_str = _lines[l];
        var _line_clean_w = _get_clean_width(_line_str);
        
        var _line_scale = (_line_clean_w > _max_width) ? (_max_width / _line_clean_w) : 1.0;
        var _line_x = floor((_view_w / 2) - ((_line_clean_w * _line_scale) / 2));
        var _draw_y = _start_y + (l * _line_height);
        var _current_x = _line_x;
        
        var _line_len = string_length(_line_str);
        for (var c = 1; c <= _line_len; c++) {
            var _char = string_char_at(_line_str, c);
            
            if (_char == "§" && c < _line_len) {
                var _code = string_char_at(_line_str, c + 1);
                c++; 
                switch (_code) {
                    case "0": _active_color = c_black; break;
                    case "1": _active_color = make_color_rgb(0, 0, 170); break;
                    case "2": _active_color = make_color_rgb(0, 170, 0); break;
                    case "3": _active_color = make_color_rgb(0, 170, 170); break;
                    case "4": _active_color = make_color_rgb(170, 0, 0); break;
                    case "5": _active_color = make_color_rgb(170, 0, 170); break;
                    case "6": _active_color = make_color_rgb(255, 170, 0); break;
                    case "7": _active_color = c_gray; break;
                    case "8": _active_color = c_dkgray; break;
                    case "9": _active_color = make_color_rgb(85, 85, 255); break;
                    case "a": _active_color = c_lime; break;
                    case "b": _active_color = c_aqua; break;
                    case "c": _active_color = c_red; break;
                    case "d": _active_color = make_color_rgb(255, 85, 255); break;
                    case "e": _active_color = c_yellow; break;
                    case "f": _active_color = c_white; break;
                    case "r": _active_color = c_yellow; break; 
                }
            } else {
                if (_chars_drawn >= _visible_limit) break;
                _chars_drawn++;
                
                var _draw_x = floor(_current_x);
                var _render_y = floor(_draw_y);
                
                // Shadow
                draw_set_color(c_black);
                draw_text_transformed(_draw_x + _shadow_offset, _render_y + _shadow_offset, _char, _line_scale, _line_scale, 0);
                
                // Text
                draw_set_color(_active_color);
                draw_text_transformed(_draw_x, _render_y, _char, _line_scale, _line_scale, 0);
                
                _current_x += string_width(_char) * _line_scale;
            }
        }
        if (_chars_drawn >= _visible_limit) break;
    }
}

// =================================================================
// 3. LEVEL SELECT UI / PRESS START DISPLAY
// =================================================================
if (fade_state != "in") {
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    
    if (font_exists(fnt_dialogue)) {
        draw_set_font(fnt_dialogue);
    } else if (font_exists(fnt_dialogue)) {
        draw_set_font(fnt_dialogue);
    } else {
        draw_set_font(-1);
    }

    var _ui_center_x = floor(_view_w / 2);
    var _ui_y = floor(_view_h - 65);

    if (level_select_unlocked) {
        // --- DRAW ACTIVE LEVEL SELECT MENU ---
        var _curr_lvl = level_list[selected_level_index];
        var _title_str = "< " + _curr_lvl.title + " >";
        var _sub_str   = _curr_lvl.sub;

        // Level Title (Yellow / Shadow)
        draw_set_color(c_black);
        draw_text(_ui_center_x + 1, _ui_y + 1, _title_str);
        draw_set_color(c_yellow);
        draw_text(_ui_center_x, _ui_y, _title_str);

        // Subtitle (Cyan / Shadow)
        draw_set_color(c_black);
        draw_text(_ui_center_x + 1, _ui_y + 15 + 1, _sub_str);
        draw_set_color(c_aqua);
        draw_text(_ui_center_x, _ui_y + 15, _sub_str);

        // Blinking Start Prompt
        if ((blink_timer div _speed) % 2 == 0) {
            draw_set_color(c_black);
            draw_text(_ui_center_x + 1, _ui_y + 30 + 1, "[ PRESS ENTER TO STAGE START ]");
            draw_set_color(c_white);
            draw_text(_ui_center_x, _ui_y + 30, "[ PRESS ENTER TO STAGE START ]");
        }
    } else {
        // --- STANDARD BLINKING START MESSAGE ---
        if ((blink_timer div _speed) % 2 == 0) {
            draw_set_color(c_black);
            draw_text(_ui_center_x + 1, _ui_y + 15 + 1, start_message);
            draw_set_color(c_white);
            draw_text(_ui_center_x, _ui_y + 15, start_message);
        }
    }
}

// =================================================================
// 4. BOTTOM RIGHT VERSION DISPLAY
// =================================================================
draw_set_halign(fa_right);
draw_set_valign(fa_bottom);

if (font_exists(fnt_dialogue)) {
    draw_set_font(fnt_dialogue);
} else if (font_exists(fnt_dialogue)) {
    draw_set_font(fnt_dialogue);
} else {
    draw_set_font(-1);
}

var _ver_x = _view_w - 6;
var _ver_y = _view_h - 4;

draw_set_color(c_black);
draw_text(_ver_x + 1, _ver_y + 1, version_text);
draw_set_color(c_white);
draw_text(_ver_x, _ver_y, version_text);

// =================================================================
// 5. SHADERLESS TRANSITION ENGINE
// =================================================================
if (fade_state != "idle") {
    draw_set_color(c_black);
    var _p = (fade_state == "in") ? (1.0 - fade_progress) : fade_progress;
    
    switch (transition_type) {
        // --- TYPE 1: CLASSIC FADE ---
        case "fade":
            draw_set_alpha(_p);
            draw_rectangle(0, 0, room_width, room_height, false);
            draw_set_alpha(1.0);
            break;
            
        // --- TYPE 2: SIDE CURTAINS ---
        case "curtain":
            var _curtain_w = (_view_w / 2) * _p;
            draw_rectangle(0, 0, _curtain_w, _view_h, false);
            draw_rectangle(_view_w - _curtain_w, 0, _view_w, _view_h, false);
            break;
            
        // --- TYPE 3: SCREEN WIPE RIGHT ---
        case "wipe_right":
            var _wipe_x = _view_w * _p;
            draw_rectangle(0, 0, _wipe_x, _view_h, false);
            break;
            
        // --- TYPE 4: PIXELATE / MOSAIC RESAMPLE ---
        case "pixelate":
            if (surface_exists(application_surface)) {
                var _grid_size = max(1, floor(32 * _p));
                if (_grid_size > 1) {
                    var _low_res_w = max(1, _view_w div _grid_size);
                    var _low_res_h = max(1, _view_h div _grid_size);
                    draw_surface_ext(application_surface, 0, 0, _view_w / _low_res_w / _grid_size, _view_h / _low_res_h / _grid_size, 0, c_black, _p);
                }
            } else {
                draw_set_alpha(_p);
                draw_rectangle(0, 0, room_width, room_height, false);
                draw_set_alpha(1.0);
            }
            break;
            
        // --- TYPE 5: CIRCLE IRIS ---
        case "circle_iris":
            var _center_x = _view_w / 2;
            var _center_y = _view_h / 2;
            var _max_radius = point_distance(0, 0, _center_x, _center_y);
            var _current_radius = _max_radius * (1.0 - _p);
            
            var _segments = 32;
            for (var s = 0; s < _segments; s++) {
                var _a1 = (s / _segments) * 360;
                var _a2 = ((s + 1) / _segments) * 360;
                
                var _x1 = _center_x + lengthdir_x(_current_radius, _a1);
                var _y1 = _center_y + lengthdir_y(_current_radius, _a1);
                var _x2 = _center_x + lengthdir_x(_current_radius, _a2);
                var _y2 = _center_y + lengthdir_y(_current_radius, _a2);
                
                var _x3 = _center_x + lengthdir_x(_max_radius * 1.5, _a2);
                var _y3 = _center_y + lengthdir_y(_max_radius * 1.5, _a2);
                var _x4 = _center_x + lengthdir_x(_max_radius * 1.5, _a1);
                var _y4 = _center_y + lengthdir_y(_max_radius * 1.5, _a1);
                
                draw_primitive_begin(pr_trianglestrip);
                draw_vertex(_x1, _y1);
                draw_vertex(_x4, _y4);
                draw_vertex(_x2, _y2);
                draw_vertex(_x3, _y3);
                draw_primitive_end();
            }
            break;
            
        // --- TYPE 6: DIAMOND GRID WIPE ---
        case "diamond_wipe":
            var _box_size = 16;
            var _cols = ceil(_view_w / _box_size);
            var _rows = ceil(_view_h / _box_size);
            
            for (var col = 0; col < _cols; col++) {
                for (var row = 0; row < _rows; row++) {
                    var _cx = (col + 0.5) * _box_size;
                    var _cy = (row + 0.5) * _box_size;
                    
                    var _local_p = clamp((_p * 1.5) - (col / _cols) * 0.5, 0, 1);
                    var _radius = (_box_size * 0.85) * _local_p;
                    
                    if (_radius > 0) {
                        draw_primitive_begin(pr_trianglelist);
                        draw_vertex(_cx, _cy - _radius);
                        draw_vertex(_cx + _radius, _cy);
                        draw_vertex(_cx, _cy + _radius);
                        
                        draw_vertex(_cx, _cy + _radius);
                        draw_vertex(_cx - _radius, _cy);
                        draw_vertex(_cx, _cy - _radius);
                        draw_primitive_end();
                    }
                }
            }
            break;
    }
}