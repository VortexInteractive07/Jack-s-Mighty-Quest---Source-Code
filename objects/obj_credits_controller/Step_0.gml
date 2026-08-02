/// @description Process Stars, 3D Vectors, Playlist Progression & Dynamic Scroll

if (!is_fading) {
    // --- PLAYLIST PROGRESSION MONITOR ---
    // When the current track completes naturally, step forward to the next song in line
    if (array_length(credits_playlist) > 0) {
        if (!audio_is_playing(credits_music_inst)) {
            playlist_index = (playlist_index + 1) % array_length(credits_playlist);
            credits_music_inst = audio_play_sound(credits_playlist[playlist_index], 1, false);
        }
    }

    // Determine the scroll bottom boundary baseline
    var _stop_margin = 40; 
    
    // Stop scrolling only when the credits text has completed its pass
    if (scroll_y > -total_credits_height + _stop_margin) {
        scroll_y -= scroll_speed;
    } else {
        credits_completed = true;
    }

    // --- Spin Matrix Geometry Cube ---
    cube_rot_x += 0.65;
    cube_rot_y += 0.85;
    cube_rot_z += 0.45;
    cube_text_spin += 1.25; 

    // --- Process Background Stars ---
    var _colors = [c_white, c_yellow, c_aqua, c_fuchsia, c_orange];
    for (var i = 0; i < star_count; i++) {
        var _s = stars[i];
        _s.z -= _s.speed; 
        _s.twinkle_phase += 0.05; 
        if (_s.z <= 0) {
            _s.x = random_range(-500, 500);
            _s.y = random_range(-500, 500);
            _s.z = 600; 
            _s.color = _colors[irandom(array_length(_colors) - 1)];
        }
    }

    // --- Process Shooting Stars ---
    for (var i = 0; i < shooting_star_max; i++) {
        var _ss = shooting_stars[i];
        if (!_ss.active) {
            if (random(100) < 0.6) {
                _ss.active = true;
                _ss.x1 = random(room_width);
                _ss.y1 = random(room_height / 2); 
                _ss.angle = random_range(20, 60); 
                _ss.timer_max = irandom_range(20, 40);
                _ss.timer = 0;
            }
        } else {
            _ss.timer++;
            var _rad = degtorad(_ss.angle);
            var _slide_speed = 12;
            _ss.x1 += cos(_rad) * _slide_speed;
            _ss.y1 += sin(_rad) * _slide_speed;
            _ss.x2 = _ss.x1 - cos(_rad) * _ss.trail_length;
            _ss.y2 = _ss.y1 - sin(_rad) * _ss.trail_length;
            if (_ss.timer >= _ss.timer_max) { _ss.active = false; }
        }
    }

    // --- Input Control Handlers ---
    var _press_enter  = keyboard_check_pressed(vk_enter);
    var _press_escape = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("E"));
    
    if ((credits_completed && _press_enter) || (!credits_completed && credits_skippable && _press_escape)) {
        is_fading = true;
        
        // Fade out active track when exiting credits
        if (audio_is_playing(credits_music_inst)) {
            audio_sound_gain(credits_music_inst, 0, 500);
        }
    }
} 
else {
    // Handle the fade-out screen logic transition window
    fade_alpha += fade_speed;
    if (fade_alpha >= 1) {
        audio_stop_all();
        if (room_exists(rm_title)) {
            room_goto(rm_title);
        } else {
            game_restart();
        }
    }
}