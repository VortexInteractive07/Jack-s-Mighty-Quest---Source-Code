/// @function scr_dialogue(_dialogue_id)
/// @description Returns an array of dialogue structs containing speaker names and text strings.
function scr_dialogue(_dialogue_id) {
    switch (_dialogue_id) {
        case "tech_demo":
            return [
                { speaker: "NARRATOR", text: "IN A.D. 2101\nWAR WAS BEGINNING." },
                { speaker: "CAPTAIN",  text: "WHAT HAPPEN!?" },
                { speaker: "MECHANIC", text: "SOMEBODY SET UP US THE BOMB." },
                { speaker: "OPERATOR", text: "WE GET SIGNAL." },
                { speaker: "CAPTAIN",  text: "WHAT!" },
                { speaker: "OPERATOR", text: "MAIN SCREEN TURN ON." },
                { speaker: "CAPTAIN",  text: "IT'S YOU!!" },
                { speaker: "CATS",     text: "HOW ARE YOU GENTLEMEN!!" },
                { speaker: "CATS",     text: "ALL YOUR BASE ARE BELONG TO US." },
                { speaker: "CATS",     text: "YOU ARE ON THE WAY TO DESTRUCTION." },
                { speaker: "CAPTAIN",  text: "WHAT YOU SAY!!" },
                { speaker: "CATS",     text: "YOU HAVE NO CHANCE TO SURVIVE\nMAKE YOUR TIME." },
                { speaker: "CATS",     text: "HA HA HA HA !!" },
                { speaker: "OPERATOR", text: "CAPTAIN !!" },
                { speaker: "CAPTAIN",  text: "TAKE OFF EVERY 'ZIG'!!" },
                { speaker: "CAPTAIN",  text: "YOU KNOW WHAT YOU DOING." },
                { speaker: "CAPTAIN",  text: "MOVE 'ZIG'." },
                { speaker: "CAPTAIN",  text: "FOR GREAT JUSTICE." }
            ];
            
        default:
            return [];
    }
}