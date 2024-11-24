vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

-- Set various options
vim.o.ai = true
vim.o.ruler = true
vim.o.hlsearch = true
vim.o.showmatch = true
vim.o.incsearch = true
vim.o.expandtab = true
vim.o.lazyredraw = true
vim.o.swapfile = false
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.wrap = true
vim.o.linebreak = true
vim.o.undofile = true
vim.o.wildignore = '.hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site'

-- Set mouse and status line
vim.o.mouse = "a"
vim.o.laststatus = 2

-- Set tab and indentation options
vim.o.tabstop = 2
vim.o.scrolloff = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"
vim.o.backspace = "indent,eol,start"

-- Set termguicolors if supported
vim.o.termguicolors = true

-- Set sign column and fill characters
vim.wo.signcolumn = "yes:1"
vim.o.fillchars = "vert:|,eob: ,diff: ,fold: ,msgsep:‾"

-- Set update and timeout lengths
vim.o.updatetime = 50
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 0

-- Adjust maximum width of hover window
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    max_width = 100
  }
)

-- Jonhoo content
--
-- Neat X clipboard integration
-- <leader>p will paste clipboard into buffer
-- <leader>c will copy entire buffer into clipboard
vim.keymap.set('n', '<leader>p', '<cmd>read !wl-paste<cr>')
vim.keymap.set('n', '<leader>c', '<cmd>w !wl-copy<cr><cr>')
-- always center search results
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })
vim.keymap.set('n', '*', '*zz', { silent = true })
vim.keymap.set('n', '#', '#zz', { silent = true })
vim.keymap.set('n', 'g*', 'g*zz', { silent = true })
-- "very magic" (less escaping needed) regexes by default
vim.keymap.set('n', '?', '?\\v')
vim.keymap.set('n', '/', '/\\v')
vim.keymap.set('c', '%s/', '%sm/')
-- open new file adjacent to current file
vim.keymap.set('n', '<leader>o', ':e <C-R>=expand("%:p:h") . "/" <cr>')
-- end Jonhoo content

-- Custom function to display diagnostic messages with wrapping
local orig_hover = vim.lsp.handlers["textDocument/hover"]
vim.lsp.handlers["textDocument/hover"] = function(...)
  local bufnr, winnr = orig_hover(...)
  if bufnr and winnr then
    vim.api.nvim_win_set_option(winnr, 'wrap', true)
    vim.api.nvim_win_set_option(winnr, 'linebreak', true)
  end
  return bufnr, winnr
end

-- Set terminal colors and syntax highlighting
if not vim.fn.has('gui_running') then
  vim.o.t_Co = 256
end

vim.cmd("syntax on")

-- Set gitgutter settings
vim.g.gitgutter_enabled = 1
vim.g.gitgutter_set_sign_backgrounds = 1

-- Set key mappings
vim.api.nvim_set_keymap('n', 'H', '^', { noremap = true })
vim.api.nvim_set_keymap('n', 'L', '$', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W><C-J>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-K>', '<C-W><C-K>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-L>', '<C-W><C-L>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-H>', '<C-W><C-H>', { noremap = true })

-- Set autocmds
vim.cmd([[
autocmd BufRead *.plot set filetype=gnuplot
autocmd BufRead *.md set filetype=markdown
autocmd FileType markdown setlocal tabstop=2 shiftwidth=2
autocmd BufRead *.tex set filetype=tex
]])

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme kanagawa]])
      require("kanagawa").setup({
        colors = {
            theme = {
                all = {
                    ui = {
                        bg_gutter = "none"
                    }
                }
            }
        },
        compile = true,
        undercurl = true,
        commentStyle = { italic = true },
        keywordStyle = { italic = true},
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = true,
        dimInactive = true,
        terminalColors = true,
      })

      -- probably some proper way to set this in kanagawa but whatever this works fine
      vim.cmd("highlight clear SpellBad")
      vim.cmd("highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline ctermbg=None guibg=None")
      vim.cmd("highlight clear SpellCap")
      vim.cmd("highlight SpellCap term=underline cterm=underline ctermbg=None guibg=None")
      vim.cmd("highlight clear SpellRare")
      vim.cmd("highlight SpellRare term=underline cterm=underline ctermbg=None guibg=None")
      vim.cmd("highlight clear SpellLocal")
      vim.cmd("highlight SpellLocal term=underline cterm=underline ctermbg=None guibg=None")

      -- Remove the background for the sign column
      vim.cmd [[highlight SignColumn guibg=NONE ctermbg=NONE]]

      -- Customize diagnostic signs to remove background
      vim.cmd [[highlight DiagnosticSignError guibg=NONE ctermbg=NONE]]
      vim.cmd [[highlight DiagnosticSignWarn guibg=NONE ctermbg=NONE]]
      vim.cmd [[highlight DiagnosticSignInfo guibg=NONE ctermbg=NONE]]
      vim.cmd [[highlight DiagnosticSignHint guibg=NONE ctermbg=NONE]]

      -- Remove the background for line numbers and normal text (optional)
      vim.cmd [[highlight Normal guibg=NONE ctermbg=NONE]]
      vim.cmd [[highlight LineNr guibg=NONE ctermbg=NONE]]
    end

  },
  {
    'ggandor/leap.nvim',
    config = function()
      require('leap').create_default_mappings()
    end
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require('lspconfig')

      lspconfig.rust_analyzer.setup {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
            },
            imports = {
              group = {
                enable = false
              }
            },
            completion = {
              postfix = {
                enable = true,
              },
              fullFunctionSignatures = {
                enable = true,
              },
            },
            procMacro = {
              enable = true
            },
            diagnostics = {
              styleLints = {
                enable = true
              },
            },
            inlayHints = {
              closureCaptureHints = {
                enable = true
              },
              maxLength = 120,
            },
            typing = {
              autoClosingAngleBrackets = {
                enable = true
              },
            },
          }
        }
      }
      end
    },
    {
      "hrsh7th/nvim-cmp",
      -- load cmp on InsertEnter
      event = "InsertEnter",
      -- these dependencies will only be loaded when cmp loads
      -- dependencies are always lazy-loaded unless specified otherwise
      dependencies = {
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
      config = function()
        local cmp = require'cmp'
        cmp.setup({
          snippet = {
            -- REQUIRED by nvim-cmp. get rid of it once we can
            expand = function(args)
              vim.fn["vsnip#anonymous"](args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            -- Accept currently selected item.
            -- Set `select` to `false` to only confirm explicitly selected items.
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
          }, {
            { name = 'path' },
          }),
          experimental = {
            ghost_text = true,
          },
        })

        -- Enable completing paths in :
        cmp.setup.cmdline(':', {
          sources = cmp.config.sources({
            { name = 'path' }
          })
        })
      end
    },
    {
      'rust-lang/rust.vim',
      ft = { "rust" },
      config = function()
        vim.g.rustfmt_autosave = 1
        vim.g.rustfmt_emit_files = 1
        vim.g.rustfmt_fail_silently = 0
        vim.g.rust_clip_command = 'wl-copy'
      end
    },
    {
      "christoomey/vim-tmux-navigator",
      cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
      },
      keys = {
        { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
        { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
        { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
        { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
      },
    },
    "khaveesh/vim-fish-syntax",
    "airblade/vim-gitgutter",
    "ctrlpvim/ctrlp.vim",
  })
