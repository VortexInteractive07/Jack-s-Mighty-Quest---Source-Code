function msg(_speaker, _text) {
    return { speaker: _speaker, text: _text };
}

function get_dialogue_intro() {
    // 0 = English, 1 = Romaji, 2 = Dhivehi (Latinized)
    switch (global.language_mode) {
        case 1: // Romaji Mode
            return [
                msg("SYSTEM", "CHOTTO MATTE...\nOYA! HARO!"),
                msg("JACK", "JACK DESU!"),
                msg("SYSTEM", "OSHIRASE SHIMASU..."),
                msg("SYSTEM", "KORE WA PUROTOTAIIPU DESU."),
                msg("SYSTEM", "MITE NO TOORI..."),
                msg("SYSTEM", "OOKU NO KINOU WA MIKANSEI\nMATAWA KOWARETE IMASU."),
                msg("SYSTEM", "KONO FEEZU DEWA,\nJUUDAINA BAGU YA KURASSHU NI\nSOUGOU SURU KANOUSEI GA ARIMASU."),
                msg("SYSTEM", "KAIHATSU CHIIMU NO SAGYOU WO\nKANTAN NI SURU TAME NI..."),
                msg("SYSTEM", "IKA NO Gmail NI BAGU REPOOTO WO\nSOUSHIN SHITE KUDASAI:"),
                msg("SYSTEM", "info.vortexint@gmail.com"),
                msg("SYSTEM", "GEEMU WO TESUTO SHITE ITADAKI\nARIGATOU GOZAIMASU!"),
                msg("VORTEX", "Vortex Corporation\nMaldives NI YOTTE\nTEIKYOU SARETE IMASU"),
                msg("SYSTEM", "(C) 2026\nAll Rights Reserved"),
                msg("SYSTEM", "KUIKKU NOOTO:"),
                msg("SYSTEM", "KONO GEEMU NI SONZAI SURU\nHOTONDO NO PUROTOTAIIPU KINOU WA"),
                msg("SYSTEM", "SHOURAI NO ITEREESHON DE\nHENKOU SARERU KANOUSEI GA ARIMASU!"),
                msg("SYSTEM", "ITSUMO NO YUU NI,\nHAJIMEMASHOU!")
            ];
            // Removed unreachable break

        case 2: // Dhivehi Mode (Latinized / Romanized)
            return [
                msg("SYSTEM", "Irukolheh dhehcheh..\nAha! Koba?"),
                msg("JACK", "Aharen ge namakee Jack!"),
                msg("SYSTEM", "Emme furathama ves alhugandumen bunelan\nbeynunfulhu vaa vaahaka akee..."),
                msg("SYSTEM", "mi version akee fahaga kohlevey\ngothugaa under development build eh!"),
                msg("SYSTEM", "Engi vadaigannavaane,"),
                msg("SYSTEM", "mi game ge varah gina baithakeh\nmivaguthu hadhamun dhaatheeve,"),
                msg("SYSTEM", "game hutti, nufenna faadhu faadhuge\nkankan dhimaavedhaane!"),
                msg("SYSTEM", "E fadha kameh faahaga vehjje kamugai\nvaanama,"),
                msg("SYSTEM", "mi email ah bug report eh\nfonuvailadhevva!"),
                msg("SYSTEM", "info.vortexint@gmail.com"),
                msg("SYSTEM", "Game test kurevuneethee varah bodah shukuru\n dhannavan!"),
                msg("VORTEX", "Presented to you by\nVortex Corporation\nMaldives"),
                msg("SYSTEM", "(C) 2026\nAll Rights Reserved"),
                msg("SYSTEM", "QUICK NOTE:"),
                msg("SYSTEM", "Mi game ge gina thakethi anna\nversion thakugaa"),
                msg("SYSTEM", "badhal genas, nuvatha eythi remove kureveynekan\nangaaladhen!"),
                msg("SYSTEM", "OK! Hingaa fashamaa!")
            ];
            // Removed unreachable break

        default: // English Mode
            return [
                msg("SYSTEM", "Hold up...\nOh! Hiya!"),
                msg("JACK", "Jack here!"),
                msg("SYSTEM", "Just to let you know..."),
                msg("SYSTEM", "This is an prototype tech demo."),
                msg("SYSTEM", "As you can tell..."),
                msg("SYSTEM", "Many features are unfinished\nor broken."),
                msg("SYSTEM", "During this phase,\nyou may encounter severe bugs\nand potential crashes."),
                msg("SYSTEM", "To make stuff easier for our\ndevelopment team..."),
                msg("SYSTEM", "Send a bug report to our\nfollowing Gmail:"),
                msg("SYSTEM", "info.vortexint@gmail.com"),
                msg("SYSTEM", "Thank you for\ntesting our game!"),
                msg("VORTEX", "Presented to you by\nVortex Corporation\nMaldives"),
                msg("SYSTEM", "(C) 2026\nAll Rights Reserved"),
                msg("SYSTEM", "QUICK NOTE:"),
                msg("SYSTEM", "Most prototype features present\nin this game"),
                msg("SYSTEM", "are subject to change\nin future iterations!"),
                msg("SYSTEM", "As always, let's hop in!")
            ];
            // Removed unreachable break
    }
}