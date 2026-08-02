/// @description Process Banner Timer Ticker & Auto-Cleanup

if (triggered) {
    if (text_timer > 0) {
        text_timer--;
    } else {
        // Destroy only AFTER the banner text animation finishes
        instance_destroy();
    }
}