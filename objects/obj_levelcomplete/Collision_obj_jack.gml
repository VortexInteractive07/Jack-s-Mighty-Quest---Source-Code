/// @description Trigger Demo Complete Sequence on Contact

// Only trigger once so it doesn't loop every frame Jack is touching it
if (!activated) {
    activated = true;

    // 1. Instantly stop all background music and sound effects
    audio_stop_all();

    // 2. PLAY the victory jingle using the variable you defined in Create
    // The parameters are: sound_id, priority, loops
    level_audio_id = audio_play_sound(victory_jingle, 10, true);
}