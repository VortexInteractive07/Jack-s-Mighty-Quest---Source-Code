/// @desc Toggle the dungeon measurement overlay with Ctrl+Space.
/// Space alone confirms battle commands and must not enable debug geometry.
if (!dungeon_battle_active && keyboard_check(vk_control)) {
	lines = !lines;
}
