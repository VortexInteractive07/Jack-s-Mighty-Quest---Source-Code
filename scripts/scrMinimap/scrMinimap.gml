/// @desc scrMinimap

/// @desc minimap_create(currLvl,slotStart,dungWidth,dungHeight)
/// @arg currLvl
/// @arg slotStart
/// @arg dungWidth
/// @arg dungHeight

function minimap_create(_currLvl,_slotStart,_dungWidth,_dungHeight) {
	
	var _layerID = layer_tilemap_get_id("Minimap");
	
	// Iterate the current level
	for (var _yy=0; _yy<_dungHeight; _yy++) {
		
		for (var _xx=0; _xx<_dungWidth; _xx++) {
			
			for (var _contSlot=CONTSLOT.BASESTRUCT; _contSlot<CONTSLOT.length; _contSlot++) {
				
				var _tileIndex = 0;
				
				// Select tile index
				switch (_currLvl[_yy][_xx][_contSlot]) {
					
					case SLOT.WALL:
					case SLOT.WALLFAKE: _tileIndex = 1; break;
					case SLOT.GATE:
					case SLOT.DOOR:
					case SLOT.DOORLOCKED:
					case SLOT.DOORMAGIC:
					case SLOT.GATEOPEN:
					case SLOT.DOOROPEN:
					case SLOT.DOORLOCKEDOPEN:
					case SLOT.DOORMAGICOPEN:
					case SLOT.STAIRSUP:
					case SLOT.STAIRSDOWN: _tileIndex = 2; break;
					case SLOT.CHEST: _tileIndex = 3; break;
					case SLOT.ODIN: _tileIndex = 4; break;
					
				}
				
				// Place the selected tile on the minimap layer
				if (_tileIndex != 0) tilemap_set(_layerID,_tileIndex,_slotStart+_xx,_slotStart+_yy);
				
		    }
			
		}
		
	}
	
	layer_set_visible("Minimap",true);
	
}

/// @desc minimap_remove(slotStart,dungWidth,dungHeight)
/// @arg slotStart
/// @arg dungWidth
/// @arg dungHeight

function minimap_remove() {
	
	var _layerID = layer_tilemap_get_id("Minimap");
	
	// Clear all tiles from the minimap layer
	tilemap_clear(_layerID,0);
	
	// Hide the minimap layer
	layer_set_visible("Minimap",false);
	
}

/// @desc fncSlotcount(dungLvl,y-axis?,exception)
/// @arg dungLvl   The 2D array to search through
/// @arg y-axis?   True(y-axis) or false(x-axis)
/// @arg exception What value to avoid counting

function fncSlotcount(_dungLvl,_yAxis,_exception) {
	
	/* Return the number of non-exception slots along the chosen axis if the value is over 0,
	   else iterate until the value is anything but 0, or have reached the end of the dungLvl. */
	
	var _yy      = 0;
	var _xx      = 0;
	var _arrSize = _yAxis ? array_length(_dungLvl) : array_length(_dungLvl[_yy]);
	var _nSlots  = 0;
	
	while (true) {
		
		repeat (_arrSize) {
			
			// Increment amount when content is found
			if (_dungLvl[_yy][_xx][CONTSLOT.BASESTRUCT] != _exception) _nSlots++;
			
			if (_xx == _arrSize-1 or _yy == _arrSize-1) {
				
				if (_xx == _arrSize-1 and _yy == _arrSize-1) {
					
					// Return critical
					return _nSlots;
					
				} else {
					
					if (_nSlots == 0) {
						
						// Choose the next column or row and repeat the whole process
						if (_yAxis) _xx++; else _yy++;
						
					} else {
						
						// Return the sum for the chosen axis
						return _nSlots;
						
					}
					
				}
				
			}
			
			// Iterate the choosen axis
			if (_yAxis) _yy++; else _xx++;
			
		}
		
		// Reset the index
		if (_yAxis) _yy = 0; else _xx = 0;
		
	}
	
}