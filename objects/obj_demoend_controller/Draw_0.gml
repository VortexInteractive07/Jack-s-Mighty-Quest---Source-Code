/// @description Render Video, Red Aura, Premium Visualizer & Subtitles

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

draw_clear(c_black);

// ============================================================================
// 1. VIDEO RENDERER (Mode 0)
// ============================================================================
if (play_mode == 0) {
    var _video_data = video_draw();
    var _video_status = _video_data[0];

    if (_video_status == 0) { 
        var _surface = _video_data[1];
        if (surface_exists(_surface)) {
            var _vid_w = surface_get_width(_surface);
            var _vid_h = surface_get_height(_surface);
            var _scale   = min(_gui_w / _vid_w, _gui_h / _vid_h);
            var _draw_w  = _vid_w * _scale;
            var _draw_h  = _vid_h * _scale;
            var _draw_x  = (_gui_w - _draw_w) / 2;
            var _draw_y  = (_gui_h - _draw_h) / 2;
            
            // Fix pixel blurring by turning off interpolation during video render
            var _prev_filter = gpu_get_tex_filter();
            gpu_set_tex_filter(false);
            
            draw_surface_stretched(_surface, _draw_x, _draw_y, _draw_w, _draw_h);
            
            gpu_set_tex_filter(_prev_filter);
        }
    }
}

// ============================================================================
// 2. RED MUSIC AURA & PREMIUM VISUALIZER (Mode 1)
// ============================================================================
if (play_mode == 1) {
    var _center_x = _gui_w / 2;
    var _center_y = _gui_h / 2;
    
    gpu_set_blendmode(bm_add);
    
    for (var r = 3; r > 0; r--) {
        var _radius = (80 * r) + (aura_pulse * 40 * r);
        var _alpha  = (0.15 / r) * (0.6 + aura_pulse);
        draw_set_alpha(_alpha);
        draw_set_color(aura_color);
        draw_circle(_center_x, _center_y + 20, _radius, false);
    }
    
    var _edge_alpha = 0.25 + (aura_pulse * 0.35);
    draw_set_alpha(_edge_alpha);
    draw_rectangle_color(0, 0, _gui_w, 25, aura_color, aura_color, c_black, c_black, false);
    
    var _bar_w = _gui_w / vis_bars;
    var _base_y = _gui_h - 70; 
    
    for (var i = 0; i < vis_bars; i++) {
        var _bx = i * _bar_w;
        var _by_top = _base_y - vis_levels[i];
        
        draw_set_alpha(0.6 + (vis_levels[i] / 150));
        draw_rectangle_color(_bx + 1, _by_top, _bx + _bar_w - 2, _base_y, aura_color, aura_color, c_black, c_black, false);
        
        var _peak_y = _base_y - vis_peaks[i];
        draw_set_alpha(0.9);
        draw_set_color(c_white);
        draw_rectangle(_bx + 1, _peak_y - 2, _bx + _bar_w - 2, _peak_y, false);
    }
    
    var _track_pos = audio_played && audio_is_playing(end_sequence_audio) ? audio_sound_get_track_position(end_sequence_audio) : 0;
    
    draw_set_color(make_color_rgb(255, 100, 120));
    
    for (var _thick = 0; _thick < 2; _thick++) {
        draw_set_alpha(1.0 - (_thick * 0.5));
        draw_primitive_begin(pr_linestrip);
        
        for (var i = 0; i <= _gui_w; i += 6) {
            var _wave = sin((i * 0.05) + (_track_pos * 10)) * 
                        cos((i * 0.02) - (_track_pos * 5)) * 
                        (vis_levels[floor((i / _gui_w) * (vis_bars - 1))] * 0.4);
            
            draw_vertex(i, (_gui_h / 2) + _wave + (_thick * 2));
        }
        draw_primitive_end();
    }
    
    gpu_set_blendmode(bm_normal);
}

// ============================================================================
// 3. CINEMATIC SUBTITLES & LYRICS RENDERER
// ============================================================================
if (!show_dialogue) exit;
if (array_length(text_array) == 0 || current_line >= array_length(text_array)) exit; 

draw_set_alpha(0.50);
draw_rectangle_color(0, _gui_h - 70, _gui_w, _gui_h, c_black, c_black, c_black, c_black, false);

draw_primitive_begin(pr_trianglestrip);
draw_vertex_color(0, _gui_h - 90, c_black, 0.0);
draw_vertex_color(_gui_w, _gui_h - 90, c_black, 0.0);
draw_vertex_color(0, _gui_h - 70, c_black, 0.5);
draw_vertex_color(_gui_w, _gui_h - 70, c_black, 0.5);
draw_primitive_end();

