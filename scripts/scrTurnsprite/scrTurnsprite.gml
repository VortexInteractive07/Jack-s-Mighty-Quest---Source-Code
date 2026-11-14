/// @desc scrTurnsprite(state,turnDir,locX,locY,dungLvl,fragSet,fragTurn,corrWall,leftRight)
/// @arg state     The current/previous state
/// @arg turnDir   The side the player turns to
/// @arg locX      The player's X location
/// @arg locY      The player's Y location
/// @arg dungLvl   The current dungeon level
/// @arg fragSet   The index selecting the set of sprite fragments to use
/// @arg fragTurn  Turn sprite fragment
/// @arg corrWall  Corridor or wall
/// @arg leftRight Left or right

function scrTurnsprite(_state,_turnDir,_locX,_locY,_dungLvl,_fragSet,_fragTurn,_corrWall,_leftRight) {
	
	var _enws = [0,1,_turnDir,0,-1,0,0,_turnDir,0,-1,-_turnDir,0,1,0,0,-_turnDir];
	
	var _slotFront = _dungLvl[_locY+_enws[(_state*4)  ]][_locX+_enws[(_state*4)+1]];
	var _slotSide  = _dungLvl[_locY+_enws[(_state*4)+2]][_locX+_enws[(_state*4)+3]];
	
	var _turnSprite = undefined;
	
	#region TURN
	
	switch (_slotFront[CONTSLOT.BASESTRUCT]) {
		
		case SLOT.WALL:
		case SLOT.WALLFAKE:
			
			switch (_slotSide[CONTSLOT.BASESTRUCT]) {
				
				case SLOT.WALL:
				case SLOT.WALLFAKE: _turnSprite = _fragTurn[(_corrWall*4)+3][_fragSet][_leftRight]; break;
				default: _turnSprite = _turnDir == 1 ? _fragTurn[(_corrWall*4)+2][_fragSet][_leftRight] : _fragTurn[(_corrWall*4)+1][_fragSet][_leftRight];
				
			}
			
		break;
		default:
			
			switch (_slotSide[CONTSLOT.BASESTRUCT]) {
				
				case SLOT.WALL:
				case SLOT.WALLFAKE: _turnSprite = _turnDir == 1 ? _fragTurn[(_corrWall*4)+1][_fragSet][_leftRight] : _fragTurn[(_corrWall*4)+2][_fragSet][_leftRight]; break;
				default: _turnSprite = _fragTurn[(_corrWall*4)][_fragSet][_leftRight];
				
			}
			
	}
	
	#endregion
	
	return _turnSprite;
	
}