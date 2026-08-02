/// @description Render "IT'S BOSS TIME!" Banner Overlay in Draw End

if (triggered && text_timer > 0) {
    // Grab the final camera position after locking
    var _cam   = view_camera[0];
    var _cam_x = camera_get_view_x(_cam);
    var _cam_y = camera_get_view_y(_cam);
    var _cam_w = camera_get_view_width(_cam);
    var _cam_h = camera_get_view_height(_cam);
    
    // Safely apply font
    if (font_exists(fnt_dialogue)) {
        draw_set_font(fnt_dialogue);
    }
    
    // Fade out logic
    var _alpha = 1.0;
    if (text_timer < 30) {
        _alpha = text_timer / 30.0;
    }
    
    draw_set_alpha(_alpha);
    
    // Align banner to the upper third of the settled camera view
    var _banner_y = _cam_y + (_cam_h / 3);
    var _banner_h = 28;
    
    // Backdrop Strip
    draw_set_color(make_color_rgb(15, 10, 20));
    draw_rectangle(_cam_x, _banner_y - (_banner_h / 2), _cam_x + _cam_w, _banner_y + (_banner_h / 2), false);
    
    // Red Accent Lines
    draw_set_color(make_color_rgb(255, 50, 50));
    draw_rectangle(_cam_x, _banner_y - (_banner_h / 2) - 1, _cam_x + _cam_w, _banner_y - (_banner_h / 2), false);
    draw_rectangle(_cam_x, _banner_y + (_banner_h / 2), _cam_x + _cam_w, _banner_y + (_banner_h / 2) + 1, false);
    
    // Text Alignment
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    var _center_x = _cam_x + (_cam_w / 2);
    
    // Text Shadow
    draw_set_color(c_black);
    draw_text_transformed(_center_x + 1, _banner_y + 1, "IT'S BOSS TIME!", 0.9, 0.9, 0);
    
    // Text Foreground
    draw_set_color(c_yellow);
    draw_text_transformed(_center_x, _banner_y, "IT'S BOSS TIME!", 0.9, 0.9, 0);
    
    // Clean up Draw State
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_alpha(1.0);
}