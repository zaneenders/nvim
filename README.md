# nvim

Neovim with LazyVim, Tokyo Night, completion, file search, Git integration, and debugging.
Configured for TypeScript/JavaScript, HTML/CSS, Swift, and C/C++.

## Setup

Use the same config on macOS and Linux. Install Neovim (at least 0.11.2), Git,
curl, a C compiler, Node/npm, fzf, ripgrep, fd, and LazyGit. LuaRocks is needed
for the configured Luacheck installation. Mason installs the remaining tools.

### macOS

Install the command-line dependencies:

```sh
brew install neovim node fzf ripgrep fd lazygit luarocks shellcheck
brew install --cask font-hack-nerd-font
```

### Linux

Install the dependencies above with your distribution's package manager; check
that its Neovim package meets the version requirement. Some distributions name
the fd executable `fdfind`, which LazyVim also supports.

For a local desktop clipboard, install `wl-clipboard` on Wayland or `xclip` on X11.
SSH sessions use OSC 52 and require a terminal that supports it.

Install a Nerd Font, such as Hack, and select it in your terminal's font settings
so icons display correctly. The `guifont` option only affects graphical Neovim clients.

### First launch

Keep this config in `~/.config/nvim`, then start Neovim from your project directory:

```sh
cd /path/to/your/project
nvim .
```

On first launch, wait for plugin and tool installation to finish. Mason installs the
language servers and formatters, including VTSLS, the Lua/HTML/CSS language servers,
Prettier, and StyLua. Node/npm is required for the JavaScript tools.

C/C++ uses `clangd` from PATH when available; Mason installs it otherwise.
ShellCheck is also installed by Mason when it is absent from PATH.

Swift support activates when `sourcekit-lsp` is on PATH. Install the Swift
toolchain on Linux, or Apple's command-line tools (`xcode-select --install`) on
macOS. Swift debugging uses `lldb-dap` from PATH, with `xcrun` as a macOS fallback.
The Swift debug adapter is only configured when its executable is available.

## Getting started

Press `i` to start typing and `Esc` to return to normal mode. Enter `:w` to save,
`:q` to quit, or `:q!` to discard unsaved changes. Run `:Tutor` for the built-in tutorial.

The leader key is **Space**. Press Space in normal mode and pause to see available commands.

| Keys | Action |
| --- | --- |
| `Space Space` | Find files |
| `Space /` | Search text in the project |
| `Space e` | File explorer |
| `Space ,` | Switch open buffers |
| `gd` | Go to definition |
| `K` | Documentation under the cursor |
| `Space cr` | Rename symbol |
| `Space cf` | Format file or selection |
| `Space gg` | Open LazyGit |
| `Ctrl /` | Toggle terminal |
| `Space db` | Toggle debugger breakpoint |
| `Space dc` | Start or continue debugging |

Formatting runs on save. `Space uf` toggles automatic formatting. Completion appears
while typing; use `Ctrl n` / `Ctrl p` to select an item and Enter to accept it.
Ctrl-Space is deliberately left unbound in this config.

File search and terminals use the directory from which you launched Neovim.
Local sessions use Neovim's native clipboard detection on macOS, Wayland, and X11.
SSH sessions retain the OSC 52 clipboard integration.

## Maintenance and customization

- `:Lazy` manages plugins; `:LazyHealth` loads plugins and checks the setup.
- `:Mason` manages language servers, formatters, and other tools.
- `:LazyExtras` enables support for additional languages and features.
- `:ConformInfo` shows the formatters available for the current buffer.
- `lua/config/options.lua` contains editor settings.
- `lua/config/keymaps.lua` contains custom shortcuts.
- `lua/plugins/` contains plugin settings and language servers.

See the [LazyVim keymaps](https://www.lazyvim.org/keymaps) for the full shortcut list.
