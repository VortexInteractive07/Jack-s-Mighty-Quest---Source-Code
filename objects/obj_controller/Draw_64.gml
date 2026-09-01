/// @description Draw HUD - Fully Safeguarded against missing obj_jack variables

// Base dimensions for HUD anchoring
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// Default values if obj_jack is missing or resetting
var _current_hp = 0;
var _maximum_hp = 100;

// Safe instance & variable validation
if (instance_exists(obj_jack)) {
    if (variable_instance_exists(obj_jack, "hp")) {
        _current_hp = obj_jack.hp;
    }
    if (variable_instance_exists(obj_jack, "max_hp")) {
        _maximum_hp = obj_jack.max_hp;
    }
}

// Calculate ratio safely to prevent division by zero
var _hp_ratio = clamp(_current_hp / max(1, _maximum_hp), 0, 1);

// Draw HP Bar Frame & Fill
var _bar_x = 16;
var _bar_y = 16;
var _bar_width = 80;
var _bar_height = 8;

// Background
draw_set_color(c_black);
draw_rectangle(_bar_x - 1, _bar_y - 1, _bar_x + _bar_width + 1, _bar_y + _bar_height + 1, false);

// Health Fill
draw_set_color(_hp_ratio > 0.25 ? c_green : c_red);
draw_rectangle(_bar_x, _bar_y, _bar_x + (_bar_width * _hp_ratio), _bar_y + _bar_height, false);

// Reset draw color
draw_set_color(c_white);