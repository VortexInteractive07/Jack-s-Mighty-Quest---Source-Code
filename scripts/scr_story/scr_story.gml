/// @function scr_story()
/// @description Fully extended, character-driven dramatic cutscene array for Jack's Mighty Quest with elevated prose and full cinematic narrative beats.
/// NOTE: Sprite indices are set to -1 temporarily until artwork is manually drawn and imported into the project.
/// NOTE: The three "voice_sync_group: victor_monologue" beats below carry lyric-timed `sync_lines` used by
///       obj_cutscene_controller's voice-sync mode. That mode requires a new audio asset, `sfx_victor_monologue_vo`
///       (the actual recorded VO, ~48.454s, matching the timing baked into sync_lines below) — see the reminder
///       at the end of the response for details. Until that asset is imported, these three beats behave exactly
///       as before (standard typewriter + automated one-shot laugh SFX).
function scr_story() {
    return [
        {
            sprite: -1,
            speaker: "",
            sfx: asset_get_index("sfx_ambient_city") != -1 ? sfx_ambient_city : -1,
            text: "Celestia was never conceived as a mere urban sprawl. Nestled within the western suburbs of the Republic of Aetheria, it blossomed over decades into a sacred covenant — a sovereign haven where spires of emerald glass harvested the dawn."
        },
        {
            sprite: -1,
            speaker: "",
            sfx: asset_get_index("sfx_dialogue_narrative") != -1 ? sfx_dialogue_narrative : -1,
            text: "It was a citadel where market squares echoed with genuine tranquility rather than desperate commerce, and where no citizen retired to sleep fearing the cruelty of tomorrow."
        },
        {
            sprite: -1,
            speaker: "",
            sfx: asset_get_index("sfx_dialogue_narrative") != -1 ? sfx_dialogue_narrative : -1,
            text: "This prosperity was forged by President William Smith Moore and First Lady Samantha Smith Moore, who dedicated a generation to erecting an imperishable republic anchored in civil dignity and unyielding stability."
        },
        {
            sprite: -1,
            speaker: "",
            sfx: asset_get_index("sfx_dialogue_narrative") != -1 ? sfx_dialogue_narrative : -1,
            text: "Beneath their public service lay a foundational lineage: Jack's grandparents, Grandfather Smith Moore and Grandmother Sarah Johnson, alongside great-grandfather Johnson Moore, whose quiet sacrifices carved the bedrock of Aetheria."
        },
        {
            sprite: -1,
            speaker: "",
            sfx: asset_get_index("sfx_dialogue_narrative") != -1 ? sfx_dialogue_narrative : -1,
            text: "Jack matured within the shadow of that public reverence, yet he harbored no desire for political prestige. He carved out a private existence alongside his wife, Charlotte — a brilliant systems engineer whose brilliant mind matched her warmth."
        },
        {
            sprite: -1,
            speaker: "CHARLOTTE",
            sfx: asset_get_index("sfx_charlotte_speak") != -1 ? sfx_charlotte_speak : -1,
            text: "'Jack, if you attempt to bypass the transformer and hardwire that coffee synthesizer directly into the main grid one more time, I am revoking your workshop privileges. I oversee infrastructure, not municipal miracles.'"
        },
        {
            sprite: -1,
            speaker: "JACK",
            sfx: asset_get_index("sfx_jack_speak") != -1 ? sfx_jack_speak : -1,
            text: "'Optimal molecular extraction demands at least three continuous amperes of direct current, Char. Do not smother technical innovation before we've even finished breakfast.'"
        },
        {
            sprite: -1,
            speaker: "CHARLOTTE",
            sfx: asset_get_index("sfx_charlotte_speak") != -1 ? sfx_charlotte_speak : -1,
            text: "'Your definition of 'innovation' induced a voltage surge that nearly blacked out District 4 last Tuesday. Just drink your—'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: asset_get_index("sfx_seismic_rumble") != -1 ? sfx_seismic_rumble : -1,
            text: "The playful retort dissolved instantly. A violent subterranean shockwave tore through the bedrock of Celestia, severing the structural inertia of the city and throwing Jack violently against the console."
        },
        {
            sprite: -1,
            speaker: "CHARLOTTE",
            sfx: asset_get_index("sfx_charlotte_speak") != -1 ? sfx_charlotte_speak : -1,
            text: "'That wave was not tectonic! Jack, look at the terminal diagnostic... the entire regional distribution grid just went pitch black!'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: asset_get_index("sfx_static_glitch") != -1 ? sfx_static_glitch : -1,
            text: "Before a manual override could be initiated, the monitor flared with high-voltage static. An emergency civil broadcast hijacked every frequency in Aetheria, flickering violently before stabilizing into an ominous feed."
        },
        {
            sprite: -1,
            speaker: "VICTOR SCHADENFREUDE",
            sfx: asset_get_index("sfx_sharp_speak") != -1 ? sfx_sharp_speak : -1,
            text: "'Good morning, citizens of Aetheria. I apologize for disturbing the pristine tranquility of your gilded cage. My name is Victor Schadenfreude.'"
        },
        {
            sprite: -1,
            speaker: "VICTOR SCHADENFREUDE",
            sfx: asset_get_index("sfx_sharp_speak") != -1 ? sfx_sharp_speak : -1,
            text: "'And to you, Jack... pay close attention. Gaze through your window and observe your ancestral legacy reduce to ash. Your complete annihilation is the only outcome.'"
        },
        {
            sprite: -1,
            speaker: "VICTOR SCHADENFREUDE",
            sfx: asset_get_index("sfx_victor_laugh") != -1 ? sfx_victor_laugh : (asset_get_index("sfx_sharp_speak") != -1 ? sfx_sharp_speak : -1),
            text: "'Hahahahaaa! How exquisitely predictable! The pieces have assumed their positions, entirely orchestrated by that inept protagonist!'",
            voice_sync_group: "victor_monologue",
            sync_lines: [
                { t: 0.470,  txt: "(laughs)" },
                { t: 3.894,  txt: "How exquisitely predictable!" },
                { t: 6.988,  txt: "The pieces has assumed their positions," },
                { t: 10.091, txt: "entirely orchestrated by that..." },
                { t: 13.022, txt: "inept Protagonist!" }
            ]
        },
        {
            sprite: -1,
            speaker: "VICTOR SCHADENFREUDE",
            sfx: asset_get_index("sfx_sharp_speak") != -1 ? sfx_sharp_speak : -1,
            text: "'And as for you, Jack, you miserable, incompetent simpleton! Do you genuinely believe that you, your stupid wife, and every citizen of the city of Celestia carry an ounce of efficacy?!'",
            voice_sync_group: "victor_monologue",
            sync_lines: [
                { t: 15.259, txt: "And as for you, Jack!" },
                { t: 18.060, txt: "You miserable," },
                { t: 19.504, txt: "incompetent," },
                { t: 21.154, txt: "SIMPLETON!!!" },
                { t: 23.128, txt: "Did you generally believe that you," },
                { t: 26.198, txt: "carry an ounce of efficacy?" }
            ]
        },
        {
            sprite: -1,
            speaker: "VICTOR SCHADENFREUDE",
            sfx: asset_get_index("sfx_victor_laugh") != -1 ? sfx_victor_laugh : (asset_get_index("sfx_sharp_speak") != -1 ? sfx_sharp_speak : -1),
            text: "'Hahahahahaa! Gaze upon the impending ruin and savor... the futility of your efforts! Muahahahahahahaaaa!'",
            voice_sync_group: "victor_monologue",
            sync_lines: [
                { t: 29.149, txt: "(giggles)" },
                { t: 30.724, txt: "Gaze upon the impending ruin," },
                { t: 33.299, txt: "and savour," },
                { t: 34.707, txt: "THE FUTILITY OF YOUR EFFORTS!!!!" },
                { t: 37.830, txt: "(AAAAHAHAHAHAAHAHAHHAHA....)" }
            ]
        },
        {
            sprite: -1,
            speaker: "",
            sfx: asset_get_index("sfx_screen_off") != -1 ? sfx_screen_off : (asset_get_index("sfx_siren_distant") != -1 ? sfx_siren_distant : -1),
            text: "[THE SCREEN GOES OFF INTO PITCH BLACK] As Jack breached the street level, the pristine metropolis of Celestia was already engulfed in a suffocating shroud of black smoke and sirens."
        },
        {
            sprite: -1,
            speaker: "JACK",
            sfx: asset_get_index("sfx_jack_speak") != -1 ? sfx_jack_speak : -1,
            text: "'Charlotte, maintain proximity behind me! We must navigate through the perimeter to reach the central vault!'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: asset_get_index("sfx_dialogue_narrative") != -1 ? sfx_dialogue_narrative : -1,
            text: "The true horror was not the collapsing architecture, but the populace. Celestia's own youth marched through the inferno with dilated, glassy eyes, their speech synchronized into mechanical algorithms under the command of Dr. Vic Sharp."
        },
        {
            sprite: -1,
            speaker: "CHARLOTTE",
            sfx: asset_get_index("sfx_charlotte_speak") != -1 ? sfx_charlotte_speak : -1,
            text: "'Jack! They've breached the alley blockade! Jack, help me!'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: asset_get_index("sfx_dialogue_narrative") != -1 ? sfx_dialogue_narrative : -1,
            text: "Jack sprinted desperately through the smoke toward her scream. He reached the alleyway only to see her collapse motionless onto the concrete."
        },
        {
            sprite: -1,
            speaker: "JACK",
            sfx: asset_get_index("sfx_jack_speak") != -1 ? sfx_jack_speak : -1,
            text: "'Charlotte! No, no, no—stay conscious! Focus on my voice!'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: asset_get_index("sfx_dialogue_narrative") != -1 ? sfx_dialogue_narrative : -1,
            text: "Despair threatened to break him, but as his hands gripped her shoulders, the illusion shattered. What lay in his arms was not biological tissue, but the cold synthetic shell of an articulated mannequin. Charlotte had been abducted."
        },
        {
            sprite: -1,
            speaker: "PRESIDENT MOORE",
            sfx: asset_get_index("sfx_williams_speak") != -1 ? sfx_williams_speak : -1,
            text: "'Jack! You must infiltrate the core mainframe! Neutralize the neural network control protocol from the inside, son!'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: asset_get_index("sfx_dialogue_narrative") != -1 ? sfx_dialogue_narrative : -1,
            text: "Jack forced his way into the executive bunker. First Lady Samantha met him amid falling debris, thrusting a reinforced tactical hoodie into his hands moments before hydraulic blast doors were torn open."
        },
        {
            sprite: -1,
            speaker: "",
            sfx: asset_get_index("sfx_explosion_subdued") != -1 ? sfx_explosion_subdued : -1,
            text: "Dr. Vic Sharp stepped through the breach surrounded by automated legionaries, dragging President Moore into captivity as the facility collapsed."
        },
        {
            sprite: -1,
            speaker: "",
            sfx: asset_get_index("sfx_dialogue_narrative") != -1 ? sfx_dialogue_narrative : -1,
            text: "Kneeling amidst the ruins of burning server banks, Jack's despair hardened into absolute resolve. This was no longer merely a defensive evacuation; it was a campaign to dismantle Victor Schadenfreude entirely."
        },
        {
            sprite: -1,
            speaker: "MARK",
            sfx: asset_get_index("sfx_mark_speak") != -1 ? sfx_mark_speak : -1,
            text: "'Biometric evaluation completed. User stress levels critical but operational. I am Mark, autonomous tactical unit designed by WiLL. Rerouting power reserves to suit systems.'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: asset_get_index("sfx_dialogue_narrative") != -1 ? sfx_dialogue_narrative : -1,
            text: "Mark evolved from a tactical interface into an indispensable ally. Alongside them stood Jessie, a former acrobatic performer turned elite cybersecurity operative, securing high-risk routes across the skyline."
        },
        {
            sprite: -1,
            speaker: "CHARLOTTE",
            sfx: asset_get_index("sfx_charlotte_glitch_speak") != -1 ? sfx_charlotte_glitch_speak : -1,
            text: "'Jack... navigate through the secondary maintenance conduit. The automated security grid is blind on that vector. I am holding the entry port open.'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: asset_get_index("sfx_dialogue_narrative") != -1 ? sfx_dialogue_narrative : -1,
            text: "Her voice echoed through the encrypted network channels, guiding Jack with familiar precision. He clung to her presence, refusing to consider how much of her humanity remained within the machine."
        },
        {
            sprite: -1,
            speaker: "",
            sfx: asset_get_index("sfx_dialogue_narrative") != -1 ? sfx_dialogue_narrative : -1,
            text: "As Jack breached Victor's internal archives, a tragic origin emerged. Long before he became Aetheria's destroyer, Victor was a father whose own children — Edward, Nicholas, Jason, and Katie — had been abducted and weaponized."
        },
        {
            sprite: -1,
            speaker: "JESSICA",
            sfx: asset_get_index("sfx_jessica_speak") != -1 ? sfx_jessica_speak : -1,
            text: "'Jack, listen to me carefully. I am Jessica... your biological sister. I've survived inside Victor's network for years acting as an internal resistance. Time is running out.'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: asset_get_index("sfx_dialogue_narrative") != -1 ? sfx_dialogue_narrative : -1,
            text: "Yet, blocking the perimeter stood Jason — Victor's weaponized son, his profound grief corrupted into an absolute hatred directed squarely at Jack."
        },
        {
            sprite: -1,
            speaker: "JASON",
            sfx: asset_get_index("sfx_jason_speak") != -1 ? sfx_jason_speak : -1,
            text: "'You deprived me of my family, Jack! You stole my wife, and now you dare posture as a savior? I will personally carve you to pieces!'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: asset_get_index("sfx_dialogue_narrative") != -1 ? sfx_dialogue_narrative : -1,
            text: "At the threshold of the outer gateway, a mind-controlled child soldier raised a heavy military firearm, hands trembling violently under the weight of neural subjugation commands."
        },
        {
            sprite: -1,
            speaker: "MARK",
            sfx: asset_get_index("sfx_mark_speak") != -1 ? sfx_mark_speak : -1,
            text: "'Alert: Neural-override link active. Target is a non-combatant civilian operating under forced command protocols. Lethal response ensures self-preservation; non-lethal pulse disarmament carries high operational risk.'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: asset_get_index("sfx_dialogue_narrative") != -1 ? sfx_dialogue_narrative : -1,
            text: "The path forward offers no explicit guidance. You must choose whether to neutralize threats with lethal finality, or endure the burden of severing their neural control to restore their freedom."
        },
        {
            sprite: -1,
            speaker: "JACK",
            sfx: asset_get_index("sfx_jack_speak") != -1 ? sfx_jack_speak : -1,
            text: "'We do not abandon anyone to Victor's machine. Not Charlotte, not my family, and not these kids. Mark, charge the high-frequency EMP. We do this the hard way.'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: asset_get_index("sfx_emp_charge") != -1 ? sfx_emp_charge : -1,
            text: "Every action taken will echo throughout the campaign, quietly determining the ultimate fate of Aetheria and defining the man Jack becomes."
        }
    ];
}