/// @description Initialize Expanded Intro Sequence (Unlooped Theme Integration)

display_set_gui_size(426, 240);

// --- TARGET LEVEL ROOM ---
var _station_room = (asset_get_index("rm_station") != -1) ? asset_get_index("rm_station") : room;
target_room = _station_room;

// --- AUDIO INTEGRATION ---
// Plays theme unlooped as requested
if (asset_get_index("mus_no_bridge_to_cross_ai") != -1) {
    if (!audio_is_playing(mus_no_bridge_to_cross_ai)) {
        audio_play_sound(mus_no_bridge_to_cross_ai, 1, false);
    }
}

// --- EXTENDED STORY DATA STRUCTURE ---
cutscenes = [
    {
        sprite: -1,
        speaker: "CELESTIA",
        text: "Celestia was never meant to be ordinary. Built in the western suburbs of Aetheria, it rose as a promise kept—where towers of glass caught the morning light and peace felt unbroken."
    },
    {
        sprite: -1,
        speaker: "THE MOORE LEGACY",
        text: "President William Smith Moore and First Lady Samantha spent a generation building Aetheria. Behind them stood decades of quiet service from the Moore and Johnson family line."
    },
    {
        sprite: -1,
        speaker: "JACK & CHARLOTTE",
        text: "Jack sought no spotlight. Alongside his wife Charlotte—a brilliant systems engineer—their life felt like its own small sanctuary, untouched by his father's politics."
    },
    {
        sprite: -1,
        speaker: "THE NIGHT OF FIRE",
        text: "Then the earth lost its footing. Tremors shook Celestia as emergency news broadcasts glitched and tore across every terminal screen at once."
    },
    {
        sprite: -1,
        speaker: "VICTOR SCHADENFREUDE",
        text: "The broadcast was hijacked. Victor Schadenfreude's voice filled the room, calm and freezing cold, addressing Jack directly: 'This will end with your death.'"
    },
    {
        sprite: -1,
        speaker: "DR. VIC SHARP",
        text: "By the time Jack reached the streets, smoke turned morning into dusk. Most horrific of all were Celestia's children—eyes glassy, marching as synchronized soldiers for Dr. Vic Sharp."
    },
    {
        sprite: -1,
        speaker: "THE DECEPTION",
        text: "Hearing Charlotte's scream, Jack sprinted through the smoke. He found her motionless and fell to his knees in grief—only to touch cold, hollow mannequin plastic. She was taken alive."
    },
    {
        sprite: -1,
        speaker: "THE FALL OF THE REPUBLIC",
        text: "Running for his father's office, Jack's mother pressed a protective hoodie into his hands. Seconds later, doors blew inward. His father shouted: 'Hack the network, shut it down from inside, son!'"
    },
    {
        sprite: -1,
        speaker: "THE RESISTANCE",
        text: "Jack didn't stand alone. Mark—an AI built by WiLL—became family. Jessie, an agile specialist, secured ground no one else could reach. And a network presence echoed Charlotte's voice..."
    },
    {
        sprite: -1,
        speaker: "SHADOWS & SECRETS",
        text: "Victor Schadenfreude's cruelty ran deep. Years ago, his own children were stolen and weaponized. Among them fought Jessica—Jack's lost sister—resisting secretly from within."
    },
    {
        sprite: -1,
        speaker: "MISGUIDED VENGEANCE",
        text: "Waiting at the outer edges was Jason, driven by a twisted belief that Jack took his wife. Grief forged into a blade aimed at the wrong man."
    },
    {
        sprite: -1,
        speaker: "THE GATEKEEPER",
        text: "At the broken outer gates, a glassy-eyed child blocks the way. Mark's sensors confirm the truth: he is a hostage forced to wear a soldier's orders."
    },
    {
        sprite: -1,
        speaker: "FIGHT OR FREE?",
        text: "No prompt will judge you. Strike them down to move forward, or find the harder path: disarm and sever the control keeping them prisoner."
    },
    {
        sprite: -1,
        speaker: "THE QUEST BEGINS",
        text: "Every choice will quietly shape the path ahead. Jack stands at the gates of his city—ready to decide who survives, and who he becomes to save them."
    }
];

scene_index = 0;
scene_total = array_length(cutscenes);

// --- TYPEWRITER & TIMING ---
char_index = 0;
char_speed = 0.25; // Adjusted for natural reading speed & consistent chatter pacing
current_text = "";
text_finished = false;

// --- STATE MACHINE & FADES ---
fade_alpha = 1;
fade_speed = 0.03;
fade_state = 0; // 0: Fade In | 1: Interactive Typing | 2: Final Transition Out