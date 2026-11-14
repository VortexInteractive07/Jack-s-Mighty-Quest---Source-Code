scrEnumerator();
scrMacros();
randomize();
global.debug = 0;
fncPalswapinit(shdPaletteswap);

bitmapFont = font_add_sprite_ext(sprFont, " abcdefghijklmnopqrstuvwxyz0123456789-,.:;'\"?!/", false, 0);
draw_set_font(bitmapFont);

input_controller = instance_create_layer(x, y, "Instances", sysInput);
dungeon_library = instance_create_layer(x, y, "Instances", sysLibrary);
dungeon_engine = instance_create_layer(x, y, "Instances", objDungeon);
dungeon_engine.input = input_controller;
dungeon_engine.lib = dungeon_library;
