# Personal Neovim Config

Built on [LazyVim](https://www.lazyvim.org). Everything LazyVim documents still applies —
this file only covers what's different. Press `<space>` and wait for which-key, or
`<space>?` to fuzzy-search every keymap.

## Setup

- Colorscheme: oxocarbon
- Language extras: C/C++ (clangd), Python, Go, TypeScript/Vue/Tailwind, SQL, Docker, Clojure
- Requires `tree-sitter-cli` (parsers can't be built without it) — see `../packages.txt`

## Custom keymaps

| Key | Action |
|-----|--------|
| `<space>?` | Search all keymaps |
| `<C-/>` | Toggle terminal (project root, bottom of current window) |
| **AI** — `<space>a` | |
| `<space>aa` / `ac` | Toggle CLI / toggle Claude ([sidekick](https://github.com/folke/sidekick.nvim)) |
| `<space>as` / `ad` | Select CLI / detach session |
| `<space>at` / `af` / `av` | Send this / file / visual selection |
| `<space>ap` | Pick a prompt |
| `<C-.>` | Focus the sidekick terminal (any mode) |
| **Git** (Neogit) — `<space>g` | |
| `<space>gg` | Neogit status |
| `<space>gc` / `gl` / `gp` | Commit / log / push |
| **Harpoon** | |
| `<space>h` | Add file to harpoon |
| `<C-e>` | Harpoon menu |
| `<C-1>`…`<C-4>` | Jump to harpoon file 1–4 |
| **Other** | |
| `<space>cu` | Undotree |
| `<C-w><space>` | Window "hydra" mode (repeat window commands) |

## Behaviour changes from LazyVim

- 4-space indent everywhere (clangd fallback style matches); C/C++ has format-on-save **off**
  (format manually with `<space>cf`)
- `nvim a b c` opens the files side by side
- Inactive windows are dimmed (vimade); markdown renders inline (markview)
