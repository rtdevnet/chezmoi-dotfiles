return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    config = function()
      require("conform").setup({
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true, -- fallback to LSP formatting if no tool configured
        },
        formatters_by_ft = {
          python = { "black" },
          go = { "gofmt" },
          lua = { "stylua" },
        },
      })
    end,
  },
}
