# oh-my-neovim

My Neovim configuration, based on [oh-my-nvim](https://github.com/hardhackerlabs/oh-my-nvim).
Plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim) and pinned in `lazy-lock.json`.

## Requirements

- Linux or macOS (x86_64 or arm64)
- `git`, `curl`, `unzip`, `make`, `gcc`, `ripgrep`, `jq`
- A [Nerd Font](https://www.nerdfonts.com/font-downloads) set as the terminal font (e.g. JetBrainsMono Nerd Font Mono), otherwise icons show as boxes
- Neovim **0.11** (installed below; Ubuntu's apt package is too old, Homebrew's is too new)
- Optional: `fortune` for a quote on the start screen

On Ubuntu/Debian:

```sh
sudo apt install git curl unzip make gcc ripgrep jq
```

On macOS (with [Homebrew](https://brew.sh)):

```sh
xcode-select --install        # git, make and a C compiler
brew install ripgrep jq
```

The Alt shortcuts (`<A-…>`, `<M-…>`) need the terminal to send Option as Meta:
iTerm2: Settings → Profiles → Keys → Left Option key: **Esc+**;
Terminal.app: Settings → Profiles → Keyboard → **Use Option as Meta key**.

## Install

1. **Back up any existing config**

   ```sh
   mv ~/.config/nvim ~/.config/nvim.bak
   mv ~/.local/share/nvim ~/.local/share/nvim.bak
   ```

2. **Clone this repo**

   ```sh
   git clone git@github.com:adrian-niebla-rios/oh-my-neovim.git ~/.config/nvim
   ```

3. **Install Neovim** with the included `update-nvim` script (no sudo needed).
   It installs the newest 0.11.x into `~/.local/opt` and links it as `~/.local/bin/nvim`.
   Make sure `~/.local/bin` is on your `PATH` before `/usr/bin` (and, on macOS, before
   `/opt/homebrew/bin`, or `brew uninstall neovim`).

   ```sh
   mkdir -p ~/.local/bin
   ln -s ~/.config/nvim/bin/update-nvim ~/.local/bin/update-nvim
   update-nvim
   ```

4. **Start `nvim`** and wait for lazy.nvim to install the plugins, then run
   `:Lazy restore` to pin every plugin to the version in `lazy-lock.json`.
   Restart `nvim`.

Formatters (shfmt, stylua, clang-format) and the clangd language server are installed by
Mason on first start, and Treesitter parsers download the first time you open a file of that type.

For C++ completion, clangd needs a `compile_commands.json` in the project root
(CMake: `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`, then symlink it from the build directory)
or a `compile_flags.txt` with one compiler flag per line.

## Update

```sh
cd ~/.config/nvim && git pull   # then :Lazy restore in nvim
update-nvim                     # newest Neovim 0.11.x
```

`update-nvim --check` shows what's available, `--latest` moves to a newer series
(e.g. 0.12; check the config first), `--rollback` switches back, `--list` lists installed versions.

## Configure

| What | Where |
|---|---|
| Shortcut keys | `lua/custom_keys.lua` |
| Editor options (line numbers, tabs, …) | `lua/basic.lua` |
| Key mappings and autocommands | `lua/core.lua` |
| Fuzzy search: ignored folders, keys | `lua/plugins/find.lua` (`file_ignore_patterns`) |
| Formatters and language servers installed by Mason | `lua/plugins/lsp.lua` (`ensure_installed`) |
| Plugins | a file in `lua/plugins/` (lazy.nvim spec, see below) |
| Machine-local plugins | a file in `lua/my_plugins/` (ignored by git) |
| Machine-local config, loaded last | `lua/custom.lua` (create it; ignored by git) |

Adding a plugin, e.g. `lua/plugins/example.lua`:

```lua
return {
    { "author/plugin-name", config = function() require("plugin-name").setup({}) end },
}
```

Then run `:Lazy install` for new plugins, or `:Lazy update plugin-name` to update one plugin.
Avoid a plain `:Lazy sync` / `:Lazy update`: it updates **every** plugin and can pull versions
that need a newer Neovim. Commit the updated `lazy-lock.json` once everything works.

Language servers: `:LspInstall <server>` (e.g. `:LspInstall clangd`).
Treesitter parsers: `:TSInstall <language>`.
