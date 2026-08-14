/// @description Main Gameplay Controller - Station Track Integration

// --- AUDIO INTEGRATION ---
// Ensures mus_station loops continuously during gameplay
if (asset_get_index("mus_station") != -1) {
    if (!audio_is_playing(mus_station)) {
        audio_play_sound(mus_station, 10, true);
    }
}