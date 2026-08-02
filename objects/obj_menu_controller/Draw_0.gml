/// @description Render Widescreen Adjusted UI Layout Array Matrices

// Track dynamic hardware dimensions safely
var _view_w = room_width;
var _view_h = room_height;
var _shadow_offset = 1;

// Ensure text_scale is defined and non-zero
var _scale = 1;
if (variable_instance_exists(id, "text_scale") && text_scale > 0) {
    _scale = text_scale;
}

// Ensure array and scroll variables exist safely
var _total_items = 0;
if (variable_instance_exists(id, "options_list") && is_array(options_list)) {
    _total_items = array_length(options_list);
}

var _max_vis = variable_instance_exists(id, "max_visible_items") ? max_visible_items : _total_items;
var _scroll  = variable_instance_exists(id, "scroll_offset") ? scroll_offset : 0;
var _select  = variable_instance_exists(id, "current_menu_selection") ? current_menu_selection : 0;

// ============================================================================
// 1. BACKGROUND RENDER LAYER
// ============================================================================
if (sprite_exists(spr_bg_menu)) {
    // Center the 426x240 background image inside room coordinate space
    var _bg_x = floor((_view_w - 426) / 2);
    draw_sprite(spr_bg_menu, 0, _bg_x, 0);
} else {
    // Brighter dark navy fallback so screen isn't pure black if sprite is missing
    draw_clear(make_color_rgb(20, 24, 48));
}

// ============================================================================
// 2. CONFIGURE TYPOGRAPHY RULES
// ============================================================================
draw_set_halign(fa_left);
draw_set_valign(fa_top);

if (font_exists(fnt_bit)) {
    draw_set_font(fnt_bit);
} else {
    draw_set_font(-1);
}

// Shift menu layout rightwards horizontally
var _start_x = 54;  
var _start_y = 48;  
var _spacing = 26; 

// --- Viewport Scissoring Iterator Loop ---
for (var i = 0; i < _max_vis; i++) {
    var _actual_index = _scroll + i;
    if (_actual_index >= _total_items) break; 
    
    var _draw_x = floor(_start_x);
    var _draw_y = floor(_start_y + (i * _spacing));
    var _menu_string = string(options_list[_actual_index]);
    var _is_selected = (_actual_index == _select);
    
    // Draw crisp drop shadows first
    draw_set_color(c_black);
    if (_is_selected) {
        draw_text_transformed(_draw_x - 14 + _shadow_offset, _draw_y + _shadow_offset, ">", _scale, _scale, 0);
    }
    draw_text_transformed(_draw_x + _shadow_offset, _draw_y + _shadow_offset, _menu_string, _scale, _scale, 0);
    
    // Draw foreground text layers
    if (_is_selected) {
        draw_set_color(c_yellow);
        draw_text_transformed(_draw_x - 14, _draw_y, ">", _scale, _scale, 0);
    } else {
        draw_set_color(c_white);
    }
    draw_text_transformed(_draw_x, _draw_y, _menu_string, _scale, _scale, 0);
}

// ============================================================================
// 3. SYSTEM METRICS FOOTER
// ============================================================================
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);

var _footer_x = floor(12);
var _footer_y = floor(_view_h - 8);

draw_set_color(c_black);
draw_text_transformed(_footer_x + _shadow_offset, _footer_y + _shadow_offset, "ALPHA v1.0", _scale, _scale, 0);
draw_set_color(c_white);
draw_text_transformed(_footer_x, _footer_y, "ALPHA v1.0", _scale, _scale, 0);

// ============================================================================
// 4. MODAL OVERLAYS SYSTEM DISPLAY STATE
// ============================================================================
if (variable_instance_exists(id, "is_info_open") && is_info_open) {
    draw_set_color(c_black);
    draw_set_alpha(0.88);
    draw_rectangle(0, 0, _view_w, _view_h, false);
    draw_set_alpha(1.0); 
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    var _cen_x = floor(_view_w / 2);
    var _msg_y = floor(_view_h / 2 - 10);
    var _prompt_y = floor(_view_h / 2 + 50);
    var _return_prompt = "PRESS ANY KEY TO RETURN";
    var _display_text = variable_instance_exists(id, "info_text") ? info_text : "";
    
    // Modal Text Drop Shadows
    draw_set_color(c_black);
    draw_text_ext_transformed(_cen_x + 1, _msg_y + 1, _display_text, 14, _view_w - 64, _scale, _scale, 0);
    draw_text_transformed(_cen_x + 1, _prompt_y + 1, _return_prompt, _scale, _scale, 0);
    
    // Modal Text Foregrounds
    draw_set_color(c_white);
    draw_text_ext_transformed(_cen_x, _msg_y, _display_text, 14, _view_w - 64, _scale, _scale, 0);
    
    draw_set_color(c_yellow);
    draw_text_transformed(_cen_x, _prompt_y, _return_prompt, _scale, _scale, 0);
}

// System State Restoration
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);