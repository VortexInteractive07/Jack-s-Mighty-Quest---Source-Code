/// @description Input Processing, Dialogue SFX, & Cutscene Progression

var _advance_pressed = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter) || mouse_check_button_pressed(mb_left);
var _skip_pressed    = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("S"));

// PRESS ESC TO SKIP ENTIRE INTRO
if (_skip_pressed && fade_state != 2) {
    io_clear();
    
    if (asset_get_index("sfx_dialogue_continue") != -1) {
        audio_play_sound(sfx_dialogue_continue, 5, false);
    }
    
    fade_state = 2; // Trigger final fade out
}

switch (fade_state) {

    // --- STATE 0: INITIAL FADE IN AT GAME START ---
    case 0:
        fade_alpha -= fade_speed;
        if (fade_alpha <= 0) {
            fade_alpha = 0;
            fade_state = 1;
        }
        break;

    // --- STATE 1: ACTIVE STORY SLIDE ---
    case 1:
        var _target_text = cutscenes[scene_index].text;
        var _prev_char_count = floor(char_index);

        // Typewriter effect progression
        if (char_index < string_length(_target_text)) {
            char_index += char_speed;
            current_text = string_copy(_target_text, 1, floor(char_index));
            text_finished = false;

            var _curr_char_count = floor(char_index);

            // Trigger sound for every newly revealed character
            if (_curr_char_count > _prev_char_count) {
                var _char = string_char_at(_target_text, _curr_char_count);

                // Play SFX letter-by-letter (ignoring spaces & newlines)
                if (_char != " " && _char != "\n") {
                    if (asset_get_index("sfx_dialogue") != -1) {
                        audio_play_sound(sfx_dialogue, 1, false);
                    }
                }
            }
        } else {
            current_text = _target_text;
            text_finished = true;
        }

        // Progression controls
        if (_advance_pressed) {
            if (asset_get_index("sfx_dialogue_continue") != -1) {
                audio_play_sound(sfx_dialogue_continue, 5, false);
            }

            if (!text_finished) {
                // Press 1: Instantly reveal full line text
                char_index = string_length(_target_text);
                current_text = _target_text;
                text_finished = true;
            } else {
                // Press 2: INSTANTLY advance to next scene
                scene_index++;

                if (scene_index < scene_total) {
                    char_index = 0;
                    current_text = "";
                    text_finished = false;
                } else {
                    // Sequence finished -> begin final fade out
                    fade_state = 2;
                }
            }
        }
        break;

    // --- STATE 2: FINAL FADE OUT & ROOM TRANSITION ---
    case 2:
        fade_alpha += fade_speed;

        if (fade_alpha >= 1) {
            fade_alpha = 1;

            // Stop the intro track cleanly so the next room can start its BGM properly
            if (asset_get_index("mus_no_bridge_to_cross_ai") != -1 && audio_is_playing(mus_no_bridge_to_cross_ai)) {
                audio_stop_sound(mus_no_bridge_to_cross_ai);
            }

            room_goto(target_room);
        }
        break;
}