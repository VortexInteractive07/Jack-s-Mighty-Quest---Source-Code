/// @description Award score when Jack collects the gem.

if (instance_exists(obj_controller)) {
    obj_controller.register_collectible(value);
}

instance_destroy();
