# nvim

A standalone Neovim config with 6 plugins, including the plugin manager.
Snacks provides the file explorer, file picker, live grep, Git views, and Lazygit integration.
Neovim provides LSP, formatting, diagnostics, the status line, and clipboard integration.
The local Night colorscheme, Blink completion, and Tree-sitter highlighting
complete the setup. There is no LazyVim layer.

## Setup

Install these command-line dependencies and make their executables available on PATH:

| Dependency | Executable / minimum version | Purpose |
| --- | --- | --- |
| Neovim | `nvim` 0.12+ | Editor and native LSP client |
| Git | `git` | Install plugins and support Git views |
| ripgrep | `rg` | Live grep |
| fd | `fd` or `fdfind` | File search and recursive explorer search |
| Lazygit | `lazygit` | Git interface at `Space gg` |
| Node.js and npm | `node`, `npm` | Install and run the web language servers |
| Tree-sitter CLI | `tree-sitter` 0.26.1+ | Build syntax parsers |
| C compiler, curl, tar | `cc`, `curl`, `tar` | Download and compile parsers |

The configured language servers are listed below. They also provide formatting.
There is no separate formatter dependency.

On macOS:

```sh
brew install neovim node ripgrep fd tree-sitter-cli lazygit lua-language-server
npm install --global @vtsls/language-server vscode-langservers-extracted
xcode-select --install # if the command-line tools are not already installed
```

On Linux, install Neovim, Node/npm, ripgrep, fd, Lazygit, the Tree-sitter CLI,
lua-language-server, and clangd with your package manager, then run the
same npm command above. Check the required versions and ensure all executables
are on PATH. For a desktop clipboard, install `wl-clipboard` on Wayland or `xclip`
on X11. A Nerd Font is optional; select one in your terminal for file icons.

Keep the config in `~/.config/nvim` and start from your project directory:

```sh
cd /path/to/project
nvim .
```

The first launch installs plugins and syntax parsers. Language servers come
from your system PATH; install them with the commands above.
Neovim enables the configured servers that are available and reports any missing
required server executables. Restart Neovim after installing tools.

## Language support

| Language | Server | Installation |
| --- | --- | --- |
| TypeScript / JavaScript / JSX / TSX | VTSLS | npm: `@vtsls/language-server` |
| HTML | HTML language server | npm: `vscode-langservers-extracted` |
| CSS / SCSS / Less | CSS language server | npm: `vscode-langservers-extracted` |
| Lua | lua-language-server | Homebrew or your system package manager |
| C / C++ / Objective-C | clangd | Your toolchain or system package manager |
| Swift | sourcekit-lsp | Your Swift toolchain |

SourceKit is enabled only when `sourcekit-lsp` is on PATH, and attaches only to
Swift. Metal files use C++ highlighting with their own filetype so neither
clangd nor SourceKit attaches to them. C/C++ projects may need a
`compile_commands.json` for accurate diagnostics.

On macOS, this setup uses clangd from your existing Swift/LLVM toolchain. If
clangd is unavailable, install LLVM and add its `bin` directory to PATH.

## Keys

The leader is **Space**. `Space sk` opens the searchable shortcut list.

| Keys | Action |
| --- | --- |
| `Space Space`, `Space ff` | Find files |
| `Space /`, `Space sg` | Live grep |
| `Space e`, `Space fe` | File explorer |
| `Space ,` | Switch open buffers |
| `Shift h` / `Shift l` | Previous / next buffer |
| `Space bd` | Close buffer while preserving windows |
| `gd`, `gr`, `gI`, `gy` | Definition, references, implementations, type definition |
| `K`, `gK` | Documentation, signature help |
| `Space cr`, `Space ca` | Rename symbol, code actions |
| `Space ss`, `Space sS` | Document / workspace symbols |
| `Space cd`, `Space sd` | Line / project diagnostics |
| `[d`, `]d` | Previous / next diagnostic (Neovim defaults) |
| `Space cf` | Format file or visual selection |
| `Space uf` | Toggle format on save |
| `Space gg` | Lazygit |
| `Space gl`, `Space gd` | Git log, diff |
| `Ctrl /` | Toggle terminal |
| `Esc Esc` in terminal | Enter terminal normal mode |
| `Ctrl h/j/k/l` | Move between windows |
| `Ctrl s` | Save |
| `Space sh`, `Space sk` | Help, keymaps |
| `Space l`, `Space cl` | Plugins, LSP status |
| `Space qq` | Quit |

