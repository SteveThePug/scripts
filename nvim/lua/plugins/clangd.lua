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
            -- breaks, never rewrap or join lines. IndentWidth: 4 matches
            -- the editor's shiftwidth
            "--fallback-style={BasedOnStyle: LLVM, IndentWidth: 4, ColumnLimit: 0}",
          },
        },
      },
    },
  },
}
