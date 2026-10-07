# Jack's Mighty Quest: code map

This guide describes the current prototype's runtime layout and where to make focused changes. It is based on the current project files; it does not replace the GameMaker resource tree as the source of truth.

## Runtime flow

1. `obj_init_controller` loads settings and handles the startup language/challenge flow, then enters the title room.
2. `obj_title_controller` owns title input, title dialogue, music, and its transition to the main menu or stage select.
3. `obj_menu_controller` owns menu pages, option actions, save/load/time-attack choices, and menu music. Its Create event builds the option/action data; Step processes input and Draw renders it.
4. `obj_level_select_controller` owns the standalone stage carousel and launches the selected playable room.
5. Playable rooms use `obj_controller` for session state, HUD coordination, pause, death/restart, autosave, and room transitions. `obj_jack` owns player movement and attacks. `obj_mark` follows and assists Jack.
6. `obj_controller` calls `scr_hud_draw(id)` from its Draw GUI event. The HUD script delegates to smaller draw functions for status, pause, game over, death notice, boss bar, and transition overlay.

## Where to change common features

| Feature | Main owner | Supporting resources |
| --- | --- | --- |
| Player movement, jump, firing | `objects/obj_jack/Step_0.gml` | `obj_jack/Create_0.gml`, `obj_projectile`, `obj_projectile_impact`, `scr_projectile_impact_apply_blast` |
| Regular enemy patrol and contact | `objects/obj_enemy_base/Step_0.gml` | `obj_enemy_base/Create_0.gml`; enemy child Create events configure stats |
| Boss behavior | `objects/obj_boss_pumpkin/Step_0.gml` | `obj_enemy_base`, `obj_plasma_wave`, `obj_levelcomplete_afterboss` |
| Gameplay HUD and pause UI | `scripts/scr_hud_draw/scr_hud_draw.gml` | `obj_controller/Draw_64.gml`; pause input remains in `obj_controller/Step_0.gml` |
| Main menu options/actions | `objects/obj_menu_controller/Create_0.gml` | `Step_0.gml`, `Draw_64.gml`, settings scripts |
| Language strings | `scripts/scr_language_system/scr_language_system.gml` | story and intro scripts call `get_localized_text` |
| Story/cutscene flow | `scripts/scr_story/scr_story.gml`, `obj_cutscene_controller` events | `scr_dialogue` and language system |
| Startup retry story | `obj_init_controller` Create/Step/Draw GUI events | Reuses `scr_story`; after three wrong answers it offers the story or a direct skip to its one-question check |
| Title splash messages | `scr_get_random_splash`, `scr_get_random_press_start_message` | `obj_splash_controller`, `obj_title_controller` |
| Settings persistence | `scr_load_settings`, `scr_save_settings` | `settings.json` at runtime |
| Gameplay autosave | `scr_game_autosave_write/read` in `scr_save_settings` | `obj_controller` writes/restores; menu offers load |
| Stage list | `scripts/scr_level_select_data/scr_level_select_data.gml` | `obj_level_select_controller` |
| Music catalogs | `scr_title_ost_playlist`, `scr_splash_ost_playlist`, `scr_jukebox_ost_playlist` | title, splash, menu, and jukebox controllers |

## Current boundaries and coupling

- **Gameplay controller is the largest behavior hotspot.** `obj_controller/Step_0.gml` coordinates pause input, pause pages, player-death resolution, room transitions, timers, and autosave. Before extracting code, keep its state transitions and event order unchanged; pause uses `instance_deactivate_all(true)` and resumes the room's instances.
- **Menu setup mixes data and behavior.** `obj_menu_controller/Create_0.gml` constructs menu entries with inline getter/action functions. Keep each option's label, displayed value, and action together. Moving those closures into separate scripts can change which instance `self` refers to.
- **Settings are a shared global contract.** Add a setting's default and validation in `scr_load_settings`, persistence in `scr_save_settings`, then wire it into the owning menu. Keep accepted enum strings aligned across all three places.
- **Startup challenge recovery is deliberately forgiving.** Three wrong submissions show a warning; Enter opens the intro story, Escape skips to its question, and the story question can be retried without limit. The feature still respects the optional challenge setting.
- **Transition behavior is shared but lifecycle is distributed.** Fade style drawing and black-hold timing live in `scr_hud_draw`; title, menu, cutscene, jukebox, stage select, and gameplay controllers advance their own transition state. A future unification should preserve each screen's timing and room-entry behavior.
- **Enemy behavior has a useful inheritance seam.** `obj_enemy_base` owns shared patrol, gravity, contact damage, and health; child Create events set per-enemy values. Add new shared enemy behavior there and keep boss-only attacks in the boss object.
- **Most big language/story/message/playlist files are content catalogs, not one giant algorithm.** They can be reorganized later by content domain, but doing so now would create a large translation/resource churn with little runtime benefit.
- **`scripts/Script13` is a legacy resource name.** Its function is `scr_question_drm`; avoid adding unrelated code to it. Renaming a GameMaker resource requires updating project metadata and references, so it is intentionally left in place during this safety-focused audit.

## Safe workflow for extending the prototype

1. Find the owning controller or base object in the table above before editing a behavior.
2. Keep content data separate from state transitions and rendering. Prefer a small named helper for reusable behavior over copying a block into another event.
3. Keep event responsibilities narrow: Create establishes defaults, Step changes state, Draw GUI renders UI, and Clean Up releases resources.
4. When adding a global setting, update load defaults/validation, save serialization, menu presentation/input, and any runtime consumer together.
5. When adding a resource, register it in the `.yyp` and its folder's `.resource_order` using GameMaker's normal resource workflow.
6. Avoid changing multiple owners of a transition in one edit. Verify the affected room path in the IDE after a focused change.

## Audit priorities

These are maintainability risks to address incrementally, not a reason to rewrite the working prototype in one pass:

1. Extract pause state/input from `obj_controller/Step_0.gml` behind a small controller-owned helper while retaining exact order and instance activation behavior.
2. Separate menu option data from menu rendering/input without changing the inline callbacks' instance context.
3. Consider a shared transition state helper after documenting each controller's distinct entry/exit rules.
4. Replace `Script13` with a meaningful resource name only as a dedicated metadata migration.

No runtime behavior was intentionally changed as part of this code map.
