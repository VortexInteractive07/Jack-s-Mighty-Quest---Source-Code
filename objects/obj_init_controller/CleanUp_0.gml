// ============================================================================
// CLEAN UP EVENT
// Object: obj_init_controller
// ============================================================================

if (ds_exists(key_history_list, ds_type_list)) {
    ds_list_destroy(key_history_list);
}