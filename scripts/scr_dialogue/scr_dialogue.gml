/// @function scr_dialogue(_dialogue_id)
/// @description Returns localized dialogue structs for title and stage introductions.
function scr_dialogue(_dialogue_id) {
    var _language = variable_global_exists("language") ? global.language : "EN";

    switch (_dialogue_id) {
        case "title_intro":
            switch (_language) {
                case "DE": return [
                    { speaker: "JACK", text: "Hallo! Ich bin Jack. Willkommen bei Jack's Mighty Quest:\nDie Alpha-Indev-Version!" },
                    { speaker: "JACK", text: "Dies ist eine fruehe Entwicklungsversion.\nManches ist noch etwas holprig." },
                    { speaker: "JACK", text: "Probiert die Level und meine Moves aus\nund sagt uns, was noch besser werden muss." },
                    { speaker: "JACK", text: "Wenn etwas komisch aussieht, ist es wohl\nkein geheimes Feature. Wahrscheinlich." },
                    { speaker: "JACK", text: "Danke fuers Testen! Bereit, unser\nmaechtiges Abenteuer zu beginnen?" }
                ];
                case "ES": return [
                    { speaker: "JACK", text: "¡Hola! Soy Jack. Bienvenidos a Jack's Mighty Quest:\n¡La versión Alpha Indev!" },
                    { speaker: "JACK", text: "Esta es una versión temprana del juego,\nasí que algunas cosas aún están sin pulir." },
                    { speaker: "JACK", text: "Prueben las fases y mis movimientos,\ny cuéntennos qué debemos arreglar." },
                    { speaker: "JACK", text: "Si algo parece raro, probablemente\nno sea una función secreta. Probablemente." },
                    { speaker: "JACK", text: "¡Gracias por ayudar con las pruebas!\n¿Listos para nuestra gran aventura?" }
                ];
                case "PL": return [
                    { speaker: "JACK", text: "Hej! Jestem Jack. Witajcie w Jack's Mighty Quest:\nwersji Alpha Indev!" },
                    { speaker: "JACK", text: "To wczesna wersja gry,\nwiec nie wszystko jest jeszcze dopracowane." },
                    { speaker: "JACK", text: "Sprawdzcie poziomy i moje ruchy,\na potem powiedzcie nam, co poprawic." },
                    { speaker: "JACK", text: "Jesli cos wyglada dziwnie, to pewnie\nnie jest tajna funkcja. Chyba." },
                    { speaker: "JACK", text: "Dzieki za pomoc w testach! Gotowi,\nby zaczac nasza wielka przygode?" }
                ];
                case "SH": return [
                    { speaker: "JACK", text: "Good morrow! I am Jack. Welcome to Jack's Mighty Quest:\nThe Alpha Indev build!" },
                    { speaker: "JACK", text: "This humble build is yet in its youth,\nso rough edges may still be found." },
                    { speaker: "JACK", text: "Try every stage and test my merry moves;\nthen tell us what deserves repair." },
                    { speaker: "JACK", text: "If aught looks strange, 'tis likely not\na secret feature. Likely." },
                    { speaker: "JACK", text: "I thank thee for thy help in testing!\nShall we begin our mighty quest?" }
                ];
                case "EG": return [
                    { speaker: "JACK", text: "Hello! I am Jack. Welcome to Jack's Mighty Quest:\nThe Alpha Indev development build, yes!" },
                    { speaker: "JACK", text: "This game is early developing now,\nso some parts are not finished good." },
                    { speaker: "JACK", text: "Please try stages and test my moves,\nthen tell us what is needing fix." },
                    { speaker: "JACK", text: "If something is looking strange,\nit is probably not secret feature, maybe." },
                    { speaker: "JACK", text: "Thank you for testing help!\nAre we ready for mighty quest start?" }
                ];
                case "JG": return [
                    { speaker: "JACK", text: "KONNICHIWA! I am Jack person.\nWelcome to Jack's Mighty Quest game!" },
                    { speaker: "JACK", text: "This is Alpha Indev build.\nSome things are still under making." },
                    { speaker: "JACK", text: "Please test the stages and jump action.\nTell us bugs, not only good things." },
                    { speaker: "JACK", text: "If strange thing happens, it is not\na secret. Maybe it is a bug-san." },
                    { speaker: "JACK", text: "Thank you for test play!\nPlease start the mighty quest now." }
                ];
                default: return [
                    { speaker: "JACK", text: "Hey! I'm Jack. Welcome to Jack's Mighty Quest:\nThe Alpha Indev build!" },
                    { speaker: "JACK", text: "This is an early development build,\nso a few things may still be rough." },
                    { speaker: "JACK", text: "Try the stages, test the moves,\nand let us know what needs fixing." },
                    { speaker: "JACK", text: "If something looks odd, it probably\nisn't a secret feature. Probably." },
                    { speaker: "JACK", text: "Thanks for helping us test!\nReady to start our mighty quest?" }
                ];
            }

        case "stage_intro":
            switch (_language) {
                case "DE": return [
                    { speaker: "JACK", text: "NÄCHSTER HALT: DIE U-BAHN.\nDIE SCHILDER SAGEN: 'VORSICHT, LÜCKE.'" },
                    { speaker: "JACK", text: "Mehr Sorgen macht mir,\nwas auch immer dieses Geräusch macht." },
                    { speaker: "JACK", text: "Bleib wachsam, pass auf deinen Schritt auf\nund füttere bitte keine Schleime." },
                    { speaker: "JACK", text: "Na dann. Das Abenteuer ruft!\nHoffentlich gilt mein Ticket noch." }
                ];
                case "ES": return [
                    { speaker: "JACK", text: "SIGUIENTE PARADA: EL METRO.\nLOS CARTELES DICEN: 'CUIDADO CON EL HUECO'." },
                    { speaker: "JACK", text: "Me preocupa más\nlo que está haciendo ese ruido." },
                    { speaker: "JACK", text: "Mantén los ojos abiertos, mira dónde pisas\ny no alimentes a los limos." },
                    { speaker: "JACK", text: "¡Muy bien, la aventura nos espera!\nEspero que mi billete siga siendo válido." }
                ];
                case "PL": return [
                    { speaker: "JACK", text: "NASTEPNY PRZYSTANEK: METRO.\nTABLICE MOWIA: 'UWAZAJ NA SZCZELINE'." },
                    { speaker: "JACK", text: "Bardziej martwi mnie\nto, co wydaje ten halas." },
                    { speaker: "JACK", text: "Uwazaj na kroki i miej oczy otwarte.\nI nie karm slimow." },
                    { speaker: "JACK", text: "No dobrze, przygoda czeka!\nOby moj bilet byl jeszcze wazny." }
                ];
                case "SH": return [
                    { speaker: "JACK", text: "NEXT, TO THE SUBWAY!\nTHE SIGNS CRY: 'MIND THE GAP.'" },
                    { speaker: "JACK", text: "Yet more I fear the dreadful noise\nthan any chasm 'neath my feet." },
                    { speaker: "JACK", text: "Keep sharp, watch where thou dost tread,\nand feed no slime, however sad." },
                    { speaker: "JACK", text: "Come then! Adventure calls us forth.\nI pray my ticket still holds worth." }
                ];
                case "EG": return [
                    { speaker: "JACK", text: "NEXT STOP: SUBWAY PLACE.\nSIGN SAYS 'PLEASE MIND THE HOLE GAP'." },
                    { speaker: "JACK", text: "I am more worried about noise thing\nthan the very big floor gap." },
                    { speaker: "JACK", text: "Watch your foot carefully, please.\nDo not give food to slime persons." },
                    { speaker: "JACK", text: "Adventure is waiting now!\nI hope ticket is still use-valid." }
                ];
                case "JG": return [
                    { speaker: "JACK", text: "TSUGI STOP: SUBWAY STATION.\nSIGN: 'MIND THE GAP, PLEASE FRIEND.'" },
                    { speaker: "JACK", text: "That sound is very not relaxing.\nI am worry about the noise-san." },
                    { speaker: "JACK", text: "Please watch the step carefully.\nSlime is not a pet, maybe." },
                    { speaker: "JACK", text: "Adventure is starting now!\nTicket is okay? We will find out." }
                ];
                default: return [
                    { speaker: "JACK", text: "NEXT STOP: THE SUBWAY.\\nTHE SIGNS SAY 'MIND THE GAP.'" },
                    { speaker: "JACK", text: "I'M MORE WORRIED ABOUT\\nWHATEVER IS MAKING THAT NOISE." },
                    { speaker: "JACK", text: "STAY SHARP, WATCH YOUR STEP,\\nAND PLEASE DON'T FEED THE SLIMES." },
                    { speaker: "JACK", text: "RIGHT THEN. ADVENTURE AWAITS!\\nI HOPE IT VALIDATED MY TICKET." }
                ];
            }
    }

    return [];
}

/// @function scr_dialogue_format_text(_text)
/// @description Normalizes escaped newline markers for dialogue and splash rendering.
function scr_dialogue_format_text(_text) {
    var _formatted = string(_text);
    _formatted = string_replace_all(_formatted, "/n", chr(10));
    _formatted = string_replace_all(_formatted, "\\n", chr(10));
    return _formatted;
}
