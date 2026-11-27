/// @desc scrSpawn(slotFacing,contSlot)
/// @arg slotFacing
/// @arg contSlot

function scrSpawn(_slotFacing,_contSlot) {
	var _opened = true;
	
	// Spawn the animation controller
	switch (_slotFacing[_contSlot]) {
		
		case SLOT.CHEST:
			scrAnimation(id,dvX+(dvW/2),dvY+(dvH/2),sprAnimChest,0.80,sfxChestopen,30,undefined);
			if (!variable_global_exists("dungeon_chests_opened")) global.dungeon_chests_opened = 0;
			var _roll = irandom(5);
			if (global.dungeon_chests_opened == 0 || _roll == 0) {
				global.dungeon_keys++;
				global.inventory_add("dungeon_key", "Dungeon Key", "KEY", 1);
				id.dungeon_set_message("Chest opened: you found a Dungeon Key!");
			} else if (_roll == 1) {
				global.inventory_add("ration", "Trail Ration", "FOOD", 1);
				for (var _food_i = 0; _food_i < array_length(global.inventory_items); _food_i++) {
					if (global.inventory_items[_food_i].id == "ration") global.inventory_items[_food_i].heal = 35;
				}
				id.dungeon_set_message("Chest opened: you found a Trail Ration!");
			} else if (_roll == 2) {
				global.inventory_add("rounds", "Sidearm Rounds", "AMMUNITION", 6);
				id.dungeon_set_message("Chest opened: you found 6 rounds of ammunition!");
			} else if (_roll == 3) {
				var _coins = irandom_range(12, 30);
				global.dungeon_currency += _coins;
				id.dungeon_set_message("Chest opened: you found " + string(_coins) + " coins!");
			} else if (_roll == 4) {
				global.inventory_add("plasma_buddy", "Plasma Buddy Charge", "GADGET", 1);
				id.dungeon_set_message("Chest opened: you found a Plasma Buddy charge!");
			} else {
				global.inventory_add("sidearm", "Service Sidearm", "WEAPON", 1);
				id.dungeon_set_message("Chest opened: you found a Service Sidearm!");
			}
			global.dungeon_chests_opened++;
			break;
		case SLOT.DOOR: scrAnimation(id,dvX+(dvW/2),dvY+(dvH/2),sprAnimDoor,0.80,sfxDooropen,10,palette); break;
		case SLOT.DOORLOCKED:
			if (global.dungeon_keys > 0) {
				global.dungeon_keys--;
				var _key_items = global.inventory_items;
				for (var _key_i = 0; _key_i < array_length(_key_items); _key_i++) {
					if (_key_items[_key_i].id == "dungeon_key") {
						_key_items[_key_i].quantity--;
						if (_key_items[_key_i].quantity <= 0) _key_items = array_delete(_key_items, _key_i, 1);
						break;
					}
				}
				global.inventory_items = _key_items;
				scrAnimation(id,dvX+(dvW/2),dvY+(dvH/2),sprAnimDoor,0.80,sfxDooropen,10,palette);
				id.dungeon_set_message("You used a Dungeon Key. The door unlocks!");
			} else {
				id.dungeon_set_message("The door is locked. Find a Dungeon Key.");
				_opened = false;
			}
			break;
		case SLOT.DOORMAGIC:  scrAnimation(id,dvX+(dvW/2),dvY+(dvH/2),sprAnimDoorM,0.80,sfxDooropen ,10,palette  ); break;
		case SLOT.GATE:       scrAnimation(id,dvX+(dvW/2),dvY+(dvH/2),sprAnimGate ,0.20,sfxStairs   ,10,palette  ); break;
		case SLOT.ODIN:       scrAnimation(id,dvX+(dvW/2),dvY+(dvH/2),sprAnimOdin ,0.60,sfxChestopen,60,undefined); break;
		
	}
	
	// Swap slots
	if (_opened) scrSwapslot(_slotFacing,_contSlot);
	
	viewUpdate = true;
	
	// Update the dungeon view
	scrMain(state[mPREV]);
	
	// Pop the stack
	fncPopaction(id);
	
}
