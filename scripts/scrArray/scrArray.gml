/// scrArray

/// @desc array_create_multi(value,index,[array1,array2,etc...])
/// @arg value The default value
/// @arg index Set to 0
/// @arg [array1,array2,etc...]

function array_create_multi(_value,_index,_sizes) {
	
	var _arrCreateMulti = array_create_multi;
	var _arrLen = array_length;
	var _array;
	
	for (var _i=_sizes[_index]-1; _i>=0; _i--) {
		
		_array[_i] = _index < _arrLen(_sizes)-1 ? _arrCreateMulti(_value,_index+1,_sizes) : _value;
		
	}
	
	return _array;
	
}