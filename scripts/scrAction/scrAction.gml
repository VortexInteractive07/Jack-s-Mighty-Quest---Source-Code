/// @desc scrAction

function scrAction() {
	
	var _slotCurrent = lib.cat[CAT.DUNGEONS][currDung][currLvl][locY        ][locX        ];
	var _slotFacing  = lib.cat[CAT.DUNGEONS][currDung][currLvl][locY+facingY][locX+facingX];
	
	switch (action) {
		
		// Open a chest/door
		case ACTION.CHEST: scrSpawn(_slotFacing,CONTSLOT.OBJECT ); break;
		case ACTION.DOOR:  scrSpawn(_slotFacing,CONTSLOT.PASSAGE); break;
		
		// Fall down to the level below
		case ACTION.FLOORTRAP: scrTrapfloor(_slotCurrent); break;
		
		// Activate Odin
		case ACTION.ODIN: scrSpawn(_slotFacing,CONTSLOT.OBJECT); break;
		
		// Return to the cardinal state we just left
		case undefined: state[mCURR] = state[mPREV]; break;
		
	}
	
}