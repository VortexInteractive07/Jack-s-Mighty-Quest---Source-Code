/// @description Process Progression, Background Vectors & Boundary Checks

// 1. Move the Text Vertically Upward
scroll_y -= scroll_speed;

// 2. Update Parallax Background Decoration Coordinates
bg_offset_x -= 0.10;
bg_offset_y -= 0.15;

// 3. Poll Player Skip Input Buffers
var _skip_intro = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);

// 4. Dynamic Text Bound Tracking Metrics (Updated for widescreen box limits)
if (font_exists(fnt_bit_true)) {
    draw_set_font(fnt_bit_true);
}
var _calculated_text_height = string_height_ext(story_text, 14, 420);

// Advance room conditions if skipped or text passes entirely offscreen
if (_skip_intro || scroll_y < -_calculated_text_height) {
    if (room_exists(rm_game)) {
        room_goto(rm_game);
    }
}