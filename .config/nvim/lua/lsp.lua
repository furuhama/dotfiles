-- blink.cmp setup (must come before get_lsp_capabilities)
require("blink.cmp").setup({
  keymap = {
    preset = "none",
    ["<Tab>"]   = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "fallback" },
    ["<CR>"]    = { "accept", "fallback" },
    ["<C-e>"]   = { "hide" },
  },
  completion = {
    list = {
      selection = { preselect = false },
    },
  },
  sources = {
    default = { "lsp", "buffer" },
  },
})

local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf, silent = true }
    vim.keymap.set("n", "K",          vim.lsp.buf.hover,          opts)
    vim.keymap.set("n", "gd",         vim.lsp.buf.definition,     opts)
    vim.keymap.set("n", "gr",         vim.lsp.buf.references,     opts)
    vim.keymap.set("n", "gi",         vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,         opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,    opts)
    vim.keymap.set("n", "[d",         vim.diagnostic.goto_prev,   opts)
    vim.keymap.set("n", "]d",         vim.diagnostic.goto_next,   opts)
    vim.keymap.set("n", "<leader>e",  vim.diagnostic.open_float,  opts)
  end,
})

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = {
    "ts_ls",
    "ruby_lsp",
    "pyright",
    "rust_analyzer",
    "kotlin_language_server",
    "html",
    "cssls",
    "marksman",
  },
  automatic_installation = true,
  handlers = {
    function(server_name)
      require("lspconfig")[server_name].setup({
        capabilities = capabilities,
      })
    end,
  },
})
