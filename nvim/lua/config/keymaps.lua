-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Terminal: open relative to current window (don't squash explorer) and smaller.
-- Root is resolved on each press so it follows the current buffer's project.
local function terminal()
  Snacks.terminal(nil, {
    cwd = LazyVim.root(),
    win = { position = "bottom", height = 0.3, relative = "win" },
  })
end
vim.keymap.set({ "n", "t" }, "<c-/>", terminal, { desc = "Terminal (Root Dir)" })
vim.keymap.set({ "n", "t" }, "<c-_>", terminal, { desc = "which_key_ignore" })
