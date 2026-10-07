/// @function scr_projectile_impact_apply_blast(_impact, _damage, _radius)
/// @description Damages every enemy within one explosion's radius.
function scr_projectile_impact_apply_blast(_impact, _damage, _radius) {
    if (!instance_exists(_impact)) return;

    var _blast_x = _impact.x;
    var _blast_y = _impact.y;
    var _blast_damage = max(1, _damage);
    var _blast_radius = max(1, _radius);

    // obj_boss_pumpkin inherits obj_enemy_base, so this includes the boss.
    with (obj_enemy_base) {
        if (point_distance(x, y, _blast_x, _blast_y) <= _blast_radius) {
            take_damage(_blast_damage);
        }
    }
}
