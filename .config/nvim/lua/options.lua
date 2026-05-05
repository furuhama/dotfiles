-- ======================
-- display settings
-- ======================
vim.opt.ruler = true
vim.opt.cursorline = true
vim.opt.cmdheight = 2
vim.opt.laststatus = 2
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest,full"
vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.incsearch = true
vim.opt.hidden = true
vim.opt.list = true
vim.opt.listchars = { tab = "> ", extends = "<" }
vim.opt.showmatch = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.whichwrap = "b,s,h,l,<,>,[,]"
vim.opt.belloff = "all"
vim.opt.backspace = "indent,eol,start"
vim.opt.title = false
vim.opt.swapfile = false
vim.opt.history = 1000
vim.opt.clipboard:append("unnamedplus")
vim.opt.number = true
vim.opt.diffopt = "vertical"
vim.opt.maxmempattern = 3000
vim.opt.foldenable = false
vim.opt.autoread = true
vim.opt.guicursor = ""
vim.opt.mouse = ""
vim.opt.splitright = true

-- ======================
-- completion settings
-- ======================
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- ======================
-- keybind settings
-- ======================
vim.keymap.set({ "n", "x", "o" }, "<Esc><Esc>", ":nohlsearch<CR><Esc>")
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { silent = true })
vim.keymap.set("t", "<C-q>", "<C-\\><C-n>:q<CR>", { silent = true })
vim.keymap.set("n", "tt", ":tabe<CR>:terminal<CR>:setlocal nonumber<CR>", { silent = true })
vim.keymap.set({ "n", "x", "o" }, "tn", ":<C-u>tabnew<CR>")
vim.keymap.set({ "n", "x", "o" }, "<C-n>", "gt")
vim.keymap.set({ "n", "x", "o" }, "<C-p>", "gT")
vim.keymap.set({ "n", "x", "o" }, "<C-a>", "^")
vim.keymap.set({ "n", "x", "o" }, "<C-e>", "$")

-- ======================
-- trailing whitespace highlight (skip floating windows)
-- ======================
local function set_trailing_ws_hl()
  vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = "#F4503E" })
end
set_trailing_ws_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_trailing_ws_hl })

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
  callback = function()
    local win = vim.api.nvim_get_current_win()
    if vim.api.nvim_win_get_config(win).relative ~= "" then return end
    local prev = vim.w[win].trailing_ws_id
    if prev then pcall(vim.fn.matchdelete, prev) end
    vim.w[win].trailing_ws_id = vim.fn.matchadd("TrailingWhitespace", [[\s\+$]])
  end,
})

-- ======================
-- commands
-- ======================
if vim.fn.exists(":DiffOrig") == 0 then
  vim.api.nvim_create_user_command(
    "DiffOrig",
    "vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis",
    {}
  )
end
