/// @function scr_drm_answer_matches(_submitted, _expected)
/// @description Compare a submitted answer with whitespace/case normalization.
function scr_drm_answer_matches(_submitted, _expected) {
    var _answer = string_upper(string_trim(_submitted));
    if (_answer == "" || _answer == "-") return false;
    return _answer == string_upper(string_trim(_expected));
}