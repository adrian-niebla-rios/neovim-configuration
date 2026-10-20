# CLAUDE.md

Personal Neovim configuration (forked from oh-my-nvim), cloned to `~/.config/nvim`.
Targets **Neovim 0.11** on Linux and macOS; plugins are managed by lazy.nvim and pinned in `lazy-lock.json`.

## Keep README.md in sync

`README.md` is the install/update/configure guide. **Update it in the same change** whenever
an installation-level change is made, for example:

- requirements change (system packages, Neovim version, Nerd Font, new external tools)
- install or update steps change (`bin/update-nvim` flags or behavior, `:Lazy` workflow)
- formatters / LSP servers / Treesitter parsers installed automatically change
- a file in the "Configure" table moves, is renamed, or a new user-facing config entry point is added

Keep it terse: install and configure steps only, no feature tour. The plugin list lives in
`docs/plugins.md`; update it when plugins are added or removed.

## Layout

- `init.lua`: loads `basic`, bootstraps lazy.nvim, imports specs from `lua/plugins/`,
  `lua/languages/` and `lua/my_plugins/`, then loads `core` and (optionally) `custom`.
- `lua/basic.lua`: editor options. `lua/core.lua`: keymaps and autocommands.
- `lua/custom_keys.lua`: every user-facing shortcut, as a named table. Add new shortcuts here
  and reference them (`keys.<name>`) from `core.lua` or plugin configs instead of hard-coding keys.
- `lua/custom_opts.lua`: user-tunable options (tab style, terminal size, start-screen header, …).
- `lua/plugins/*.lua`: lazy.nvim specs grouped by area (`coding`, `find`, `git`, `lsp`, `view`, …);
  larger plugin setups live in `lua/plugins/<plugin>/config.lua`.
- `lua/languages/`: per-language plugin specs (e.g. Rust).
- `lua/open_in_place.lua`: helper used by Telescope/Neo-tree so opening a file replaces the current tab.
- `misc/recommended/`: optional specs the user can copy into `lua/my_plugins/`; not loaded.
- `bin/update-nvim`: bash script that installs/updates Neovim into `~/.local/opt`, linked as `~/.local/bin/nvim`.
  It must run on both Linux and macOS: stick to bash 3.2 and to flags GNU and BSD tools share
  (no `find -printf`, `sed -i`, `readlink -f`).
- Git-ignored, machine-local: `lua/custom.lua`, `lua/my_plugins/*` (except `example.lua`).

## Conventions

- Lua is indented with **tabs** and uses double quotes; format with stylua (installed by Mason in
  `~/.local/share/nvim/mason/bin/stylua`). Some older files (e.g. `lua/plugins/*/config.lua`) are
  not stylua-formatted: don't reformat files you aren't otherwise changing. Match the comment style
  already in the file.
- Don't use APIs newer than Neovim 0.11.
- Don't run a blanket `:Lazy update`/`:Lazy sync` or rewrite `lazy-lock.json` wholesale; update
  only the plugin being changed and commit the lockfile change with it.
- Commit messages: short imperative summary of the user-visible change
  (e.g. "Open files in a new tab with Alt-Enter").

## Checking a change

```sh
nvim --headless "+lua print('ok')" +qa   # config loads without errors (prints "ok")
bash -n bin/update-nvim                  # syntax-check the update script
```
