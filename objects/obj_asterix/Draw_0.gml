/// @description Pro-Max Pixel Rendering & Effects

// 1. Invulnerability Flicker
if (invulnerable_timer > 0) {
    invulnerable_timer--;
    // Crisp 4-frame toggle skip
    if ((invulnerable_timer div 4) % 2 == 0) exit; 
}

// 2. Draw Pro-Max Charging Aura (When Ult is Ready!)
if (pmax_charge >= pmax_max && state == 0) {
    draw_sprite_ext(sprite_index, image_index, floor(x), floor(y), facing * 1.1, 1.1, 0, c_yellow, 0.4);
}

// 3. Render Main Sprite (Pixel-perfect floor clamping stops sub-pixel jitter)
draw_sprite_ext(sprite_index, image_index, floor(x), floor(y), facing, 1, 0, c_white, 1.0);