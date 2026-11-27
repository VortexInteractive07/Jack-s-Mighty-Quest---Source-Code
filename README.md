# JACK'S MIGHTY QUEST - Source Code (Temporary)

Thank you for downloading the source code for Jack's Mighty Quest (JMQ)!

This repository contains the complete source files and assets for the 16-bit retro platformer/RPG developed by **Vortex Interactive**.

---

## 🎮 Game Overview

* **Engine:** GameMaker LTS 2026.0+ (GML Scripting)
* **Target Resolution:** 432x240 Widescreen (16:9 Aspect Ratio) @ 60 FPS
* **Target Platforms:** Windows PC (Original Release)

---

## 🛠️ Required Assets & Setup

Ensure all asset dependencies are present in your local project hierarchy before compiling.

### Project Assets Structure
Well, it's only visible in the project files, cause there's a lot of assets that I cannot list!

---

## 🕹️ Controls (Default Engine Inputs)

| Action | Keyboard | Gamepad |
| :--- | :--- | :--- |
| **Move Left / Right** | Arrow Keys / `A` / `D` | D-Pad Left / Right |
| **Jump** | `Space` / `Z` | Button South (`A` / `Cross`) |
| **Attack / Action** | `X` / `K` | Button West (`X` / `Square`) |
| **Pause Game** | `Enter` / `Escape` | Start Button |

---

## 🚀 How to Build & Run

1. Open **GameMaker LTS 2026.0+**.
2. Select **Open** and navigate to the project root directory.
3. Open `JMQ.yyp` (or your project configuration file).
4. Select the **Windows (VM or YYC)** target platform.
5. Set the output display resolution to **432x240** with standard integer scaling enabled.
6. Press `F5` or click the **Run** button to compile and execute.

---

## ⚠️ Notes for Developers

* **Pixel Grid Alignment:** The HUD and level complete interfaces rely on flat slanted primitives drawn relative to integer coordinates. Modify `fnt_bitmap` or UI scale variables with caution to maintain pixel-perfect rendering.
* **Direct Asset Reference:** All GML scripts strictly utilize direct asset handles. Avoid `asset_get_index()` calls in performance-critical draw cycles.
* **Memory Management:** Ensure dynamic surface cleanup and DS structure garbage collection are handled cleanly inside `Clean Up` events.

---

## Save Slots

Choose **Story / Save Slots** from the main menu to open ten save slots. Select an empty slot to name a new adventure, or select an occupied slot to continue it. The active slot autosaves during play and when leaving a mission; deleting a slot requires pressing **Delete** twice while it is selected. Slot files are stored in `save_directory` under GameMaker's writable working directory. On death, Jack and Mark return to their last recorded positions.

## Add-On Manager and Pack Authoring (Windows)

Open **Settings → Add-On Manager**. Use **N** to create a starter package folder or **I** to import an archive. The creator asks for the package type (texture, behavior, or resource), then writes a randomly named `.jmqpack` folder under the game's `save_directory`. You can edit the generated files with any text or image editor while the game is closed. The manager lists installed texture packs; select one and press Enter, then restart to apply it.

The importer accepts `.zip` and `.jmqpack` archives (a `.jmqpack` import is a ZIP archive using that extension). Choose its type before selecting the archive. The manifest can be at the archive root or inside one enclosing package folder. Imports are extracted beneath `save_directory\texture_packs\` for texture packs or `save_directory\addons\<type>_packs\` for behavior and resource packs. Only import archives you trust.

### Texture pack layout

Texture packs are currently data-only and may replace only the supported built-in sprite list. Each pack folder contains `pack.json` and `textures/`:

Example:

```text
Example.jmqpack/
  pack.json
  textures/
    spr_gem.png
    spr_main_menu.png
```

```json
{
  "format_version": 1,
  "name": "Example",
  "textures": ["spr_gem", "spr_main_menu"]
}
```

Supported sprite names: `spr_dialogue`, `spr_dialogue_continue_btn`, `spr_gem`, `spr_main_menu`, `spr_menu_arrow_down`, `spr_menu_arrow_up`, and `spr_titlescreen`. Each PNG must be a horizontal frame strip with the original frame count and per-frame dimensions; incompatible images are ignored instead of stretched.

### Behavior and resource starter packs

Generated behavior and resource packs contain an `addon.json` manifest plus `data/`, `assets/`, and `source/` folders. They are editable package templates and can be imported and stored by the game. The current runtime does not yet load their content or execute external GML. GameMaker compiles scripts into the game; to add characters, gameplay behavior, or executable scripts, incorporate those source files into the GameMaker project and rebuild. Resource assets that are not part of the currently supported texture replacement format are stored only, not activated.

Example behavior/resource manifest:

```json
{
  "format_version": 1,
  "type": "behavior",
  "name": "Example Behavior Pack",
  "description": "Package description",
  "version": "1.0.0"
}
```

For authored archives, put the manifest and package files directly at the archive root, or put them inside one enclosing package folder. Use UTF-8 JSON and keep files inside the package folder. Current package handling is Windows-only.

## Stage Prototypes

The title-screen level select is unlocked with Up, Up, Down, Down, Left, Right, Left, Right. Stages 2 and 3 reuse the Stage 1 parallax background with separate rain and ember effects. Stage 2 contains the Melonhead boss prototype; press `X` or `K` near it to attack. Ranga Dhun Yeh loops while the boss arena is active.

---

*© Vortex Interactive. All rights reserved.*
