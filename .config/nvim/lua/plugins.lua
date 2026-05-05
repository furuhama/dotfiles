return {

  -- ==========================
  -- syntax / treesitter
  -- ==========================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc",
          "rust", "ruby", "go", "kotlin", "javascript", "typescript",
          "toml", "json", "yaml",
          "bash", "html", "css", "sql",
          "diff", "dockerfile", "terraform", "proto",
          "c_sharp", "haskell", "commonlisp", "fsharp",
          "markdown", "markdown_inline",
        },
      })
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },

  -- ==========================
  -- file tree
  -- ==========================
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        filters = {
          dotfiles = false,
        },
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")
          api.config.mappings.default_on_attach(bufnr)
          local opts = { buffer = bufnr, silent = true, nowait = true }
          vim.keymap.set("n", "l", api.node.open.edit,           opts)
          vim.keymap.set("n", "h", api.node.navigate.parent_close, opts)
        end,
      })
      vim.keymap.set("n", "<C-x>", ":NvimTreeFindFileToggle<CR>", { silent = true })
    end,
  },

  -- ==========================
  -- motion
  -- ==========================
  {
    "tyru/columnskip.vim",
    config = function()
      vim.keymap.set({ "n", "x" }, "<C-j>", "<Plug>(columnskip-j)", { silent = true })
      vim.keymap.set({ "n", "x" }, "<C-k>", "<Plug>(columnskip-k)", { silent = true })
    end,
  },

  -- ==========================
  -- search
  -- ==========================
  {
    "junegunn/fzf",
    build = "./install --bin",
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    config = function()
      vim.g.fzf_layout = { down = "~30%" }
      vim.keymap.set("n", "<C-l>", ":Rg<CR>", { silent = true })
      vim.keymap.set("n", "<C-s>", ":GitFiles<CR>", { silent = true })
    end,
  },

  -- ==========================
  -- editing
  -- ==========================
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  { "bronson/vim-trailing-whitespace" },

  -- ==========================
  -- git
  -- ==========================
  { "tpope/vim-fugitive" },

  -- ==========================
  -- color scheme
  -- ==========================
  {
    "morhetz/gruvbox",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      vim.cmd("colorscheme gruvbox")
      vim.cmd("highlight Normal guibg=#292C33")
      vim.cmd("highlight NormalNC guibg=#292C33")
      vim.cmd("highlight SignColumn guibg=#292C33")
    end,
  },

  -- ==========================
  -- status line
  -- ==========================
  {
    "itchyny/lightline.vim",
    -- g:lightline must be set before lightline sources (init runs before plugin load)
    init = function()
      vim.g.lightline = {
        mode_map = { c = "NORMAL" },
        active = {
          left = { { "mode", "paste" }, { "fugitive", "dirname" } },
        },
        component_function = {
          modified    = "LightlineModified",
          readonly    = "LightlineReadonly",
          fugitive    = "LightlineFugitive",
          dirname     = "LightlineDirname",
          fileformat  = "LightlineFileformat",
          filetype    = "LightlineFiletype",
          fileencoding = "LightlineFileencoding",
          mode        = "LightlineMode",
        },
      }
    end,
    config = function()
      -- git branch cache (no fugitive dependency)
      local function update_git_branch()
        local branch = vim.fn.trim(vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null"))
        vim.b.git_branch = (branch == "HEAD" or vim.v.shell_error ~= 0) and "" or branch
      end
      vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "DirChanged" }, {
        callback = update_git_branch,
      })

      vim.cmd([[
        function! LightlineModified()
          return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
        endfunction

        function! LightlineReadonly()
          return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
        endfunction

        function! LightlineDirname()
          return expand('%')
        endfunction

        function! LightlineFugitive()
          return &ft !~? 'vimfiler\|gundo' ? get(b:, 'git_branch', '') : ''
        endfunction

        function! LightlineFileformat()
          return winwidth(0) > 70 ? &fileformat : ''
        endfunction

        function! LightlineFiletype()
          return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
        endfunction

        function! LightlineFileencoding()
          return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
        endfunction

        function! LightlineMode()
          return winwidth(0) > 60 ? lightline#mode() : ''
        endfunction

        let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

        augroup InsertHook
          autocmd!
          autocmd InsertEnter * call s:StatusLine('Enter')
          autocmd InsertLeave * call s:StatusLine('Leave')
        augroup END

        let s:slhlcmd = ''
        function! s:StatusLine(mode)
          if a:mode == 'Enter'
            silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
            silent exec g:hi_insert
          else
            highlight clear StatusLine
            silent exec s:slhlcmd
          endif
        endfunction

        function! s:GetHighlight(hi)
          redir => hl
          exec 'highlight '.a:hi
          redir END
          let hl = substitute(hl, '[\r\n]', '', 'g')
          let hl = substitute(hl, 'xxx', '', '')
          return hl
        endfunction
      ]])
    end,
  },

  -- ==========================
  -- LSP
  -- ==========================
  { "williamboman/mason.nvim" },
  { "neovim/nvim-lspconfig" },
  { "saghen/blink.cmp", version = "*" },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
    config = function()
      require("lsp")
    end,
  },

  -- ==========================
  -- markdown preview
  -- ==========================
  {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
