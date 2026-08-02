/// @description Mark AI Processing & Full Sprite Matrix

// --- 0. DYNAMIC TARGET RE-ROUTING (EASTER EGG VALIDATION) ---
if (!instance_exists(target)) {
    if (instance_exists(obj_asterix)) {
        target = obj_asterix;
    } 
}

// Re-verify after the re-routing sweep
if (instance_exists(target)) {
    
    // --- 1. Environmental & Pit Detection ---
    var _is_falling = (target.y > room_height + 16); 
    
    var _target_failed = false;
    if (instance_exists(obj_controller)) {
        if (obj_controller.player_dead || _is_falling) {
            _target_failed = true;
        }
    }
    
    // --- 2. Dynamic Tracking & Hyper-Movement Engine ---
    if (!_target_failed) {
        var _target_x = target.x + (follow_offset_x * target.facing);
        var _target_y = target.y + follow_offset_y;
        
        var _dist = point_distance(x, y, _target_x, _target_y);
        
        var _base_lerp = follow_speed + (_dist * 0.001);
        var _hyper_scaler = clamp(_dist / 64, 1.0, 4.5); 
        var _final_speed = clamp(_base_lerp * _hyper_scaler, 0.08, 0.60);
        
        x = lerp(x, _target_x, _final_speed);
        
        hover_timer += 0.06; 
        var _hover_wave = sin(hover_timer) * 0.25;
        y = lerp(y, _target_y, _final_speed) + _hover_wave;
        
        image_xscale = target.facing;
    } else {
        hover_timer += 0.03; 
        y += (sin(hover_timer) * 0.08); 
    }
    
    // --- 3. Projectile & Massacre Replication Layer ---
    if (!_target_failed) {
        var _target_is_dead_or_hurt = (target.state == 2 || target.state == 3);
        var _input_massacre = keyboard_check(ord("F"));
        
        if (_input_massacre && !_target_is_dead_or_hurt) {
            repeat (3) {
                var _spawn_x = x + (16 * image_xscale);
                var _spawn_y = y + irandom_range(-6, 6);
                var _mark_bullet = instance_create_depth(_spawn_x, _spawn_y, depth - 10, obj_projectile);
                
                if (instance_exists(_mark_bullet)) {
                    _mark_bullet.mark_processed = true;
                    _mark_bullet.hspeed = (image_xscale * irandom_range(8, 14)); 
                    _mark_bullet.vspeed = irandom_range(-3, 3); 
                    
                    if (variable_instance_exists(_mark_bullet, "facing")) {
                        _mark_bullet.facing = image_xscale;
                    }
                }
            }
        } else {
            var _target_just_shot = false;
            
            with (obj_projectile) {
                if (!variable_instance_exists(id, "mark_processed")) {
                    mark_processed = true; 
                    if (point_distance(x, y, other.target.x, other.target.y) < 48) {
                        _target_just_shot = true;
                    }
                }
            }
            
            if (_target_just_shot && !_target_is_dead_or_hurt) {
                var _spawn_x = x + (16 * image_xscale);
                var _spawn_y = y;
                var _mark_bullet = instance_create_depth(_spawn_x, _spawn_y, depth - 10, obj_projectile);
                
                if (instance_exists(_mark_bullet)) {
                    _mark_bullet.mark_processed = true; 
                    if (variable_instance_exists(_mark_bullet, "facing")) {
                        _mark_bullet.facing = image_xscale;
                    }
                    _mark_bullet.hspeed = image_xscale * 8;
                }
            }
        }
    }
    
    // --- 4. Enum Emotion & Motion Priority Evaluator ---
    if (instance_exists(obj_controller)) {
        if (obj_controller.stage_cleared) {
            emotion_state = MARK_EMOTION.HAPPY;
        } 
        else if (_target_failed) {
            emotion_state = MARK_EMOTION.SHOCKED; 
        } 
        else if (target.y >= room_height - 64) { 
            emotion_state = MARK_EMOTION.FROWNED;
        }
        else if (variable_instance_exists(target, "hp") && target.hp <= 15) {
            emotion_state = MARK_EMOTION.SHOCKED; 
        } 
        else if (obj_controller.stage_time <= 900 && obj_controller.stage_time > 0) {
            emotion_state = MARK_EMOTION.NERVOUS; 
        } 
        else {
            if (target.vsp < -1.5) {
                emotion_state = MARK_EMOTION.LOOKING_UP;
            }
            else if (target.vsp > 1.5) {
                emotion_state = MARK_EMOTION.LOOKING_DOWN;
            }
            else if (target.facing == -1 && abs(target.hsp) > 0.1) {
                emotion_state = MARK_EMOTION.LOOKING_LEFT;
            }
            else if (target.facing == 1 && abs(target.hsp) > 0.1) {
                emotion_state = MARK_EMOTION.LOOKING_RIGHT;
            }
            else {
                emotion_state = MARK_EMOTION.IDLE;
            }
        }
    }
    
    // --- 5. Graphical Sprite Matrix (Enum-Based) ---
    switch (emotion_state) {
        case MARK_EMOTION.HAPPY:
            if (sprite_exists(spr_mark_happy)) sprite_index = spr_mark_happy;
            break;
            
        case MARK_EMOTION.UPSET:
            if (sprite_exists(spr_mark_upset)) sprite_index = spr_mark_upset;
            break;
            
        case MARK_EMOTION.FROWNED:
            if (sprite_exists(spr_mark_frowned)) sprite_index = spr_mark_frowned;
            break;
            
        case MARK_EMOTION.SHOCKED:
            if (sprite_exists(spr_mark_shocked)) sprite_index = spr_mark_shocked;
            break;
            
        case MARK_EMOTION.NERVOUS:
            if (sprite_exists(spr_mark_nervous)) sprite_index = spr_mark_nervous;
            break;
            
        case MARK_EMOTION.LOOKING_UP:
            if (sprite_exists(spr_mark_looking_up)) sprite_index = spr_mark_looking_up;
            break;
            
        case MARK_EMOTION.LOOKING_DOWN:
            if (sprite_exists(spr_mark_looking_down)) sprite_index = spr_mark_looking_down;
            break;
            
        case MARK_EMOTION.LOOKING_LEFT:
            if (sprite_exists(spr_mark_looking_left)) sprite_index = spr_mark_looking_left;
            break;
            
        case MARK_EMOTION.LOOKING_RIGHT:
            if (sprite_exists(spr_mark_looking_right)) sprite_index = spr_mark_looking_right;
            break;
            
        case MARK_EMOTION.IDLE:
        default:
            if (sprite_exists(spr_mark)) sprite_index = spr_mark;
            break;
    }
}