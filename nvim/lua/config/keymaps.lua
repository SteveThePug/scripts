-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Terminal: open relative to current window (don't squash explorer) and smaller
local terminal_opts = {
  cwd = LazyVim.root(),
  win = { position = "bottom", height = 0.3, relative = "win" },
}
vim.keymap.set({ "n", "t" }, "<c-/>", function()
  Snacks.terminal(nil, terminal_opts)
end, { desc = "Terminal (Root Dir)" })
vim.keymap.set({ "n", "t" }, "<c-_>", function()
  Snacks.terminal(nil, terminal_opts)
end, { desc = "which_key_ignore" })
