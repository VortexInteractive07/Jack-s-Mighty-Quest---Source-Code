/// @function scr_calculator_evaluate(expression_string)
/// @param {string} _expr The raw mathematical string (e.g., "1+1", "10+5*2")
/// @returns {string} Evaluated numerical result as a string, or "ERROR"

function scr_calculator_evaluate(_expr) {
    if (_expr == "") return "0";

    // Strip all spaces
    _expr = string_replace_all(_expr, " ", "");

    var _len = string_length(_expr);
    var _tokens = [];
    var _operators = [];
    var _current_num = "";

    // ----------------------------------------------------
    // STEP 1: Tokenize string into numbers and operators
    // ----------------------------------------------------
    for (var i = 1; i <= _len; i++) {
        var _char = string_char_at(_expr, i);

        if (_char == "+" || _char == "-" || _char == "*" || _char == "/") {
            if (_current_num == "" && _char == "-") {
                // Allow leading negative numbers (e.g. "-5+3")
                _current_num += _char;
            } else if (_current_num != "") {
                array_push(_tokens, real(_current_num));
                array_push(_operators, _char);
                _current_num = "";
            } else {
                return "ERROR"; // Syntax error (e.g., "5++5")
            }
        } else if ((_char >= "0" && _char <= "9") || _char == ".") {
            _current_num += _char;
        } else {
            return "ERROR"; // Invalid character encountered
        }
    }

    if (_current_num != "") {
        array_push(_tokens, real(_current_num));
    } else {
        return "ERROR"; // Syntax error (trailing operator)
    }

    if (array_length(_tokens) == 0) return "ERROR";
    if (array_length(_tokens) == 1) return string(_tokens[0]);

    // ----------------------------------------------------
    // STEP 2: First Pass - Handle Multiplication & Division
    // ----------------------------------------------------
    var i = 0;
    while (i < array_length(_operators)) {
        var _op = _operators[i];
        if (_op == "*" || _op == "/") {
            var _val1 = _tokens[i];
            var _val2 = _tokens[i + 1];
            var _res = 0;

            if (_op == "*") {
                _res = _val1 * _val2;
            } else {
                if (_val2 == 0) return "ERROR"; // Division by zero guard
                _res = _val1 / _val2;
            }

            _tokens[i] = _res;
            array_delete(_tokens, i + 1, 1);
            array_delete(_operators, i, 1);
        } else {
            i++;
        }
    }

    // ----------------------------------------------------
    // STEP 3: Second Pass - Handle Addition & Subtraction
    // ----------------------------------------------------
    i = 0;
    while (i < array_length(_operators)) {
        var _op = _operators[i];
        var _val1 = _tokens[i];
        var _val2 = _tokens[i + 1];
        var _res = 0;

        if (_op == "+") {
            _res = _val1 + _val2;
        } else if (_op == "-") {
            _res = _val1 - _val2;
        }

        _tokens[i] = _res;
        array_delete(_tokens, i + 1, 1);
        array_delete(_operators, i, 1);
    }

    return string(_tokens[0]);
}