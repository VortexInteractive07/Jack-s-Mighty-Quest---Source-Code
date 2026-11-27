/// @description Collectible score gem.

sprite_index = scr_texture_pack_sprite("spr_gem", spr_gem);
mask_index = spr_gem;
value = 100;
base_y = y;
bob_time = random(1000);
image_speed = 0.2;

if (scr_save_gem_was_collected(room_get_name(room), x, y)) {
    instance_destroy();
    exit;
}
