/// @function scr_story()
/// @description Segmented retro arcade narrative script translated into the Bard's tongue, combined into a single continuous flat array.
/// Intelligence Level: 10/10
function scr_story() {
    var _part_one = [
        {
            sprite: spr_celestia,
            speaker: "",
            sfx: sfx_ambient_city,
            text: "HARK, WELL MET UPON THIS DRAMA'S THRESHOLD!\nFair Celestia was ne'er ordained to be\nMere crowded hive of common mortal throng.\nHewn forth from western mountain stony crags\nE'er since the Great Severance sundered all,\nIt rose a sanctum unto towering glass."
        },
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_dialogue_narrative,
            text: "Within the lower winding avenues,\nThe open markets hummed with peaceful speech.\nGood merchants set their orchard harvest forth,\nWhile children wended gladly to the school."
        },
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_dialogue_narrative,
            text: "A brittle peace was this, redeemed through years\nOf heavy sacrifice and weary toil.\nThe ancient sires did chart these valleys deep\nTo flee the ash and bloody chaos born\nOf ancient, unforgiving battlefield."
        },
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_dialogue_narrative,
            text: "Upon the loftiest seat of governance\nSat Lord William Smith Moore and Lady fair\nSamantha Nicholas Johnson, holding scale\n'Twixt factory forge and sweet humanity."
        },
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_dialogue_narrative,
            text: "Behind their bright and public majesty\nLies heavy history of ancient blood.\nGrandfather Smith Moore, Grandmother Sarah dear,\nAnd great-grandsire Johnson laid the iron base."
        },
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_dialogue_narrative,
            text: "Young Jack did hear such tales of ancient fame\nAbout the board, yet spurned the courtly post,\nPreferring engine grease and heavy steel\nAnd tangled mazes of electrical wire."
        },
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_dialogue_narrative,
            text: "He shared a high and lofty chambered tower\nWithin the upper ring, with Charlotte dear,\nHis witty wife, a maid of wondrous craft\nIn secret logic of the computing arts."
        },
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_dialogue_narrative,
            text: "Their morning hours kept a gentle pace\nOf steaming brew and hasty parchment plans,\nWith merry jests concerning civic laws."
        },
        {
            sprite: -1,
            speaker: "CHARLOTTE",
            sfx: sfx_charlotte_speak,
            text: "'Jack! If thou link this vessel of dark brew\nStraight to the master conduit once again,\nThe civic master shall take up abode\nWithin our empty chamber for his own!'"
        },
        {
            sprite: -1,
            speaker: "JACK",
            sfx: sfx_jack_speak,
            text: "'Aha! Where bides the daring pioneer\nIn gentle step-down voltage, Charlotte mine?\nTrue brewing doth demand the raging flood\nOf raw, unbridled lightning's sudden stroke!'"
        },
        {
            sprite: -1,
            speaker: "CHARLOTTE",
            sfx: sfx_charlotte_speak,
            text: "'Thy wild and perilous experiments\nDo smite my fluttering heart with sore alarms!\nDrain straight thy cup ere this unholy spark\nDoth plunge our kitchen into rayless night!'"
        }
    ];

    var _part_two = [
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_seismic_rumble,
            text: "HARK! Lo, a sudden and tempestuous shock\nDid cleave the deep foundations of the earth,\nShaking the casements and casting noble Jack\nWith violent force against his timber bench!"
        },
        {
            sprite: -1,
            speaker: "CHARLOTTE",
            sfx: sfx_charlotte_speak,
            text: "'Alas, I slumbered through the opening act!\nNay, this was ne'er the shaking of the ground!\nLook to the glass terminal, my dearest Jack:\nThe kingdom's power hath expired at once!'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_static_glitch,
            text: "Ere auxiliary engines could awake,\nEach crystal screen flared with a venomous green.\nA cursed and wicked signal seized the air!"
        },
        {
            sprite: -1,
            speaker: "VICTOR SCHADENFREUDE",
            sfx: sfx_sharp_speak,
            text: "'HEARKEN, YE DENIZENS OF AETHERIA!\nI do repent me of this sudden din.\nVictor Schadenfreude is my proper style,\nAnd all thy strongholds are subdued to me!'"
        },
        {
            sprite: -1,
            speaker: "VICTOR SCHADENFREUDE",
            sfx: sfx_sharp_speak,
            text: "'And thou, brave Jack, look forth from out thy pane!\nBehold thy noble lineage turn to ash!\nTo raze thy towers to dust is my sole aim!'"
        },
        {
            sprite: spr_charlotte_escape,
            speaker: "",
            sfx: sfx_explosion_subdued,
            text: "A thunderous engine of destruction roared\nFrom out the crowded plaza far below!\nFair Charlotte seized her coat of plated steel\nAnd flew toward the corridor to flee."
        },
        {
            sprite: spr_vic_seek,
            speaker: "VICTOR SCHADENFREUDE",
            sfx: sfx_victor_laugh,
            text: "'HA, HA, HA, HA! HOW WONDROUS PROMPT AND FIT!\nAll things do march in most exact accord\nAccording to the starry calendar!'"
        },
        {
            sprite: -1,
            speaker: "VICTOR SCHADENFREUDE",
            sfx: sfx_sharp_speak,
            text: "'And as for thee, thou stubborn, foolish wight,\nDost truly deem thy paltry, petty crafts\nCan shield thee from the coming stroke of doom?!'"
        },
        {
            sprite: -1,
            speaker: "VICTOR SCHADENFREUDE",
            sfx: sfx_victor_laugh,
            text: "'MUAHA, HA, HA, HA! Behold thy world in flames,\nAnd taste the bitter fruit of helplessness!\nFor righteous justice, thou shalt perish now!'"
        }
    ];

    var _part_three = [
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_screen_off,
            text: "The magic glass lapsed into rayless night.\nAs Jack stepped forth into the hallway gloom,\nThe air grew thick with acrid sulfur scent,\nWhile wailing sirens pierced the startled dark."
        },
        {
            sprite: -1,
            speaker: "JACK",
            sfx: sfx_jack_speak,
            text: "'Dear Charlotte, bide close beside my very side!\nThrough yonder secret conduit we must plunge\nTo reach the central vault before the gate locks fast!'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_dialogue_narrative,
            text: "The city youth did wander through the smoke\nWith vacant, glass-like eyes and frozen souls,\nEnsnared within a wicked wizard's spell\nCast by the tyrant's unrelenting voice."
        },
        {
            sprite: -1,
            speaker: "CHARLOTTE",
            sfx: sfx_charlotte_speak,
            text: "'Jack, stay thy foot! Grave peril lies ahead!\nThe stone bridge hath been shattered into dust!\nBeware the plunging crags that tumble down!'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_dialogue_narrative,
            text: "Through blinding smoke did valiant Jack press on,\nAnd plunged into a shadowy recess,\nJust as a mortal figure reeled and fell\nUpon the stony pavement at his feet."
        },
        {
            sprite: spr_charlotte_mannequin_dust,
            speaker: "JACK",
            sfx: sfx_jack_speak,
            text: "'Sweet Charlotte! Prithee keep thy vital spark,\nForsake me not, but look into mine eyes!'"
        },
        {
            sprite: spr_charlotte_mannequin_dust,
            speaker: "",
            sfx: sfx_dialogue_narrative,
            text: "ALAS, WHAT WOE! The form within his clasp\nWas never flesh and blood of mortal maid,\nBut lifeless wax and clockwork mechanism,\nBedight with spies! Fair Charlotte was purloined!"
        },
        {
            sprite: -1,
            speaker: "PRESIDENT MOORE",
            sfx: sfx_williams_speak,
            text: "'Brave Jack, make haste unto the master shrine\nOf lore beneath the plaza's stony floor!\nQuench thou their sorcerous and binding web\nEre archives of the past are blotted out!'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_dialogue_narrative,
            text: "First Lady Samantha met him 'mid the stones\nThat tumbled from the ceiling overhead,\nAnd thrust a plated vest and scroll of lore\nInto his eager hands."
        },
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_explosion_subdued,
            text: "The wicked Doctor Sharp did burst the door\nWith iron-visaged minions at his back,\nAnd dragged the President into the gloom\nAs floors gave way in ruin all around!"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_dialogue_narrative,
            text: "Now kneeling lone amid the smoking frames,\nJack banished every trace of trembling dread,\nAnd clad his soul in stern, vindictive steel.\nNow is the time for battle and for blood!"
        }
    ];

    var _part_four = [
        {
            sprite: -1,
            speaker: "MARK",
            sfx: sfx_mark_speak,
            text: "'ALL HAIL, THOU CHAMPION! Diagnostic whole!\nThy pulse is steady and thy spirit firm.\nMark am I named, a cunning engine wrought\nFor war! I feed new lightning to thy mail!'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_dialogue_narrative,
            text: "Mark stood confed'rate in the coming fray,\nBeside fair Jessie, maiden skilled in craft\nTo keep their secret whispers free of harm."
        },
        {
            sprite: -1,
            speaker: "CHARLOTTE",
            sfx: sfx_charlotte_glitch_speak,
            text: "'O Jack... give ear... seek out the conduit old...\nThe tyrant's iron warders watch not there...\nI hold the gateway open for thy step...'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_dialogue_narrative,
            text: "Her voice was fractured by a phantom screech.\nHe hung upon each cadence of her tongue,\nDenying that her noble, living soul\nWas thrall to yonder cursed machinery."
        },
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_dialogue_narrative,
            text: "Within the dark recesses of the vault,\nJack found the grievous, melancholy tale\nOf Victor's children, twisted into tools\nOf war by ruthless lords of governance."
        },
        {
            sprite: -1,
            speaker: "JESSICA",
            sfx: sfx_jessica_speak,
            text: "'Hearken unto my words, dear brother Jack!\nI am thy sister, hidden from thy sight;\nFor years have I undermined the tyrant's core\nFrom deep within! The hourglass drains apace!'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_dialogue_narrative,
            text: "Before the inner gate stood youthful Jason,\nThe corrupted scion of the tyrant lord,\nWhose youthful grief was forged in fires of hate."
        },
        {
            sprite: -1,
            speaker: "JASON",
            sfx: sfx_jason_speak,
            text: "'Thou and thy kin have blighted all my joy!\nThou hast despoiled me of my every hope,\nAnd darest play the righteous champion now?\nHere shall I reap thy life and shatter thee!'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_dialogue_narrative,
            text: "Upon the threshold of the master core,\nA captive townsman stood in stony trance,\nGrasping a heavy engine of destruction,\nWhile trembling 'neath the master's wizard spell."
        },
        {
            sprite: -1,
            speaker: "MARK",
            sfx: sfx_mark_speak,
            text: "'GRAVE PERIL! Will is fettered in this wight!\nTo smite him dead doth make destruction sure,\nYet gentle lightning may consume our gear!'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_dialogue_narrative,
            text: "Each choice henceforth by mortal hand decreed\nShall seal the fate where Aetheria stands,\nAnd prove what metal marks our hero Jack\nWhen the last thunderous cataclysm falls!"
        },
        {
            sprite: -1,
            speaker: "JACK",
            sfx: sfx_jack_speak,
            text: "'We may not leave the guiltless souls to perish!\nNot Charlotte dear, nor these enthralled young babes!\nMark, charge our lightning engine to the full!'"
        },
        {
            sprite: -1,
            speaker: "",
            sfx: sfx_emp_charge,
            text: "The massive iron portal hissed apart,\nRevealing a vast, humming vault of light.\nNow doth the final battle for the realm commence!\nForward to glory! On, unto the fray!"
        }
    ];

    return array_concat(_part_one, _part_two, _part_three, _part_four);
}