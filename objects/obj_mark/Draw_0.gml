/// @description Render Mark with Glitch & Aura Effects

var _draw_x = x;
var _draw_y = y;

// 1. Jitter effect on shock/nervous states
if (emotion_state == MARK_EMOTION.SHOCKED || emotion_state == MARK_EMOTION.NERVOUS) {
    _draw_x += irandom_range(-1, 1);
    _draw_y += irandom_range(-1, 1);
}

// 2. Draw soft glowing aura ring
gpu_set_blendmode(bm_add);

// Safe Hex Colors: Cyan = $FFFF00, Red = $0000FF
var _glow_color = $FFFF00; 
if (emotion_state == MARK_EMOTION.SHOCKED) {
    _glow_color = $0000FF;
}

draw_sprite_ext(sprite_index, image_index, _draw_x, _draw_y, image_xscale * 1.1, image_yscale * 1.1, image_angle, _glow_color, 0.25);
gpu_set_blendmode(bm_normal);

// 3. Draw Mark's main active sprite frame
draw_sprite_ext(sprite_index, image_index, _draw_x, _draw_y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

// 4. Draw HUD status indicator above Mark
if (emotion_state == MARK_EMOTION.SHOCKED) {
    draw_set_font(-1);
    draw_set_halign(fa_center);
    draw_set_color($0000FF); // Red
    
    var _glitch_txt = choose("WARN!", "ERR//", "!!", "ALT_SYS");
    draw_text_transformed(_draw_x, _draw_y - 20, _glitch_txt, 0.5, 0.5, 0);
    
    draw_set_halign(fa_left);
    draw_set_color($FFFFFF); // White
}