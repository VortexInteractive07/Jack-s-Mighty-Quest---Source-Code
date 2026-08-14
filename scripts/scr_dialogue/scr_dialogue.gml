/// @function scr_dialogue(_dialogue_id)
/// @description Returns an array of dialogue structs containing speaker names and text strings.
function scr_dialogue(_dialogue_id) {
    switch (_dialogue_id) {
        case "tech_demo":
            return [
                { speaker: "SYSTEM NOTICE", text: "WELCOME TO JACK'S MIGHTY QUEST!/nTHIS IS A TECH DEMO." },
                { speaker: "SYSTEM NOTICE", text: "REBUILT TO TEST STABILITY, UI,/nAND AUDIO SYSTEMS." },
                { speaker: "SYSTEM NOTICE", text: "PRESS ENTER OR SPACE TO ADVANCE/nAND BEGIN YOUR QUEST." }
            ];
            
        default:
            return [];
    }
}