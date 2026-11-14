/// @desc scrTriggeraction()

/// @desc fncPushaction(creator,action,wait?)
/// @arg creator
/// @arg action The action to trigger
/// @arg wait wait?

function fncPushaction(_creator,_action,_wait) {
	
	// If our current state is a cardinal state
	if (_creator.state[mCURR] <= STATE.SOUTH) {
		
		_creator.state[mPREV] = _creator.state[mCURR];
		_creator.state[mCURR] = STATE.ACTION;
		
	}
	
	// Wait for a spawned instance to pop the wait action
	if (_wait) ds_stack_push(_creator.actionStack,ACTION.WAIT);
	
	_creator.action = _action;
	
}

/// @desc fncPopaction(creator)
/// @arg creator

function fncPopaction(_creator) {
	
	_creator.action = ds_stack_pop(_creator.actionStack);
	
}