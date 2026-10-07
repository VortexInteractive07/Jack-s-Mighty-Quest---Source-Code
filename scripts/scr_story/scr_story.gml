/// @function scr_story()
/// @description Returns the opening story as scene structs with explicit speaker attribution.
function scr_story() {
    var _story = [
        {
            sprite: spr_celestia, speaker: "NARRATOR", sfx: sfx_ambient_city,
            text: "Morning air drifted over Celestia, fresh and quiet. Transit lines hummed softly while sunrise shone across the glass towers.",
            de_text: "Morgenluft zog frisch und still ueber Celestia. Die Bahnlinien summten leise, waehrend die Sonne auf den Glastuermen schimmerte."
        },
        {
            sprite: -1, speaker: "NARRATOR", sfx: sfx_dialogue_narrative,
            text: "A peaceful city nestled in Aetheria... or so it was, until four minutes ago.",
            de_text: "Eine friedliche Stadt in Aetheria... zumindest bis vor vier Minuten."
        },
        {
            sprite: -1, speaker: "NARRATOR", sfx: sfx_dialogue_narrative,
            text: "Inside the Moore home, the morning did not begin with a heroic call. It began with burnt breakfast and three loud microwave beeps.",
            de_text: "Im Haus der Moores begann der Morgen nicht mit einem heldenhaften Auftrag. Er begann mit verbranntem Fruehstueck und drei lauten Pieptoenen aus der Mikrowelle."
        },
        {
            sprite: -1, speaker: "JACK", sfx: sfx_jack_speak,
            text: "Unbelievable! I set it for TWO MINUTES!",
            de_text: "Unglaublich! Ich hatte ZWEI MINUTEN eingestellt!"
        },
        {
            sprite: -1, speaker: "NARRATOR", sfx: sfx_dialogue_narrative,
            text: "Jack opened the door. Smoke poured out, smelling like burnt cardboard. A dead sensor had ruined his food again. Charlotte stepped in, unplugged the microwave, and patted his arm.",
            de_text: "Jack oeffnete die Tuer. Rauch stroemte heraus und roch nach verbranntem Karton. Ein defekter Sensor hatte sein Essen schon wieder ruiniert. Charlotte zog den Stecker und legte ihm sanft die Hand auf den Arm."
        },
        {
            sprite: -1, speaker: "CHARLOTTE", sfx: sfx_charlotte_speak,
            text: "Let it go, Jackie. We can always get another microwave, I guess!",
            de_text: "Lass gut sein, Jackie. Wir koennen uns wohl einfach eine neue Mikrowelle besorgen!"
        },
        {
            sprite: -1, speaker: "NARRATOR", sfx: sfx_dialogue_narrative,
            text: "Jack's irritation faded. It was nearly impossible to stay mad around Charlotte. Ah, young love and broken microwaves. Exactly what you expected!",
            de_text: "Jacks Aerger verrauchte. Neben Charlotte konnte er kaum lange boese sein. Ach, junge Liebe und kaputte Mikrowellen. Genau das habt ihr erwartet!"
        },
        {
            sprite: -1, speaker: "NARRATOR", sfx: sfx_explosion_subdued,
            text: "But peaceful mornings in a game never last. Before Jack could answer, an earthquake slammed through the floor. Dishes crashed; the windows shattered.",
            de_text: "Doch friedliche Spielmorgen halten nie lange. Bevor Jack antworten konnte, erschuetterte ein Erdbeben den Boden. Geschirr zersprang, die Fenster zerbarsten."
        },
        {
            sprite: -1, speaker: "JACK", sfx: sfx_jack_speak,
            text: "Whoa!",
            de_text: "Whoa!"
        },
        {
            sprite: -1, speaker: "EMERGENCY BROADCAST", sfx: sfx_dialogue_narrative,
            text: "Warning! All citizens must stay indoors. The main power grid is down, and intruders have breached Sector 1.",
            de_text: "Warnung! Alle Einwohner muessen in ihren Wohnungen bleiben. Das Hauptstromnetz ist ausgefallen. Eindringlinge sind in Sektor 1 eingedrungen."
        },
        {
            sprite: -1, speaker: "NARRATOR", sfx: sfx_dialogue_narrative,
            text: "Jack raced to the window. Black smoke spiraled above the suburbs. Buildings sparked, neon signs died, and sirens wailed through the streets.",
            de_text: "Jack eilte zum Fenster. Schwarzer Rauch stieg ueber den Vororten auf. Gebaeude spruehten Funken, Leuchtreklamen erloschen und Sirenen heulten durch die Strassen."
        },
        {
            sprite: -1, speaker: "NARRATOR", sfx: sfx_screen_off,
            text: "Charlotte pointed at the wall screen. The emergency signal vanished, replaced by a shifting dark logo. The city's defense network had been hacked from within.",
            de_text: "Charlotte zeigte auf den Bildschirm. Das Warnsignal verschwand und ein wandelndes, dunkles Logo erschien. Das Verteidigungsnetz der Stadt war von innen gehackt worden."
        },
        {
            sprite: -1, speaker: "NARRATOR", sfx: sfx_dialogue_narrative,
            text: "Oh boy... here comes the main villain. Doctor Victor Schadenfreude had seized control of Celestia's systems.",
            de_text: "Oje... jetzt kommt der grosse Boesewicht. Doktor Victor Schadenfreude hatte Celestias Systeme uebernommen."
        },
        {
            sprite: -1, speaker: "NARRATOR", sfx: sfx_dialogue_narrative,
            text: "Jack grabbed his handheld tactical screen. Its diagnostic logs confirmed the whole city was locked down.",
            de_text: "Jack griff nach seinem taktischen Handbildschirm. Die Diagnoseprotokolle bestaetigten: Die ganze Stadt war abgeriegelt."
        },
        {
            sprite: -1, speaker: "JACK", sfx: sfx_jack_speak,
            text: "We need to reach Dad's office, President William Smith Moore's office, and use the master passwords.",
            de_text: "Wir muessen zu Papas Buero, dem Buero von Praesident William Smith Moore, und die Hauptpasswoerter benutzen."
        },
        {
            sprite: -1, speaker: "CHARLOTTE", sfx: sfx_charlotte_speak,
            text: "I have my tech kit. We can get to President Moore's office together.",
            de_text: "Meine Technik-Ausruestung habe ich dabei. Zusammen kommen wir zu Praesident Moores Buero."
        },
        {
            sprite: -1, speaker: "JACK", sfx: sfx_jack_speak,
            text: "The streets are too dangerous. Stay here and lock the door. I'll go alone.",
            de_text: "Die Strassen sind zu gefaehrlich. Bleib hier und schliess die Tuer ab. Ich gehe allein."
        },
        {
            sprite: -1, speaker: "CHARLOTTE", sfx: sfx_charlotte_speak,
            text: "We're going together, Jack. That's final.",
            de_text: "Wir gehen zusammen, Jack. Das steht fest."
        },
        {
            sprite: -1, speaker: "DOCTOR VICTOR SCHADENFREUDE", sfx: sfx_sharp_speak,
            text: "Did you really think you could lock me out of my own playground, little boy? Celestia belongs to the future now. Your little legacy ends TODAY!",
            de_text: "Dachtest du wirklich, du koenntest mich aus meinem eigenen Spielplatz aussperren, kleiner Junge? Celestia gehoert jetzt der Zukunft. Dein kleines Vermachtnis endet HEUTE!"
        },
        {
            sprite: -1, speaker: "NARRATOR", sfx: sfx_victor_laugh,
            text: "His evil laugh echoed through the apartment. The screen went black. Classic villain speech, right? Whoever wrote this deserves a raise!",
            de_text: "Sein boeses Lachen hallte durch die Wohnung. Der Bildschirm wurde schwarz. Ein klassischer Boesewicht-Monolog, oder? Wer das geschrieben hat, verdient eine Gehaltserhoehung!"
        },
        {
            sprite: -1, speaker: "NARRATOR", sfx: sfx_dialogue_narrative,
            text: "Jack nodded to Charlotte. She would watch his back. Together, they stepped into the chaos outside.",
            de_text: "Jack nickte Charlotte zu. Sie wuerde ihm den Ruecken freihalten. Gemeinsam traten sie hinaus ins Chaos."
        }
    ];

    var _language = variable_global_exists("language") ? global.language : "EN";
    if (_language == "DE") {
        for (var _i = 0; _i < array_length(_story); _i++) {
            if (variable_struct_exists(_story[_i], "de_text")) {
                _story[_i].text = _story[_i].de_text;
            }
        }
    }

    return _story;
}
