# nvim

LazyVim configuration in `~/.config/nvim`.

## Dependencies

Neovim >= 0.11.2 with LuaJIT, Git, a C compiler, and the Tree-sitter CLI are required.
Search and picker features use `ripgrep`, `fd`, `fzf`, and `lazygit`.
Node.js and npm must be available on `PATH` for the JavaScript/TypeScript tools;
using mise is fine.

### Arch Linux / Arch Linux ARM

On standard Arch (not Omarchy), run package installation commands yourself in a terminal:

```sh
sudo pacman -Syu --needed neovim git curl unzip base-devel ripgrep fd fzf lazygit tree-sitter-cli wl-clipboard ttf-jetbrains-mono-nerd
```

On Omarchy, update with `omarchy update` instead. Only after the update completes
successfully, install any missing packages with `omarchy pkg add <packages...>`.
Do not bypass Omarchy's direct-system-upgrade guard.

These core dependencies are already installed on the checked ARM64 machine.
The clipboard uses `wl-copy`/`wl-paste` on local Wayland sessions and OSC 52
elsewhere (including SSH). OSC 52 requires terminal support; clipboard reads may
require permission from the terminal.

### macOS

```sh
brew install neovim git fzf ripgrep lazygit node fd tree-sitter luarocks shellcheck
brew install --cask font-hack-nerd-font
```

Choose a Nerd Font in your terminal settings. `vim.opt.guifont` only affects GUI
clients, not terminal Neovim. JetBrainsMono Nerd Font is already installed on the
checked Linux machine; Hack is not required for terminal use.

## Language tools

Mason installs the configured formatters, linters, language servers, and the
JavaScript debug adapter. Check their status with `:Mason`. Mason's binaries are
added to Neovim's `PATH`; they do not need separate system-wide installations.

Swift's `sourcekit-lsp` and `clangd` come from the Swift toolchain and must be on
`PATH`. `clangd` is deliberately not installed through Mason because its Mason
binary does not support this ARM64 host.

### Optional Lua linting

`luacheck` is not used by this configuration's default linters. Mason's installed
luacheck 1.1.0 crashes under Lua 5.5, so it is no longer auto-installed. If you want
to use it on Arch, remove the old Mason copy with `:MasonUninstall luacheck` (it
otherwise shadows the system executable), then install Arch's Lua 5.4-based
package.

On Omarchy, run `omarchy update` first. Only after it completes successfully, run:

```sh
omarchy pkg add luacheck
```

On standard Arch (not Omarchy):

```sh
sudo pacman -Syu --needed luacheck
```

## Health checks

Run `:LazyHealth` inside a normal terminal to load plugins and check their health.
Headless checks can report misleading UI/terminal errors.

Missing Python/Ruby/Perl/Node remote-plugin providers are optional for these Lua
plugins. Mason's warnings about unused language runtimes (Go, Java, PHP, etc.)
also do not require installing them. Fish formatting only needs `fish` if you
edit Fish scripts. LaTeX/Mermaid rendering tools are optional, and Snacks image
rendering is currently disabled. Prettier's condition can fail for unsupported
filetypes such as a health-check buffer without indicating a broken install.

The test extra provides the test UI but still needs a language/framework-specific
Neotest adapter to run project tests.

## Config checks

```sh
nvim --headless -u NONE -i NONE -l tests/config.lua
~/.local/share/nvim/mason/bin/stylua --check init.lua lua tests
```