Completion appears while typing. `Ctrl n` / `Ctrl p` select items; Enter accepts.
Ctrl-Space stays unbound. Blink uses its Lua matcher and needs no native library.

Formatting uses the attached language server and follows its rules and project
settings. It runs on save when the server supports formatting; `Space uf` toggles
it and `Space cf` formats the file or visual selection manually. JSON, YAML, and
Markdown have no configured language server, so they save unchanged.

Search, the explorer, Git views, and terminals use Neovim's global working
directory. Change it with `:cd`; opening files never guesses a new project
root for these commands. Language servers still detect their own workspace roots.
Hidden files are shown, and `.gitignore` is respected. In the explorer, `H`
toggles hidden files and `I` toggles ignored files; in file/grep pickers, use
`Alt h` and `Alt i`.

Local clipboard detection works normally. Over SSH, OSC 52 copies to your
terminal, and pastes within Neovim use the session cache. Use the terminal's paste
shortcut for text copied from other applications.

## Maintenance

- `:Lazy` manages plugins; `:Lazy restore` restores the committed lockfile.
- Manage language servers through Homebrew/npm or your system package manager.
- `:TSUpdate` updates installed syntax parsers.
- `:checkhealth snacks` and `:checkhealth vim.lsp` diagnose missing tools.
- `lua/config/` contains options, shortcuts, startup, and autocmds.
- `lua/plugins/` contains the explicit plugin setup; edit `lsp.lua` to add servers.

The 6 plugins are lazy.nvim, snacks.nvim, mini.icons, nvim-lspconfig, blink.cmp,
and nvim-treesitter.
The lockfile is tracked so this setup can be reproduced on another machine.

On macOS, update the external editor tools with:

```sh
brew upgrade lua-language-server tree-sitter-cli
npm update --global @vtsls/language-server vscode-langservers-extracted
```

## Colors

The colorscheme is local Lua code based on Tokyo Night's Night variant, with
deeper Easter-inspired accents over near-black charcoal backgrounds: lavender,
mint, peach, warm gold, dusty pink, and cornflower blue.
There is no theme plugin dependency or automatic upstream update.

- `lua/theme/palette.lua` contains the base colors.
- `lua/theme/config.lua` contains transparency, text styles, and direct highlight overrides.
- `lua/theme/groups/` contains the copied editor, LSP, Tree-sitter, Snacks, Blink, and icon highlights.
- `colors/local-night.lua` loads the local colorscheme.

After editing the palette, settings, or highlight groups, run
`:colorscheme local-night` to reload them.

The source is [folke/tokyonight.nvim at cdc07ac](https://github.com/folke/tokyonight.nvim/tree/cdc07ac78467a233fd62c493de29a17e0cf2b2b6).
Its Apache-2.0 license is preserved in `licenses/tokyonight-LICENSE`; the copied
HSLuv helper retains its original MIT notice in `lua/theme/hsluv.lua`.

## Moving from the previous config

The rewrite removes LazyVim, Mason, Conform, the Tokyo Night plugin, Telescope, fzf-lua, the debugger, Neotest, Lean,
Markdown rendering/browser preview, and the extra UI plugins. `Space gg` keeps
Lazygit through Snacks, without an additional Neovim plugin. Git operations can
also run in the terminal.

`:Lazy clean` removes any remaining unused plugins. Mason's downloaded tools,
registry, and cache have been removed from this machine. Restart any open
Neovim sessions so they use the new configuration and system language servers.
Prettier, StyLua, fzf, and LuaRocks are outside this config's runtime dependencies;
existing system installations can still be used by other tools.

## Checks

With plugins and tools installed, run from the config directory:

```sh
nvim --headless -u NONE -i NONE -l tests/clipboard.lua
nvim --headless -i NONE -c "lua dofile('tests/smoke.lua')"
```
