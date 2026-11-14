/// @desc libFragments(fragments)
/// @arg fragments

function libFragments(_fragments) {
	
	var _u = undefined;
	
	var _dist4 = DIST.FOUR;
	var _dist3 = DIST.THREE;
	var _dist2 = DIST.TWO;
	var _dist1 = DIST.ONE;
	
	#region WALK FRAGMENTS [SET1, SET2, ETC..]
	
	var _walk = FRAGCAT.WALK;
	
	// Walk fragment sets
	_fragments[@ _walk][_dist4][WALKFRAG.CF        ] = [[sprWalk13CF         ,_u                  ],[_u,_u]];
	_fragments[@ _walk][_dist4][WALKFRAG.CORR      ] = [[sprWalk02Corr       ,sprWalk02CorrCF     ],[_u,_u]];
	_fragments[@ _walk][_dist4][WALKFRAG.CORRTAIL  ] = [[sprWalk02CorrTail   ,sprWalk02CorrTailCF ],[_u,_u]];
	_fragments[@ _walk][_dist4][WALKFRAG.SKELETON  ] = [[sprWalkSkeletonS4   ,_u                  ],[_u,_u]];
	_fragments[@ _walk][_dist4][WALKFRAG.STATIC    ] = [[_u                  ,_u                  ],[_u,_u]];
	_fragments[@ _walk][_dist4][WALKFRAG.WALL      ] = [[sprWalk02Wall       ,_u                  ],[_u,_u]];
	
	_fragments[@ _walk][_dist3][WALKFRAG.CF        ] = [[sprWalk57CF         ,_u                  ],[_u,_u]];
	_fragments[@ _walk][_dist3][WALKFRAG.CORR      ] = [[sprWalk46Corr       ,sprWalk46CorrCF     ],[_u,_u]];
	_fragments[@ _walk][_dist3][WALKFRAG.CORRTAIL  ] = [[sprWalk46CorrTail   ,sprWalk46CorrTailCF ],[_u,_u]];
	_fragments[@ _walk][_dist3][WALKFRAG.SKELETON  ] = [[sprWalkSkeletonS3   ,_u                  ],[_u,_u]];
	_fragments[@ _walk][_dist3][WALKFRAG.STATIC    ] = [[_u                  ,_u                  ],[_u,_u]];
	_fragments[@ _walk][_dist3][WALKFRAG.WALL      ] = [[sprWalk46Wall       ,_u                  ],[_u,_u]];
	
	_fragments[@ _walk][_dist2][WALKFRAG.CF        ] = [[sprWalk911CF        ,_u                  ],[_u,_u]];
	_fragments[@ _walk][_dist2][WALKFRAG.CORR      ] = [[sprWalk810Corr      ,sprWalk810CorrCF    ],[_u,_u]];
	_fragments[@ _walk][_dist2][WALKFRAG.CORRTAIL  ] = [[sprWalk810CorrTail  ,sprWalk810CorrTailCF],[_u,_u]];
	_fragments[@ _walk][_dist2][WALKFRAG.SKELETON  ] = [[sprWalkSkeletonS2   ,_u                  ],[_u,_u]];
	_fragments[@ _walk][_dist2][WALKFRAG.STATIC    ] = [[_u                  ,_u                  ],[_u,_u]];
	_fragments[@ _walk][_dist2][WALKFRAG.WALL      ] = [[sprWalk810Wall      ,_u                  ],[_u,_u]];
	
	_fragments[@ _walk][_dist1][WALKFRAG.CF        ] = [[sprWalk1315CF       ,_u                  ],[_u,_u]];
	_fragments[@ _walk][_dist1][WALKFRAG.CORR      ] = [[sprWalk1214Corr     ,sprWalk1214CorrCF   ],[_u,_u]];
	_fragments[@ _walk][_dist1][WALKFRAG.CORRTAIL  ] = [[sprWalk1214Corr     ,sprWalk1214CorrCF   ],[_u,_u]];
	_fragments[@ _walk][_dist1][WALKFRAG.SKELETON  ] = [[sprWalkSkeletonS1   ,_u                  ],[_u,_u]];
	_fragments[@ _walk][_dist1][WALKFRAG.STATIC    ] = [[sprWalk16Static     ,_u                  ],[_u,_u]];
	_fragments[@ _walk][_dist1][WALKFRAG.WALL      ] = [[sprWalk1214Wall     ,_u                  ],[_u,_u]];
	
	#endregion
	
	#region BEYE FRAGMENTS [SET1, SET2, ETC..]
	
	var _beye = FRAGCAT.BEYE;
	
	// Beye fragment sets
	_fragments[@ _beye][_dist4][BEYEFRAG.CHEST     ] = [_u                    ,_u];
	_fragments[@ _beye][_dist4][BEYEFRAG.EXITDR    ] = [sprBeyeExitS4         ,_u];
	_fragments[@ _beye][_dist4][BEYEFRAG.EXITDRLD  ] = [sprBeyeExitS4         ,_u];
	_fragments[@ _beye][_dist4][BEYEFRAG.EXITDRMC  ] = [sprBeyeExitS4         ,_u];
	_fragments[@ _beye][_dist4][BEYEFRAG.EXITDRMCON] = [sprBeyeExitS4         ,_u];
	_fragments[@ _beye][_dist4][BEYEFRAG.EXITDRON  ] = [sprBeyeExitS4         ,_u];
	_fragments[@ _beye][_dist4][BEYEFRAG.EXITGE    ] = [sprBeyeExitS4         ,_u];
	_fragments[@ _beye][_dist4][BEYEFRAG.EXITGEON  ] = [sprBeyeExitS4         ,_u];
	_fragments[@ _beye][_dist4][BEYEFRAG.EXITSTAD  ] = [sprBeyeExitS4         ,_u];
	_fragments[@ _beye][_dist4][BEYEFRAG.EXITSTAU  ] = [sprBeyeExitS4         ,_u];
	_fragments[@ _beye][_dist4][BEYEFRAG.INFINITY  ] = [sprBeyeInfinityS4     ,_u];
	_fragments[@ _beye][_dist4][BEYEFRAG.ODIN      ] = [_u                    ,_u];
	_fragments[@ _beye][_dist4][BEYEFRAG.SKELETON  ] = [sprBeyeSkeletonS4     ,_u];
	_fragments[@ _beye][_dist4][BEYEFRAG.WALL      ] = [sprBeyeWallS4         ,_u];
	_fragments[@ _beye][_dist4][BEYEFRAG.WALLLR    ] = [sprBeyeWallS4RL       ,_u];
	
	_fragments[@ _beye][_dist3][BEYEFRAG.CHEST     ] = [_u                    ,_u];
	_fragments[@ _beye][_dist3][BEYEFRAG.EXITDR    ] = [sprBeyeExitS3         ,_u];
	_fragments[@ _beye][_dist3][BEYEFRAG.EXITDRLD  ] = [sprBeyeExitS3         ,_u];
	_fragments[@ _beye][_dist3][BEYEFRAG.EXITDRMC  ] = [sprBeyeExitS3         ,_u];
	_fragments[@ _beye][_dist3][BEYEFRAG.EXITDRMCON] = [sprBeyeExitS3         ,_u];
	_fragments[@ _beye][_dist3][BEYEFRAG.EXITDRON  ] = [sprBeyeExitS3         ,_u];
	_fragments[@ _beye][_dist3][BEYEFRAG.EXITGE    ] = [sprBeyeExitS3         ,_u];
	_fragments[@ _beye][_dist3][BEYEFRAG.EXITGEON  ] = [sprBeyeExitS3         ,_u];
	_fragments[@ _beye][_dist3][BEYEFRAG.EXITSTAD  ] = [sprBeyeExitS3         ,_u];
	_fragments[@ _beye][_dist3][BEYEFRAG.EXITSTAU  ] = [sprBeyeExitS3         ,_u];
	_fragments[@ _beye][_dist3][BEYEFRAG.INFINITY  ] = [_u                    ,_u];
	_fragments[@ _beye][_dist3][BEYEFRAG.ODIN      ] = [_u                    ,_u];
	_fragments[@ _beye][_dist3][BEYEFRAG.SKELETON  ] = [sprBeyeSkeletonS3     ,_u];
	_fragments[@ _beye][_dist3][BEYEFRAG.WALL      ] = [sprBeyeWallS3         ,_u];
	_fragments[@ _beye][_dist3][BEYEFRAG.WALLLR    ] = [sprBeyeWallS3RL       ,_u];
	
	_fragments[@ _beye][_dist2][BEYEFRAG.CHEST     ] = [_u                    ,_u];
	_fragments[@ _beye][_dist2][BEYEFRAG.EXITDR    ] = [sprBeyeExitS2         ,_u];
	_fragments[@ _beye][_dist2][BEYEFRAG.EXITDRLD  ] = [sprBeyeExitS2         ,_u];
	_fragments[@ _beye][_dist2][BEYEFRAG.EXITDRMC  ] = [sprBeyeExitS2         ,_u];
	_fragments[@ _beye][_dist2][BEYEFRAG.EXITDRMCON] = [sprBeyeExitS2         ,_u];
	_fragments[@ _beye][_dist2][BEYEFRAG.EXITDRON  ] = [sprBeyeExitS2         ,_u];
	_fragments[@ _beye][_dist2][BEYEFRAG.EXITGE    ] = [sprBeyeExitS2         ,_u];
	_fragments[@ _beye][_dist2][BEYEFRAG.EXITGEON  ] = [sprBeyeExitS2         ,_u];
	_fragments[@ _beye][_dist2][BEYEFRAG.EXITSTAD  ] = [sprBeyeExitS2         ,_u];
	_fragments[@ _beye][_dist2][BEYEFRAG.EXITSTAU  ] = [sprBeyeExitS2         ,_u];
	_fragments[@ _beye][_dist2][BEYEFRAG.INFINITY  ] = [_u                    ,_u];
	_fragments[@ _beye][_dist2][BEYEFRAG.ODIN      ] = [_u                    ,_u];
	_fragments[@ _beye][_dist2][BEYEFRAG.SKELETON  ] = [sprBeyeSkeletonS2     ,_u];
	_fragments[@ _beye][_dist2][BEYEFRAG.WALL      ] = [sprBeyeWallS2         ,_u];
	_fragments[@ _beye][_dist2][BEYEFRAG.WALLLR    ] = [sprBeyeWallS2RL       ,_u];
	
	_fragments[@ _beye][_dist1][BEYEFRAG.CHEST     ] = [sprBeyeChestS1        ,_u];
	_fragments[@ _beye][_dist1][BEYEFRAG.EXITDR    ] = [sprBeyeDoorS1         ,_u];
	_fragments[@ _beye][_dist1][BEYEFRAG.EXITDRLD  ] = [sprBeyeDoorLockedS1   ,_u];
	_fragments[@ _beye][_dist1][BEYEFRAG.EXITDRMC  ] = [sprBeyeDoorMagicS1    ,_u];
	_fragments[@ _beye][_dist1][BEYEFRAG.EXITDRMCON] = [sprBeyeDoorMagicOpenS1,_u];
	_fragments[@ _beye][_dist1][BEYEFRAG.EXITDRON  ] = [sprBeyeDoorOpenS1     ,_u];
	_fragments[@ _beye][_dist1][BEYEFRAG.EXITGE    ] = [sprBeyeGateS1         ,_u];
	_fragments[@ _beye][_dist1][BEYEFRAG.EXITGEON  ] = [sprBeyeGateOpenS1     ,_u];
	_fragments[@ _beye][_dist1][BEYEFRAG.EXITSTAD  ] = [sprBeyeStairsDownS1   ,_u];
	_fragments[@ _beye][_dist1][BEYEFRAG.EXITSTAU  ] = [sprBeyeStairsUpS1     ,_u];
	_fragments[@ _beye][_dist1][BEYEFRAG.INFINITY  ] = [_u                    ,_u];
	_fragments[@ _beye][_dist1][BEYEFRAG.ODIN      ] = [sprBeyeOdinS1         ,_u];
	_fragments[@ _beye][_dist1][BEYEFRAG.SKELETON  ] = [sprBeyeSkeletonS1     ,_u];
	_fragments[@ _beye][_dist1][BEYEFRAG.WALL      ] = [sprBeyeWallS1         ,_u];
	_fragments[@ _beye][_dist1][BEYEFRAG.WALLLR    ] = [sprBeyeWallS1RL       ,_u];
	
	#endregion
	
	#region TURN FRAGMENTS [SET1, SET2, ETC..]
	
	var _turn = FRAGCAT.TURN;
	
	_fragments[@ _turn][TURNFRAG.TCC2C] = [[sprTurnCorrC2CL,sprTurnCorrC2CR],[_u,_u]];
	_fragments[@ _turn][TURNFRAG.TCC2W] = [[sprTurnCorrC2WL,sprTurnCorrC2WR],[_u,_u]];
	_fragments[@ _turn][TURNFRAG.TCW2C] = [[sprTurnCorrW2CL,sprTurnCorrW2CR],[_u,_u]];
	_fragments[@ _turn][TURNFRAG.TCW2W] = [[sprTurnCorrW2WL,sprTurnCorrW2WR],[_u,_u]];
	_fragments[@ _turn][TURNFRAG.TWC2C] = [[sprTurnWallC2CL,sprTurnWallC2CR],[_u,_u]];
	_fragments[@ _turn][TURNFRAG.TWC2W] = [[sprTurnWallC2WL,sprTurnWallC2WR],[_u,_u]];
	_fragments[@ _turn][TURNFRAG.TWW2C] = [[sprTurnWallW2CL,sprTurnWallW2CR],[_u,_u]];
	_fragments[@ _turn][TURNFRAG.TWW2W] = [[sprTurnWallW2WL,sprTurnWallW2WR],[_u,_u]];
	
	#endregion
	
	#region ROOM FRAGMENTS [SET1, SET2, ETC..]
	
	var _room = FRAGCAT.ROOM;
	
	// Room fragment sets
	_fragments[@ _room][ROOMFRAG.WALL ] = [sprRoomWallDung ,_u];
	_fragments[@ _room][ROOMFRAG.FLOOR] = [sprRoomFloorDung,_u];
	
	#endregion
	
	#region ANIM FRAGMENTS [SET1, SET2, ETC..]
	
	var _anim = FRAGCAT.ANIM;
	
	// Animation fragment sets
	_fragments[@ _anim][ANIMFRAG.DOOR  ] = [sprAnimDoor ,_u];
	_fragments[@ _anim][ANIMFRAG.DOORMC] = [sprAnimDoorM,_u];
	_fragments[@ _anim][ANIMFRAG.GATE  ] = [sprAnimGate ,_u];
	
	#endregion
	
}