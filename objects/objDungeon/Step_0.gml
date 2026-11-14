/// @desc Sprite engine

if (alarm[0] > -1) exit;

scrDebug();

counter = (counter+1)&31;

switch (state[mCURR]) {
	
	// Cardinal direction
	case STATE.EAST:
	case STATE.NORTH:
	case STATE.WEST:
	case STATE.SOUTH: scrMain(state[mCURR]); break;
	
	// Execute action
	case STATE.ACTION: scrAction(); break;
	
	// Dungeon room
	case STATE.ROOM: scrRoom(); break;
	
	// Transition
	case STATE.EXIT: scrExit(); break;
	case STATE.INIT: scrInit(); break;
	
}