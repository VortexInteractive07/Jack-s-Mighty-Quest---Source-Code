/// @function scr_intro_dialogue()
/// @description Returns the localized splash intro dialogue spoken by Jack.
function scr_intro_dialogue() {
    var _language = variable_global_exists("language") ? global.language : "EN";
    var _messages;

    switch (_language) {
        case "DE":
            _messages = [
                "GLÜCKWUNSCH!\nDU HAST DIE WORK-IN-PROGRESS-DEMO\nVON JACK'S MIGHTY QUEST GESTARTET!",
                "ICH HABE BEIM ERSTEN AUFTRITT\nFAST GESCHLAFEN! DOCH HÖR GUT ZU!",
                "DIESES SPIEL IST NOCH IN\nVOLLER ENTWICKLUNG!",
                "GRAFIK, MUSIK UND SPIELABLAUF\nKÖNNEN SICH NOCH ÄNDERN!",
                "ALLES GEHÖRT UNS!\nBITTE VERBREITE DIE SPIELDATEIEN NICHT!",
                "EINE WAHRE HELDIN IST EINE SCHWESTER,\nDIE DIE WELT BESCHÜTZT! DANKE FÜRS TESTEN!",
                "AUF ZUR NÄCHSTEN STUFE!\nVIEL GLÜCK!"
            ];
            break;
        case "ES":
            _messages = [
                "¡ENHORABUENA!\n¡HAS INICIADO LA DEMO EN DESARROLLO\nDE JACK'S MIGHTY QUEST!",
                "¡CASI ME DUERMO EN LA PRIMERA ESCENA!\n¡DESPIERTA Y ESCUCHA CON ATENCIÓN!",
                "¡ESTE JUEGO SIGUE\nEN PLENO DESARROLLO!",
                "¡LOS GRÁFICOS, LA MÚSICA Y EL JUEGO\nTODAVÍA PUEDEN CAMBIAR!",
                "¡TODO ESTO ES NUESTRO!\nNO FILTRES NI COPIES LOS ARCHIVOS DEL JUEGO.",
                "¡UNA VERDADERA HEROÍNA ES UNA HERMANA\nQUE PROTEGE EL MUNDO! ¡GRACIAS POR PROBARLO!",
                "¡A POR LA SIGUIENTE FASE!\n¡MUCHA SUERTE!"
            ];
            break;
        case "PL":
            _messages = [
                "GRATULACJE!\nURUCHOMILES DEMO W TRAKCIE PRAC\nGRY JACK'S MIGHTY QUEST!",
                "PRAWIE ZASNALEM W PIERWSZEJ SCENIE!\nALE OBUDZ SIE I SLUCHAJ UWAZNIE!",
                "TA GRA JEST NADAL\nW TRAKCIE TWORZENIA!",
                "GRAFIKA, MUZYKA I ROZGRYWKA\nMOGA JESZCZE SIE ZMIENIC!",
                "TO NASZA GRA!\nNIE ROZPOWSZECHNIAJ PLIKOW GRY!",
                "PRAWDZIWA BOHATERKA TO SIOSTRA,\nKTORA CHRONI SWIAT! DZIEKI ZA TESTY!",
                "RUSZAJ DO NASTEPNEJ FAZY!\nPOWODZENIA!"
            ];
            break;
        case "SH":
            _messages = [
                "WELL MET!\nTHOU HAST BEGUN THE WORK-IN-PROGRESS DEMO\nOF JACK'S MIGHTY QUEST!",
                "I NEARLY SLEPT THROUGH MINE ENTRANCE!\nPRAY, WAKE AND LEND THINE EAR!",
                "THIS GAME REMAINS\nIN MIGHTY DEVELOPMENT!",
                "ART, MUSIC, AND PLAY MAY CHANGE\nERE THIS QUEST IS FULLY WROUGHT!",
                "ALL THIS REALM IS OURS!\nSPREAD NOT THE GAME'S SECRET FILES!",
                "A TRUE HERO IS A SISTER WHO KEEPS\nTHE WORLD FROM PERIL! THANK THEE, TESTERS!",
                "ONWARD TO THE NEXT STAGE!\nGOOD FORTUNE GO WITH THEE!"
            ];
            break;
        case "EG":
            _messages = [
                "CONGRATULATIONS GOOD!\nYOU STARTED THE WORK-IN-PROGRESS DEMO\nOF JACK'S MIGHTY QUEST GAME!",
                "I WAS SLEEPING AT THE FIRST SCENE!\nPLEASE WAKE UP YOUR EARS NOW!",
                "THIS GAME SOFTWARE IS STILL\nIN THE MAKING WORKS!",
                "PICTURES, MUSIC AND PLAYING RULES\nMAY BE CHANGED IN FUTURE TIMES!",
                "ALL YOUR BASE ARE BELONG TO US!\nPLEASE DO NOT LEAK THE CARTRIDGE FILE!",
                "A REAL HERO IS A SISTER WHO PROTECTS\nTHE WORLD, YES! THANK YOU FOR TESTING!",
                "GO NOW TO NEXT STAGE PLACE!\nGOOD LUCK TO YOU PERSON!"
            ];
            break;
        case "JG":
            _messages = [
                "OMEDATOU!\nYOU START WORKING DEMO OF\nJACK'S MIGHTY QUEST, PLEASE!",
                "I SLEEP AT FIRST SCENE!\nWAKE UP AND LISTEN WITH YOUR EARS!",
                "THIS SOFTWARE IS STILL\nUNDER DEVELOPMENT CONSTRUCTION!",
                "GRAPHICS, MUSIC AND GAME PLAY\nMAY CHANGE IN FUTURE TIME, SORRY!",
                "ALL YOUR BASE ARE BELONG TO US!\nDO NOT SHARE GAME DATA, PLEASE FRIEND!",
                "A TRUE HERO IS A SISTER WHO PROTECTS\nTHE WORLD! THANK YOU FOR TEST PLAY!",
                "GO TO NEXT STAGE NOW!\nGOOD LUCK, PLEASE!"
            ];
            break;
        default:
            _messages = [
                "CONGRATURATION!\nYOU HAVE START THE WORK-IN-PROGRESS DEMO\nOF JACK'S MIGHTY QUEST!",
                "I FEEL ASLEEP AT THE FIRST SCENE!\nBUT PLEASE WAKE UP AND LISTEN CLOSELY!",
                "THIS SOFTWARE PROGRAM IS STILL\nUNDER HEAVY DEVELOPMENT CONSTRUCTION!",
                "MANY GRAPHICS, SOUND TUNES, AND GAMEPLAY\nWILL BE CHANGE OR GO AWAY IN FUTURE TIME!",
                "ALL YOUR BASE ARE BELONG TO US!\nSO DO NOT LEAK OR PIRATE THIS CARTRIDGE DATA!",
                "A REAL HERO IS SISTER WHO PROTECTS WORLD!\nTHANK YOU FOR TEST OUR PROTOTYPE GAME!",
                "NOW GO AND PROCEEDS TO NEXT STAGE!\nGOOD LUCK TO YOU!"
            ];
            break;
    }

    var _dialogue = [];
    for (var _i = 0; _i < array_length(_messages); _i++) {
        array_push(_dialogue, {
            name: "Jack",
            text: _messages[_i],
            font: fnt_bitmap,
            color: c_white,
            scale: 1,
            speed: 0.45,
            hold: 200 + (_i * 10)
        });
    }
    return _dialogue;
}
