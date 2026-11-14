if (!credits_finished) {
    credits_scroll_y -= credits_scroll_speed;
    // Keep the crawl moving until even the final credit has cleared the top.
    if (credits_scroll_y + credits_total_height < 0) credits_finished = true;
} else if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_escape)) {
    room_goto(rm_title_screen);
}

for (var _star = 0; _star < credits_star_count; _star++) {
    credits_star_y[_star] -= credits_star_speed[_star];
    if (credits_star_y[_star] < 0) {
        credits_star_y[_star] += 240;
        credits_star_x[_star] = (credits_star_x[_star] + 137) mod 432;
    }
}
