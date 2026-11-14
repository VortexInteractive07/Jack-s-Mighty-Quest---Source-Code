/// @desc scrSetsprites(state,dirDiff,dirTurn,locX,locY,fragCat)
/// @arg state   The current/previous state
/// @arg turnDir The side the player turns to
/// @arg locX	 The player's X location
/// @arg locY	 The player's Y location
/// @arg fragCat The fragment category to set (WALK, TURN, ROOM)

function scrSetsprites(_state,_turnDir,_locX,_locY,_fragCat) {
	
	var _dungLvl = lib.cat[CAT.DUNGEONS][currDung][currLvl];
	var _fragSet = lib.cat[CAT.FRAGSETS][currDung][currLvl];
	var _arrLen  = array_length(arrDraw);
	var _u       = undefined;
	
	// Empty the draw sprites array
	for (var _i=0; _i<_arrLen; _i++) { arrDraw[_i] = _u; }
	
	switch (_fragCat) {
		
		case FRAGCAT.WALK:
			
			#region SET WALK, BEYE & DECOR FRAGMENTS
			
			var _fragWalk  = lib.cat[CAT.FRAGMENTS][FRAGCAT.WALK];
			var _fragBeye  = lib.cat[CAT.FRAGMENTS][FRAGCAT.BEYE];
			var _contBase  = CONTSLOT.BASESTRUCT;
			var _contPass  = CONTSLOT.PASSAGE;
			var _contObj   = CONTSLOT.OBJECT;
			var _contDecor = CONTSLOT.DECOR;
			var _dist4     = DIST.FOUR;
			var _dist3     = DIST.THREE;
			var _dist2     = DIST.TWO;
			var _dist1     = DIST.ONE;
			
			// Dist 4
			arrDraw[ 0] = _fragBeye[_dist4][BEYEFRAG.INFINITY][_fragSet];
			arrDraw[ 1] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contBase , 2,3, 1,_fragSet,_fragWalk[_dist4],mMAIN);
			arrDraw[ 2] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contBase , 2,3,-1,_fragSet,_fragWalk[_dist4],mMAIN);
			arrDraw[ 3] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contBase , 2,3, 1,_fragSet,_fragWalk[_dist4],mEXT );
			arrDraw[ 4] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contBase , 2,3,-1,_fragSet,_fragWalk[_dist4],mEXT );
			arrDraw[ 5] = _fragWalk[_dist4][WALKFRAG.CF      ][_fragSet][mMAIN];
			arrDraw[ 6] = scrBeyesprite(_state,_locX,_locY,_dungLvl,_contBase , 4, 1,_fragSet,_fragBeye[_dist4]);
			arrDraw[ 7] = scrBeyesprite(_state,_locX,_locY,_dungLvl,_contBase , 4,-1,_fragSet,_fragBeye[_dist4]);
			arrDraw[ 8] = scrBeyesprite(_state,_locX,_locY,_dungLvl,_contPass , 4, 0,_fragSet,_fragBeye[_dist4]);
			arrDraw[ 9] = scrBeyesprite(_state,_locX,_locY,_dungLvl,_contDecor, 4, 0,_fragSet,_fragBeye[_dist4]);
			arrDraw[10] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contDecor, 2,3, 1,_fragSet,_fragWalk[_dist4],mMAIN);
			arrDraw[11] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contDecor, 2,3,-1,_fragSet,_fragWalk[_dist4],mMAIN);
			arrDraw[12] = scrBeyesprite(_state,_locX,_locY,_dungLvl,_contObj  , 4, 0,_fragSet,_fragBeye[_dist4]);
			
			// Dist 3
			arrDraw[13] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contBase , 1,2, 1,_fragSet,_fragWalk[_dist3],mMAIN);
			arrDraw[14] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contBase , 1,2,-1,_fragSet,_fragWalk[_dist3],mMAIN);
			arrDraw[15] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contBase , 1,2, 1,_fragSet,_fragWalk[_dist3],mEXT );
			arrDraw[16] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contBase , 1,2,-1,_fragSet,_fragWalk[_dist3],mEXT );
			arrDraw[17] = _fragWalk[_dist3][WALKFRAG.CF      ][_fragSet][mMAIN];
			arrDraw[18] = scrBeyesprite(_state,_locX,_locY,_dungLvl,_contBase , 3, 1,_fragSet,_fragBeye[_dist3]);
			arrDraw[19] = scrBeyesprite(_state,_locX,_locY,_dungLvl,_contBase , 3,-1,_fragSet,_fragBeye[_dist3]);
			arrDraw[20] = scrBeyesprite(_state,_locX,_locY,_dungLvl,_contPass , 3, 0,_fragSet,_fragBeye[_dist3]);
			arrDraw[21] = scrBeyesprite(_state,_locX,_locY,_dungLvl,_contDecor, 3, 0,_fragSet,_fragBeye[_dist3]);
			arrDraw[22] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contDecor, 1,2, 1,_fragSet,_fragWalk[_dist3],mMAIN);
			arrDraw[23] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contDecor, 1,2,-1,_fragSet,_fragWalk[_dist3],mMAIN);
			arrDraw[24] = scrBeyesprite(_state,_locX,_locY,_dungLvl,_contObj  , 3, 0,_fragSet,_fragBeye[_dist3]);
			
			// Dist 2
			arrDraw[25] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contBase , 0,1, 1,_fragSet,_fragWalk[_dist2],mMAIN);
			arrDraw[26] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contBase , 0,1,-1,_fragSet,_fragWalk[_dist2],mMAIN);
			arrDraw[27] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contBase , 0,1, 1,_fragSet,_fragWalk[_dist2],mEXT );
			arrDraw[28] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contBase , 0,1,-1,_fragSet,_fragWalk[_dist2],mEXT );
			arrDraw[29] = _fragWalk[_dist2][WALKFRAG.CF      ][_fragSet][mMAIN];
			arrDraw[30] = scrBeyesprite(_state,_locX,_locY,_dungLvl,_contBase , 2, 1,_fragSet,_fragBeye[_dist2]);
			arrDraw[31] = scrBeyesprite(_state,_locX,_locY,_dungLvl,_contBase , 2,-1,_fragSet,_fragBeye[_dist2]);
			arrDraw[32] = scrBeyesprite(_state,_locX,_locY,_dungLvl,_contPass , 2, 0,_fragSet,_fragBeye[_dist2]);
			arrDraw[33] = scrBeyesprite(_state,_locX,_locY,_dungLvl,_contDecor, 2, 0,_fragSet,_fragBeye[_dist2]);
			arrDraw[34] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contDecor, 0,1, 1,_fragSet,_fragWalk[_dist2],mMAIN);
			arrDraw[35] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contDecor, 0,1,-1,_fragSet,_fragWalk[_dist2],mMAIN);
			arrDraw[36] = scrBeyesprite(_state,_locX,_locY,_dungLvl,_contObj  , 2, 0,_fragSet,_fragBeye[_dist2]);
			
			// Dist 1
			arrDraw[37] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contBase ,-1,0, 1,_fragSet,_fragWalk[_dist1],mMAIN);
			arrDraw[38] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contBase ,-1,0,-1,_fragSet,_fragWalk[_dist1],mMAIN);
			arrDraw[39] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contBase ,-1,0, 1,_fragSet,_fragWalk[_dist1],mEXT );
			arrDraw[40] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contBase ,-1,0,-1,_fragSet,_fragWalk[_dist1],mEXT );
			arrDraw[41] = _fragWalk[_dist1][WALKFRAG.CF      ][_fragSet][mMAIN];
			arrDraw[42] = _fragWalk[_dist1][WALKFRAG.STATIC  ][_fragSet][mMAIN];
			arrDraw[43] = scrBeyesprite(_state,_locX,_locY,_dungLvl,_contBase , 1, 1,_fragSet,_fragBeye[_dist1]);
			arrDraw[44] = scrBeyesprite(_state,_locX,_locY,_dungLvl,_contBase , 1,-1,_fragSet,_fragBeye[_dist1]);
			arrDraw[45] = scrBeyesprite(_state,_locX,_locY,_dungLvl,_contPass , 1, 0,_fragSet,_fragBeye[_dist1]);
			arrDraw[46] = scrBeyesprite(_state,_locX,_locY,_dungLvl,_contDecor, 1, 0,_fragSet,_fragBeye[_dist1]);
			arrDraw[47] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contDecor,-1,0, 1,_fragSet,_fragWalk[_dist1],mMAIN);
			arrDraw[48] = scrWalksprite(_state,_locX,_locY,_dungLvl,_contDecor,-1,0,-1,_fragSet,_fragWalk[_dist1],mMAIN);
			arrDraw[49] = scrBeyesprite(_state,_locX,_locY,_dungLvl,_contObj  , 1, 0,_fragSet,_fragBeye[_dist1]);
			
			#endregion
			
		break;
		case FRAGCAT.TURN:
			
			#region SET TURN FRAGMENTS
			
			var _fragTurn = lib.cat[CAT.FRAGMENTS][FRAGCAT.TURN];
			
			arrDraw[_arrLen-6] = scrTurnsprite(_state,_turnDir,_locX,_locY,_dungLvl,_fragSet,_fragTurn,mWALL,mRGHT);
			arrDraw[_arrLen-5] = scrTurnsprite(_state,_turnDir,_locX,_locY,_dungLvl,_fragSet,_fragTurn,mWALL,mLEFT);
			arrDraw[_arrLen-4] = scrTurnsprite(_state,_turnDir,_locX,_locY,_dungLvl,_fragSet,_fragTurn,mCORR,mRGHT);
			arrDraw[_arrLen-3] = scrTurnsprite(_state,_turnDir,_locX,_locY,_dungLvl,_fragSet,_fragTurn,mCORR,mLEFT);
			
			#endregion
			
		break;
		case FRAGCAT.ROOM:
			
			#region SET ROOM FRAGMENTS
			
			var _fragRoom = lib.cat[CAT.FRAGMENTS][FRAGCAT.ROOM];
			
			arrDraw[_arrLen-2] = _fragRoom[ROOMFRAG.WALL ][_fragSet];
			arrDraw[_arrLen-1] = _fragRoom[ROOMFRAG.FLOOR][_fragSet];
			
			#endregion
			
		break;
		
	}
	
}