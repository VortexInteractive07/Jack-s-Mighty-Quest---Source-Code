/// @function scr_level_select_data()
/// @description Returns an array of level structs for the Level Select menu.
function scr_level_select_data() {
    return [
        { name: "CELESTIA SUBWAY", act: "STAGE 1", room_id: rm_subway,   unlocked: true },
        { name: "CITY BOSS TEST",  act: "STAGE 2", room_id: rm_city,     unlocked: true },
        { name: "EMBER DUNGEONS",  act: "STAGE 3", room_id: rm_dungeons, unlocked: true }
    ];
}