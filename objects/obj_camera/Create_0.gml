/// @description Establish Target & Parallax Background Architecture
target = obj_player;
cam_speed = 0.1; // Smooth lerp delta

// --- BOSS LOCK REGISTRATION STRUCTS ---
boss_lock = false;
lock_x = 0;
lock_y = 0;

// ============================================================================
// 3-LAYER PARALLAX CONFIGURATION POINTERS
// ============================================================================
layer_bg_close  = layer_get_id("bg_close");  // e.g., Trees, low-range structures
layer_bg_mid    = layer_get_id("bg_mid");    // e.g., Hills, distant buildings
layer_bg_far    = layer_get_id("bg_far");    // e.g., Sky, Clouds

// Ratio coefficients
ratio_close = 0.4;  
ratio_mid   = 0.7;  
ratio_far   = 0.95;