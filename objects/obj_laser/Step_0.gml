/// @description Pulse the laser hazard without changing its collision size.

pulse_timer += 0.08;
image_alpha = 0.75 + (sin(pulse_timer) * 0.25);
