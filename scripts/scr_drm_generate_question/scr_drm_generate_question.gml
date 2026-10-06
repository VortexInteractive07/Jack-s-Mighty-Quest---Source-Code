/// @function scr_drm_generate_question(_difficulty)
/// @description Return one numeric-answer educational challenge without mutating a controller.
function scr_drm_generate_question(_difficulty) {
    var _subject_id = irandom(4);
    var _topic_title = "";
    var _question = "";
    var _answer = 0;
    var _a = 0;
    var _b = 0;
    var _c = 0;
    var _operation = 0;
    var _words = [];
    var _word = "";
    var _index = 0;
    var _i = 0;
    var _letter = "";
    var _extra = 0;
    var _syllables = [];
    var _hex_values = [];

    if (_difficulty == 0) {
        switch (_subject_id) {
            case 0:
                _operation = irandom(3);
                if (_operation == 0) {
                    _a = irandom_range(5, 25);
                    _b = irandom_range(1, 25);
                    _answer = _a + _b;
                    _topic_title = "MATH: BASIC ADDITION";
                    _question = string(_a) + " + " + string(_b) + " = ?";
                } else if (_operation == 1) {
                    _a = irandom_range(10, 40);
                    _b = irandom_range(1, _a);
                    _answer = _a - _b;
                    _topic_title = "MATH: BASIC SUBTRACTION";
                    _question = string(_a) + " - " + string(_b) + " = ?";
                } else if (_operation == 2) {
                    _a = irandom_range(2, 9);
                    _b = irandom_range(2, 9);
                    _answer = _a * _b;
                    _topic_title = "MATH: MULTIPLICATION";
                    _question = string(_a) + " * " + string(_b) + " = ?";
                } else {
                    _b = irandom_range(2, 8);
                    _c = irandom_range(2, 9);
                    _a = _b * _c;
                    _answer = _c;
                    _topic_title = "MATH: EXACT DIVISION";
                    _question = string(_a) + " / " + string(_b) + " = ?";
                }
                break;

            case 1:
                if (irandom(1) == 0) {
                    _words = ["APPLE", "BANANA", "CAT", "DRAGON", "ELEPHANT", "FROG", "GIRAFFE", "HOUSE"];
                    _word = _words[irandom(array_length(_words) - 1)];
                    _answer = string_length(_word);
                    _topic_title = "ENGLISH: LETTER COUNT";
                    _question = "HOW MANY LETTERS IN '" + _word + "'?";
                } else {
                    _words = ["GAME", "QUEST", "WATER", "TIGER", "PLANET", "ROCKET"];
                    _word = _words[irandom(array_length(_words) - 1)];
                    _answer = 0;
                    for (_i = 1; _i <= string_length(_word); _i++) {
                        _letter = string_char_at(_word, _i);
                        if (_letter == "A" || _letter == "E" || _letter == "I" || _letter == "O" || _letter == "U") {
                            _answer++;
                        }
                    }
                    _topic_title = "ENGLISH: VOWEL COUNT";
                    _question = "HOW MANY VOWELS IN '" + _word + "'?";
                }
                break;

            case 2:
                if (irandom(1) == 0) {
                    _topic_title = "SCIENCE: WATER FREEZING POINT";
                    _question = "FREEZING POINT OF WATER IN CELSIUS?";
                    _answer = 0;
                } else {
                    _words = ["MERCURY", "VENUS", "EARTH", "MARS", "JUPITER", "SATURN"];
                    _index = irandom(array_length(_words) - 1);
                    _topic_title = "SCIENCE: PLANETARY ORDER";
                    _question = "POSITION OF " + _words[_index] + " FROM SUN?";
                    _answer = _index + 1;
                }
                break;

            case 3:
                if (irandom(1) == 0) {
                    _topic_title = "COMP-SCI: BYTE CAPACITY";
                    _question = "HOW MANY BITS IN 1 BYTE?";
                    _answer = 8;
                } else {
                    _words = ["0001", "0010", "0011", "0100", "0101", "0110", "0111", "1000"];
                    _index = irandom(array_length(_words) - 1);
                    _topic_title = "COMP-SCI: BINARY TO DECIMAL";
                    _question = "DECIMAL VALUE OF BINARY " + _words[_index] + "?";
                    _answer = _index + 1;
                }
                break;

            case 4:
                if (irandom(1) == 0) {
                    _topic_title = "GEOGRAPHY: CONTINENTS";
                    _question = "TOTAL NUMBER OF CONTINENTS ON EARTH?";
                    _answer = 7;
                } else {
                    _topic_title = "GEOGRAPHY: OCEANS";
                    _question = "TOTAL NUMBER OF NAMED OCEANS ON EARTH?";
                    _answer = 5;
                }
                break;
        }
    } else {
        switch (_subject_id) {
            case 0:
                _operation = irandom(3);
                if (_operation == 0) {
                    _a = irandom_range(6, 15);
                    _b = irandom_range(4, 12);
                    _c = irandom_range(5, 30);
                    _answer = (_a * _b) - _c;
                    _topic_title = "MATH: MULTIPLY THEN SUBTRACT";
                    _question = "(" + string(_a) + " * " + string(_b) + ") - " + string(_c) + " = ?";
                } else if (_operation == 1) {
                    _a = irandom_range(15, 50);
                    _b = irandom_range(5, 12);
                    _c = irandom_range(3, 9);
                    _answer = _a + (_b * _c);
                    _topic_title = "MATH: OPERATOR PRECEDENCE";
                    _question = string(_a) + " + (" + string(_b) + " * " + string(_c) + ") = ?";
                } else if (_operation == 2) {
                    _b = irandom_range(3, 9);
                    _c = irandom_range(5, 15);
                    _a = _b * _c;
                    _extra = irandom_range(10, 45);
                    _answer = _c + _extra;
                    _topic_title = "MATH: DIVISION AND SUM";
                    _question = "(" + string(_a) + " / " + string(_b) + ") + " + string(_extra) + " = ?";
                } else {
                    _b = irandom_range(5, 20);
                    _a = _b + irandom_range(5, 15);
                    _c = irandom_range(4, 12);
                    _answer = (_a - _b) * _c;
                    _topic_title = "MATH: PARENTHETICAL EVALUATION";
                    _question = "(" + string(_a) + " - " + string(_b) + ") * " + string(_c) + " = ?";
                }
                break;

            case 1:
                _words = ["COMPUTER", "ALGORITHM", "ARCHITECTURE", "DEVELOPMENT", "SECURITY"];
                _syllables = ["3", "4", "5", "4", "4"];
                _index = irandom(array_length(_words) - 1);
                _answer = real(_syllables[_index]);
                _topic_title = "ENGLISH: SYLLABLE COUNT";
                _question = "NUMBER OF SYLLABLES IN '" + _words[_index] + "'?";
                break;

            case 2:
                if (irandom(1) == 0) {
                    _topic_title = "SCIENCE: ATOMIC NUMBER";
                    _question = "ATOMIC NUMBER OF CARBON (C)?";
                    _answer = 6;
                } else {
                    _topic_title = "SCIENCE: BOILING POINT";
                    _question = "BOILING POINT OF WATER IN CELSIUS?";
                    _answer = 100;
                }
                break;

            case 3:
                if (irandom(1) == 0) {
                    _topic_title = "COMP-SCI: NIBBLE CAPACITY";
                    _question = "HOW MANY BITS IN A NIBBLE?";
                    _answer = 4;
                } else {
                    _words = ["0x0A", "0x0F", "0x10", "0x14", "0x20"];
                    _hex_values = [10, 15, 16, 20, 32];
                    _index = irandom(array_length(_words) - 1);
                    _topic_title = "COMP-SCI: HEX TO DECIMAL";
                    _question = "DECIMAL VALUE OF HEX " + _words[_index] + "?";
                    _answer = _hex_values[_index];
                }
                break;

            case 4:
                if (irandom(1) == 0) {
                    _topic_title = "HISTORY: CENTURY SPAN";
                    _question = "HOW MANY YEARS ARE IN 1 CENTURY?";
                    _answer = 100;
                } else {
                    _topic_title = "GEOGRAPHY: US STATES";
                    _question = "TOTAL NUMBER OF US STATES?";
                    _answer = 50;
                }
                break;
        }
    }

    return {
        difficulty: clamp(floor(_difficulty), 0, 1),
        topic_title: _topic_title,
        question: _question,
        answer: string(_answer)
    };
}