## Galagus - Space shooter in LUA

This is a demo repository for a working game that uses my own hobby quick-iteration game jam engine.
It's a version of Galaga with a tilted 3D viewpoint.

![Screenshot](tex/screenshot.png)

## Debugging Lua in VSCode

This project uses the [Local Lua Debugger](https://marketplace.visualstudio.com/items?itemName=tomblind.local-lua-debugger-vscode) VSCode extension for debugging Lua scripts running inside the game engine.

### Setup
1. Install the **Local Lua Debugger** extension by tomblind from the VSCode marketplace.
2. Open the engine project (`game/`) in VSCode.
3. Check that the `LOCAL_LUA_DEBUGGER_FILEPATH` path in `.vscode/launch.json` matches your installed extension version. Look in `~/.vscode/extensions/` for the actual folder name (e.g. `tomblind.local-lua-debugger-vscode-0.3.3`).

### Usage
1. Set breakpoints in any `.lua` file under `script/`.
2. Select **"Lua Debug (Windows - MSVC)"** (or the Linux/Mac variant) from the VSCode debug dropdown.
3. Press F5 to launch. The engine will start and the Lua debugger will attach automatically.

Debugging is enabled via `DebuggingStartup(true)` in `script/game.lua`. Set the argument to `false` to disable it.

# TASK QUEUE
1. Level end state
2. Level spawn pattern definitions
3. Players getting captured
4. Challenging stages
5. Sound

