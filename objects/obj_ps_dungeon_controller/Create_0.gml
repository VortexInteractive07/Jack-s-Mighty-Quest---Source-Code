scrEnumerator();
scrMacros();
randomize();
global.debug = 0;
global.guidebook_open = false;
fncPalswapinit(shdPaletteswap);

// Keep all system and dungeon UI text on the shared project font.
bitmapFont = fnt_regular;
draw_set_font(bitmapFont);

input_controller = instance_create_layer(x, y, "Instances", sysInput);
dungeon_library = instance_create_layer(x, y, "Instances", sysLibrary);
dungeon_engine = instance_create_layer(x, y, "Instances", objDungeon);
dungeon_engine.input = input_controller;
dungeon_engine.lib = dungeon_library;
