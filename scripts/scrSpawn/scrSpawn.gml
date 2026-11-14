/// @desc scrSpawn(slotFacing,contSlot)
/// @arg slotFacing
/// @arg contSlot

function scrSpawn(_slotFacing,_contSlot) {
	
	// Spawn the animation controller
	switch (_slotFacing[_contSlot]) {
		
		case SLOT.CHEST:      scrAnimation(id,dvX+(dvW/2),dvY+(dvH/2),sprAnimChest,0.80,sfxChestopen,30,undefined); break;
		case SLOT.DOOR:
		case SLOT.DOORLOCKED: scrAnimation(id,dvX+(dvW/2),dvY+(dvH/2),sprAnimDoor ,0.80,sfxDooropen ,10,palette  ); break;
		case SLOT.DOORMAGIC:  scrAnimation(id,dvX+(dvW/2),dvY+(dvH/2),sprAnimDoorM,0.80,sfxDooropen ,10,palette  ); break;
		case SLOT.GATE:       scrAnimation(id,dvX+(dvW/2),dvY+(dvH/2),sprAnimGate ,0.20,sfxStairs   ,10,palette  ); break;
		case SLOT.ODIN:       scrAnimation(id,dvX+(dvW/2),dvY+(dvH/2),sprAnimOdin ,0.60,sfxChestopen,60,undefined); break;
		
	}
	
	// Swap slots
	scrSwapslot(_slotFacing,_contSlot);
	
	viewUpdate = true;
	
	// Update the dungeon view
	scrMain(state[mPREV]);
	
	// Pop the stack
	fncPopaction(id);
	
}