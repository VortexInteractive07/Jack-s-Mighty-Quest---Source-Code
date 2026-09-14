/// @function scr_splash_sequence_controller(enable_dialogue, console_type, switch_region, publisher_name)
/// @param {bool} enable_dialogue Toggle inclusion of dialogue frame sequences
/// @param {string} console_type Platform string: "pc", "ps", "switch", "xbox", "deck_machine"
/// @param {string} switch_region Switch region string: "AMERICA", "JP", "EUROPE"
/// @param {string} publisher_name Optional custom publisher entity string
/// @description Assembles dynamic copyright, platform licensing, intro dialogue, and logos into the splash queue.
function scr_splash_sequence_controller(_enable_dialogue = true, _console_type = "pc", _switch_region = "AMERICA", _publisher_name = "VORTEX Interactive") {
    var _sequence = [];

    // ==========================================
    // 0. ATTRIBUTION & MEME SPLASH ROLL (1 in 378)
    // ==========================================
    randomise();
    var _meme_roll = irandom_range(1, 378);
    
    if (_meme_roll == 1 && sprite_exists(spr_GameMaker_G_MEME)) {
        array_push(_sequence, spr_GameMaker_G_MEME);
    } else if (sprite_exists(spr_gamemaker_attribution)) {
        array_push(_sequence, spr_gamemaker_attribution);
    }

    // ==========================================
    // 1. DYNAMIC RETRO DISCLAIMER & LICENSING
    // ==========================================
    var _licensing_text = "";

    switch (string_lower(_console_type)) {
        case "ps":
            _licensing_text = "\n\nLICENSED BY\nSONY INTERACTIVE ENTERTAINMENT INC.";
            break;

        case "switch":
            if (string_upper(_switch_region) == "JP") {
                _licensing_text = "\n\nLICENSED BY\nNINTENDO CO., LTD.";
            } else {
                _licensing_text = "\n\nLICENSED BY\nNINTENDO OF AMERICA INC.";
            }
            break;

        case "xbox":
            _licensing_text = "\n\nLICENSED BY\nMICROSOFT CORPORATION";
            break;

        case "deck_machine":
            _licensing_text = "\n\nCOMPATIBLE WITH STEAM DECK\nVALVE CORPORATION";
            break;

        case "pc":
        default:
            _licensing_text = "";
            break;
    }

    var _pub_string = string_upper(_publisher_name);
    var _disclaimer_text = "JACK'S MIGHTY QUEST (TM)\n\n(C) 2026, 2027 " + _pub_string + "\nALL RIGHTS RESERVED." + _licensing_text + "\n\nDEVELOPED AND PUBLISHED BY:\n" + _pub_string + "\n\nTHIS IS A WORK OF FICTION.";

    array_push(_sequence, {
        raw_text: _disclaimer_text,
        font: fnt_bitmap,
        color: c_white,
        scale: 1,
        speed: 1,
        hold: 240,
        blue_shadow: true,
        instant_display: true
    });

    // ==========================================
    // 2. OPTIONAL DIALOGUE SEQUENCE
    // ==========================================
    if (_enable_dialogue && script_exists(scr_intro_dialogue)) {
        var _dialogue_list = scr_intro_dialogue();
        for (var i = 0; i < array_length(_dialogue_list); i++) {
            array_push(_sequence, _dialogue_list[i]);
        }
    }

    // ==========================================
    // 3. BRANDING & LOGO SPLASHES
    // ==========================================
    array_push(_sequence, { 
        raw_text: "PRESENTED BY " + _pub_string, 
        font: fnt_bitmap, 
        color: c_white, 
        scale: 1, 
        speed: 0.4, 
        hold: 180, 
        blue_shadow: true,
        instant_display: false
    });
    
    array_push(_sequence, { 
        raw_text: "BASED ON THE NARRATIVE OF IBRAHIM AAYAN BIN ABDULLA", 
        font: fnt_bitmap, 
        color: c_white, 
        scale: 1, 
        speed: 0.4, 
        hold: 180, 
        blue_shadow: true,
        instant_display: false
    });
    
    if (sprite_exists(spr_vortex_logo_lightmode)) array_push(_sequence, spr_vortex_logo_lightmode);
    if (sprite_exists(spr_vortex_presents)) array_push(_sequence, spr_vortex_presents);

    return _sequence;
}