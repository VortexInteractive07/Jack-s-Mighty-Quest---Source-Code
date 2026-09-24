/// @description Animate the collectible's floating motion.

bob_time += 0.08;
y = base_y + sin(bob_time) * 3;
image_angle = sin(bob_time * 0.7) * 8;
