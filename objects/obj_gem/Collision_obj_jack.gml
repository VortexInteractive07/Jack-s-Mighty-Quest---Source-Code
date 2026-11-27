/// @description Award score when Jack collects the gem.

if (instance_exists(obj_controller)) {
    obj_controller.register_collectible(value);
}

if (scr_save_record_collected_gem(room_get_name(room), x, y)) {
    scr_save_slot_autosave();
}

instance_destroy();
