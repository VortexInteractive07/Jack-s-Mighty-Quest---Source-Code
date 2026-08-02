/// @description Take Projectile Damage & Play Hit SFX

var _dmg = variable_instance_exists(other, "damage") ? other.damage : 25;
hp -= _dmg;

hit_flash_timer = 6;

var _sfx_hit = asset_get_index("sfx_enemy_hit");
if (_sfx_hit != -1 && audio_exists(_sfx_hit)) {
    audio_play_sound(_sfx_hit, 5, false);
}

if (!variable_global_exists("player_score")) global.player_score = 0;
global.player_score += 250;

instance_destroy(other);