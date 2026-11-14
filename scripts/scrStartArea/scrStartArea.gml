/// @desc scrStartArea(dungeon,dungLvl,dungCol,state,locX,locY)
/// @arg dungeon Start dungeon
/// @arg dungLvl Start lvl
/// @arg dungCol Start colour
/// @arg state   Start direction
/// @arg locX    Start X location
/// @arg locY    Start Y location

function scrStartArea(_dungeon,_dungLvl,_dungCol,_state,_locX,_locY){
	
	currDung               = _dungeon;
	currLvl                = _dungLvl;
	palette[DUNGPAL.INDEX] = _dungCol;
	state[mPREV]           = _state;
	locX                   = _locX;
	locY                   = _locY;
	
}