/// Draw world-space collision bounds when the hitbox cheat is enabled.
if (!global.cheat_hitboxes) exit;

draw_set_alpha(0.9);

draw_set_color(make_color_rgb(255, 128, 32));
with (obj_wall) {
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
}

draw_set_color(c_lime);
with (obj_jack) {
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
}

draw_set_color(c_red);
with (obj_enemy_base) {
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
}

draw_set_color(c_aqua);
with (obj_projectile) {
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
}

draw_set_color(c_yellow);
with (obj_gem) {
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
}

draw_set_alpha(1);
draw_set_color(c_white);
