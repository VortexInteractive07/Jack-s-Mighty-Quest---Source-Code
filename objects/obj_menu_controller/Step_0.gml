/// @description Input Engine, Fade State Machine & Background Animation Updates

// ----------------------------------------------------------------------------
// 1. GLOBAL FADE TRANSITION PROCESSOR
// ----------------------------------------------------------------------------
if (fade_state == -1) {
    fade_alpha -= fade_speed;
    if (fade_alpha <= 0) {
        fade_alpha = 0;
        fade_state = 0;
    }
} else if (fade_state == 1) {
    fade_alpha += fade_speed;
    if (fade_alpha >= 1) {
        fade_alpha = 1;
        fade_state = -1;
        
        if (is_method(fade_action)) {
            fade_action();
            fade_action = undefined;
        } else if (fade_target_room != -1 && room_exists(fade_target_room)) {
            room_goto(fade_target_room);
            fade_target_room = -1;
        }
    }
}

// Lock input handling during active fade-outs
if (fade_state == 1) exit;

// ----------------------------------------------------------------------------
// 2. UPDATE BACKGROUND & BLINK TIMERS
// ----------------------------------------------------------------------------
scroll_x = (scroll_x + scroll_speed_x) % grid_size;
scroll_y = (scroll_y + scroll_speed_y) % grid_size;

if (bg_mode == 1) {
    for (var i = 0; i < star_count; i++) {
        var _s = stars[i];
        _s.x += scroll_speed_x * _s.speed;
        _s.y += scroll_speed_y * _s.speed;
        _s.twinkle += 0.05;

        if (_s.x < 0) _s.x += canvas_w;
        if (_s.x > canvas_w) _s.x -= canvas_w;
        if (_s.y < 0) _s.y += canvas_h;
        if (_s.y > canvas_h) _s.y -= canvas_h;
    }
}

if (blink_timer > 0) blink_timer--;

// ----------------------------------------------------------------------------
// 3. INPUT POLLING
// ----------------------------------------------------------------------------
var _key_up      = keyboard_check_pressed(vk_up) || gamepad_button_check_pressed(0, gp_padu);
var _key_down    = keyboard_check_pressed(vk_down) || gamepad_button_check_pressed(0, gp_padd);
var _key_confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("A")) || gamepad_button_check_pressed(0, gp_face1);
var _key_escape  = keyboard_check_pressed(vk_escape) || gamepad_button_check_pressed(0, gp_face2);

var _sfx_select  = asset_get_index("sfx_textbox");
var _sfx_confirm = asset_get_index("sfx_textbox_continue");

// ----------------------------------------------------------------------------
// 4. MODAL INTERCEPTOR
// ----------------------------------------------------------------------------
if (is_info_open) {
    if (_key_confirm || _key_escape || keyboard_check_pressed(vk_space)) {
        is_info_open = false;
        
        if (is_welcome_modal) {
            save_tutorial_status();
            is_first_time = false;
            is_welcome_modal = false;
        }

        if (_sfx_select != -1 && audio_exists(_sfx_select)) audio_play_sound(_sfx_select, 1, false);
    }
    exit;
}

// ----------------------------------------------------------------------------
// 5. MENU NAVIGATION
// ----------------------------------------------------------------------------
if (_key_up) {
    current_menu_selection--;
    if (current_menu_selection < 0) {
        current_menu_selection = menu_total - 1;
        scroll_offset = max(0, menu_total - max_visible_items);
    }
    if (_sfx_select != -1 && audio_exists(_sfx_select)) audio_play_sound(_sfx_select, 1, false);
}

if (_key_down) {
    current_menu_selection++;
    if (current_menu_selection >= menu_total) {
        current_menu_selection = 0;
        scroll_offset = 0;
    }
    if (_sfx_select != -1 && audio_exists(_sfx_select)) audio_play_sound(_sfx_select, 1, false);
}

if (current_menu_selection < scroll_offset) {
    scroll_offset = current_menu_selection;
}
if (current_menu_selection >= scroll_offset + max_visible_items) {
    scroll_offset = current_menu_selection - max_visible_items + 1;
}

// ----------------------------------------------------------------------------
// 6. MATRIX EXECUTION ENGINE
// ----------------------------------------------------------------------------
if (_key_confirm && blink_timer <= 0) {
    if (_sfx_confirm != -1 && audio_exists(_sfx_confirm)) {
        audio_play_sound(_sfx_confirm, 1, false);
    }
    
    var _item = menu_matrix[current_menu_selection];
    blink_timer = 12; // Trigger 12 frames of high-speed confirmation flash
    
    switch (_item.type) {
        case "room":
            if (_item.target != -1 && room_exists(_item.target)) {
                trigger_transition(_item.target);
            } else {
                is_info_open = true;
                info_text = "TARGET ROOM MISSING!";
            }
            break;
            
        case "modal":
            is_info_open = true;
            info_text = _item.text;
            break;
            
        case "action":
            if (is_method(_item.action)) {
                trigger_transition(-1, _item.action);
            }
            break;
    }
}