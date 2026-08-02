/// @description Initialize Mark & AI Emotion Engine

// --- EMOTION ENGINE ENUM DEFINITION ---
enum MARK_EMOTION {
    IDLE,
    HAPPY,
    UPSET,
    FROWNED,
    SHOCKED,
    NERVOUS,
    LOOKING_UP,
    LOOKING_DOWN,
    LOOKING_LEFT,
    LOOKING_RIGHT
}

// Target tracking
target = obj_player;

// Movement properties
hover_timer = 0;
follow_offset_x = -16; 
follow_offset_y = -18; 
follow_speed = 0.08;

// AI State Engine variable (now using enum)
emotion_state = MARK_EMOTION.IDLE;

// Draw Event Visual Helpers (Glitch & Status effects)
glitch_intensity = 0;
scanline_alpha = 0.3;

// Smooth approach helper method
smooth_approach = function(_current, _target, _step) {
    return lerp(_current, _target, _step);
};