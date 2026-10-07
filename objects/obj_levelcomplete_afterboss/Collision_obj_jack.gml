/// @description Start the inherited level-complete flow only after the boss is defeated.

if (!variable_global_exists("boss_defeated") || !global.boss_defeated) exit;
event_inherited();
