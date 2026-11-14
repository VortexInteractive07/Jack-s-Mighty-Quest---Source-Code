/// @function scr_changelog_details()
/// @description Returns an array of strings representing the version history and patch notes.
function scr_changelog_details() {
    return [
        "=== VERSION CHANGELOG ===",
        "",
        "[PROTOTYPE v1.1.0] - 2026-11-14",
        "+ Added Stage 2 and Stage 3 prototypes with distinct effects",
        "+ Added Melonhead boss prototype and looped arena music",
        "+ Fixed dungeon fragment sizing and debug-map controls",
        "+ Removed duplicate palette-swap local declarations",
        "",
        "[PROTOTYPE v1.0.1] - 2026-08-30",
        "+ Released August 30th Prototype Build",
        "+ Fixed Time Attack crash by adding a notification toast instead of loading missing room",
        "+ Fixed Dialogue Narration for Dr. Vic Sharp's line (\"How Exquisitely Predictable!\")",
        "- Removed old laugh SFX due to copyright claims",
        "",
        "[ALPHA v1.0.0] - 2026-03-31",
        "+ Added Sub-Menu Architecture (432x240)",
        "+ Integrated Script-Based Sound Test / Jukebox Mode",
        "+ Integrated Settings with Volume Sliders & Fullscreen",
        "+ Added Interactive Changelog Viewer with Scrolling",
        "+ Added Room Transition and Splash Screen Integration",
        "",
        "[ALPHA v0.9.0] - 2026-02-15",
        "+ Initial Engine Alpha Build & Subtitle Engine",
        "+ Title Screen & Navigation Base Setup",
        "",
		"End of Changelog",
        "--- ---"
    ];
}