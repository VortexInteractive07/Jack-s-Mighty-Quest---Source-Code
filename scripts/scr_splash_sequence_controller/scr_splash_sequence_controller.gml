/// @function scr_splash_sequence_controller()
/// @description Assembles sprite splashes, intro dialogue, and standalone text into the master splash queue.
function scr_splash_sequence_controller() {
    var _sequence = [
        spr_disclaimer
    ];

    // Append dialogue list from scr_intro_dialogue
    var _dialogue_list = scr_intro_dialogue();
    for (var i = 0; i < array_length(_dialogue_list); i++) {
        array_push(_sequence, _dialogue_list[i]);
    }

    // Append standalone text splashes and logos
    array_push(_sequence, { raw_text: "PRESENTED BY VORTEX INTERACTIVE", font: fnt_bitmap, color: c_white, scale: 1, speed: 0.4, hold: 180, blue_shadow: false });
    array_push(_sequence, { raw_text: "A GAME BY AAYAN", font: fnt_bitmap, color: c_white, scale: 1, speed: 0.4, hold: 180, blue_shadow: true });
    array_push(_sequence, spr_vortex_logo_lightmode);
    array_push(_sequence, spr_vortex_presents);

    return _sequence;
}