/// @description Step Event - Animation States & Direct Room Handoff

state_timer++;
pulse_timer += 0.1;

switch (state) {
    case 0: // BANNER POP-IN ANIMATION
        // Smooth scale-up elastic pop
        banner_scale = lerp(banner_scale, 1.2, 0.25);
        if (banner_scale >= 1.15) {
            banner_scale = 1.0;
            state = 1;
            state_timer = 0;
        }
        break;

    case 1: // HOLD & DISPLAY SCORE / TIME (180 frames = 3 seconds)
        text_alpha = min(1.0, text_alpha + 0.1);
        
        // Fast-forward on Enter/Space key press
        if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
            state_timer = 180;
        }

        if (state_timer >= 180) {
            state = 2;
            state_timer = 0;
        }
        break;

    case 2: // DIRECT CLEAN ROOM HANDOFF TO DEMO END
        instance_activate_all();
        audio_resume_all();
        application_surface_draw_enable(true);

        var _next_room = -1;
        
        // Check global next room override first
        if (variable_global_exists("next_room") && room_exists(global.next_room)) {
            _next_room = global.next_room;
        } else {
            // Direct handoff target: rm_demoend
            var _rm_demoend = asset_get_index("rm_demoend");
            var _rm_menu    = asset_get_index("rm_main_menu");
            
            if (_rm_demoend != -1 && room_exists(_rm_demoend)) {
                _next_room = _rm_demoend;
            } else if (_rm_menu != -1 && room_exists(_rm_menu)) {
                _next_room = _rm_menu;
            }
        }

        if (_next_room != -1 && room_exists(_next_room)) {
            room_goto(_next_room);
        } else {
            room_restart();
        }
        
        instance_destroy();
        break;
}