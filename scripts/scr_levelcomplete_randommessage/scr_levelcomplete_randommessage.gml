/// @function scr_levelcomplete_randommessage()
/// @description Central database of randomized victory text strings
function scr_levelcomplete_randommessage() {
    var _messages = [
        // Standard English
        "STAGE CLEAR!",
        "VICTORY!",
        "AWESOME JOB, JACK!",
        "LEVEL COMPLETE!",
        "EXCELLENT PROGRESS!",
        "You Crushed It!",
        "Sweet moves, Jack!",
        "Perfection!",
        "Bravo, Jack!",
        "Superb!",
        "Extraordinary!",
        "ABSOLUTELY NO WORDS!",
        "WILD!",
        "You're a Legend!",
        "Keep Going!",
        "Unstoppable!",
        
        // Shakespeare
        "No words can describe how great thou art, Jack!",
        "Thou hast conquered the field, good sir!",
        "Fortune smiles upon thee, Jack!",
        "'Tis a triumph fit for kings!",
        "Thou art a champion without peer!",
        "By my troth, thou hast succeeded!",
        "A most valiant display, Jack!",
        
        // Dhivehi
        "Salhi!",
        "Hama Habeys!",
        "Saabahey! Saabahey!",
        "Varah Rangalhu!",
        "Hihvarah Saabas, Jack!",
        
        // Japanese (Transliterated)
        "YATTA!",
        "Omedetou, Jakku!",
        "Sugoi!",
        "Subarashii!",
        
        // French
        "MAGNIFIQUE!",
        "Tres Bien!",
        
        // German
        "GUT GEMACHT!",
        "Ausgezeichnet!",
        
        // Spanish
        "EXCELLENTE!",
        "Buen Trabajo!",
        "Felicidades!",
        
        // Portuguese
        "Parabens!",
        "Muito Bem!",
        
        // Arabic (Transliterated)
        "Ahsant!",
        "Mabrouk!",
        "Mumtaz!",
        
        // Chinese (Transliterated)
        "Jia You!",
        "Tai Bang Le!",
        
        // Korean (Transliterated)
        "Jal Haesseo!",
        "Dae-bak!",
        
        // Engrish / Classic Arcade
        "A WINNER IS YOU!",
        "CONGRATURATION!",
        "JACK, THE GREATNESS!",
        "ALL YOUR BASE ARE BELONG TO US!"
    ];
    
    // Pick a random entry from the array indexes
    var _index = irandom(array_length(_messages) - 1);
    return _messages[_index];
}