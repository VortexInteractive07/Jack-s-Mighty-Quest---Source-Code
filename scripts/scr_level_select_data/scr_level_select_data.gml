/// @function scr_level_select_data()
/// @description Returns an array of level structs for the Level Select menu.
function scr_level_select_data() {
    return [
        { name: "SEWERS", act: "DEMO", room_id: rm_subway, unlocked: true },
        { name: "CITY", act: "DEMO", room_id: rm_city, unlocked: true },
        { name: "DUNGEONS", act: "DEMO", room_id: rm_dungeons, unlocked: true },
        { name: "BOSS ARENA", act: "DEMO", room_id: rm_boss, unlocked: true }
    ];
}
