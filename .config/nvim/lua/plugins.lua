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
          "c_sharp", "haskell", "commonlisp",
          "markdown",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- ==========================
  -- file tree
  -- ==========================
  {
    "lambdalisue/fern.vim",
    config = function()
      vim.cmd([[
        function! s:fern_preview_init() abort
          nmap <buffer><expr>
            \ <Plug>(fern-my-preview-or-nop)
            \ fern#smart#leaf(
            \   "\<Plug>(fern-action-open:edit)\<C-w>p",
            \   "",
            \ )
          nmap <buffer><expr> J
            \ fern#smart#drawer(
            \   "j\<Plug>(fern-my-preview-or-nop)",
            \   "j",
            \ )
          nmap <buffer><expr> K
            \ fern#smart#drawer(
            \   "k\<Plug>(fern-my-preview-or-nop)",
            \   "k",
            \ )
          nmap <buffer><expr> <C-j> "j"
          nmap <buffer><expr> <C-k> "k"
        endfunction

        augroup my-fern-preview
          autocmd! *
          autocmd FileType fern call s:fern_preview_init()
        augroup END
      ]])
      vim.g["fern#default_hidden"] = 1
      vim.keymap.set("n", "<C-x>", ":Fern . -reveal=%<CR>", { silent = true })
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
  -- run
  -- ==========================
  { "thinca/vim-quickrun" },

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
  { "vim-denops/denops.vim" },
  { "lambdalisue/askpass.vim" },
  { "lambdalisue/guise.vim" },
  {
    "lambdalisue/gin.vim",
    dependencies = {
      "vim-denops/denops.vim",
      "lambdalisue/askpass.vim",
      "lambdalisue/guise.vim",
    },
    config = function()
      vim.api.nvim_create_user_command("Blame", function()
        vim.cmd("GinBlame " .. vim.fn.fnameescape(vim.fn.expand("%")))
      end, {})
      vim.api.nvim_create_user_command("OpenPR", function()
        local line = vim.fn.getline(".")
        local hash = vim.fn.matchstr(line, [[^\^\?[0-9a-f]\{7,\}]])
        if hash == "" then return end
        vim.fn.system(string.format("git openpr %s", hash))
      end, {})
    end,
  },
  { "furuhama/vim-tig-viewer" },

  -- ==========================
  -- color scheme
  -- ==========================
  { "rhysd/vim-color-spring-night", lazy = true },
  { "arcticicestudio/nord-vim",     lazy = true },
  {
    "morhetz/gruvbox",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_sign_column = "bg0"
      vim.o.background = "dark"
      vim.cmd("colorscheme gruvbox")
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
  -- language-specific (lazy)
  -- ==========================
  {
    "rust-lang/rust.vim",
    ft = "rust",
    config = function()
      vim.g.rustfmt_autosave = 1
      vim.g.rustfmt_options = "override"
    end,
  },
  {
    "tpope/vim-rails",
    ft = "ruby",
  },
  {
    "rhysd/reply.vim",
    cmd = { "Repl", "ReplAuto" },
  },
}
