/// @description Initialize Gem Properties & SFX

// --- Sprite Setup ---
if (sprite_exists(spr_gem)) {
    sprite_index = spr_gem;
}

// Default animation speed set by the Sprite Editor
image_speed = 1.0; 

// --- Sound Effect Configuration ---
if (audio_exists(sfx_gem)) {
    collect_sfx = sfx_gem;
} else if (audio_exists(sfx_coin)) {
    collect_sfx = sfx_coin;
} else {
    collect_sfx = -1;
}