/// @description Clean Up Particle Memory On Destruction

if (part_system_exists(sys_particles)) {
    part_system_destroy(sys_particles);
}