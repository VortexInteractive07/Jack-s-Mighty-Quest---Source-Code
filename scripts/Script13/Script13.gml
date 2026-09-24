/// @function scr_question_drm()
/// @description Generates a random DRM question covering Math, Science, or History (Limit: 200).
/// @returns {struct} Struct containing question string, array of 4 choices, and correct answer index.

function scr_question_drm() {
    var _max_questions = 200;
    var _subject_type = irandom(2); // 0: Math, 1: Science, 2: History
    
    var _question_text = "";
    var _choices = ["", "", "", ""];
    var _correct_index = 0;
    
    // Shared local variables across switch cases
    var _val_a = 0;
    var _val_b = 0;
    var _ans = 0;
    var _wrong = 0;
    var _coeff = 0;
    var _const = 0;
    var _val_x = 0;
    var _raw_data = [];
    var _wrong_options = [];
    var _wrong_idx = 0;
    
    switch (_subject_type) {
        // =========================================================================
        // SUBJECT 0: MATHEMATICS (Procedurally Generated)
        // =========================================================================
        case 0:
            var _math_type = irandom(3);
            
            switch (_math_type) {
                case 0: // Addition
                    _val_a = irandom_range(10, 99);
                    _val_b = irandom_range(10, 99);
                    _ans = _val_a + _val_b;
                    _question_text = "Solve: " + string(_val_a) + " + " + string(_val_b);
                    _correct_index = irandom(3);
                    _choices[_correct_index] = string(_ans);
                    
                    for (var i = 0; i < 4; i++) {
                        if (i != _correct_index) {
                            _wrong = _ans + choose(-10, -5, -2, -1, 1, 2, 5, 10) + irandom_range(-3, 3);
                            while (_wrong == _ans || _wrong < 0) {
                                _wrong += irandom_range(1, 5);
                            }
                            _choices[i] = string(_wrong);
                        }
                    }
                    break;
                    
                case 1: // Subtraction
                    _val_a = irandom_range(30, 150);
                    _val_b = irandom_range(10, _val_a);
                    _ans = _val_a - _val_b;
                    _question_text = "Solve: " + string(_val_a) + " - " + string(_val_b);
                    _correct_index = irandom(3);
                    _choices[_correct_index] = string(_ans);
                    
                    for (var i = 0; i < 4; i++) {
                        if (i != _correct_index) {
                            _wrong = _ans + choose(-8, -4, -1, 1, 4, 8);
                            while (_wrong == _ans || _wrong < 0) {
                                _wrong += irandom_range(1, 4);
                            }
                            _choices[i] = string(_wrong);
                        }
                    }
                    break;
                    
                case 2: // Multiplication
                    _val_a = irandom_range(4, 15);
                    _val_b = irandom_range(3, 12);
                    _ans = _val_a * _val_b;
                    _question_text = "Solve: " + string(_val_a) + " * " + string(_val_b);
                    _correct_index = irandom(3);
                    _choices[_correct_index] = string(_ans);
                    
                    for (var i = 0; i < 4; i++) {
                        if (i != _correct_index) {
                            _wrong = _ans + choose(-_val_a, _val_a, -_val_b, _val_b, -2, 2);
                            while (_wrong == _ans || _wrong <= 0) {
                                _wrong += irandom_range(1, 3);
                            }
                            _choices[i] = string(_wrong);
                        }
                    }
                    break;
                    
                case 3: // Algebraic Expression
                    _val_x = irandom_range(2, 9);
                    _coeff = irandom_range(2, 6);
                    _const = irandom_range(1, 15);
                    _ans = (_coeff * _val_x) + _const;
                    _question_text = "If x = " + string(_val_x) + ", find " + string(_coeff) + "x + " + string(_const);
                    _correct_index = irandom(3);
                    _choices[_correct_index] = string(_ans);
                    
                    for (var i = 0; i < 4; i++) {
                        if (i != _correct_index) {
                            _wrong = _ans + choose(-3, -1, 1, 3, 5);
                            while (_wrong == _ans || _wrong <= 0) {
                                _wrong += irandom_range(1, 4);
                            }
                            _choices[i] = string(_wrong);
                        }
                    }
                    break;
            }
            break;
            
        // =========================================================================
        // SUBJECT 1: SCIENCE (Procedurally Selected & Formatted)
        // =========================================================================
        case 1:
            var _sci_category = irandom(3);
            _raw_data = [];
            
            switch (_sci_category) {
                case 0: // Chemical Symbols
                    var _elements = [
                        ["Chemical symbol for Gold?", "Au", "Ag", "Fe", "Gd"],
                        ["Chemical symbol for Silver?", "Ag", "Au", "Si", "Pb"],
                        ["Chemical symbol for Iron?", "Fe", "Ir", "Fi", "Fe2"],
                        ["Chemical symbol for Sodium?", "Na", "So", "S", "Na2"],
                        ["Chemical symbol for Potassium?", "K", "P", "Po", "Pt"],
                        ["Chemical symbol for Helium?", "He", "H", "Hl", "Hm"],
                        ["Chemical symbol for Oxygen?", "O", "Ox", "O2", "Og"],
                        ["Chemical symbol for Copper?", "Cu", "Co", "Cp", "Cr"]
                    ];
                    _raw_data = _elements[irandom(array_length(_elements) - 1)];
                    break;
                    
                case 1: // Planets & Astronomy
                    var _space_facts = [
                        ["Largest planet in the Solar System?", "Jupiter", "Saturn", "Neptune", "Uranus"],
                        ["Closest planet to the Sun?", "Mercury", "Venus", "Mars", "Earth"],
                        ["Which planet is known as the Red Planet?", "Mars", "Venus", "Jupiter", "Saturn"],
                        ["Planet famous for its high-visibility rings?", "Saturn", "Uranus", "Jupiter", "Neptune"]
                    ];
                    _raw_data = _space_facts[irandom(array_length(_space_facts) - 1)];
                    break;
                    
                case 2: // Biology & Physics
                    var _general_sci = [
                        ["Powerhouse of the cell?", "Mitochondria", "Nucleus", "Ribosome", "Golgi Body"],
                        ["Unit of electrical resistance?", "Ohm", "Volt", "Ampere", "Watt"],
                        ["Gas absorbed by plants during photosynthesis?", "Carbon Dioxide", "Oxygen", "Nitrogen", "Hydrogen"],
                        ["Speed of light in a vacuum (approx)?", "300,000 km/s", "150,000 km/s", "1,000,000 km/s", "3,000 km/s"]
                    ];
                    _raw_data = _general_sci[irandom(array_length(_general_sci) - 1)];
                    break;
                    
                case 3: // States of Matter & Mechanics
                    var _physics_facts = [
                        ["Process of solid turning directly into gas?", "Sublimation", "Evaporation", "Condensation", "Melting"],
                        ["SI unit of force?", "Newton", "Joule", "Pascal", "Watt"],
                        ["Primary component of natural gas?", "Methane", "Ethane", "Propane", "Butane"]
                    ];
                    _raw_data = _physics_facts[irandom(array_length(_physics_facts) - 1)];
                    break;
            }
            
            _question_text = _raw_data[0];
            _correct_index = irandom(3);
            _choices[_correct_index] = _raw_data[1];
            
            _wrong_options = [_raw_data[2], _raw_data[3], _raw_data[4]];
            _wrong_idx = 0;
            for (var i = 0; i < 4; i++) {
                if (i != _correct_index) {
                    _choices[i] = _wrong_options[_wrong_idx];
                    _wrong_idx++;
                }
            }
            break;
            
        // =========================================================================
        // SUBJECT 2: HISTORY (Procedurally Selected & Formatted)
        // =========================================================================
        case 2:
            var _hist_category = irandom(2);
            _raw_data = [];
            
            switch (_hist_category) {
                case 0: // Historical Eras & Events
                    var _events = [
                        ["Year the Titanic sank?", "1912", "1905", "1918", "1923"],
                        ["Century of the Renaissance peak in Europe?", "15th Century", "12th Century", "18th Century", "10th Century"],
                        ["Ancient wonder located in Giza?", "Great Pyramid", "Hanging Gardens", "Colossus", "Lighthouse"],
                        ["First artificial satellite sent into space?", "Sputnik 1", "Explorer 1", "Vostok 1", "Apollo 11"]
                    ];
                    _raw_data = _events[irandom(array_length(_events) - 1)];
                    break;
                    
                case 1: // Historical Figures
                    var _figures = [
                        ["Civilization that built the Parthenon?", "Ancient Greeks", "Romans", "Egyptians", "Persians"],
                        ["Who formulated the laws of motion?", "Isaac Newton", "Galileo Galilei", "Nikola Tesla", "Albert Einstein"],
                        ["First human to travel into outer space?", "Yuri Gagarin", "Neil Armstrong", "Buzz Aldrin", "John Glenn"]
                    ];
                    _raw_data = _figures[irandom(array_length(_figures) - 1)];
                    break;
                    
                case 2: // Inventions & Discoveries
                    var _inventions = [
                        ["Inventor credited with the telephone?", "Alexander Graham Bell", "Thomas Edison", "Guglielmo Marconi", "Benjamin Franklin"],
                        ["Main writing material used in Ancient Egypt?", "Papyrus", "Parchment", "Vellum", "Paper"],
                        ["Discovered penicillin in 1928?", "Alexander Fleming", "Louis Pasteur", "Robert Koch", "Edward Jenner"]
                    ];
                    _raw_data = _inventions[irandom(array_length(_inventions) - 1)];
                    break;
            }
            
            _question_text = _raw_data[0];
            _correct_index = irandom(3);
            _choices[_correct_index] = _raw_data[1];
            
            _wrong_options = [_raw_data[2], _raw_data[3], _raw_data[4]];
            _wrong_idx = 0;
            for (var i = 0; i < 4; i++) {
                if (i != _correct_index) {
                    _choices[i] = _wrong_options[_wrong_idx];
                    _wrong_idx++;
                }
            }
            break;
    }
    
    return {
        question: _question_text,
        answers: _choices,
        correct: _correct_index,
        limit: _max_questions
    };
}