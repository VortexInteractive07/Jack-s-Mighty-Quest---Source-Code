/// @description Render Jack, Additive Flash Trails & Invulnerability FX

// --- 1. Draw Additive Glowing Flash Speed Trail ---
if (array_length(trail_history) > 0) {
    gpu_set_blendmode(bm_add);
    
    for (var i = 0; i < array_length(trail_history); i++) {
        var _ghost = trail_history[i];
        
        draw_sprite_ext(
            _ghost.sprite,
            _ghost.frame,
            floor(_ghost.x_pos),
            floor(_ghost.y_pos),
            _ghost.facing_dir,
            1,
            0,
            _ghost.color,
            _ghost.alpha
        );
    }
    
    gpu_set_blendmode(bm_normal);
}

// --- 2. Damage Invulnerability Flashing ---
if (invulnerable_timer > 0 && (floor(invulnerable_timer / 3) % 2 == 0)) {
    exit;
}

// --- 3. Main Player Rendering ---
// draw_y_offset aligns Jack's 128x128 art feet directly with the collision mask
draw_sprite_ext(
    sprite_index, 
    image_index, 
    floor(x), 
    floor(y + draw_y_offset), 
    facing, 
    1, 
    0, 
    c_white, 
    1.0
);