draw_set_valign(fa_top);

// --- DYNAMIC FONT SELECTION (Language Mode Sync) ---
var _end_font = -1;

switch (global.language_mode) {
    case 0: // English Mode (uses fnt_dialogue)
        _end_font = asset_get_index("fnt_dialogue");
        break;
        
    case 1: // Romaji Mode (uses fnt_romaji)
        _end_font = asset_get_index("fnt_romaji");
        break;
        
    case 2: // Dhivehi Mode / Romanized (uses fnt_dialogue)
        _end_font = asset_get_index("fnt_dialogue");
        break;
}

if (_end_font == -1) {
    _end_font = asset_get_index("fnt_dialogue");
}
if (_end_font != -1 && font_exists(_end_font)) {
    draw_set_font(_end_font);
}

var _current_msg    = text_array[current_line];
var _full_msg_text = variable_struct_exists(_current_msg, "text") ? _current_msg.text : "";
var _visible_text  = string_copy(_full_msg_text, 1, floor(char_index));

var _box_w    = _gui_w - 32;
var _render_y = _gui_h - 52; 
var _wrap_w   = _box_w;
var _line_sep = 16;
var _scale    = 1.0; 
var _render_x = 16;

if (play_mode == 1) {
    draw_set_halign(fa_center);
    _render_x = _gui_w / 2;
} else {
    draw_set_halign(fa_left);
    _render_x = 16;
}

if (play_mode != 1 && variable_struct_exists(_current_msg, "speaker") && _current_msg.speaker != "" && _current_msg.speaker != "SYSTEM") {
    var _speaker_text = _current_msg.speaker + ":";
    draw_set_alpha(1.0);
    draw_set_color(c_black);
    draw_text_ext_transformed(_render_x + 1, _render_y - 14, _speaker_text, _line_sep, _wrap_w / _scale, _scale, _scale, 0);
    draw_text_ext_transformed(_render_x - 1, _render_y - 14, _speaker_text, _line_sep, _wrap_w / _scale, _scale, _scale, 0);
    draw_text_ext_transformed(_render_x, _render_y - 13, _speaker_text, _line_sep, _wrap_w / _scale, _scale, _scale, 0);
    draw_text_ext_transformed(_render_x, _render_y - 15, _speaker_text, _line_sep, _wrap_w / _scale, _scale, _scale, 0);
    draw_set_color(make_color_rgb(255, 220, 100));
    draw_text_ext_transformed(_render_x, _render_y - 14, _speaker_text, _line_sep, _wrap_w / _scale, _scale, _scale, 0);
}

draw_set_alpha(1.0);
draw_set_color(c_black);
draw_text_ext_transformed(_render_x + 1, _render_y + 1, _visible_text, _line_sep, _wrap_w / _scale, _scale, _scale, 0);
draw_text_ext_transformed(_render_x - 1, _render_y + 1, _visible_text, _line_sep, _wrap_w / _scale, _scale, _scale, 0);
draw_text_ext_transformed(_render_x + 1, _render_y - 1, _visible_text, _line_sep, _wrap_w / _scale, _scale, _scale, 0);
draw_text_ext_transformed(_render_x - 1, _render_y - 1, _visible_text, _line_sep, _wrap_w / _scale, _scale, _scale, 0);
draw_set_color(c_white);
draw_text_ext_transformed(_render_x, _render_y, _visible_text, _line_sep, _wrap_w / _scale, _scale, _scale, 0);

if (is_finished && play_mode != 1) {
    var _btn_x = _gui_w - 20;
    var _btn_y = _gui_h - 16 + (sin(prompt_sine) * 2); 
    draw_set_alpha(0.7 + (sin(prompt_sine * 1.5) * 0.3));
    if (sprite_exists(button_sprite)) {
        var _subimg = (current_time * 0.001 * sprite_get_speed(button_sprite)) % sprite_get_number(button_sprite);
        draw_sprite(button_sprite, _subimg, _btn_x, _btn_y);
    } else {
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        draw_set_color(c_black);
        draw_text_transformed(_btn_x + 1, _btn_y + 1, "[D]", 0.55, 0.55, 0);
        draw_set_color(make_color_rgb(255, 220, 100));
        draw_text_transformed(_btn_x, _btn_y, "[D]", 0.55, 0.55, 0);
    }
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);