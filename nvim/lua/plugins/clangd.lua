return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            -- ColumnLimit: 0 = fix indentation only; keep existing line
            -- breaks, never rewrap or join lines
            "--fallback-style={BasedOnStyle: LLVM, ColumnLimit: 0}",
          },
        },
      },
    },
  },
}
