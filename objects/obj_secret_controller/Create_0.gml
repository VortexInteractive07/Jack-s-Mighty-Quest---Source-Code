/// @description Handle Secret Room Ambient Audio

// Stop all previous music (level BGM, jukebox tracks, etc.)
audio_stop_all();

// Direct asset reference to your secret looping track (e.g., mus_man, mus_secret_loop, etc.)
var _secret_tune = mus_man; 

if (audio_exists(_secret_tune)) {
    // Play sound on loop
    audio_play_sound(_secret_tune, 10, true);
}